using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class TimeSheetController
    {
        TaskController tc = new TaskController();

        public List<TimeSheet> GetTimeSheet(
            Int32? id,
            DateTime? dataDa,
            DateTime? dataA,
            string risorse_Fk,
            string figure_Fk,
            TimeSpan? ingresso,
            TimeSpan? pausaPranzo,
            TimeSpan? rientro,
            TimeSpan? uscita,
            string attivita,
            decimal? oreRendicontate,
            bool inGaranzia)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timeSheetTmp = from t in context.TimeSheet
                                       where
                                       (
                                            (id == null || t.Id == id) &&
                                            (dataDa == null || t.Data >= dataDa) &&
                                            (dataA == null || t.Data <= dataA) &&
                                            (risorse_Fk == string.Empty || t.Risorse_FK == risorse_Fk) &&
                                            (figure_Fk == string.Empty || t.FigureProfessionali_FK == figure_Fk) &&
                                            (ingresso == null || t.Ingresso == ingresso) &&
                                            (pausaPranzo == null || t.PausaPranzo == pausaPranzo) &&
                                            (rientro == null || t.Rientro == rientro) &&
                                            (uscita == null || t.Uscita == uscita) &&
                                            (attivita == string.Empty || t.Attivita.Contains(attivita)) &&
                                            (oreRendicontate == null || t.OreRendicontate == oreRendicontate) &&
                                            (t.InGaranzia == inGaranzia)
                                       )
                                       orderby t.Data descending, t.FigureProfessionali_FK ascending
                                       select t;
                    if (timeSheetTmp != null && timeSheetTmp.Count() > 0)
                    {
                        foreach (TimeSheet singolo in timeSheetTmp)
                        {
                            CompletaDatiTimesheet(singolo);
                        }
                    }
                    return timeSheetTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CalcolaLavoratoEffettivo(TimeSheet singolo)
        {
            try
            {
                TimeSpan nettoMattina = singolo.Ingresso;
                TimeSpan nettoPomeriggio = singolo.Uscita;

                if (singolo.PausaPranzo.HasValue)
                {
                    nettoMattina = singolo.PausaPranzo.Value - singolo.Ingresso;
                }

                if (singolo.Rientro.HasValue)
                {
                    nettoPomeriggio = singolo.Uscita - singolo.Rientro.Value;
                }

                singolo.LavoratoEffettivo = nettoPomeriggio + nettoMattina;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CalcolaRendicontatoEffettivo(TimeSheet singolo)
        {
            try
            {
                decimal parteIntera = Math.Truncate(singolo.OreRendicontate);
                int parteFrazionaria = 0;
                switch (singolo.OreRendicontate - parteIntera)
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

                singolo.RendicontatoEffettivo = new TimeSpan(Convert.ToInt32(parteIntera), parteFrazionaria, 0);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CalcolaDifferenzaLavoratoConRendicontato(TimeSheet singolo)
        {
            try
            {
                singolo.DifferenzaLavoratoConRendicontato = singolo.LavoratoEffettivo - singolo.RendicontatoEffettivo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<TimeSheet> GetTimeSheet(DateTime? dataDa, DateTime? dataA, string risorse_Fk, string figure_Fk)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timeSheetTmp = from t in context.TimeSheet
                                       where
                                       (
                                            (dataDa == null || t.Data >= dataDa) &&
                                            (dataA == null || t.Data <= dataA) &&
                                            (risorse_Fk == string.Empty || t.Risorse_FK == risorse_Fk) &&
                                            (figure_Fk == string.Empty || t.FigureProfessionali_FK == figure_Fk)
                                       )
                                       orderby t.Data descending, t.FigureProfessionali_FK ascending
                                       select t;
                    if (timeSheetTmp != null && timeSheetTmp.Count() > 0)
                    {
                        foreach (TimeSheet singolo in timeSheetTmp)
                        {
                            CompletaDatiTimesheet(singolo);
                        }
                    }
                    return timeSheetTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<TimeSheet> GetTimeSheet(
            int mese, 
            int anno, 
            string risorse_Fk,
            string figure_Fk)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timeSheetTmp = from t in context.TimeSheet
                                       where
                                       (
                                            t.Data.Month == mese &&
                                            t.Data.Year == anno &&
                                            t.Risorse_FK == risorse_Fk &&
                                            (figure_Fk == string.Empty || t.FigureProfessionali_FK == figure_Fk)
                                       )
                                       orderby t.Data ascending, t.Ingresso ascending, t.FigureProfessionali_FK ascending
                                       select t;
                    if (timeSheetTmp != null && timeSheetTmp.Count() > 0)
                    {
                        foreach (TimeSheet singolo in timeSheetTmp)
                        {
                            CompletaDatiTimesheet(singolo);
                        }
                    }
                    return timeSheetTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public TimeSheet GetSingolaGiornata(Int32 id)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.TimeSheet.Where(w => w.Id == id).First();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public TimeSheet GetSingolaGiornataConCalcoliEffettivi(Int32 id)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timesheetTmp = context.TimeSheet.Where(w => w.Id == id).First();
                    if (timesheetTmp != null)
                    {
                        CompletaDatiTimesheet(timesheetTmp);
                    }
                    return timesheetTmp;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertGiornata(TimeSheet nuovo)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    context.TimeSheet.AddObject(nuovo);
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateGiornata(TimeSheet modifica)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var t = context.TimeSheet.Where(w => w.Id == modifica.Id).First();
                    t.Data = modifica.Data;
                    t.Risorse_FK = modifica.Risorse_FK;
                    t.FigureProfessionali_FK = modifica.FigureProfessionali_FK;
                    t.Ingresso = modifica.Ingresso;
                    t.PausaPranzo = modifica.PausaPranzo;
                    t.Rientro = modifica.Rientro;
                    t.Uscita = modifica.Uscita;
                    t.Attivita = modifica.Attivita;
                    t.Validazione = modifica.Validazione;
                    t.OreRendicontate = modifica.OreRendicontate;
                    t.InGaranzia = modifica.InGaranzia;
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteGiornata(Int32 id)
        {
            using (var context = new TimesheetEntities())
            {
                // Rimuovo i records dall atabella TasksLavorati
                tc.DeleteTasksLavoratiByTimeSheetId(id, context);

                // Rimuovo la giornata
                var timesheet = context.TimeSheet.Where(w => w.Id == id).First();
                context.TimeSheet.DeleteObject(timesheet);

                context.SaveChanges();
            }
        }

        public void Valida(Int32 id, Boolean valida)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timeSheet = context.TimeSheet.Where(w => w.Id == id).First();
                    if (valida)
                    {
                        timeSheet.Validazione = DateTime.Now.Date;
                    } 
                    else
                    {
                        timeSheet.Validazione = null;
                    }
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void ValidaArma(Int32 id, Boolean valida)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var timeSheet = context.TimeSheet.Where(w => w.Id == id).First();
                    if (valida)
                    {
                        timeSheet.ValidazioneArma = DateTime.Now.Date;
                    }
                    else
                    {
                        timeSheet.ValidazioneArma = null;
                    } 
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int GetAnnoMinimo()
        {
            using (var context = new TimesheetEntities())
            {
                return context.TimeSheet?.Select(t => t.Data).Min().Year ?? 0;
            }
        }

        private void CompletaDatiTimesheet(TimeSheet timesheet)
        {
            timesheet.ListaTasksLavorati = tc.GetTaskLavoratiByTimesheetId(timesheet.Id);
            CalcolaRendicontatoEffettivo(timesheet);
            CalcolaLavoratoEffettivo(timesheet);
            CalcolaDifferenzaLavoratoConRendicontato(timesheet);
        }
    }
}