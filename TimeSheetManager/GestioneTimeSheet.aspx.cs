using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;

namespace TimeSheetManager
{
    public partial class GestioneTimeSheet : System.Web.UI.Page
    {
        FigureProfessionaliController fc = new FigureProfessionaliController();
        RisorsaController rc = new RisorsaController();
        TaskController tc = new TaskController();
        TimeSheetController tsc = new TimeSheetController();

        struct GrdIndex
        {
            public const int Id = 0;
            public const int Data = 1;
            public const int Risorsa = 2;
            public const int Figura = 3;
            public const int OrarioDiLavoro = 4;
            public const int Task = 5;
            public const int SituazioneTask = 6;
            public const int Lavorato = 7;
            public const int GGHHMM = 8;
            public const int Ore = 9;
            public const int LavoratoInMinuti = 10;
            public const int Validazione = 11;
            public const int Validato = 12;
            public const int ValidatoArma = 13;
            public const int Modifica = 14;
            public const int Elimina = 15;
        }


        #region Gestione Giornata
        string dataTemp; // Utilizzato nella griglia dei giorni

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    SettaDateInizialiMese();
                    CaricaRisorse();
                    CaricaFigureProfessionali();
                    CaricaProgetti();
                    DisabilitaControlliPagina();
                    Pulisci(true);
                    AbilitaControlliPerRicerca();
                    Cerca();
                    Session["TITOLO"] = "Gestione TimeSheet";
                }
                catch (Exception ex)
                {
                    LblMessaggio.Text = "Eccezione: " + ex.Message;
                    Messaggio_ModalPopupExtender.Show();
                }
            }
        }

        private void SettaDateInizialiMese()
        {
            try
            {
                TxtData.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToShortDateString();
                if (DateTime.Now.Month < 12)
                {
                    TxtDataA.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month + 1, 1).AddDays(-1).ToShortDateString();
                }
                else
                {
                    TxtDataA.Text = new DateTime(DateTime.Now.Year + 1, 1, 1).AddDays(-1).ToShortDateString();
                }   
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
                if (!(Session["RISORSA"] as Risorse).IsAdmin)
                    DdlRisorsa.Enabled = false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CaricaFigureProfessionali()
        {
            try
            {
                List<FigureProfessionali> elenco = null;
                if (DdlRisorsa.SelectedIndex == 0)
                {
                    elenco = fc.GetFigure(string.Empty, string.Empty, null, null, null, null, null);
                }
                else
                {
                    elenco = fc.GetFigureByCodiceRisorsa(DdlRisorsa.SelectedValue);
                }
                DdlFigura.DataSource = elenco;
                DdlFigura.DataBind();

                if ((Session["RISORSA"] as Risorse).IsAdmin)
                {
                    DdlFigura.Items.Insert(0, new ListItem("----- Tutte -----"));
                }

                if (DdlRisorsa.SelectedIndex != 0)
                {
                    DdlFigura.SelectedValue = fc.GetRuoloDiDefaultByCodiceRisorsa(DdlRisorsa.SelectedValue);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void BtnCerca_Click(object sender, EventArgs e)
        {
            try
            {
                if (IsOreRendicontateValido(TxtOreRendicontate.Text))
                {
                    Cerca();
                }
                else
                {
                    LblMessaggio.Text = "I valori in minuti del campo Ore Rrendicontate possono essere 00, 15, 30, 45";
                    Messaggio_ModalPopupExtender.Show();
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void Cerca()
        {
            try
            {
                Int32? id = null;
                DateTime? dataDa = null, dataA = null;
                TimeSpan? ingresso = null, pausaPranzo = null, rientro = null, uscita = null;
                string attivita = string.Empty, risorse_Fk = string.Empty, figure_Fk = string.Empty;
                decimal? oreRendicontate = null;

                if (ViewState["IDSELEZIONATO"] != null)
                {
                    id = Convert.ToInt32(ViewState["IDSELEZIONATO"]);
                }

                if (TxtOreRendicontate.Text != string.Empty)
                {
                    oreRendicontate = CreaOreRendicontate(TxtOreRendicontate.Text);
                }

                if (TxtData.Text != string.Empty)
                {
                    dataDa = Convert.ToDateTime(TxtData.Text);
                }

                if (TxtDataA.Text != string.Empty)
                {
                    dataA = Convert.ToDateTime(TxtDataA.Text);
                }

                if (TxtIngresso.Text != string.Empty)
                {
                    ingresso = new TimeSpan(Convert.ToInt32(TxtIngresso.Text.Split(':')[0]), Convert.ToInt32(TxtIngresso.Text.Split(':')[1]), 0);
                }

                if (TxtPranzo.Text != string.Empty)
                {
                    pausaPranzo = new TimeSpan(Convert.ToInt32(TxtPranzo.Text.Split(':')[0]), Convert.ToInt32(TxtPranzo.Text.Split(':')[1]), 0);
                }

                if (TxtRientro.Text != string.Empty)
                {
                    rientro = new TimeSpan(Convert.ToInt32(TxtRientro.Text.Split(':')[0]), Convert.ToInt32(TxtRientro.Text.Split(':')[1]), 0);
                }

                if (TxtUscita.Text != string.Empty)
                {
                    uscita = new TimeSpan(Convert.ToInt32(TxtUscita.Text.Split(':')[0]), Convert.ToInt32(TxtUscita.Text.Split(':')[1]), 0);
                }

                if (TxtAttivita.Text != string.Empty)
                {
                    attivita = TxtAttivita.Text;
                }

                if (DdlRisorsa.SelectedIndex > 0)
                {
                    risorse_Fk = DdlRisorsa.SelectedValue;
                }

                if (DdlFigura.SelectedIndex > 0)
                {
                    figure_Fk = DdlFigura.SelectedValue;
                }

                List<TimeSheet> elenco = tsc.GetTimeSheet(id,
                    dataDa,
                    dataA,
                    risorse_Fk,
                    figure_Fk,
                    ingresso,
                    pausaPranzo,
                    rientro,
                    uscita,
                    attivita,
                    oreRendicontate,
                    ChkInGaranzia.Checked);

                if (elenco != null && elenco.Count() > 0)
                {
                    GrdRisultatiRicerca.DataSource = elenco;
                    PnlRisultatiRicerca.Visible = true;
                }
                else
                {
                    GrdRisultatiRicerca.DataSource = null;
                    PnlRisultatiRicerca.Visible = false;
                }
                GrdRisultatiRicerca.DataBind();

                SettaTotale(elenco);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CercaPostInserimento()
        {
            try
            {
                DateTime? dataDa = null, dataA = null;
                string risorse_Fk = string.Empty, figure_Fk = string.Empty;

                dataDa = new DateTime(
                    Convert.ToInt32(TxtData.Text.Split('/')[2]),
                    Convert.ToInt32(TxtData.Text.Split('/')[1]), 1);

                dataA = dataDa.Value.AddMonths(1).AddDays(-1);

                if (DdlRisorsa.SelectedIndex > 0)
                {
                    risorse_Fk = DdlRisorsa.SelectedValue;
                }

                if (DdlFigura.SelectedIndex > 0)
                {
                    figure_Fk = DdlFigura.SelectedValue;
                }

                List<TimeSheet> elenco = tsc.GetTimeSheet(
                    dataDa,
                    dataA,
                    risorse_Fk,
                    figure_Fk);
                if (elenco != null && elenco.Count() > 0)
                {
                    GrdRisultatiRicerca.DataSource = elenco;
                    PnlRisultatiRicerca.Visible = true;
                }
                else
                {
                    GrdRisultatiRicerca.DataSource = null;
                    PnlRisultatiRicerca.Visible = false;
                }
                GrdRisultatiRicerca.DataBind();

                SettaTotale(elenco);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void SettaTotale(List<TimeSheet> elenco)
        {
            CalcolaSommaOre(elenco, out TimeSpan oreRendicontateTotali, out TimeSpan oreLavorateTotali, out TimeSpan differenza);
            LblOreRendicontateTotali.Text = Math.Truncate(oreRendicontateTotali.TotalHours).ToString() + ":" + oreRendicontateTotali.Minutes.ToString("D2");
            LblOreLavorateTotali.Text = Math.Truncate(oreLavorateTotali.TotalHours).ToString() + ":" + oreLavorateTotali.Minutes.ToString("D2");
            LblDifferenza.Text = differenza.ToString().Substring(0, differenza.ToString().Length - 3);
            if (differenza.TotalMinutes > 0)
            {
                LblDifferenza.ForeColor = System.Drawing.Color.Green;
            }
            else if (differenza.TotalMinutes == 0)
            {
                LblDifferenza.ForeColor = System.Drawing.Color.Black;
            }
            else
            {
                LblDifferenza.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void BtnNuovaGiornata_Click(object sender, EventArgs e)
        {
            try
            {
                if (IsOreRendicontateValido(TxtOreRendicontate.Text))
                {
                    SalvaGiornata();
                }
                else
                {
                    LblMessaggio.Text = "I valori in minuti del campo Ore Rrendicontate possono essere 00, 15, 30, 45";
                    Messaggio_ModalPopupExtender.Show();
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void SalvaGiornata()
        {
            try
            {
                TimeSheet nuovo = new TimeSheet();
                nuovo.Data = Convert.ToDateTime(TxtData.Text);
                nuovo.Risorse_FK = DdlRisorsa.SelectedValue;
                nuovo.FigureProfessionali_FK = DdlFigura.SelectedValue;
                nuovo.Ingresso = new TimeSpan(Convert.ToInt32(TxtIngresso.Text.Split(':')[0]), Convert.ToInt32(TxtIngresso.Text.Split(':')[1]), 0);
                if (!string.IsNullOrEmpty(TxtPranzo.Text))
                {
                    nuovo.PausaPranzo = new TimeSpan(Convert.ToInt32(TxtPranzo.Text.Split(':')[0]), Convert.ToInt32(TxtPranzo.Text.Split(':')[1]), 0);
                }
                if (!string.IsNullOrEmpty(TxtRientro.Text))
                {
                    nuovo.Rientro = new TimeSpan(Convert.ToInt32(TxtRientro.Text.Split(':')[0]), Convert.ToInt32(TxtRientro.Text.Split(':')[1]), 0);
                }
                nuovo.Uscita = new TimeSpan(Convert.ToInt32(TxtUscita.Text.Split(':')[0]), Convert.ToInt32(TxtUscita.Text.Split(':')[1]), 0);
                nuovo.Attivita = TxtAttivita.Text;
                nuovo.InGaranzia = ChkInGaranzia.Checked;

                if (!string.IsNullOrEmpty(TxtOreRendicontate.Text))
                {
                    nuovo.OreRendicontate = CreaOreRendicontate(TxtOreRendicontate.Text);
                }

                if (ViewState["IDSELEZIONATO"] == null)
                {
                    tsc.InsertGiornata(nuovo);
                }
                else
                {
                    nuovo.Id = Convert.ToInt32(ViewState["IDSELEZIONATO"]);
                    tsc.UpdateGiornata(nuovo);
                }
                Pulisci(false);
                CercaPostInserimento();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        private bool IsOreRendicontateValido(string valoreText)
        {
            bool esito = true;

            if (!string.IsNullOrEmpty(valoreText))
            {
                List<byte> frazioniValide = new List<byte> { 00, 15, 30, 45 };

                string[] valoriSplit = valoreText.Split(':');

                if (valoriSplit.Length > 0)
                {
                    byte frazione = Convert.ToByte(valoriSplit[1]);
                    esito = frazioniValide.Contains(frazione) ? true : false;
                }
                else
                {
                    return true; // E' un intero
                }
            }

            return esito;
        }

        private decimal CreaOreRendicontate(string valoreText)
        {
            decimal risultato = decimal.Zero;

            try
            {
                if (!string.IsNullOrEmpty(valoreText))
                {
                    string[] valoriSplit = valoreText.Split(':');

                    risultato = new decimal(Convert.ToDouble(valoriSplit[0]));
                    decimal frazione = decimal.Zero;
                    switch (valoriSplit[1])
                    {
                        case "00":
                            frazione = 0.00M;
                            break;
                        case "15":
                            frazione = 0.25M;
                            break;
                        case "30":
                            frazione = 0.50M;
                            break;
                        case "45":
                            frazione = 0.75M;
                            break;
                    }
                    risultato += frazione;
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }

            return risultato;
        }

        private TimeSpan CreaOreRendicontate(decimal valore)
        {
            decimal parteIntera = Math.Truncate(valore);
            int parteFrazionaria = 0;
            switch (valore - parteIntera)
            {
                case 0.00M:
                    parteFrazionaria = 0;
                    break;
                case 0.25M:
                    parteFrazionaria = 15;
                    break;
                case 0.50M:
                    parteFrazionaria = 30;
                    break;
                case 0.75M:
                    parteFrazionaria = 45;
                    break;
            }
            return new TimeSpan(Convert.ToInt32(parteIntera), parteFrazionaria, 0);
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            try
            {
                Pulisci(true);
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void Pulisci(Boolean settaDateIniziali)
        {
            if (settaDateIniziali)
            {
                SettaDateInizialiMese();
            }

            DdlFigura.SelectedValue = fc.GetRuoloDiDefaultByCodiceRisorsa(DdlRisorsa.SelectedValue);

            if (RbtnOperazione.SelectedIndex == 0)
            {
                TxtIngresso.Text = (Session["RISORSA"] as Risorse).Ingresso.Value.ToString().Substring(0, 5);
                TxtPranzo.Text = "13:00";
                TxtRientro.Text = "13:30";
                TxtUscita.Text = (Session["RISORSA"] as Risorse).Uscita.Value.ToString().Substring(0, 5);
                TxtOreRendicontate.Text = "8:00";
            }
            else
            {
                TxtIngresso.Text = string.Empty;
                TxtPranzo.Text = string.Empty;
                TxtRientro.Text = string.Empty;
                TxtUscita.Text = string.Empty;
                TxtOreRendicontate.Text = string.Empty;
            }
            TxtAttivita.Text = string.Empty;
            ChkInGaranzia.Checked = false;

            ViewState["IDSELEZIONATO"] = null;
        }

        protected void RbtnOperazione_SelectedIndexChanged(object sender, EventArgs e)
        {
            SettaModalita();
        }

        private void SettaModalita()
        {
            DisabilitaControlliPagina();
            Pulisci(true);
            if (RbtnOperazione.SelectedIndex == 0)
            {
                AbilitaControlliPerInserimento();
                TxtData.Text = DateTime.Now.ToShortDateString();
            }
            else
            {
                AbilitaControlliPerRicerca();
            }
        }

        protected void DdlRisorsa_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Carico figure professionali
            CaricaFigureProfessionali();

            // Porto la form allo stato iniziale
            RbtnOperazione.SelectedIndex = 1;
            Pulisci(true);
            AbilitaControlliPerRicerca();
            Cerca();
        }

        private void DisabilitaControlliPagina()
        {
            TxtData.Enabled = false;
            TxtDataA.Enabled = false;
            DdlRisorsa.Enabled = false;
            DdlFigura.Enabled = false;
            TxtIngresso.Enabled = false;
            TxtPranzo.Enabled = false;
            TxtRientro.Enabled = false;
            TxtUscita.Enabled = false;

            TxtOreRendicontate.Enabled = false;
            TxtAttivita.Enabled = false;
            BtnCerca.Visible = false;
            BtnNuovaGiornata.Visible = false;
        }

        private void AbilitaControlliPerInserimento()
        {
            TxtData.Enabled = true;
            TxtDataA.Enabled = false;
            TxtDataA.Text = string.Empty;
            DdlRisorsa.Enabled = (Session["RISORSA"] as Risorse).IsAdmin;
            DdlFigura.Enabled = true;
            TxtIngresso.Enabled = true;
            TxtPranzo.Enabled = true;
            TxtRientro.Enabled = true;
            TxtUscita.Enabled = true;
            TxtOreRendicontate.Enabled = true;
            DdlTask.Enabled = true;
            TxtAttivita.Enabled = true;
            BtnCerca.Visible = false;
            BtnNuovaGiornata.Visible = true;
        }

        private void AbilitaControlliPerRicerca()
        {
            bool isAdmin = (Session["RISORSA"] as Risorse).IsAdmin;
            TxtData.Enabled = true;
            TxtDataA.Enabled = true;
            DdlRisorsa.Enabled = isAdmin;
            DdlFigura.Enabled = true;
            TxtIngresso.Enabled = true;
            TxtPranzo.Enabled = true;
            TxtRientro.Enabled = true;
            TxtUscita.Enabled = true;
            TxtOreRendicontate.Enabled = true;
            DdlTask.Enabled = true;
            TxtAttivita.Enabled = true;
            BtnCerca.Visible = true;
            BtnNuovaGiornata.Visible = false;
        }

        protected void GrdRisultatiRicerca_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Modifica":
                    TimeSheet giornata = tsc.GetSingolaGiornata(Convert.ToInt32(GrdRisultatiRicerca.Rows[Convert.ToInt32(e.CommandArgument)].Cells[GrdIndex.Id].Text));
                    Pulisci(false);
                    DisabilitaControlliPagina();
                    AbilitaControlliPerInserimento();
                    RbtnOperazione.SelectedIndex = 0;
                    ViewState["IDSELEZIONATO"] = giornata.Id;
                    TxtData.Text = giornata.Data.ToShortDateString();
                    DdlRisorsa.SelectedValue = giornata.Risorse_FK;
                    CaricaFigureProfessionali();
                    DdlFigura.SelectedValue = giornata.FigureProfessionali_FK;
                    TxtIngresso.Text = TrasformaTimespanInString(giornata.Ingresso);
                    TxtPranzo.Text = TrasformaTimespanInString(giornata.PausaPranzo);
                    TxtRientro.Text = TrasformaTimespanInString(giornata.Rientro);
                    TxtUscita.Text = TrasformaTimespanInString(giornata.Uscita);
                    TxtOreRendicontate.Text = giornata.OreRendicontate.ToString().Replace(',', ':');
                    TxtAttivita.Text = giornata.Attivita;
                    ChkInGaranzia.Checked = giornata.InGaranzia;
                    break;
                case "Elimina":
                    tsc.DeleteGiornata(Convert.ToInt32(GrdRisultatiRicerca.Rows[Convert.ToInt32(e.CommandArgument)].Cells[GrdIndex.Id].Text));
                    CercaPostInserimento();
                    break;
                case "GestioneTasks":
                    PulisciGestioneTask();
                    ApriGestioneTask(Convert.ToInt32(GrdRisultatiRicerca.Rows[Convert.ToInt32(e.CommandArgument)].Cells[GrdIndex.Id].Text));
                    break;
            }
        }

        protected void GrdRisultatiRicerca_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TimeSheet datoDellaRiga = ((TimeSheet)e.Row.DataItem);

            e.Row.Cells[GrdIndex.Id].Visible = false;

            bool isAdmin = (Session["RISORSA"] as Risorse).IsAdmin;

            if (!isAdmin)
            {
                e.Row.Cells[GrdIndex.Lavorato].Visible = false;
                e.Row.Cells[GrdIndex.GGHHMM].Visible = false;
                e.Row.Cells[GrdIndex.LavoratoInMinuti].Visible = false;
                e.Row.Cells[GrdIndex.Validazione].Visible = false;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblIngresso") as Label).Text = (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblIngresso") as Label).Text.Substring(0, 5);
                (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblUscita") as Label).Text = (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblUscita") as Label).Text.Substring(0, 5);
                (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaDalle") as Label).Text = (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaDalle") as Label).Text.Substring(0, 5);
                (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaAlle") as Label).Text = (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaAlle") as Label).Text.Substring(0, 5);

                if ((e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblIngresso") as Label).Text == "00:00") (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblIngresso") as Label).Text = string.Empty;
                if ((e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblUscita") as Label).Text == "00:00") (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblUscita") as Label).Text = string.Empty;
                if ((e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaDalle") as Label).Text == "00:00") (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaDalle") as Label).Text = string.Empty;
                if ((e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaAlle") as Label).Text == "00:00") (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblPausaAlle") as Label).Text = string.Empty;

                if (dataTemp == e.Row.Cells[GrdIndex.Data].Text)
                {
                    e.Row.Cells[GrdIndex.Data].Text = string.Empty;
                }
                else
                {
                    dataTemp = e.Row.Cells[GrdIndex.Data].Text;
                }

                bool isValidato = (datoDellaRiga.Validato != 0);
                if (isValidato)
                {
                    ((Image)e.Row.FindControl("imgValidato")).ImageUrl = "~/Immagini/check.png";
                } 
                else
                {
                    ((Image)e.Row.FindControl("imgValidato")).ImageUrl = "~/Immagini/blank.png";
                }
                    
                bool isValidatoArma = (datoDellaRiga.ValidatoArma != 0);
                if (isValidatoArma)
                {
                    ((Image)e.Row.FindControl("imgValidatoArma")).ImageUrl = "~/Immagini/check.png";
                }
                else
                {
                    ((Image)e.Row.FindControl("imgValidatoArma")).ImageUrl = "~/Immagini/blank.png";
                }

                (e.Row.Cells[GrdIndex.Ore].FindControl("LblOreRendicontate") as Label).Text =
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblOreRendicontate") as Label).Text.Substring(0, (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblOreRendicontate") as Label).Text.Length - 3);

                (e.Row.Cells[GrdIndex.Ore].FindControl("LblOreLavorate") as Label).Text =
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblOreLavorate") as Label).Text.Substring(0, (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblOreLavorate") as Label).Text.Length - 3);

                (e.Row.Cells[GrdIndex.Ore].FindControl("LblDifferenzaLavorateConRendicontate") as Label).Text =
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblDifferenzaLavorateConRendicontate") as Label).Text.Substring(0, (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblDifferenzaLavorateConRendicontate") as Label).Text.Length - 3);
                if (datoDellaRiga.DifferenzaLavoratoConRendicontato.TotalMinutes > 0)
                {
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblDifferenzaLavorateConRendicontate") as Label).ForeColor = System.Drawing.Color.Green;
                }
                else if (datoDellaRiga.DifferenzaLavoratoConRendicontato.TotalMinutes == 0)
                {
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblDifferenzaLavorateConRendicontate") as Label).ForeColor = System.Drawing.Color.Black;
                }
                else
                {
                    (e.Row.Cells[GrdIndex.OrarioDiLavoro].FindControl("LblDifferenzaLavorateConRendicontate") as Label).ForeColor = System.Drawing.Color.Red;
                }

                if ((isValidato || isValidatoArma) && !isAdmin)
                {
                    e.Row.FindControl("BtnEliminaTimeSheet").Visible = false;
                    e.Row.FindControl("BtnModificaTimeSheet").Visible = false;
                }

                SettaIconaSituazioneTask(e, datoDellaRiga);

                if (datoDellaRiga.InGaranzia)
                {
                    ((Label)e.Row.FindControl("LblGiornataInGaranzia")).Visible = true;
                }

                
            }
        }

        private void SettaIconaSituazioneTask(GridViewRowEventArgs e, TimeSheet datoDellaRiga)
        {
            if (datoDellaRiga.ListaTasksLavorati != null && datoDellaRiga.ListaTasksLavorati.Count() > 0)
            {
                e.Row.FindControl("LblNessunTask").Visible = false;

                ((ListView)e.Row.FindControl("LViewTasksLavorati")).DataSource = datoDellaRiga.ListaTasksLavorati;
                ((ListView)e.Row.FindControl("LViewTasksLavorati")).DataBind();

                e.Row.FindControl("LViewTasksLavorati").Visible = true;

                // Verifica che le ore lavorate effettive sono uguali o inferiore alla somma di quelle dichiarate nei tasks. E' il caso in cui l'orario della giornata viene
                // modificato DOPO aver inseriti i tasks.
                TimeSpan orarioEffettivo = datoDellaRiga.LavoratoEffettivo;
                TimeSpan sommaLavoratoTasks = new TimeSpan(0, 0, 0);
                foreach (var singolo in datoDellaRiga.ListaTasksLavorati)
                {
                    sommaLavoratoTasks += singolo.Lavorato.Value;
                }
                if (sommaLavoratoTasks > orarioEffettivo)
                {
                    ((Image)e.Row.FindControl("ImgSituazioneTasks")).ImageUrl = "~/Immagini/outline_error.png";
                    ((Image)e.Row.FindControl("ImgSituazioneTasks")).ToolTip = "Valori non congruenti tra le ore lavorate della giornata e quelle dei singoli tasks";
                }
                else if (sommaLavoratoTasks < orarioEffettivo)
                {
                    ((Image)e.Row.FindControl("ImgSituazioneTasks")).ImageUrl = "~/Immagini/outline_info.png";
                    ((Image)e.Row.FindControl("ImgSituazioneTasks")).ToolTip = "Valori non congruenti tra le ore lavorate della giornata e quelle dei singoli tasks";
                }
            }
            else
            {
                e.Row.FindControl("LblNessunTask").Visible = true;
                e.Row.FindControl("LViewTasksLavorati").Visible = false;
                ((Image)e.Row.FindControl("ImgSituazioneTasks")).ImageUrl = "~/Immagini/outline_info.png";
                ((Image)e.Row.FindControl("ImgSituazioneTasks")).ToolTip = "Valori non congruenti tra le ore lavorate della giornata e quelle dei singoli tasks";
            }
        }

        private void CalcolaSommaOre(List<TimeSheet> elenco,
            out TimeSpan oreRendicontate,
            out TimeSpan oreLavorate,
            out TimeSpan differenza)
        {
            try
            {
                oreRendicontate = new TimeSpan();
                oreLavorate = new TimeSpan();
                if (elenco != null && elenco.Count() > 0)
                {
                    foreach (TimeSheet t in elenco)
                    {
                        oreRendicontate += CreaOreRendicontate(t.OreRendicontate);
                        oreLavorate += t.LavoratoEffettivo;
                    }
                }

                differenza = oreLavorate - oreRendicontate;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void LViewTasksLavorati_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            (e.Item.FindControl("LblLavoratoTask") as Label).Text =
                (e.Item.FindControl("LblLavoratoTask") as Label).Text.Substring(0, (e.Item.FindControl("LblLavoratoTask") as Label).Text.Length - 3);
        }
        #endregion

        #region Gestione Tasks Lavorati
        private void CaricaTask(List<string> progetti)
        {
            try
            {
                DdlTask.Items.Clear();
                List<Tasks> elenco = tc.GetTasks(null, null, string.Empty, string.Empty, null, null, null, null, progetti, true);
                DdlTask.DataSource = elenco;
                DdlTask.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CaricaProgetti()
        {
            try
            {
                DdlProgetti.DataSource = tc.GetProgetti();
                DdlProgetti.DataBind();
                DdlProgetti.Items.Insert(0, "- Progetti -");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ApriGestioneTask(int idTimesheet)
        {
            try
            {
                RecuperaGiornataSelezionata(idTimesheet);

                RecuperaTaskLavorati(idTimesheet);

                GestioneTask_ModalPopupExtender.Show();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void RecuperaGiornataSelezionata(int idTimesheet)
        {
            TimeSheet giornata = tsc.GetSingolaGiornataConCalcoliEffettivi(idTimesheet);
            ViewState["GIORNATASELEZIONATAPERGESTIONETASK"] = giornata;
            LblOreLavorateGiornata.Text = giornata.LavoratoEffettivo.ToString().Substring(0, giornata.LavoratoEffettivo.ToString().Length - 3);
        }

        private void RecuperaTaskLavorati(int idTimesheet)
        {
            List<TasksLavorati> tasksLavorati = tc.GetTaskLavoratiByTimesheetId(idTimesheet);
            ViewState["TASKSLAVORATIGIORNATA"] = tasksLavorati;
            GrdTasksLavorati.DataSource = tasksLavorati;
            GrdTasksLavorati.DataBind();
        }

        protected void BtnPulisciTask_Click(object sender, EventArgs e)
        {
            PulisciGestioneTask();
            GestioneTask_ModalPopupExtender.Show();
        }

        protected void BtnChiudiGestioneTask_Click(object sender, EventArgs e)
        {
            ViewState["GIORNATASELEZIONATAPERGESTIONETASK"] = null;
            ViewState["TASKSLAVORATIGIORNATA"] = null;
            Pulisci(false);
            CercaPostInserimento();
        }

        private void PulisciGestioneTask()
        {
            HdnIdTask.Value = string.Empty;
            if (DdlProgetti.Items.Count > 0)
            {
                DdlProgetti.SelectedIndex = 0;
            }
            CaricaTask(null);
            TxtOreLavorateTask.Text = string.Empty;
            TxtNotaTask.Text = string.Empty;
            LblMessaggioGestioneTask.Text = string.Empty;
        }

        protected void DdlProgetti_SelectedIndexChanged(object sender, EventArgs e)
        {
            List<string> idProgetti = new List<string>();
            if (((DropDownList)sender).SelectedIndex > 0)
            {
                idProgetti.Add(((DropDownList)sender).SelectedValue);
            }
            CaricaTask(idProgetti);
            GestioneTask_ModalPopupExtender.Show();
        }

        protected void GrdTasksLavorati_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[3].Text = e.Row.Cells[3].Text.Substring(0, e.Row.Cells[3].Text.Length - 3);
                if (e.Row.Cells[4].Text.Length > 100)
                {
                    e.Row.Cells[4].Text = $"{e.Row.Cells[4].Text.Substring(0, 100)}...";
                }
            }
        }

        protected void GrdTasksLavorati_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "ModificaTask":
                    RiempiSingoloTask(Convert.ToInt32(e.CommandArgument));
                    break;
                case "EliminaTask":
                    EiminaSingoloTask(Convert.ToInt32(e.CommandArgument));
                    break;
            }
        }

        private void RiempiSingoloTask(int idTaskLavorato)
        {
            try
            {
                PulisciGestioneTask();

                TasksLavorati taskLavorato = tc.GetTaskLavoratoById(idTaskLavorato);
                HdnIdTask.Value = taskLavorato.Id.ToString();
                DdlProgetti.SelectedValue = taskLavorato.NomeProgetto;
                CaricaTask(new List<string> { taskLavorato.NomeProgetto });
                DdlTask.SelectedValue = taskLavorato.Task_FK.ToString();
                TxtOreLavorateTask.Text = TrasformaTimespanInString(taskLavorato.Lavorato);
                TxtNotaTask.Text = taskLavorato.Note;

                GestioneTask_ModalPopupExtender.Show();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnSalvaTask_Click(object sender, EventArgs e)
        {
            if (VerificaPerInserimentoTask())
            {
                TasksLavorati taskLavorato = new TasksLavorati
                {
                    Id = HdnIdTask.Value == string.Empty ? 0 : Convert.ToInt32(HdnIdTask.Value),
                    TimeSheet_FK = (ViewState["GIORNATASELEZIONATAPERGESTIONETASK"] as TimeSheet).Id,
                    Task_FK = Convert.ToInt32(DdlTask.SelectedValue),
                    Lavorato = new TimeSpan(Convert.ToInt32(TxtOreLavorateTask.Text.Split(':')[0]),
                                            Convert.ToInt32(TxtOreLavorateTask.Text.Split(':')[1]),
                                            0),
                    Note = TxtNotaTask.Text
                };

                tc.SaveTaskLavorato(taskLavorato);
                PulisciGestioneTask();
                RecuperaTaskLavorati(taskLavorato.TimeSheet_FK);
            }
            GestioneTask_ModalPopupExtender.Show();
        }

        private bool VerificaPerInserimentoTask()
        {
            // Verifica campi obbligatori
            if (DdlTask.SelectedIndex == -1)
            {
                LblMessaggioGestioneTask.Text = "Selezionare un task";
                return false;
            }
            if (TxtOreLavorateTask.Text == string.Empty)
            {
                LblMessaggioGestioneTask.Text = "Inserire ore lavorate";
                return false;
            }

            // Verifica tempo inserito
            TimeSpan oreLavorateDisponibili = new TimeSpan(Convert.ToInt32(LblOreLavorateGiornata.Text.Split(':')[0]),
                Convert.ToInt32(LblOreLavorateGiornata.Text.Split(':')[1]),
                0);

            TimeSpan oreLavorateInserite = new TimeSpan(Convert.ToInt32(TxtOreLavorateTask.Text.Split(':')[0]),
                Convert.ToInt32(TxtOreLavorateTask.Text.Split(':')[1]),
                0);

            TimeSpan oreLavorateGiaPresenti = new TimeSpan(0, 0, 0);

            List<TasksLavorati> tasksLavorati = ViewState["TASKSLAVORATIGIORNATA"] as List<TasksLavorati>;
            // Sommo le ore già presenti nei task del giorno alnetto di quello che sto controllando
            int idTaskDaEscludereDalConteggio = HdnIdTask.Value == string.Empty ? 0 : Convert.ToInt32(HdnIdTask.Value);
            foreach (var singolo in tasksLavorati.Where(t => t.Id != idTaskDaEscludereDalConteggio))
            {
                oreLavorateGiaPresenti += singolo.Lavorato.Value;
            }
            if (oreLavorateGiaPresenti + oreLavorateInserite > oreLavorateDisponibili)
            {
                TimeSpan oreDisponibili = oreLavorateDisponibili - oreLavorateGiaPresenti;
                LblMessaggioGestioneTask.Text = $"Non è possibile inserire un valore di ore lavorate superiore a { oreDisponibili.ToString().Substring(0, oreDisponibili.ToString().Length - 3) } ";
                return false;
            }

            return true;
        }

        private void EiminaSingoloTask(int idTaskLavorato)
        {
            int idTimesheet = (ViewState["GIORNATASELEZIONATAPERGESTIONETASK"] as TimeSheet).Id;
            tc.DeleteTaskLavorato(idTaskLavorato);
            PulisciGestioneTask();
            RecuperaTaskLavorati(idTimesheet);
            GestioneTask_ModalPopupExtender.Show();
        }
        #endregion

        #region Metodi Comuni
        private string TrasformaTimespanInString(TimeSpan? t)
        {
            if (t.HasValue)
            {
                string temp = t.Value.Hours.ToString() +
                    ":" +
                    (t.Value.Minutes.ToString() == "0" ? "00" : t.Value.Minutes.ToString());
                return temp;
            }
            else
            {
                return string.Empty;
            }

        }

        private string TrasformaTimespanInString(TimeSpan t)
        {
            string temp = t.Hours.ToString() +
                    ":" +
                    (t.Minutes.ToString() == "0" ? "00" : t.Minutes.ToString());
            return temp;
        }
        #endregion
    }
}