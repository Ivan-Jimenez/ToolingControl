using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Web.UI.WebControls;
using WebMatrix.Data;

namespace ToolingControl
{
    public partial class Control : System.Web.UI.Page
    {
        private enum  _Status
        {
            AVAILABLE,
            TOOLING,
            PLANNING,
            PRODUCTION,
            QUALITY,
            FINISHED
        }
        private string _UserRol;
        //private string _UserLogin;


        protected void Page_Load(object sender, EventArgs e)
        {
            var db = Database.Open("Tool");
            var userRol = db.QuerySingle("select rol from users where userid=@0;", User.Identity.Name.Split('\\')[1].ToLower());
            db.Close();

            if (userRol == null)
            {
                //Response.Write("You don't have access to this page.");
                Response.Redirect("RestrictedAccess.aspx");
                return;
            }
            else
            {
                _UserRol = userRol[0].ToString().ToUpper();
            }
            
            if (_UserRol.Equals(_Status.TOOLING.ToString()))
            {
                FillMaintData();
                FAROOption.Visible = true;
                ValidationOption.Visible = true;
            }
            else
            {
                MaintTable.Visible = false;
            }
            FillInProgressesTable();
            divPlanner.Visible = false;
        }


        private void FillMaintData()
        {
            string connection = ConfigurationManager.ConnectionStrings["Tool"].ConnectionString;
            using (SqlConnection db = new SqlConnection(connection))
            {
                SqlCommand query = new SqlCommand(@"select * from maintenance where (NextNormal <= getdate()+7 or NextAnnual <= getdate()+7) AND Status='Available';", db);

                using (var adapter = new SqlDataAdapter(query))
                {
                    var maintenanceTable = new DataTable();
                    adapter.Fill(maintenanceTable);

                    if (maintenanceTable.Rows.Count > 0)
                    {
                        RequestGrid.DataSource = maintenanceTable;
                        RequestGrid.DataBind();

                        DataRow[] rows = maintenanceTable.Select();
                        var count = 0;
                        foreach (var row in rows)
                        {
                            if (DateTime.Now >= Convert.ToDateTime(row["NextNormal"]).AddDays(-7) || DateTime.Now >= Convert.ToDateTime(row["NextAnnual"]).AddDays(-7))
                            {
                                var button = new Button { ID = row["ToolingID"] +"_"+ row["NP"].ToString(), Text = "Solicitar", };
                                button.CssClass = "btn btn-info";
                                button.ToolTip = "Request";
                                button.Click += Ok_Click;

                                RequestGrid.Rows[count].Cells[11].Controls.Add(button);
                            }
                            else
                            {
                                rows[count].Delete();
                            }
                            ++count;
                        }
                    }
                    else
                    {
                        maintenanceTable.Rows.Add(maintenanceTable.NewRow());
                        RequestGrid.DataSource = maintenanceTable;
                        RequestGrid.DataBind();
                        int totalColums = RequestGrid.Rows[0].Cells.Count;
                        RequestGrid.Rows[0].Cells.Clear();
                        RequestGrid.Rows[0].Cells.Add(new TableCell());
                        RequestGrid.Rows[0].Cells[0].ColumnSpan = totalColums;
                        RequestGrid.Rows[0].Cells[0].Text = "No hay nuevas solicitides";
                    }
                }
            }
            FillInProgressesTable();
        }

        
        private void FillInProgressesTable()
        {
            string connection = ConfigurationManager.ConnectionStrings["Tool"].ConnectionString;
            using (SqlConnection db = new SqlConnection(connection))
            {
                string query = "";
                if (_UserRol.Equals(_Status.TOOLING.ToString()))
                {
                    query = @"SELECT ToolingID, NP, MaintType, Status, RequestDate, PlanningDate, ProductionDate," +
                            "QualityDate, RequestComment, PlanningComment, ProductionComment, QualityComment, FARO, Validation FROM MaintenanceLog WHERE Status!='" 
                            + _Status.FINISHED.ToString() +"';";
                }
                else
                {
                    query = @"SELECT ToolingID, NP, MaintType, Status, RequestDate, PlanningDate, ProductionDate," +
                            "QualityDate, RequestComment, PlanningComment, ProductionComment, QualityComment, FARO, Validation FROM MaintenanceLog WHERE Status='" + _UserRol + "';";

                }


                SqlCommand cmd = new SqlCommand(query, db);

                using (var adapter = new SqlDataAdapter(cmd))
                {
                    var table = new DataTable();
                    adapter.Fill(table);

                    if (table.Rows.Count > 0)
                    {
                        CurrentMaintGrid.DataSource = table;
                        CurrentMaintGrid.DataBind();

                        if (!_UserRol.Equals(_Status.TOOLING.ToString()))
                        {
                            var count = 0;
                            DataRow[] rows = table.Select();
                            foreach (var row in rows)
                            {
                                var btnOk = new Button { ID = row["ToolingID"].ToString()+"_"+ row["NP"], Text = "OK", };
                                btnOk.Click += Ok_Click;
                                btnOk.CssClass = "btn btn-success";
                                CurrentMaintGrid.Rows[count].Cells[14].Controls.Add(btnOk);
                                
                                if (_UserRol.Equals(_Status.QUALITY.ToString()))
                                {
                                    var rejectButton = new Button { ID="FAIL_"+row["ToolingID"]+"_"+row["NP"], Text="Fail" };
                                    rejectButton.Click += QualityFail_Click;
                                    rejectButton.CssClass = "btn btn-danger";
                                    CurrentMaintGrid.Rows[count].Cells[15].Controls.Add(rejectButton);
                                }
                                ++count;
                            }
                        }
                    }
                    else
                    {
                        table.Rows.Add(table.NewRow());
                        CurrentMaintGrid.DataSource = table;
                        CurrentMaintGrid.DataBind();
                        int totalColums = CurrentMaintGrid.Rows[0].Cells.Count;
                        CurrentMaintGrid.Rows[0].Cells.Clear();
                        CurrentMaintGrid.Rows[0].Cells.Add(new TableCell());
                        CurrentMaintGrid.Rows[0].Cells[0].ColumnSpan = totalColums;
                        CurrentMaintGrid.Rows[0].Cells[0].Text = "There is not tool in maintenance.";
                    }
                }
            }
        }


