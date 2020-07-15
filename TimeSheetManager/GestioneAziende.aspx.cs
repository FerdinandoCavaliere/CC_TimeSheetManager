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
    public partial class GestioneAziende : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TITOLO"] = "Gestione Aziende";
            } 
        }

        protected void BtnCerca_Click(object sender, EventArgs e)
        {
            try
            {
                this.cerca();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        private void cerca()
        {
            try
            {
                AziendaController ac = new AziendaController();
                List<Aziende> elenco = ac.getAziende(TxtCodice.Text,
                    TxtDescrizione.Text,
                    TxtIndirizzo.Text,
                    TxtMail.Text);
                if (elenco != null && elenco.Count() > 0)
                {
                    GrdRisultatiRicerca.DataSource = elenco;
                    GrdRisultatiRicerca.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            TxtCodice.Text = string.Empty;
            TxtDescrizione.Text = string.Empty;
            TxtIndirizzo.Text = string.Empty;
            TxtMail.Text = string.Empty;
            GrdRisultatiRicerca.DataSource = null;
            GrdRisultatiRicerca.DataBind();
        }

        protected void BtnNuovaRisorsa_Click(object sender, EventArgs e)
        {
            TxtCodiceN.Text = string.Empty;
            TxtDescrizioneN.Text = string.Empty;
            TxtIndirizzoN.Text = string.Empty;
            TxtMailN.Text = string.Empty;
            HdnModalita.Value = "Nuova";

            Dati_ModalPopupExtender.Show();

        }

        protected void BtnSalva_Click(object sender, EventArgs e)
        {
            try
            {
                Aziende azienda = new Aziende();
                azienda.Codice = TxtCodiceN.Text;
                azienda.Indirizzo = TxtIndirizzoN.Text;
                azienda.Mail = TxtMailN.Text;
                azienda.Descrizione = TxtDescrizioneN.Text;

                AziendaController ac = new AziendaController();

                switch (HdnModalita.Value)
                {
                    case "Nuova":
                        ac.insertAzienda(azienda);
                        break;
                    case "Modifica":
                        ac.updateAzienda(azienda);
                        this.cerca();
                        break;
                }

                LblMessaggio.Text = "Operazione avvenuta con successo";
                Messaggio_ModalPopupExtender.Show();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void GrdRisultatiRicerca_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                Int32 indice = Convert.ToInt32(e.CommandArgument);
                DataKey chiave = GrdRisultatiRicerca.DataKeys[indice];
                AziendaController ac = new AziendaController();
                switch (e.CommandName)
                {
                    case "Modifica":
                        Aziende azienda = ac.getAziende(chiave.Value.ToString(), string.Empty, string.Empty, string.Empty).First();
                        TxtCodiceN.Text = azienda.Codice;
                        TxtDescrizioneN.Text = azienda.Descrizione;
                        TxtIndirizzoN.Text = azienda.Indirizzo;
                        TxtMailN.Text = azienda.Mail;
                        HdnModalita.Value = "Modifica";

                        TxtCodiceN.Enabled = false;

                        Dati_ModalPopupExtender.Show();
                        TxtDescrizioneN.Focus();
                        break;
                    case "Elimina":
                        ac.deleteAzienda(chiave.Value.ToString());
                        this.cerca();
                        LblMessaggio.Text = "Operazione avvenuta con successo";
                        Messaggio_ModalPopupExtender.Show();
                        break;
                }
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }
    }
}