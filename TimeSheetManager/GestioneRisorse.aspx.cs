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
    public partial class GestioneRisorse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.caricaAziende();
                Session["SEZIONE"] = "Gestione Risorse";
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
                RisorsaController rc = new RisorsaController();
                decimal? costoGiornalieroDa = null, costoGiornalieroA = null;
                Boolean? isAdmin = null;

                if (!string.IsNullOrEmpty(TxtCostoGiornalieroDa.Text))
                    costoGiornalieroDa = Convert.ToDecimal(TxtCostoGiornalieroDa.Text.Replace(".", ","));
                if (!string.IsNullOrEmpty(TxtCostoGiornalieroA.Text))
                    costoGiornalieroA = Convert.ToDecimal(TxtCostoGiornalieroA.Text.Replace(".", ","));
                if (RbtnAdmin.SelectedIndex > 0)
                    isAdmin = Convert.ToBoolean(RbtnAdmin.SelectedValue);

                List<Risorse> elenco = rc.GetRisorse(TxtCodice.Text,
                    TxtNominativo.Text,
                    costoGiornalieroDa,
                    costoGiornalieroA,
                    DdlAzienda.SelectedIndex > 0 ? DdlAzienda.SelectedValue : string.Empty,
                    isAdmin);
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

        private void caricaAziende()
        {
            try
            {
                AziendaController ac = new AziendaController();
                List<Aziende> elenco = ac.getAllAziende();

                DdlAzienda.DataSource = elenco;
                DdlAzienda.DataBind();
                DdlAzienda.Items.Insert(0, new ListItem("----- Tutte -----"));

                DdlAziendaN.DataSource = elenco;
                DdlAziendaN.DataBind();
            }
            catch (Exception ex)
            {
                LblMessaggio.Text = ex.Message;
                Messaggio_ModalPopupExtender.Show();
            }
        }

        protected void BtnPulisci_Click(object sender, EventArgs e)
        {
            TxtAccount.Text = string.Empty;
            TxtCodice.Text = string.Empty;
            TxtCostoGiornalieroDa.Text = string.Empty;
            TxtCostoGiornalieroA.Text = string.Empty;
            TxtNominativo.Text = string.Empty;
            DdlAzienda.SelectedIndex = 0;
            RbtnAdmin.SelectedIndex = 0;
            GrdRisultatiRicerca.DataSource = null;
            GrdRisultatiRicerca.DataBind();
        }

        protected void BtnNuovaRisorsa_Click(object sender, EventArgs e)
        {
            TxtAccountN.Text = string.Empty;
            TxtCodiceN.Text = string.Empty;
            TxtCostoGiornalieroN.Text = string.Empty;
            TxtNominativoN.Text = string.Empty;
            DdlAziendaN.SelectedIndex = 0;
            ChkAdminN.Checked = false;
            HdnModalita.Value = "Nuova";

            Dati_ModalPopupExtender.Show();

        }

        protected void BtnSalva_Click(object sender, EventArgs e)
        {
            try
            {
                Risorse risorsa = new Risorse();
                risorsa.Codice = TxtCodiceN.Text;
                risorsa.Account = TxtAccountN.Text;
                risorsa.Aziende_FK = DdlAziendaN.SelectedValue;
                if (TxtCostoGiornalieroN.Text != string.Empty)
                    risorsa.CostoGiornaliero = Convert.ToDecimal(TxtCostoGiornalieroN.Text.Replace(".", ","));
                risorsa.IsAdmin = ChkAdminN.Checked;
                risorsa.Nominativo = TxtNominativoN.Text;

                RisorsaController rc = new RisorsaController();

                switch (HdnModalita.Value)
                {
                    case "Nuova":
                        rc.InsertRisorsa(risorsa);
                        break;
                    case "Modifica":
                        rc.UpdateRisorsa(risorsa);
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
                int indice = Convert.ToInt32(e.CommandArgument);
                DataKey chiave = GrdRisultatiRicerca.DataKeys[indice];
                RisorsaController rc = new RisorsaController();
                switch (e.CommandName)
                {
                    case "Modifica":
                        Risorse risorsa = rc.GetRisorse(chiave.Value.ToString(), string.Empty, null, null, string.Empty, null).First();
                        TxtCodiceN.Text = risorsa.Codice;
                        TxtNominativoN.Text = risorsa.Nominativo;
                        TxtAccountN.Text = risorsa.Account;
                        TxtCostoGiornalieroN.Text = risorsa.CostoGiornaliero.ToString();
                        DdlAziendaN.SelectedValue = risorsa.Aziende_FK;
                        ChkAdminN.Checked = risorsa.IsAdmin;
                        HdnModalita.Value = "Modifica";

                        TxtCodiceN.Enabled = false;

                        Dati_ModalPopupExtender.Show();
                        TxtNominativoN.Focus();
                        break;
                    case "Elimina":
                        rc.DeleteRisorsa(chiave.Value.ToString());
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