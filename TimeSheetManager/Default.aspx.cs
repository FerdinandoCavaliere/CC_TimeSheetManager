using System;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;

namespace TimeSheetManager
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                RisorsaController r = new RisorsaController();
                Risorse rr = null;
#if DEBUG
                rr = r.GetRisorsaLoggata(@"rete\cavalieref");
#else
                rr = r.GetRisorsaLoggata(User.Identity.Name);
#endif
                if (rr != null)
                {
                    Session["RISORSA"] = rr;
//#if DEBUG
                    if (rr.IsCustomer)
                    {
                        Response.Redirect("TimeSheetHome.aspx");
                    }
                    else
                    {
                        Session["SEZIONE"] = Sezioni.DashBoard;
                        Response.Redirect("DashBoard.aspx");
                    }
//#else
//                    Response.Redirect("TimeSheetHome.aspx");
//#endif
                }
                else
                {
                    Response.Redirect("NonAutorizzato.aspx");
                }
            }
            catch (Exception ex)
            {
                // Non bloccante
                string s = ex.Message;
            }
        }
    }
}