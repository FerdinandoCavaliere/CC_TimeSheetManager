using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class RisorsaController
    {
        public Risorse GetRisorsaLoggata(string login)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Risorse.Where(w => w.Account == login).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Risorse> GetRisorse(
            string codice,
            string nominativo,
            decimal? costoGiornalieroDa,
            decimal? costoGiornalieroA,
            string azienda_Fk,
            Boolean? isAdmin)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var risorseTmp = from r1 in context.Risorse
                                     where
                                     (
                                         (codice == string.Empty || r1.Codice == codice) &&
                                         (nominativo == string.Empty || r1.Nominativo.Contains(nominativo)) &&
                                         (costoGiornalieroDa == null || r1.CostoGiornaliero >= costoGiornalieroDa) &&
                                         (costoGiornalieroA == null || r1.CostoGiornaliero <= costoGiornalieroA) &&
                                         (azienda_Fk == string.Empty || r1.Aziende_FK == azienda_Fk) &&
                                         (isAdmin == null || r1.IsAdmin == isAdmin) &&
                                         r1.IsValid == true
                                     )
                                     select r1;
                    if (risorseTmp != null && risorseTmp.Count() > 0)
                    {
                        foreach (Risorse risorsaSingola in risorseTmp)
                        {
                            risorsaSingola.azienda = risorsaSingola.Aziende.Descrizione;
                        }
                    }
                    return risorseTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Risorse GetRisorsaByCodice(string codice)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Risorse.Where(w => w.Codice == codice)?.FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertRisorsa(Risorse nuova)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    context.Risorse.AddObject(nuova);
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateRisorsa(Risorse risorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Risorse risorsaDaModificare = context.Risorse.Where(w => w.Codice == risorsa.Codice)?.FirstOrDefault();
                    if (!(risorsaDaModificare is null))
                    {
                        risorsaDaModificare.Account = risorsa.Account;
                        risorsaDaModificare.Aziende_FK = risorsa.Aziende_FK;
                        risorsaDaModificare.CostoGiornaliero = risorsa.CostoGiornaliero;
                        risorsaDaModificare.IsAdmin = risorsa.IsAdmin;
                        risorsaDaModificare.Nominativo = risorsa.Nominativo;
                        context.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteRisorsa(string codice)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Risorse risorsaDaEliminare = context.Risorse.Where(w => w.Codice == codice)?.FirstOrDefault();
                    if (!(risorsaDaEliminare is null))
                    {
                        context.Risorse.DeleteObject(risorsaDaEliminare);
                        context.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}