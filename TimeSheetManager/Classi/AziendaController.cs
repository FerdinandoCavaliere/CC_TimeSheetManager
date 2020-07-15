using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class AziendaController
    {
        public List<Aziende> getAllAziende()
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Aziende.OrderBy(o => o.Descrizione).ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Aziende> getAziende(string codice, string descrizione, string indirizzo, string mail)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var az = from a in context.Aziende
                             where
                             (
                                (codice == string.Empty || a.Codice == codice) &&
                                (descrizione == string.Empty || a.Descrizione.Contains(descrizione)) &&
                                (indirizzo == string.Empty || a.Indirizzo == indirizzo) &&
                                (mail == string.Empty || a.Mail == mail)
                             )
                             select a;
                    if (az != null && az.Count() > 0)
                        return az.ToList();
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void insertAzienda(Aziende nuova)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    context.Aziende.AddObject(nuova);
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void updateAzienda(Aziende risorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Aziende aziendaDaModificare = context.Aziende.Where(w => w.Codice == risorsa.Codice).First();
                    aziendaDaModificare.Descrizione = risorsa.Descrizione;
                    aziendaDaModificare.Indirizzo = risorsa.Indirizzo;
                    aziendaDaModificare.Mail = risorsa.Mail;
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deleteAzienda(string codice)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Aziende aziendaDaEliminare = context.Aziende.Where(w => w.Codice == codice).First();
                    context.Aziende.DeleteObject(aziendaDaEliminare);
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}