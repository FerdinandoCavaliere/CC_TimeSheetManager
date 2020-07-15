using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TimeSheetManager.Model;
using TimeSheetManager.Classi;

namespace TimeSheetManager
{
    public partial class TimeSheetMasterPage : System.Web.UI.MasterPage
    {
        RisorsaController r = new RisorsaController();

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //PnlMenu.Visible = false;
            }

            if (Session["SEZIONE"] != null)
            {
                Sezioni sezione = (Sezioni)Session["SEZIONE"];
                switch (sezione)
                {
                    case Sezioni.GestioneAziende:
                        PnlHeader.CssClass = "HeaderGestioneAziende";
                        PnlMenu.CssClass = "MenuGestioneAziende";
                        break;
                    case Sezioni.GestioneContratti:
                        PnlHeader.CssClass = "HeaderGestioneContratti";
                        PnlMenu.CssClass = "MenuGestioneContratti";
                        break;
                    case Sezioni.GestioneFigure:
                        PnlHeader.CssClass = "HeaderGestioneFigure";
                        PnlMenu.CssClass = "MenuGestioneFigure";
                        break;
                    case Sezioni.GestioneProgetti:
                        PnlHeader.CssClass = "HeaderGestioneProgetti";
                        PnlMenu.CssClass = "MenuGestioneProgetti";
                        break;
                    case Sezioni.GestioneRisorse:
                        PnlHeader.CssClass = "HeaderGestioneRisorse";
                        PnlMenu.CssClass = "MenuGestioneRisorse";
                        break;
                    case Sezioni.GestioneTimesheet:
                        PnlHeader.CssClass = "HeaderGestioneTimesheet";
                        PnlMenu.CssClass = "MenuGestioneTimesheet";
                        break;
                    case Sezioni.GestioneTask:
                        PnlHeader.CssClass = "HeaderGestioneTask";
                        PnlMenu.CssClass = "MenuGestioneTask";
                        break;
                    case Sezioni.GestioneValidazione:
                        PnlHeader.CssClass = "HeaderGestioneValidazione";
                        PnlMenu.CssClass = "MenuGestioneValidazione";
                        break;
                    case Sezioni.GestioneConsolidamento:
                        PnlHeader.CssClass = "HeaderGestioneConsolidamento";
                        PnlMenu.CssClass = "MenuGestioneConsolidamento";
                        break;
                    case Sezioni.DashBoard:
                        PnlHeader.CssClass = "HeaderDashBoard";
                        PnlMenu.CssClass = "MenuDashBoard";
                        break;
                }
            }
            else
            {
                PnlHeader.CssClass = "HeaderDefault";
            }
                
