using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class FigureProfessionaliController
    {
        public List<FigureProfessionali> GetFigure(string codice,
            string descrizione,
            decimal? tariffaGiornalieraDa,
            decimal? tariffaGiornalieraA,
            Int32? numeroGiornatePrevisteDa,
            Int32? numeroGiornatePrevisteA,
            Int32? contratti_Fk)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var figureTmp = from f1 in context.FigureProfessionali
                                    where
                                    (
                                        (codice == string.Empty || f1.Codice == codice) &&
                                        (descrizione == string.Empty || f1.Descrizione.Contains(descrizione)) &&
                                        (tariffaGiornalieraDa == null || f1.TariffaGiornaliera >= tariffaGiornalieraDa) &&
                                        (tariffaGiornalieraA == null || f1.TariffaGiornaliera <= tariffaGiornalieraA) &&
                                        (numeroGiornatePrevisteDa == null || f1.NumeroGiornatePreviste >= numeroGiornatePrevisteDa) &&
                                        (numeroGiornatePrevisteA == null || f1.NumeroGiornatePreviste <= numeroGiornatePrevisteA) &&
                                        (contratti_Fk == null || f1.Contratti_Fk == contratti_Fk) &&
                                        f1.Visibile == true
                                    )
                                    orderby f1.Descrizione ascending
                                    select f1;
                    return figureTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<FigureProfessionali> GetFigureByCodiceRisorsa(string codiceRisorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var figureTmp = from f1 in context.FigureProfessionali
                                    join r1 in context.R_Risorse_FigureProfessionali on f1.Codice equals r1.CodiceFiguraProfessionale_FK
                                    where r1.CodiceRisorsa_FK == codiceRisorsa
                                    orderby f1.Descrizione ascending
                                    select f1;
                    return figureTmp?.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<FigureProfessionali> GetFigureProfessionaliUsateByCodiceRisosaConAnno(string codiceRisorsa, int anno)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var figureTmp = from f1 in context.FigureProfessionali
                                    join t1 in context.TimeSheet on f1.Codice equals t1.FigureProfessionali_FK
                                    where t1.Risorse_FK == codiceRisorsa &&
                                          t1.Data.Year == anno
                                    orderby f1.Descrizione ascending
                                    select f1;
                    return figureTmp?.Distinct().ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string GetRuoloDiDefaultByCodiceRisorsa(string codiceRisorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var figureTmp = from f1 in context.FigureProfessionali
                                    join r1 in context.R_Risorse_FigureProfessionali on f1.Codice equals r1.CodiceFiguraProfessionale_FK
                                    where r1.CodiceRisorsa_FK == codiceRisorsa && r1.RuoloDefault == true
                                    select r1.CodiceFiguraProfessionale_FK;
                    return figureTmp?.FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}