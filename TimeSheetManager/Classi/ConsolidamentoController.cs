using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class ConsolidamentoController
    {
        #region Mensile
        public List<uspGetRiepilogoMese_result> GetRiepilogoMesePerConsolidamento(Int32? idContratto, Int32? annoContratto, DateTime? datDa, DateTime? dataA)
        {
            try
            {
                List<uspGetRiepilogoMese_result> elencoDefinitivo = new List<uspGetRiepilogoMese_result>();
                using (var context = new TimesheetEntities())
                {
                    var elenco = context.uspGetRiepilogoMese(
                        idContratto,
                        annoContratto,
                        datDa,
                        dataA,
                        2);
                    return elenco?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Consolidamento> GetDatiConsoldatiMese(int idContratto, int anno, int mese)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var datiConsolidati = from c in context.Consolidamento
                                          where c.Anno == anno &&
                                          c.Contratto_FK == idContratto &&
                                          c.Mese == mese
                                          select c;
                    return datiConsolidati?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertConsolidamentoMese(List<Consolidamento> elenco)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    // Elimino il precedente cosolidamento

                    // Parametri di ricerca: Anno, Contratto, Semestre
                    int anno = elenco.First().Anno;
                    int contratto = elenco.First().Contratto_FK;
                    int mese = elenco.First().Mese;

                    var consolidamentoPresente = from c in context.Consolidamento
                                                 where c.Anno == anno &&
                                                       c.Contratto_FK == contratto &&
                                                       c.Mese == mese
                                                 select c;
                    if (consolidamentoPresente != null && consolidamentoPresente.Count() > 0)
                    {
                        foreach (var c in consolidamentoPresente)
                        {
                            context.Consolidamento.DeleteObject(c);
                        }
                    }

                    // Aggiungo il nuovo consolidamento
                    foreach (Consolidamento singolo in elenco)
                    {
                        context.Consolidamento.AddObject(singolo);
                    }
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Semestrale
        public List<uspGetRiepilogoSemestre_Result> GetRiepilogoSemestrePerConsolidamento(Int32? idContratto, Int32? annoContratto, int? semestre)
        {
            try
            {
                List<uspGetRiepilogoSemestre_Result> elencoDefinitivo = new List<uspGetRiepilogoSemestre_Result>();
                using (var context = new TimesheetEntities())
                {
                    var elenco = context.uspGetRiepilogoSemestre(
                        idContratto,
                        annoContratto,
                        semestre);
                    return elenco?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<ConsolidamentoSemestre> GetDatiConsoldatiSemestre(int idContratto, int anno, int semestre)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var datiConsolidati = from c in context.ConsolidamentoSemestre
                                          where c.Anno == anno &&
                                          c.Contratto_FK == idContratto &&
                                          c.Semestre == semestre
                                          select c;
                    return datiConsolidati?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertConsolidamentoSemestre(List<ConsolidamentoSemestre> elenco)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    // Elimino il precedente cosolidamento

                    // Parametri di ricerca: Anno, Contratto, Semestre
                    int anno = elenco.First().Anno;
                    int contratto = elenco.First().Contratto_FK;
                    int semestre = elenco.First().Semestre;

                    var consolidamentoPresente = from c in context.ConsolidamentoSemestre
                                                 where c.Anno == anno &&
                                                       c.Contratto_FK == contratto &&
                                                       c.Semestre == semestre
                                                 select c;
                    if (consolidamentoPresente != null && consolidamentoPresente.Count() > 0)
                    {
                        foreach (var c in consolidamentoPresente)
                        {
                            context.ConsolidamentoSemestre.DeleteObject(c);
                        }
                    }

                    // Aggiungo il nuovo consolidamento
                    foreach (ConsolidamentoSemestre singolo in elenco)
                    {
                        context.ConsolidamentoSemestre.AddObject(singolo);
                    }
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}