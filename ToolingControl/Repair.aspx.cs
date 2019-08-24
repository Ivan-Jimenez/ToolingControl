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
    public partial class Repair : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var db = Database.Open("Tool");
            var userRol = db.QuerySingle("SELECT Rol FROM Users WHERE UserID=@0;", User.Identity.Name.Split('\\')[1].ToLower());

            db.Close();

            if (userRol == null || !userRol[0].ToUpper().Equals("TOOLING"))
            {
                //Response.Write("You don't have access to this page.");
                Response.Redirect("RestrictedAccess.aspx");
                return;

            }
            Filldata();
        }


        private void Filldata()
        {
            string connection = ConfigurationManager.ConnectionStrings["Tool"].ConnectionString;
            using (var db = new SqlConnection(connection))
            {
                SqlCommand query = new SqlCommand(@"SELECT * FROM Repair;", db);

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
                            if (row["Status"].ToString() == "REQUESTED")
                            {
                                var btnAprove = new Button { ID = row["NP"].ToString(), Text = "OK" };
                                btnAprove.CssClass = "btn btn-warning";
                                btnAprove.ToolTip = "Aprovar Mantenimiento";
                                btnAprove.Click += AproveRepair_Click;
                                RequestGrid.Rows[count].Cells[12].Controls.Add(btnAprove);
                            }
                            else
                            {
                                var btnStatus = new Button { ID = row["NP"].ToString(), Text = "OK", };
                                btnStatus.CssClass = "btn btn-success";
                                btnStatus.ToolTip = "Cambiar Status";
                                btnStatus.Click += ChangeStatus_Click;
                                RequestGrid.Rows[count].Cells[12].Controls.Add(btnStatus);
                            }
                            

                            PaintCells(count, row["NP"].ToString());

                            //var button = new Button { ID = row["ToolingID"].ToString(), Text = "Borrar", };
                            //button.CssClass = "btn btn-danger";
                            //button.ToolTip = "Borrar";
                            //button.Click+= Delete_Click;

                            //RequestGrid.Rows[count].Cells[12].Controls.Add(button);

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
                        RequestGrid.Rows[0].Cells[0].Text = "No hay reparaciones en curso.";
                    }
                }
            }
        }


        protected void AproveRepair_Click(object sender, EventArgs e)
        {
            AsignRepairman.Visible = true;

            Button btn = (Button)sender;
            string np = btn.ID;

            var db = Database.Open("Tool");
            db.Execute("UPDATE Repair SET Status='DAMAGE SEARCH', DamageSearch=@0 WHERE NP=@1;", DateTime.Now, np);
            db.Close();
            Filldata();
        }

        protected void ChangeStatus_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string np = btn.ID;

            var db = Database.Open("Tool");
            string requester = db.QuerySingle("SELECT Requester FROM Repair WHERE NP=@0;", np)[0];
            string status = "REPAIR FINISHED";
            switch (db.QuerySingle("SELECT Status FROM Repair WHERE NP=@0;", np)[0])
            {
                case "REQUESTED":
                    status = "DAMAGE SEARCH";
                    db.Execute("UPDATE Repair SET DamageSearch=@0 WHERE NP=@1;", 
                            DateTime.Now, np);
                    // andres.cortez
                    SendNotificationEmail("Status De Reparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    status, DamageSelect.Value, requester, "ivan.jimenez@safrangroup.com");
                    break;
                case "DAMAGE SEARCH":
                    status = "REPAIR";
                    db.Execute("UPDATE Repair SET Repair=@0 WHERE NP=@1;", DateTime.Now, np);
                    // andres.cortez
                    SendNotificationEmail("Status De Reparación", AreaSelect.Value, ToolingIDInput.Value,
                            RepairmanInput.Value, status, DamageSelect.Value, requester, "ivan.jimenez@safrangroup.com");
                    break;
                case "REPAIR":
                    status = "BAGGING";
                    db.Execute("UPDATE Repair SET Bagging=@0 WHERE NP=@1;", DateTime.Now, np);
                    // andres.cortez
                    SendNotificationEmail("Status De Reparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    status, DamageSelect.Value, requester, "ivan.jimenez@safrangroup.com");
                    break;
                case "BAGGING":
                    status = "REPAIR VALIDATION";
                    db.Execute("UPDATE Repair SET RepairValidation=@0 WHERE NP=@1;", DateTime.Now, np);
                    // andres.cortez
                    SendNotificationEmail("Solicitud De Reparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    status, DamageSelect.Value, requester, "ivan.jimenez@safrangroup.com");
                    break;
                case "REPAIR VALIDATION":
                    status = "REPAIR FINISHED";
                    db.Execute("UPDATE Repair SET Status=@0 WHERE NP=@1;",
                            "REPAIR FINISHED", np);
                    break;
            }

            // andres.cortez
            // ivan.hernandez3
            // Requester
            SendNotificationEmail("Status De Raparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    status, DamageSelect.Value, requester, "ivan.jimenez@safrangroup.com");

            db.Execute("UPDATE Repair SET Status=@0 WHERE NP=@1;", status, np);
            db.Close();
            Filldata();
        }


        private void PaintCells(int row, string np)
        {
            var db = Database.Open("Tool");
            var status = db.QuerySingle("SELECT Status FROM Repair WHERE NP=@0;", np);

            var cell = 0;
            switch (status[0].ToString())
            {
                case "REQUESTED":
                    cell = 5;
                    break;
                case "DAMAGE SEARCH":
                    cell = 6;
                    break;
                case "REPAIR":
                    cell = 7;
                    break;
                case "BAGGING":
                    cell = 8;
                    break;
                case "REPAIR VALIDATION":
                    cell = 9;
                    break;
                default:
                    break;
            }

            for (var x = 5; x <= cell; ++x)
            {
                RequestGrid.Rows[row].Cells[x].BackColor = System.Drawing.Color.LightGreen;
                RequestGrid.Rows[row].Cells[cell].BackColor = System.Drawing.Color.Yellow;
            }
        }

        protected void RequestRepair_Click(object sender, EventArgs e)
        {
            RequestRepair.Visible = true;
            MaintTable.Visible = false;
        }


        protected void SendRequest_Click(object sender, EventArgs e)
        {
            var db = Database.Open("Tool");

            if (NPInput.Value == string.Empty)
            {
                errorPlanner.InnerText = "¡ El número de parte no puede estar vacío¡";
                return;
            }

            if (db.QuerySingle("select Status from Repair where NP=@0;", NPInput.Value) != null)
            {
                errorPlanner.InnerText = "¡El Tooling ya se encuentra en reparación!";
                return;
            }

            db.Execute("INSERT INTO Repair(ToolingID, NP, Area, Program, Damage, Status, Requested, Requester, Repairman)"
                    +"values(@0, @1, @2, @3, @4, @5, @6, @7, @8);", ToolingIDInput.Value, NPInput.Value,
                    AreaSelect.Value, ProgramSelect.Value, DamageSelect.Value, "REQUESTED", DateTime.Now, User.Identity.Name.Split('\\')[1],
                    RepairmanInput.Value);
            db.Close();

            // andres.cortez
            // ivan.hernandez3
            // planner
            SendNotificationEmail("Solicitud De Reparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    "REQUESTED", DamageSelect.Value, RepairmanInput.Value, "ivan.jimenez@safrangroup.com");

            SendNotificationEmail("Solicitud De Reparación", AreaSelect.Value, ToolingIDInput.Value, RepairmanInput.Value,
                    "REQUESTED", DamageSelect.Value, RepairmanInput.Value, RepairmanInput.Value+ "@safrangroup.com");

            RequestRepair.Visible = false;
            MaintTable.Visible = true;
            ClearFields();
            Filldata();
        }


        protected void Delete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string id = btn.ID;

            var db = Database.Open("Tool");
            db.Execute("Delete Repair where ToolingID=@0", id);
            db.Close();
            Filldata();
        } 

        protected void Cancel_Click(object sender, EventArgs e)
        {
            RequestRepair.Visible = false;
            MaintTable.Visible = true;
        }

        private void ClearFields()
        {
            ToolingIDInput.Value = string.Empty;
            NPInput.Value = string.Empty;
            AreaSelect.Value = "0";
            ProgramSelect.Value = "0";
            DamageSelect.Value = "0";
            RepairmanInput.Value = string.Empty;
        }


        private void SendNotificationEmail(string emailTitle, string area, string toolingID, string planner,
               string status, string damageType, string requester, string sendTo)
        {
            string body = PopulateEmailBody(emailTitle, "" +
                "<h1>Area: " + area + "</h1></br>"
               + "<h2><b> Fecha: </b>" + DateTime.Now.ToString() + "</br></br>"
               + "<b> Tooling ID: </b>" + toolingID + " </br></br>"
               + "<b> Tipo de Daño: </b>" + damageType + "</h2></br>"
               + "<b> Status: </b>" + status + "</h2></br>"
               + "<b> Planner:  </b>" + planner + "@safrangroup.com</h2></br>"
               + "<b> Solicitó: </b>" + requester + "@safrangroup.com</h2></br>");

            this.SendHtmlFormattedEmail(sendTo, "TOOLING: " + toolingID, body);
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