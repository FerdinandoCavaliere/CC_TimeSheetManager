using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class ContrattiController
    {
        public List<Contratti> GetContratti(Boolean getValoriConcatenati)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var contratti = context
                        .Contratti
                        .OrderByDescending(c => c.Anno)
                        .ThenByDescending(c => c.Numero);

                    if (contratti != null && contratti.Count() > 0)
                    {
                        if (getValoriConcatenati)
                        {
                            List<Contratti> elencoDefinitivo = new List<Contratti>();
                            Contratti nuovoContratto = null;
                            foreach (Contratti singoloContratto in contratti)
                            {
                                nuovoContratto = new Contratti
                                {
                                    Id = singoloContratto.Id,
                                    valoriConcatenati = singoloContratto.Anno.ToString() +
                                    " | " +
                                    singoloContratto.Descizione?.ToString() ?? string.Empty,
                                    Anno = singoloContratto.Anno
                                };
                                elencoDefinitivo.Add(nuovoContratto);
                            }
                            return elencoDefinitivo;
                        }
                        else
                        {
                            return contratti.ToList<Contratti>();
                        }   
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Contratti> GetContrattiByAnno(int anno)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var contratti = context
                        .Contratti
                        .Where(c => c.Anno == anno)
                        .OrderByDescending(c => c.Numero);
                    return contratti?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Contratti GetContrattoDefault()
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Contratti.Where(w => w.Default.Value == true).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Contratti GetContrattoById(Int32 idContratto)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Contratti.Where(w => w.Id == idContratto).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<FigureProfessionali> GetFigureByContrattoId(Int32 idContratto)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.FigureProfessionali.Where(w => w.Contratti_Fk == idContratto && w.Visibile == true).ToList<FigureProfessionali>();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<int> GetAnniContratti()
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Contratti.Select(c => c.Anno).Distinct().OrderByDescending(c => c).ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}