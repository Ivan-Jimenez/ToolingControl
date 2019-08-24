using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebMatrix.Data;

namespace ToolingControl
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        public object Grid { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            var db = Database.Open("Tool");
            var userRol = db.QuerySingle("select rol from users where userid=@0;", User.Identity.Name.Split('\\')[1].ToLower());
            db.Close();

            if (!userRol[0].Equals("TOOLING"))
            {
                Response.Redirect("RestrictedAccess.aspx");
            }

            Filldata();
        }

        private void Filldata()
        {
            string connection = ConfigurationManager.ConnectionStrings["Tool"].ConnectionString;
            using (SqlConnection db = new SqlConnection(connection))
            {
                SqlCommand cmmd = new SqlCommand("Select * from Users", db);
                using (var adapter = new SqlDataAdapter(cmmd))
                {
                    var usersTable = new DataTable();
                    adapter.Fill(usersTable);

                    if (usersTable.Rows.Count > 0)
                    {
                        UsersGrid.DataSource = usersTable;
                        UsersGrid.DataBind();

                        ScriptManager.RegisterStartupScript(Page, this.GetType(), "Key", "<script>MakeStaticHeader('" + UsersGrid.ClientID + "', 250, 1000 , 25 ,true); </script>", false);

                        if (!IsPostBack)
                        {
                            BoundField column = new BoundField();
                            column.HeaderText = "";
                            UsersGrid.Columns.Add(column);
                            UsersGrid.DataBind();

                            BoundField columna1 = new BoundField();
                            columna1.HeaderText = "";
                            UsersGrid.Columns.Add(columna1);
                            UsersGrid.DataBind();
                        }
                        DataRow[] filas = usersTable.Select();
                        var contador = 0;
                        foreach (var fila in filas)
                        {
                            //LiteralControl control = new LiteralControl("<button type='submit' name='eliminarUsuario' class='btn btn-danger' value='" + fila["ID"] + "' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='ti-trash'></i></button>");
                            //UsersGrid.Rows[contador].Cells[2].Controls.Add(control);

                            var button = new Button { ID = fila["UserID"].ToString(), Text = "Borrar" };
                            button.CssClass = "btn btn-danger";
                            button.Click += DeleteUser_Click;
                            UsersGrid.Rows[contador].Cells[2].Controls.Add(button);

                            contador++;
                        }
                    }
                    else
                    {
                        usersTable.Rows.Add(usersTable.NewRow());
                        UsersGrid.DataSource = usersTable;
                        UsersGrid.DataBind();
                        int totalcolums = UsersGrid.Rows[0].Cells.Count;
                        UsersGrid.Rows[0].Cells.Clear();
                        UsersGrid.Rows[0].Cells.Add(new TableCell());
                        UsersGrid.Rows[0].Cells[0].ColumnSpan = totalcolums;
                        UsersGrid.Rows[0].Cells[0].Text = "No hay Usuarios";
                    }
                }
            }
        }

        protected void DeleteUser_Click(object sender, EventArgs e)
        {
            Button button = (Button)sender;
            var id = button.ID;

            var db = Database.Open("Tool");
            db.Execute("DELETE Users WHERE UserID=@0", id);
            db.Close();
            Filldata();
        }

        protected void AddUserButton_Click(object sender, EventArgs e)
        {
            string user = UserInput.Value;
            var db = Database.Open("Tool");

            if (!user.Equals(string.Empty))
            {
                //var db = Database.Open("Tool");
                //var test = db.QuerySingle("select * from users where userid='ivan.jimenez'");
                if (db.QuerySingle("select * from users where userid=@0", UserInput.Value) == null)
                {
                    if (RolSelect.Value.Equals("0"))
                    {
                        AlertMessage("You must choose a rol for the new user.");
                        return;
                    }
                    db.Execute("INSERT INTO Users(UserID, Rol) values(@0, @1);", UserInput.Value, RolSelect.Value);
                }
                else
                {
                    AlertMessage("The user is already in the database.");
                }
            }
            db.Close();
            Filldata();
            UserInput.Value = "";
            RolSelect.Value = "0";
        }

        private void AlertMessage(string message)
        {
            string script = "<script language=\"javascript\" type=\"text/javascript\">alert('" + message + "');</script>";
            Response.Write(script);
        }
    }
}