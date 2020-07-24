using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;
using Newtonsoft.Json;

namespace TimeSheetManager
{
    public partial class DashBoard : System.Web.UI.Page
    {
        DashBoardController dbc = new DashBoardController();
        RisorsaController rc = new RisorsaController();

        // Chart Ore Per Mese
        protected string orePerMese;

        // Chart Ore Per Mese
        protected string orePerMesePerFiguraProfessionale;

        // Chart Tasks Per Mese
        protected string tasksPerMese;

        // Chart Tasks Per Mese Per Figura Professionale
        protected string tasksPerMesePerFiguraProfessionale;

        // Chart Tasks Per Progetto
        protected string tasksPerProgetto;

        List<Mese> elencoMesi = Utility.GetMesi();

        protected void Page_Load(object sender, EventArgs e)
        {
            CaricaAnniTaskValidi();

            if (!IsPostBack)
            {
                Session["TITOLO"] = "DashBoard";
                CaricaRisorse();
                AggiornaGrafici();
            }
        }

        private void CaricaRisorse()
        {
            PnlRisorse.Visible = false;

            Risorse risorsa = Session["RISORSA"] as Risorse;
            if (risorsa.IsAdmin)
            {
                List<Risorse> risorse = rc.GetRisorse(string.Empty, string.Empty, null, null, string.Empty, null);
                DdlRisorse.DataSource = risorse;
                DdlRisorse.DataBind();
                if (DdlRisorse.Items.Count > 0)
                {
                    DdlRisorse.SelectedValue = risorsa.Codice;
                }
                PnlRisorse.Visible = true;
            }
        }

        private void CaricaAnniTaskValidi()
        {
            List<int> anni = dbc.GetAnniTaskValidi();
            if (ViewState["ANNOSELEZIONATO"] == null)
            {
                ViewState["ANNOSELEZIONATO"] = anni.First();
            }
            
            foreach (int anno in anni)
            {
                AggiungiBottoneAnno(anno);
            }
        }

        private void AggiornaGrafici()
        {
            CaricaOrePerMese();
            CaricaOrePerMesePerFiguraProfessionale();
            CaricaTasksPerMese();
            CaricaTasksPerMesePerFiguraProfessionale();
            CaricaTasksPerProgetto();
        }

        private void AggiungiBottoneAnno(int anno)
        {
            int annoSelezionato = Convert.ToInt32(ViewState["ANNOSELEZIONATO"]);

            Button btn = new Button();
            btn.ID = "BtnAnnoTask_" + anno.ToString();
            btn.Text = anno.ToString();
            if (annoSelezionato == anno)
            {
                btn.CssClass = "BottoneAnnoSelected";
            }
            else
            {
                btn.CssClass = "BottoneAnno";
            }

            btn.Click += AggiungiBittoneAnno_Click;

            PnlAnniTaskValidi.Controls.Add(btn);
        }

        private void AggiungiBittoneAnno_Click(object sender, EventArgs e)
        {
            ViewState["ANNOSELEZIONATO"] = Convert.ToInt32((sender as Button).Text);
            SettaStileAnnoSelezionato();
            PulisciGrafici();
            AggiornaGrafici();
        }

        private void CaricaOrePerMese()
        {
            GetDatiRicerca(out Risorse risorsa, out int anno);
            orePerMese = JsonConvert.SerializeObject(dbc.GetNumeroDiOrePerMese(risorsa.Codice, anno));
        }

        private void CaricaOrePerMesePerFiguraProfessionale()
        {
            GetDatiRicerca(out Risorse risorsa, out int anno);
            orePerMesePerFiguraProfessionale = JsonConvert.SerializeObject(dbc.GetNumeroDiOrePerMesePerFiguraProfessionale(risorsa.Codice, anno));
        }

        private void CaricaTasksPerMese()
        {
            GetDatiRicerca(out Risorse risorsa, out int anno);
            tasksPerMese = JsonConvert.SerializeObject(dbc.GetNumeroDiTasksPerMese(risorsa.Codice, anno));
        }

        private void CaricaTasksPerMesePerFiguraProfessionale()
        {
            GetDatiRicerca(out Risorse risorsa, out int anno);
            tasksPerMesePerFiguraProfessionale = JsonConvert.SerializeObject(dbc.GetNumeroDiTasksPerMesePerFiguraProfessionale(risorsa.Codice, anno));
        }

        private void CaricaTasksPerProgetto()
        {
            GetDatiRicerca(out Risorse risorsa, out int anno);
            tasksPerProgetto = JsonConvert.SerializeObject(dbc.GetNumeroDiTasksPerProgetto(risorsa.Codice, anno));
        }

        private void PulisciGrafici()
        {
            orePerMese = string.Empty;
            orePerMesePerFiguraProfessionale = string.Empty;
            tasksPerMese = string.Empty;
            tasksPerMesePerFiguraProfessionale = string.Empty;
            tasksPerProgetto = string.Empty;
        }

        private void SettaStileAnnoSelezionato()
        {
            int annoSelezionato = Convert.ToInt32(ViewState["ANNOSELEZIONATO"]);
            foreach (var controllo in PnlAnniTaskValidi.Controls)
            {
                if (controllo is Button b && Convert.ToInt32(b.Text) == annoSelezionato)
                {
                    b.CssClass = "BottoneAnnoSelected";
                }
                else if (controllo is Button b1 && Convert.ToInt32(b1.Text) != annoSelezionato)
                {
                    b1.CssClass = "BottoneAnno";
                }
            }
        }

        private void GetDatiRicerca(out Risorse risorsa, out int anno)
        {
            risorsa = Session["RISORSA"] as Risorse;
            if (risorsa.IsAdmin)
            {
                risorsa = rc.GetRisorsaByCodice(DdlRisorse.SelectedValue);
            }
            anno = Convert.ToInt32(ViewState["ANNOSELEZIONATO"]);
        }

        protected void DdlRisorse_SelectedIndexChanged(object sender, EventArgs e)
        {
            SettaStileAnnoSelezionato();
            PulisciGrafici();
            AggiornaGrafici();
        }
    }
}