        protected void Ok_Click(object sender, EventArgs e)
        {
            RequestReports.Visible = true;
            CurrentMaintSection.Visible = false;
            divPlanner.Visible = true;
            Button button = (Button)sender;
            string id = button.ID;
            InputNP.Value = id;
        }


        protected void CancelRequest_Click(object sender, EventArgs e)
        {
            InputNP.Value = string.Empty;
            TxtComment.Value = string.Empty;
            divPlanner.Visible = false;
        }


        // FIXME: Some requests are being saved twice.
        protected void SendRequest_Click(object sender, EventArgs e)
        {

            string emailTitle = "";
            string area = string.Empty;
            string comments = TxtComment.Value;
            string toolingID = InputNP.Value.Split('_')[0];
            string NP = InputNP.Value.Split('_')[1];
            string planner = InputPlanner.Value;
            string maintType = GetMaintType(toolingID);

            CurrentMaintSection.Visible = true;

            if (InputNP.Value == string.Empty)
            {
                ErrorLabel.InnerText = "You must choose a tool to request maintenance.";
                return;
            }
            
            var db = Database.Open("Tool");

            if (InputNP.Value.Split('_')[0].Equals("FAIL"))
            {
                maintType = GetMaintType(InputNP.Value.Split('_')[2]);
                db.Execute("UPDATE Maintenance SET Status=@0 WHERE ToolingID=@1 AND NP=@2;", _Status.PRODUCTION.ToString(), InputNP.Value.Split('_')[1], 
                        InputNP.Value.Split('_')[2]);
                db.Execute("UPDATE MaintenanceLog SET Status='PRODUCTION', QualityComment=@0 WHERE ToolingID=@1 AND NP=@2 AND Status=@3;",comments, 
                        InputNP.Value.Split('_')[1], InputNP.Value.Split('_')[2], _Status.QUALITY.ToString());

                emailTitle = "Calidad";
                area = "Falló prueba de calidad";
                toolingID = InputNP.Value.Split('_')[1];
                SendNotificationEmail(emailTitle, area, toolingID, planner, maintType, comments, "ivan.jimenez@safrangroup.com");
                SendNotificationEmail(emailTitle, area, toolingID, planner, maintType, comments, planner+"@safrangroup.com");

                InputNP.Value = string.Empty;
                TxtComment.Value = string.Empty;
                FillMaintData();
                FillInProgressesTable();
                return;
            }

            switch (_UserRol)
            {
                case "TOOLING":
                    area = "Asignación a Planeación";
                    emailTitle = "Solicitud de TPM";
                    var frequency = db.QuerySingle("SELECT Frequency from Maintenance WHERE ToolingID=@0 AND NP=@1", InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1]);

                    db.Execute("UPDATE Maintenance SET Status='PLANNING' WHERE ToolingID=@0 AND NP=@1", InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1]);
                    db.Execute("INSERT INTO MaintenanceLog(ToolingID, NP, RequestDate, MaintType, Status, RequestComment, FARO, Validation)" +
                            "values(@0, @1, @2, @3, 'PLANNING', @4, @5, @6)", InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1], DateTime.Now,
                            maintType, comments, FAROCheckBox.Checked, ValidationCheckBox.Checked);
                    break;
                case "PLANNING":
                    area = "Asignación a Producción";
                    emailTitle="Tooling Liberado de Planeación";
                    db.Execute("UPDATE Maintenance SET Status=@0 WHERE ToolingID=@1 AND NP=@2", _Status.PRODUCTION.ToString(), InputNP.Value.Split('_')[0], 
                            InputNP.Value.Split('_')[1]);
                    db.Execute("UPDATE MaintenanceLog SET Status=@0, PlanningDate=@1, PlanningComment=@2 WHERE ToolingID=@3 AND NP=@4 AND Status=@5",
                            _Status.PRODUCTION.ToString(), DateTime.Now, comments, InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1], 
                            _Status.PLANNING.ToString());
                    break;
                case "PRODUCTION":
                    area = "Asignación a Calidad";
                    emailTitle = "Tooling Liberado de Producción";
                    db.Execute("UPDATE Maintenance SET Status=@0 WHERE ToolingID=@1 AND NP=@2", _Status.QUALITY.ToString(), InputNP.Value.Split('_')[0],
                            InputNP.Value.Split('_')[1]);
                    db.Execute("UPDATE MaintenanceLog SET Status=@0, ProductionDate=@1, ProductionComment=@2 WHERE ToolingID=@3 AND NP=@4 AND Status=@5",
                            _Status.QUALITY.ToString(), DateTime.Now, comments, InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1],
                            _Status.PRODUCTION.ToString());

                    break;
                case "QUALITY":
                    emailTitle = "Tooling Liberado de Calidad";
                    area = "TPM Terminado";
                    db.Execute("UPDATE Maintenance SET Status=@0 WHERE ToolingID=@1 AND NP=@2", _Status.AVAILABLE.ToString(), InputNP.Value.Split('_')[0],
                            InputNP.Value.Split('_')[1]);
                    UpdateMaintDates(toolingID);
                    db.Execute("UPDATE MaintenanceLog SET Status=@0, QualityDate=@1, QualityComment=@2 WHERE ToolingID=@3 AND NP=@4 AND Status=@5",
                            _Status.FINISHED.ToString(), DateTime.Now, comments, InputNP.Value.Split('_')[0], InputNP.Value.Split('_')[1],
                            _Status.QUALITY.ToString());
                    break;
                default:
                    return;
            }

            SendNotificationEmail(emailTitle, area, toolingID, planner, maintType, comments, "ivan.Jimenez@safrangroup.com");
            SendNotificationEmail(emailTitle, area, toolingID, planner, maintType, comments, planner+"@safrangroup.com");

            db.Close();
            InputNP.Value = string.Empty;
            TxtComment.Value = string.Empty;
            FillMaintData();
            FillInProgressesTable();
        }


        private string GetMaintType(string toolingID)
        {
            string maintType = "Normal";
            var db = Database.Open("Tool");
            var data = db.QuerySingle("SELECT NextNormal, NextAnnual FROM Maintenance WHERE ToolingID=@0", toolingID);

            DateTime nextNormal;
            DateTime nextAnnual;
            if (data != null)
            {
                nextNormal = data[0];
                nextAnnual = data[1];
                if (Math.Abs((nextNormal - nextAnnual).TotalDays) <= 7)
                {
                    maintType = "Normal/Annual";
                }
                else if (Convert.ToDateTime(nextAnnual).AddDays(-7) <= DateTime.Now)
                {
                    maintType = "Annual";
                }
            }
            return maintType;
        }


        private void UpdateMaintDates(string toolingID)
        {
            var db = Database.Open("Tool");
            string maintType = db.QuerySingle("SELECT MaintType FROM MaintenanceLog WHERE ToolingID=@0 AND Status=@1", toolingID, _Status.QUALITY.ToString())[0];
            string frequency = db.QuerySingle("SELECT Frequency FROM Maintenance WHERE ToolingID=@0;", toolingID)[0];
            
            int days = 0;
            switch (frequency.ToUpper())
            {
                case "2 WEEKS":
                    days = 14;
                    break;
                case "3 WEEKS":
                    days = 21;
                    break;
                case "1 MONTH":
                    days = 30;
                    break;
                case "3 MONTHS":
                    days = 90;
                    break;
                case "6 MONTHS":
                    days = 180;
                    break;
            }

            if (maintType.ToUpper().Equals("NORMAL/ANNUAL"))
            {
                db.Execute("UPDATE Maintenance SET LastNormal=@0, LastAnnual=@1, TotalNormal=TotalNormal+1, TotalAnnual=TotalAnnual+1 WHERE ToolingID=@2",
                        DateTime.Now, DateTime.Now, toolingID);
                db.Execute("UPDATE Maintenance SET NextNormal=@0, NextAnnual=@1 WHERE ToolingID=@2", DateTime.Now.AddDays(days),
                        DateTime.Now.AddDays(365), toolingID);
            }
            else if (maintType.ToUpper().Equals("NORMAL"))
            {
                db.Execute("UPDATE Maintenance SET LastNormal=@0, NextNormal=@1, TotalNormal=TotalNormal+1 WHERE ToolingID=@2;",
                        DateTime.Now, DateTime.Now.AddDays(days), toolingID);
            }
            else
            {
                db.Execute("UPDATE Maintenance SET LastAnnual=@0, NextAnnual=@1, TotalAnnual=TotalAnnual+1 WHERE ToolingID=@2;",
                        DateTime.Now, DateTime.Now.AddDays(365), toolingID);
            }
            db.Close();
        }


        private void SendNotificationEmail(string emailTitle, string area, string toolingID, string planner, 
                string maintType, string comments, string sendTo)
        {
            string body = PopulateEmailBody(emailTitle, "<h1>" + area + "</h1></br>"
           + "<h2><b> Fecha: </b>" + DateTime.Now.ToString() + "</br></br>"
           + "<b> Tooling ID: </b>" + toolingID + " </br></br>"
           + "<b> Planner:  </b>" + planner + "@safrangroup.com</h2></br>"
           + "<b> Tipo de Mantenimiento: </b>" + maintType + "</h2></br>"
           + "<b> Comentarios: </b>" + comments + "</h2></br>");

            this.SendHtmlFormattedEmail(sendTo, "TOOLING: "+toolingID, body);
        }


        protected void QualityFail_Click(object sender, EventArgs e)
        {
            string NP = string.Empty;

            RequestReports.Visible = true;

            divPlanner.Visible = true;
            Button button = (Button)sender;
            string id = button.ID;
            InputNP.Value = id;
        }


        private string PopulateEmailBody(string title, string message)
        {
            string body = string.Empty;
            using (StreamReader reader = new StreamReader(Server.MapPath("~/EmailTemplate.html")))
            {
                body = reader.ReadToEnd();
            }
            body = body.Replace("{titulo}", title);
            body = body.Replace("{mensaje}", message);
            return body;
        }

        
        protected void Cancel_Click(object sender, EventArgs e)
        {
            RequestReports.Visible = false;
            CurrentMaintSection.Visible = true;
        }


        private void SendHtmlFormattedEmail(string recipentEmail, string subject, string body)
        {
            try
            {
                using (MailMessage objMailMessage = new MailMessage())
                {
                    System.Net.NetworkCredential objSMTPUserInfo = new System.Net.NetworkCredential();

                    SmtpClient objSmtpClient = new SmtpClient();

                    objMailMessage.From = new MailAddress("Tooling@zodiacaerospace.com");
                    objMailMessage.Subject = subject;
                    //objMailMessage.
                    objMailMessage.Body = body;
                    objMailMessage.IsBodyHtml = true;
                    objMailMessage.To.Add(new MailAddress(recipentEmail));
                    objSmtpClient.EnableSsl = false;
                    objSmtpClient = new SmtpClient("11.26.16.2"); /// Server IP
                    objSMTPUserInfo = new System.Net.NetworkCredential("administrator.chihuahua@zodiacaerospace.com", "Password", "Domain");
                    objSmtpClient.Credentials = objSMTPUserInfo;
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                    objSmtpClient.Send(objMailMessage);
                }
            }
            catch
            {
                AlertMessage("Email Server Error.");
            }
        }


        private void AlertMessage(string message)
        {
            string script = "<script language=\"javascript\" type=\"text/javascript\">alert('" + message + "');</script>";
            Response.Write(script);
        }
    }
}