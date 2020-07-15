using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;
using System.Data;
using System.Data.SqlClient;
using System.Data.EntityClient;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace TimeSheetManager
{
    public partial class GestioneTasks : System.Web.UI.Page
    {
        ContrattiController cc = new ContrattiController();
        TaskController tc = new TaskController();

        // Report
        private CrystalReport.ReportSingoloTask report = new CrystalReport.ReportSingoloTask();
        ReportDocument cryRpt = new ReportDocument();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    NascondiPannelli();
                    PnlPrincipale.Visible = true;
                    CaricaContratti();
                    CaricaProgetti();
                    CaricaFigureProfessionali();
                    CaricaTasksPadre();
                    Session["TITOLO"] = "Gestione Tasks";
                }
                catch (Exception ex)
                {
                    LblMessaggio.Text = "Eccezione: " + ex.Message;
                    Messaggio_ModalPopupExtender.Show();
                }
            }
            else
            {
                if (PnlReport.Visible)
                {
                    report.SetDataSource((DataTable)ViewState["TABLE"]);
                    CrystalReportViewer2.ReportSource = report;
                    CrystalReportViewer2.DataBind();
                }
            }

            SettaVisibilitaAbilitazione();
        }

        private void SettaVisibilitaAbilitazione()
        {
            BtnNuovoTask.Visible = (Session["RISORSA"] as Risorse).IsAdmin;
        }

        private void CaricaContratti()
        {
            DdlContratti.DataSource = cc.GetContratti(true);
            DdlContratti.DataBind();

            Contratti contrattoDefault = cc.GetContrattoDefault();
            DdlContratti.SelectedValue = contrattoDefault.Id.ToString();

            RiempiDatiContratto(contrattoDefault.Id);
        }

        private void CaricaProgetti()
        {
            try
            {
                DdlProgetti.DataSource = tc.GetProgetti();
                DdlProgetti.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void RiempiDatiContratto(int idContratto)
        {
            Contratti datiContrattoDefault = cc.GetContrattoById(idContratto);

            LblDataContratto.Text = datiContrattoDefault.Data.ToShortDateString();
            LblBudget.Text = datiContrattoDefault.Budget.ToString("c");
        }

        private void CaricaFigureProfessionali()
        {
            try
            {
                ListViewGiorniPerFigura.DataSource = cc.GetFigureByContrattoId(Convert.ToInt32(DdlContratti.SelectedValue));
                ListViewGiorniPerFigura.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CaricaTasksPadre()
        {
            try
            {
                List<Tasks> elenco = tc.GetTasks(null,
                    Convert.ToInt32(DdlContratti.SelectedValue),
                    DdlProgetti.SelectedValue.ToString(),
                    null,
                    null,
                    null,
                    string.Empty,
                    null,
                    string.Empty,
                    null,
                    null);
                if (elenco != null && elenco.Count() > 0)
                {
                    DdlTaskPadre.DataSource = elenco;
                    DdlTaskPadre.DataBind();
                    DdlTaskPadre.Items.Insert(0, "- Tasks -");
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
                // Verifico che la ricerca non può essere effettuata dai campi della listview
                Boolean campoValorizzato = false;
                foreach (ListViewItem singolo in ListViewGiorniPerFigura.Items)
                {
                    TextBox txtTmp = singolo.FindControl("TxtGiorniRisorsa") as TextBox;
                    campoValorizzato = !string.IsNullOrEmpty(txtTmp.Text);
                }

                if (campoValorizzato)
                {
                    LblMessaggio.Text = "Non è possibile effettuare ricercche se i campi delle giornate per risorsa sono valorizzati";
                    Messaggio_ModalPopupExtender.Show();
                }
                else
                {
                    Cerca();
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
                Int32? idTask = null;
                Int32? contratto_FK = Convert.ToInt32(DdlContratti.SelectedValue);
                string progetto_Fk = DdlProgetti.SelectedValue.ToString();
                DateTime? dataRichiesta = null;
                Boolean? inGaranzia = ChkInGaranzia.Checked;
                Int32? numeroTask = null;
                string titolo = TxtTitolo.Text;
                decimal? totaleGiornate = null;
                string descrizione = TxtDescrizione.Text;
                Boolean? terminato = null;
                Int32? figlioDi = null;

                if (!string.IsNullOrEmpty(TxtDataRichiesta.Text))
                {
                    dataRichiesta = Convert.ToDateTime(TxtDataRichiesta.Text);
                }
                    
                if (!string.IsNullOrEmpty(TxtNumeroTask.Text))
                {
                    numeroTask = Convert.ToInt32(TxtNumeroTask.Text);
                }
                    
                if (!string.IsNullOrEmpty(TxtNumeroTotaleGiornate.Text))
                {
                    totaleGiornate = Convert.ToDecimal(TxtNumeroTotaleGiornate.Text);
                }
                    
                if (DdlTaskPadre.SelectedIndex > 0)
                {
                    figlioDi = Convert.ToInt32(DdlTaskPadre.SelectedValue);
                }
                    
                List<Tasks> elenco = tc.GetTasks(idTask,
                    contratto_FK,
                    progetto_Fk,
                    dataRichiesta,
                    inGaranzia,
                    numeroTask,
                    titolo,
                    totaleGiornate,
                    descrizione,
                    terminato,
                    figlioDi);

                GrdRisultatiRicerca.DataSource = elenco;
                GrdRisultatiRicerca.DataBind();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnNuovoTask_Click(object sender, EventArgs e)
        {
            try
            {
                string errore = EseguiVerifiche();
                if (string.IsNullOrEmpty(errore))
                {
                    // Creo il task
                    Tasks nuovo = new Tasks
                    {
                        NumeroTask = Convert.ToInt32(TxtNumeroTask.Text),
                        Progetto_FK = DdlProgetti.SelectedValue,
                        Titolo = TxtTitolo.Text,
                        DataRichiesta = Convert.ToDateTime(TxtDataRichiesta.Text),
                        PreventivoGGUU = Convert.ToDecimal(TxtNumeroTotaleGiornate.Text.Replace(".", ",")),
                        InGaranzia = ChkInGaranzia.Checked,
                        Descrizione = TxtDescrizione.Text
                    };
                    if (DdlTaskPadre.SelectedIndex > 0)
                        nuovo.FiglioDi = Convert.ToInt32(DdlTaskPadre.SelectedValue);

                    // Creo la lista delle giornate per risorsa
                    List<PreventivoTask> elencoGiornatePerRisorsa = new List<PreventivoTask>();
                    PreventivoTask nuovoP = null;
                    foreach (ListViewItem singolo in ListViewGiorniPerFigura.Items)
                    {
                        TextBox txtTmp = singolo.FindControl("TxtGiorniRisorsa") as TextBox;
                        if (!string.IsNullOrEmpty(txtTmp.Text))
                        {
                            Label lblTmp = singolo.FindControl("LblCodiceFigura") as Label;
                            nuovoP = new PreventivoTask
                            {
                                FigureProfessionali_FK = lblTmp.Text,
                                PreventivoGGUU = Convert.ToDecimal(txtTmp.Text.Replace(".", ","))
                            };
                            elencoGiornatePerRisorsa.Add(nuovoP);
                        }
                    }

                    if (ViewState["IDSELEZIONATO"] == null)
                    {
                        tc.InsertTask(nuovo, elencoGiornatePerRisorsa);
                    }
                    else
                    {
                        nuovo.Id = Convert.ToInt32(ViewState["IDSELEZIONATO"]);
                        tc.UpdateTask(nuovo, elencoGiornatePerRisorsa);
                    }

                    Cerca();
                    LblMessaggio.Text = "Operazione avvenuta con successo";
                }
                else
                {
                    LblMessaggio.Text = errore;
                }

                Messaggio_ModalPopupExtender.Show();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private string EseguiVerifiche()
        {
            string errore = string.Empty;
            bool esito = true;
            try
            {
                esito = Int32.TryParse(TxtNumeroTask.Text, out int numero);
                if (!esito)
                {
                    return "Inserire un Numero di task valido";
                }

                esito = DateTime.TryParse(TxtDataRichiesta.Text, out DateTime data);
                if (!esito)
                {
                    return "Inserire una data richiesta di task valida";
                }

                esito = decimal.TryParse(TxtNumeroTotaleGiornate.Text.Replace(".", ","), out decimal totaleGiornate);
                if (!esito)
                {
                    return "Inserire una numero di totale giornate di task valido";
                }

                decimal totaleGiornateCalcolato = decimal.Zero;
                foreach (ListViewItem singolo in ListViewGiorniPerFigura.Items)
                {
                    if (esito)
                    {
                        TextBox txtTmp = singolo.FindControl("TxtGiorniRisorsa") as TextBox;
                        if (!string.IsNullOrEmpty(txtTmp.Text))
                        {
                            esito = decimal.TryParse(txtTmp.Text.Replace(".", ","), out decimal giornateFigura);
                            totaleGiornateCalcolato += giornateFigura;
                        }
                    }
                }

                if (!esito)
                {
                    return "Inserire una numero di giornate di task per figura valido";
                }

                if (totaleGiornate != totaleGiornateCalcolato)
                {
                    return "Il totale delle giornate inserito non è conforme al numero di giornate per figura professionale";
                }

                return string.Empty;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            CaricaContratti();
            CaricaFigureProfessionali();
            CaricaTasksPadre();
            TxtDataRichiesta.Text = string.Empty;
            ChkInGaranzia.Checked = false;
            TxtNumeroTask.Text = string.Empty;
            TxtTitolo.Text = string.Empty;
            TxtNumeroTotaleGiornate.Text = string.Empty;
            TxtDescrizione.Text = string.Empty;
            ViewState["IDSELEZIONATO"] = null;
        }

        protected void DdlContratti_SelectedIndexChanged(object sender, EventArgs e)
        {
            RiempiDatiContratto(Convert.ToInt32(DdlContratti.SelectedValue));
            ListViewGiorniPerFigura.DataSource = cc.GetFigureByContrattoId(Convert.ToInt32(DdlContratti.SelectedValue));
            ListViewGiorniPerFigura.DataBind();
        }

        protected void DdlProgetti_SelectedIndexChanged(object sender, EventArgs e)
        {
            CaricaTasksPadre();
        }

        protected void GrdRisultatiRicerca_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    Tasks t = e.Row.DataItem as Tasks;
                    List<PreventivoTask> preventivo = tc.GetPreventivoGiornateByTaskId(t.Id);
                    ((ListView)e.Row.FindControl("ListViewGiorniPerFiguraInGriglia")).DataSource = preventivo;
                    ((ListView)e.Row.FindControl("ListViewGiorniPerFiguraInGriglia")).DataBind();

                    // Visibilità dei bottoni a seconda dello stato di terminazione del task
                    ((Button)e.Row.FindControl("BtnModificaTask")).Visible = !t.Terminato;
                    ((Button)e.Row.FindControl("BtnEliminaTask")).Visible = !t.Terminato;
                    ((Button)e.Row.FindControl("BtnTerminaTask")).Visible = !t.Terminato;

                    // Se il task è utilizzato non posso eliminarlo e nascondo il bottone relativo
                    if (t.IsUtilizzato)
                    {
                        ((Button)e.Row.FindControl("BtnEliminaTask")).Visible = false;
                    }

                    if (t.NumeroTaskPadre == 0)
                    {
                        e.Row.Cells[0].Text = "-";
                    }

                    // Stile bottone stampa
                    if (t.PreventivoInviato)
                    {
                        ((Button)e.Row.FindControl("BtnStampaTask")).CssClass = "BottoneRistampaInGriglia";
                        ((Button)e.Row.FindControl("BtnStampaTask")).Text = "Ristampa";
                    }
                    else
                    {
                        ((Button)e.Row.FindControl("BtnStampaTask")).CssClass = "BottoneStampaInGriglia";
                        ((Button)e.Row.FindControl("BtnStampaTask")).Text = "Stampa";
                    }

                    // Testo bottonee edit
                    if ((Session["RISORSA"] as Risorse).IsAdmin)
                    {
                        ((Button)e.Row.FindControl("BtnModificaTask")).Text = "Modifica";
                    }
                    else
                    {
                        ((Button)e.Row.FindControl("BtnModificaTask")).Text = "Dettaglio";
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void GrdRisultatiRicerca_PreRender(object sender, EventArgs e)
        {
            GrdRisultatiRicerca.Columns[5].Visible = (Session["RISORSA"] as Risorse).IsAdmin;
            GrdRisultatiRicerca.Columns[7].Visible = (Session["RISORSA"] as Risorse).IsAdmin;
            GrdRisultatiRicerca.Columns[8].Visible = (Session["RISORSA"] as Risorse).IsAdmin;
        }

        private void NascondiPannelli()
        {
            PnlPrincipale.Visible = false;
            PnlReport.Visible = false;
        }

        protected void GrdRisultatiRicerca_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                switch (e.CommandName.ToString())
                {
                    case "Modifica":
                        RiempiMascheraPerModifica(Convert.ToInt32(e.CommandArgument));
                        break;
                    case "Elimina":
                        tc.DeleteTask(Convert.ToInt32(e.CommandArgument));
                        Cerca();
                        LblMessaggio.Text = "Operazione avvenuta con successo";
                        Messaggio_ModalPopupExtender.Show();
                        break;
                    case "Termina":
                        tc.TerminaTask(Convert.ToInt32(e.CommandArgument));
                        Cerca();
                        LblMessaggio.Text = "Operazione avvenuta con successo";
                        Messaggio_ModalPopupExtender.Show();
                        break;
                    case "Stampa":
                        tc.SettaPreventivoInviato(Convert.ToInt32(e.CommandArgument));
                        Stampa(Convert.ToInt32(e.CommandArgument));
                        break;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void RiempiMascheraPerModifica(Int32 idTask)
        {
            try
            {
                ViewState["IDSELEZIONATO"] = idTask;
                Tasks task = tc.GetTasks(
                    idTask, 
                    null, 
                    string.Empty, 
                    null, 
                    null, 
                    null, 
                    string.Empty, 
                    null, 
                    string.Empty, 
                    null, 
                    null).FirstOrDefault();

                // Contratto
                DdlContratti.SelectedValue = task.IdContratto.ToString();
                RiempiDatiContratto(Convert.ToInt32(task.IdContratto));
                // Figure professionali
                CaricaFigureProfessionali();
                // Altri campi
                DdlProgetti.SelectedValue = task.Progetto_FK;
                TxtDataRichiesta.Text = task.DataRichiesta.ToShortDateString();
                ChkInGaranzia.Checked = task.InGaranzia;
                TxtNumeroTask.Text = task.NumeroTask.ToString();
                TxtTitolo.Text = task.Titolo;
                TxtNumeroTotaleGiornate.Text = task.PreventivoGGUU.ToString();
                TxtDescrizione.Text = task.Descrizione;
                // Task Padre
                CaricaTasksPadre();
                if (task.FiglioDi.HasValue)
                {
                    DdlTaskPadre.SelectedValue = task.FiglioDi.ToString();
                }
                // Giornate per figura
                List<PreventivoTask> elenco = tc.GetPreventivoGiornateByTaskId(task.Id);
                foreach (ListViewItem singolo in ListViewGiorniPerFigura.Items)
                {
                    Label lblTmp = singolo.FindControl("LblCodiceFigura") as Label;
                    TextBox txtTmp = singolo.FindControl("TxtGiorniRisorsa") as TextBox;
                    var giornatePerTipoRisorsa = elenco.Where(w => w.FigureProfessionali_FK == lblTmp.Text);
                    if (giornatePerTipoRisorsa != null && giornatePerTipoRisorsa.Count() > 0)
                    {
                        txtTmp.Text = giornatePerTipoRisorsa.FirstOrDefault().PreventivoGGUU.ToString();
                    } 
                    else
                    {
                        txtTmp.Text = string.Empty;
                    }  
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void Stampa(Int32 idTask)
        {
            Boolean eccezionePerRedirect = false;
            try
            {
                using (var context = new TimesheetEntities())
                {
                    EntityConnection ec = context.Connection as EntityConnection;
                    SqlConnection sc = (SqlConnection)ec.StoreConnection;
                    string stored = "[uspGetSituazioneSingoloTask]";
                    SqlDataAdapter Da = new SqlDataAdapter(stored, sc);
                    Da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    Da.SelectCommand.Parameters.Add("@idTask", SqlDbType.Int).Value = idTask;

                    DataTable dt = new DataTable("DtSituazioneSingoloTask");
                    Da.Fill(dt);
                    ViewState["TABLE"] = dt;
                    if (dt.Rows.Count > 0)
                    {
                        NascondiPannelli();
                        report.SetDataSource(dt);
                        CrystalReportViewer2.ReportSource = report;
                        CrystalReportViewer2.DataBind();
                        PnlReport.Visible = true;
                    }
                    else
                    {
                        LblMessaggio.Text = "Non è stato possibile reperire i dati del task";
                        Messaggio_ModalPopupExtender.Show();
                    }
                }
            }
            catch (System.Threading.ThreadAbortException t_ex)
            {
                eccezionePerRedirect = true;
                string s = t_ex.Message;
            }
            catch (Exception ex)
            {
                if (!eccezionePerRedirect)
                    throw ex;
            }
        }
    }
}