            if (Session["RISORSA"] == null)
            {
                //Sessione Scaduta --> provo a recuperare e riparto dall'inizio.
                Risorse rr = r.GetRisorsaLoggata(HttpContext.Current.User.Identity.Name);
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
            else
            {
                if ((Session["RISORSA"] as Risorse).IsAdmin)
                {
                    PreparaMenuAdmin();
                }
                else if ((Session["RISORSA"] as Risorse).IsCustomer)
                {
                    PreparaMenuCustomer();
                }
                else
                {
                    PreparaMenuRisorsa();
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (DateTime.Now.Hour <= 12)
            {
                LblUtente.Text = "Buongiorno ";
            }
            else
            {
                LblUtente.Text = "Buonasera ";
            }
            LblUtente.Text += (Session["RISORSA"] as Risorse).Nominativo;
            if (Session["TITOLO"] != null)
            {
                LblSezione.Text = "Sei nella sezione: " + Session["TITOLO"].ToString();
            }   
        }

        protected void ImgBtnMenu_Click(object sender, ImageClickEventArgs e)
        {
            //PnlMenu.Visible = !PnlMenu.Visible;
        }

        private void PreparaMenuAdmin()
        {
            PreparaMenuRisorsa();

            PreparaMenuCustomer();

            //Button btnGestioneContratti = new Button();
            //btnGestioneContratti.ID = "btnGestioneContratti";
            //btnGestioneContratti.Click += new EventHandler(BtnRedirect);
            //btnGestioneContratti.Text = "Contratti";
            //btnGestioneContratti.CssClass = "GestioneContratti";
            //PnlMenu.Controls.Add(btnGestioneContratti);

            //Button btnGestioneAziende = new Button();
            //btnGestioneAziende.ID = "btnGestioneAziende";
            //btnGestioneAziende.Click += new EventHandler(BtnRedirect);
            //btnGestioneAziende.Text = "Aziende";
            //btnGestioneAziende.CssClass = "GestioneAziende";
            //PnlMenu.Controls.Add(btnGestioneAziende);

            //Button btnGestioneFigure = new Button();
            //btnGestioneFigure.ID = "btnGestioneFigure";
            //btnGestioneFigure.Click += new EventHandler(BtnRedirect);
            //btnGestioneFigure.Text = "Figure";
            //btnGestioneFigure.CssClass = "GestioneFigure";
            //PnlMenu.Controls.Add(btnGestioneFigure);

            //Button btnGestioneRisorse = new Button();
            //btnGestioneRisorse.ID = "btnGestioneRisorse";
            //btnGestioneRisorse.Click += new EventHandler(BtnRedirect);
            //btnGestioneRisorse.Text = "Risorse";
            //btnGestioneRisorse.CssClass = "GestioneRisorse";
            //PnlMenu.Controls.Add(btnGestioneRisorse);

            //Button btnGestioneProgetti = new Button();
            //btnGestioneProgetti.ID = "btnGestioneProgetti";
            //btnGestioneProgetti.Click += new EventHandler(BtnRedirect);
            //btnGestioneProgetti.Text = "Progetti";
            //btnGestioneProgetti.CssClass = "GestioneProgetti";
            //PnlMenu.Controls.Add(btnGestioneProgetti);
        }

        private void PreparaMenuCustomer()
        {
            Button btnGestioneTask = new Button();
            btnGestioneTask.ID = "btnGestioneTask";
            btnGestioneTask.Click += new EventHandler(BtnRedirect);
            btnGestioneTask.Text = "Tasks";
            btnGestioneTask.CssClass = "GestioneTask";
            PnlMenu.Controls.Add(btnGestioneTask);

            Button btnGestioneValidazione = new Button();
            btnGestioneValidazione.ID = "btnGestioneValidazione";
            btnGestioneValidazione.Click += new EventHandler(BtnRedirect);
            btnGestioneValidazione.Text = "Validazione";
            btnGestioneValidazione.CssClass = "GestioneValidazione";
            PnlMenu.Controls.Add(btnGestioneValidazione);

            Button btnGestioneConsolidamento = new Button();
            btnGestioneConsolidamento.ID = "btnGestioneConsolidamento";
            btnGestioneConsolidamento.Click += new EventHandler(BtnRedirect);
            btnGestioneConsolidamento.Text = "Consolidamento";
            btnGestioneConsolidamento.CssClass = "GestioneConsolidamento";
            PnlMenu.Controls.Add(btnGestioneConsolidamento);
        }

        private void PreparaMenuRisorsa()
        {
            Button btnGestioneTimeSheet = new Button();
            btnGestioneTimeSheet.ID = "btnGestioneTimeSheet";
            btnGestioneTimeSheet.Click += new EventHandler(BtnRedirect);
            btnGestioneTimeSheet.Text = "TimeSheet";
            btnGestioneTimeSheet.CssClass = "GestioneTimeSheet";
            PnlMenu.Controls.Add(btnGestioneTimeSheet);

//#if DEBUG
            Button btnDashBoard = new Button();
            btnDashBoard.ID = "btnDashBoard";
            btnDashBoard.Click += new EventHandler(BtnRedirect);
            btnDashBoard.Text = "DashBoard";
            btnDashBoard.CssClass = "DashBoard";
            PnlMenu.Controls.Add(btnDashBoard);
//#endif
        }

        protected void BtnRedirect(object sender, EventArgs e)
        {
            switch ((sender as Button).ID)
            {
                case "btnGestioneContratti":
                    Session["SEZIONE"] = Sezioni.GestioneContratti;
                    Response.Redirect("GestioneContratti.aspx");
                    break;

                case "btnGestioneAziende":
                    Session["SEZIONE"] = Sezioni.GestioneAziende;
                    Response.Redirect("GestioneAziende.aspx");
                    break;

                case "btnGestioneFigure":
                    Session["SEZIONE"] = Sezioni.GestioneFigure;
                    Response.Redirect("GestioneFigure.aspx");
                    break;

                case "btnGestioneRisorse":
                    Session["SEZIONE"] = Sezioni.GestioneRisorse;
                    Response.Redirect("GestioneRisorse.aspx");
                    break;

                case "btnGestioneProgetti":
                    Session["SEZIONE"] = Sezioni.GestioneProgetti;
                    Response.Redirect("GestioneProgetti.aspx");
                    break;

                case "btnGestioneTask":
                    Session["SEZIONE"] = Sezioni.GestioneTask;
                    Response.Redirect("GestioneTasks.aspx");
                    break;

                case "btnGestioneTimeSheet":
                    Session["SEZIONE"] = Sezioni.GestioneTimesheet;
                    Response.Redirect("GestioneTimeSheet.aspx");
                    break;

                case "btnGestioneValidazione":
                    Session["SEZIONE"] = Sezioni.GestioneValidazione;
                    Response.Redirect("GestioneValidazione.aspx");
                    break;

                case "btnGestioneConsolidamento":
                    Session["SEZIONE"] = Sezioni.GestioneConsolidamento;
                    Response.Redirect("GestioneConsolidamento.aspx");
                    break;

                case "btnDashBoard":
                    Session["SEZIONE"] = Sezioni.DashBoard;
                    Response.Redirect("DashBoard.aspx");
                    break;
            }
        }
    }
}