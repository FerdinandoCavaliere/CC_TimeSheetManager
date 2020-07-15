using System;
using System.Collections.Generic;
using System.Linq;
using TimeSheetManager.Classi;
using TimeSheetManager.Model;

namespace TimeSheetManager
{
    public partial class GestioneConsolidamento : System.Web.UI.Page
    {
        ConsolidamentoController consc = new ConsolidamentoController();
        ContrattiController contc = new ContrattiController();

        const string MESE_DA_CONSOLIDARE = "Mese da consolidare";
        const string SEMESTRE_DA_CONSOLIDARE = "Semestre da consolidare";

        #region Comuni e eventi
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    SettaTipoDiConsidamento();
                    CaricaAnniContratto();
                    CaricaContratti();
                    CaricaMesi();
                    PnlConsolidamentoEsistente.Visible = false;
                    Session["TITOLO"] = "Gestione Consolidamento";
                    BtnConsolida.Visible = (Session["RISORSA"] as Risorse).IsAdmin;
                }
                catch (Exception ex)
                {
                    LblMessaggio.Text = "Eccezione: " + ex.Message;
                    Messaggio_ModalPopupExtender.Show();
                }
            }
        }

        private void CaricaAnniContratto()
        {
            DdlAnniContratto.DataSource = contc.GetAnniContratti();
            DdlAnniContratto.DataBind();
        }

        private void CaricaContratti()
        {
            DdlContratti.DataSource = contc.GetContrattiByAnno(Convert.ToInt32(DdlAnniContratto.SelectedValue)); ;
            DdlContratti.DataBind();

            CaricaDatiContratto();
        }

        private void CaricaMesi()
        {
            DdlMese.DataSource = Utility.GetMesi();
            DdlMese.DataBind();
            DdlMese.SelectedValue = DateTime.Now.Month.ToString();
        }

        private void CaricaDatiContratto()
        {
            Contratti contratto = contc.GetContrattoById(Convert.ToInt32(DdlContratti.SelectedValue));
            LblStipulatoda.Text = contratto?.StipulatoDa ?? string.Empty;
            LblBudget.Text = contratto?.Budget.ToString("c") ?? string.Empty;
        }

        private void SettaTipoDiConsidamento()
        {
            DdlMese.Visible = false;
            DdlSemestre.Visible = false;

            if (RbtnOperazione.SelectedIndex == 0)
            {
                LblPeriodoConsolidamento.Text = MESE_DA_CONSOLIDARE;
                DdlMese.Visible = true;
            }
            else
            {
                LblPeriodoConsolidamento.Text = SEMESTRE_DA_CONSOLIDARE;
                DdlSemestre.Visible = true;
            }
        }

        protected void BtnCerca_Click(object sender, EventArgs e)
        {
            try
            {
                Cerca();
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
                NascondiGriglie();

                if (RbtnOperazione.SelectedIndex == 0)
                {
                    CercaConsolidamentoMensile();
                }
                else
                {
                    CercaConsolidamentoSemestrale();
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnConsolida_Click(object sender, EventArgs e)
        {
            try
            {
                if (RbtnOperazione.SelectedIndex == 0)
                {
                    ConsolidaMese();
                }
                else
                {
                    ConsolidaSemestre();
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = "Eccezione: " + ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            this.Pulisci();
        }

        private void Pulisci()
        {
            if (DdlAnniContratto.Items.Count == 0)
            {
                CaricaAnniContratto();
            }
            DdlAnniContratto.SelectedIndex = 0;

            if (DdlContratti.Items.Count == 0)
            {
                CaricaContratti();
            }
            DdlContratti.SelectedIndex = 0;

            if (RbtnOperazione.SelectedIndex == 0)
            {
                if (DdlMese.Items.Count == 0)
                {
                    CaricaMesi();
                }
                DdlMese.SelectedValue = DateTime.Now.Month.ToString();
            }
            else
            {
                int meseCorrente = DateTime.Now.Month;
                if (meseCorrente <= 6)
                {
                    DdlSemestre.SelectedIndex = 0;
                }
                else
                {
                    DdlSemestre.SelectedIndex = 1;
                }
            }

            NascondiGriglie();
        }

        protected void RbtnOperazione_SelectedIndexChanged(object sender, EventArgs e)
        {
            SettaTipoDiConsidamento();
            Pulisci();
        }

        protected void DdlAnniContratto_SelectedIndexChanged(object sender, EventArgs e)
        {
            CaricaContratti();
        }

        protected void DdlContratti_SelectedIndexChanged(object sender, EventArgs e)
        {
            CaricaDatiContratto();
        }

        private void NascondiGriglie()
        {
            GrdRisultatiRicercaMese.DataSource = null;
            GrdRisultatiRicercaMese.DataBind();

            GrdConsolidamentoEsistenteMese.DataSource = null;
            GrdConsolidamentoEsistenteMese.DataBind();

            GrdRisultatiRicercaSemestre.DataSource = null;
            GrdRisultatiRicercaSemestre.DataBind();

            GrdConsolidamentoEsistenteSemestre.DataSource = null;
            GrdConsolidamentoEsistenteSemestre.DataBind();

            PnlConsolidamentoEsistente.Visible = false;
        }
        #endregion

        #region Mensile
        private void CercaConsolidamentoMensile()
        {
            ViewState["ELENCO"] = null;

            DateTime dataDa = new DateTime(
                Convert.ToInt32(DdlAnniContratto.SelectedValue),
                Convert.ToInt32(DdlMese.SelectedValue),
                1);
            DateTime dataA = dataDa.AddMonths(1).AddDays(-1);

            List<uspGetRiepilogoMese_result> elenco = consc.GetRiepilogoMesePerConsolidamento(Convert.ToInt32(DdlContratti.SelectedValue),
                Convert.ToInt32(DdlAnniContratto.SelectedValue),
                dataDa,
                dataA);

            if (elenco != null && elenco.Count() > 0)
            {
                ViewState["ELENCO"] = elenco;
                GrdRisultatiRicercaMese.DataSource = elenco;
            }
            else
            {
                GrdRisultatiRicercaMese.DataSource = null;
                LblMessaggio.Text = "La ricerca non ha prodotto risultati";
                Messaggio_ModalPopupExtender.Show();
            }
            GrdRisultatiRicercaMese.DataBind();

            VerificaConsolidamentoEsistenteMese();
        }

        private void ConsolidaMese()
        {
            if (ViewState["ELENCO"] != null)
            {
                List<Consolidamento> elencoDaInserire = new List<Consolidamento>();
                Consolidamento nuovo = null;

                foreach (uspGetRiepilogoMese_result singolo in ViewState["ELENCO"] as List<uspGetRiepilogoMese_result>)
                {
                    nuovo = new Consolidamento
                    {
                        Contratto_FK = Convert.ToInt32(DdlContratti.SelectedValue),
                        Anno = singolo.Anno,
                        Mese = singolo.Mese,
                        Risorse_FK = singolo.Risorsa,
                        Nominativo = singolo.Nominativo,
                        FigureProfessionali_FK = singolo.FP,
                        ErogatoTot = singolo.ErogatoTot,
                        ErogatoInFattura = singolo.ErogatoInFattura,
                        ErogatoInGaranzia = singolo.ErogatoInGaranzia
                    };
                    elencoDaInserire.Add(nuovo);
                }

                consc.InsertConsolidamentoMese(elencoDaInserire);
                Cerca();
                LblMessaggio.Text = "Operazione avvenuta con successo";
                Messaggio_ModalPopupExtender.Show();
            }
            else
            {
                LblMessaggio.Text = "Effettuare una ricerca";
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void VerificaConsolidamentoEsistenteMese()
        {
            try
            {
                PnlConsolidamentoEsistente.Visible = false;

                List<Consolidamento> elenco = consc.GetDatiConsoldatiMese(
                    Convert.ToInt32(DdlContratti.SelectedValue),
                    Convert.ToInt32(DdlAnniContratto.SelectedValue),
                    Convert.ToInt32(DdlMese.SelectedValue));

                if (elenco != null && elenco.Count() > 0)
                {
                    GrdConsolidamentoEsistenteMese.DataSource = elenco;
                    LblMessaggio.Text = "Il periodo risulta già consolidato. Viene visualizzata una griglia secondaria riempita con i valori prevedentemente consolidati";
                    Messaggio_ModalPopupExtender.Show();
                    PnlConsolidamentoEsistente.Visible = true;
                }
                else
                {
                    GrdConsolidamentoEsistenteMese.DataSource = null;
                }
                GrdConsolidamentoEsistenteMese.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void GrdConsolidamentoMese_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == System.Web.UI.WebControls.DataControlRowType.DataRow)
            {
                int meseOrdine = Convert.ToInt32(e.Row.Cells[1].Text);
                Mese m = Utility.GetMesi().Find(mese => mese.indice == meseOrdine);
                e.Row.Cells[1].Text = m.mese;
            }
        }
        #endregion

        #region Semestrale
        private void CercaConsolidamentoSemestrale()
        {
            ViewState["ELENCO"] = null;

            DateTime dataDa = new DateTime(
                Convert.ToInt32(DdlAnniContratto.SelectedValue),
                Convert.ToInt32(DdlMese.SelectedValue),
                1);
            DateTime dataA = dataDa.AddMonths(1).AddDays(-1);

            List<uspGetRiepilogoSemestre_Result> elenco = consc.GetRiepilogoSemestrePerConsolidamento(
                Convert.ToInt32(DdlContratti.SelectedValue),
                Convert.ToInt32(DdlAnniContratto.SelectedValue),
                Convert.ToInt32(DdlSemestre.SelectedValue));

            if (elenco != null && elenco.Count() > 0)
            {
                ViewState["ELENCO"] = elenco;
                GrdRisultatiRicercaSemestre.DataSource = elenco;
            }
            else
            {
                GrdRisultatiRicercaSemestre.DataSource = null;
                LblMessaggio.Text = "La ricerca non ha prodotto risultati";
                Messaggio_ModalPopupExtender.Show();
            }
            GrdRisultatiRicercaSemestre.DataBind();

            VerificaConsolidamentoEsistenteSemestre();
        }

        private void ConsolidaSemestre()
        {
            if (ViewState["ELENCO"] != null)
            {
                List<ConsolidamentoSemestre> elencoDaInserire = new List<ConsolidamentoSemestre>();
                ConsolidamentoSemestre nuovo = null;

                foreach (uspGetRiepilogoSemestre_Result singolo in ViewState["ELENCO"] as List<uspGetRiepilogoSemestre_Result>)
                {
                    nuovo = new ConsolidamentoSemestre
                    {
                        Contratto_FK = Convert.ToInt32(DdlContratti.SelectedValue),
                        Anno = singolo.Anno.Value,
                        Semestre = singolo.Semestre.Value,
                        Aziende_FK = singolo.Aziende_FK,
                        FiguraProfessionale = singolo.FiguraProfessionale,
                        Tariffa = Convert.ToDouble(singolo.Tariffa.Value),
                        ErogatoTot = singolo.ErogatoTot.Value,
                        ErogatoInFattura = singolo.ErogatoInFattura.Value,
                        ErogatoInGaranzia = singolo.ErogatoInGaranzia.Value
                    };
                    elencoDaInserire.Add(nuovo);
                }

                consc.InsertConsolidamentoSemestre(elencoDaInserire);
                Cerca();
                LblMessaggio.Text = "Operazione avvenuta con successo";
                Messaggio_ModalPopupExtender.Show();
            }
            else
            {
                LblMessaggio.Text = "Effettuare una ricerca";
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void VerificaConsolidamentoEsistenteSemestre()
        {
            try
            {
                PnlConsolidamentoEsistente.Visible = false;

                List<ConsolidamentoSemestre> elenco = consc.GetDatiConsoldatiSemestre(
                    Convert.ToInt32(DdlContratti.SelectedValue),
                    Convert.ToInt32(DdlAnniContratto.SelectedValue),
                    Convert.ToInt32(DdlSemestre.SelectedValue));

                if (elenco != null && elenco.Count() > 0)
                {
                    GrdConsolidamentoEsistenteSemestre.DataSource = elenco;
                    LblMessaggio.Text = "Il periodo risulta già consolidato. Viene visualizzata una griglia secondaria riempita con i valori prevedentemente consolidati";
                    Messaggio_ModalPopupExtender.Show();
                    PnlConsolidamentoEsistente.Visible = true;
                }
                else
                {
                    GrdConsolidamentoEsistenteSemestre.DataSource = null;
                }
                GrdConsolidamentoEsistenteSemestre.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}