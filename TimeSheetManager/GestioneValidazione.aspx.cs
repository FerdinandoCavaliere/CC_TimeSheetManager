using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;

namespace TimeSheetManager
{
    public partial class GestioneValidazione : System.Web.UI.Page
    {
        RisorsaController rc = new RisorsaController();
        TimeSheetController tc = new TimeSheetController();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    CaricaRisorse();
                    CaricaAnni();
                    Inizializza();
                }   
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void Inizializza()
        {
            try
            {
                NascondiPanelli();
                CalendarValidazione.SelectedDate = DateTime.Now.Date;
                PnlMese.Visible = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CaricaRisorse()
        {
            try
            {
                List<Risorse> elenco = rc.GetRisorse(string.Empty, string.Empty, null, null, string.Empty, null);
                DdlRisorsa.DataSource = elenco;
                DdlRisorsa.DataBind();
                DdlRisorsa.Items.Insert(0, new ListItem("----- Tutte -----"));
                DdlRisorsa.SelectedValue = (Session["RISORSA"] as Risorse).Codice;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CaricaAnni()
        {
            try
            {
                for (int i = 2014; i <= DateTime.Now.Year; i++)
                {
                    DdlAnno.Items.Add(i.ToString());
                }
                DdlAnno.SelectedValue = DateTime.Now.Year.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void CalendarValidazione_SelectionChanged(object sender, EventArgs e)
        {
            try
            {
                CercaPerGiorno();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void CercaPerGiorno()
        {
            List<TimeSheetManager.Model.TimeSheet> elenco = tc.GetTimeSheet(CalendarValidazione.SelectedDate,
                CalendarValidazione.SelectedDate,
                string.Empty,
                string.Empty);
            if (elenco != null && elenco.Count > 0)
            {
                GrdRisultatiRicerca.DataSource = elenco;
                GrdRisultatiRicerca.DataBind();
            }
            else
            {
                LblMessaggio.Text = "Nessun dato reperito";
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void CercaPerMese()
        {
            try
            {
                PnlTotaleOreLavorate.Visible = false;
                LblOreLavorateTotali.Text = string.Empty;
                LblGiorniLavoratiTotali.Text = string.Empty;

                List<TimeSheetManager.Model.TimeSheet> elenco = tc.GetTimeSheet(Convert.ToInt32(DdlMese.SelectedValue),
                    Convert.ToInt32(DdlAnno.SelectedValue),
                    DdlRisorsa.SelectedValue);
                if (elenco != null && elenco.Count > 0)
                {
                    GrdRisultatiRicerca.DataSource = elenco.Where(t => t.OreLavorate != 0);
                    decimal totaleOreLavorate = elenco.Sum(s => s.OreLavorate.Value);
                    LblOreLavorateTotali.Text = totaleOreLavorate.ToString();
                    LblGiorniLavoratiTotali.Text = (totaleOreLavorate / 8).ToString();
                    PnlTotaleOreLavorate.Visible = true;
                }
                else
                {
                    GrdRisultatiRicerca.DataSource = null;
                    LblMessaggio.Text = "Nessun dato reperito";
                    Messaggio_ModalPopupExtender.Show();
                }
                GrdRisultatiRicerca.DataBind();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void GrdRisultatiRicerca_RowDataBound(Object sender, GridViewRowEventArgs e)
        {
            e.Row.Cells[0].Visible = false;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ((CheckBox)e.Row.FindControl("ChkValida")).Enabled = (Session["RISORSA"] as Risorse).IsAdmin;
                ((CheckBox)e.Row.FindControl("ChkValidaArma")).Enabled = (Session["RISORSA"] as Risorse).IsCustomer;
            }
        }

        protected void RbtnTipo_SelectedIndexChanged(object sender, EventArgs e)
        {
            NascondiPanelli();
            switch (RbtnTipo.SelectedValue)
            {
                case "Giorno":
                    PnlGiorno.Visible = true;
                    CalendarValidazione.SelectedDate = DateTime.Now.Date;
                    CercaPerGiorno();
                    break;
                case "Mese":
                    PnlMese.Visible = true;
                    DdlRisorsa.SelectedIndex = 0;
                    DdlMese.SelectedValue = DateTime.Now.Month.ToString();
                    DdlAnno.SelectedValue = DateTime.Now.Year.ToString();
                    PnlTotaleOreLavorate.Visible = false;
                    LblOreLavorateTotali.Text = string.Empty;
                    LblGiorniLavoratiTotali.Text = string.Empty;
                    GrdRisultatiRicerca.DataSource = null;
                    GrdRisultatiRicerca.DataBind();
                    break;
            }
        }

        private void NascondiPanelli()
        {
            PnlGiorno.Visible = false;
            PnlMese.Visible = false;
        }

        protected void BtnCerca_Click(object sender, EventArgs e)
        {
            if (DdlRisorsa.SelectedIndex > 0)
            {
                CercaPerMese();
            }
            else
            {
                LblMessaggio.Text = "Selezionare una risorsa";
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnConferma_Click(object sender, EventArgs e)
        {
            try
            {
                if (GrdRisultatiRicerca.Rows.Count > 0)
                {
                    if ((Session["RISORSA"] as Risorse).IsAdmin)
                    {
                        ConfermaAdmin();
                    }
                    else if ((Session["RISORSA"] as Risorse).IsCustomer)
                    {
                        ConfermaCustomer();
                    }

                    if ((Session["RISORSA"] as Risorse).IsAdmin || (Session["RISORSA"] as Risorse).IsCustomer)
                    {
                        switch (RbtnTipo.SelectedValue)
                        {
                            case "Giorno":
                                CercaPerGiorno();
                                break;
                            case "Mese":
                                CercaPerMese();
                                break;
                        }

                        LblMessaggio.Text = "Operazione avvenuta con successo";
                        Messaggio_ModalPopupExtender.Show();
                    }
                }
                else
                {
                    LblMessaggio.Text = "Effettuare una ricerca";
                    Messaggio_ModalPopupExtender.Show();
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void ConfermaAdmin()
        {
            try
            {
                foreach (GridViewRow riga in GrdRisultatiRicerca.Rows)
                {
                    if (riga.RowType == DataControlRowType.DataRow)
                    {
                        int id = Convert.ToInt32(riga.Cells[0].Text);
                        CheckBox chkValida = riga.FindControl("ChkValida") as CheckBox;
                        tc.Valida(id, chkValida.Checked);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ConfermaCustomer()
        {
            try
            {
                foreach (GridViewRow riga in GrdRisultatiRicerca.Rows)
                {
                    if (riga.RowType == DataControlRowType.DataRow)
                    {
                        int id = Convert.ToInt32(riga.Cells[0].Text);
                        CheckBox chkValidaArma = riga.FindControl("ChkValidaArma") as CheckBox;
                        tc.Valida(id, chkValidaArma.Checked);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            switch (RbtnTipo.SelectedValue)
            {
                case "Giorno":
                    CalendarValidazione.SelectedDate = DateTime.Now.Date;
                    CercaPerGiorno();
                    break;
                case "Mese":
                    DdlRisorsa.SelectedIndex = 0;
                    DdlMese.SelectedValue = DateTime.Now.Month.ToString();
                    DdlAnno.SelectedValue = DateTime.Now.Year.ToString();
                    PnlTotaleOreLavorate.Visible = false;
                    LblOreLavorateTotali.Text = string.Empty;
                    LblGiorniLavoratiTotali.Text = string.Empty;
                    GrdRisultatiRicerca.DataSource = null;
                    GrdRisultatiRicerca.DataBind();
                    break;
            }
        }
    }
}