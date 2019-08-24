using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using WebMatrix.Data;

namespace ToolingControl
{
    public partial class AddTooling : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var db = Database.Open("Tool");
            var userRol = db.QuerySingle("select rol from users where userid=@0;", User.Identity.Name.Split('\\')[1].ToLower());

            db.Close();

            if (userRol == null || !userRol[0].Equals("TOOLING"))
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
                SqlCommand query = new SqlCommand(@"select * from maintenance;", db);

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
                            var button = new Button { ID = row["ToolingID"].ToString(), Text = "Borrar", };
                            button.CssClass = "btn btn-danger";
                            button.ToolTip = "Borrar";
                            button.Click += Delete_Click;

                            RequestGrid.Rows[count].Cells[11].Controls.Add(button);
                           
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
                        RequestGrid.Rows[0].Cells[0].Text = "El catalogo esta vacío.";
                    }
                }
            }
        }

        protected void SearchTool_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM Maintenance WHERE NP='" + InputSearchTooling.Value + "';";
            if (InputSearchTooling.Value.EndsWith("*"))
            {
                query = "select * from maintenance where np like '%"+ InputSearchTooling.Value.Trim('*') +"%'";
            }

            string connection = ConfigurationManager.ConnectionStrings["Tool"].ConnectionString;
            using (SqlConnection db = new SqlConnection(connection))
            {
                SqlCommand cmd = new SqlCommand(query, db);

                using (var adapter = new SqlDataAdapter(cmd))
                {
                    var maintenanceTable = new DataTable();
                    adapter.Fill(maintenanceTable);

                    if (maintenanceTable.Rows.Count > 0)
                    {
                        RequestGrid.DataSource = maintenanceTable;
                        RequestGrid.DataBind();
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
                        RequestGrid.Rows[0].Cells[0].Text = "Tooling not found.";
                    }
                }
            }
        }

        protected void Delete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string id = btn.ID;

            var db = Database.Open("Tool");
            db.Execute("delete maintenance where toolingid=@0", id);
            Filldata();
        }

        protected void AddTooling_Click(object sender, EventArgs e)
        {
            if (ToolingIDInput.Value == string.Empty)
            {
                errorPlanner.InnerText = "!El ID del Tooling no puede ser nulo!";
                return;
            }

            var db = Database.Open("Tool");
            if (db.QuerySingle("select NP from maintenance where toolingId=@0;", ToolingIDInput.Value) != null)
            {
                return;
            }

            int days = 0;
            switch (FrequencySelect.Value)
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

            db.Execute("insert into maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual)" +
                    "values(@0, @1, @2, @3, @4, @5, @6, @7)", ToolingIDInput.Value, NPInput.Value, AreaSelect.Value, ProgramSelect.Value,
                    FrequencySelect.Value, "AVAILABLE", DateTime.Now.AddDays(days), DateTime.Now.AddDays(365));

            db.Close();
        }


        protected void AddTool_Click(object sender, EventArgs e)
        {
            MaintTable.Visible = false;
            Add_tooling.Visible = true;
        }


        private void AlertMessage(string message)
        {
            string script = "<script language=\"javascript\" type=\"text/javascript\">alert('" + message + "');</script>";
            Response.Write(script);
            Add_tooling.Visible = false;
            MaintTable.Visible = true;
        }
    }
}