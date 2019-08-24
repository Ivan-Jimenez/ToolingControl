using System;

namespace ToolingControl
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["nombre"] == null)
            {
                Login.Visible = false;
                Logout.Visible = false;
            }
            else
            {
                Logout.Visible = true;
                Login.Visible = false;
            }
        }
    }
}