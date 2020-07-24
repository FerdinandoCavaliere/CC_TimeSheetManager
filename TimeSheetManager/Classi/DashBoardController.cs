using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;
using Newtonsoft.Json;

namespace TimeSheetManager.Classi
{
    public class DashBoardController
    {

        FigureProfessionaliController fc = new FigureProfessionaliController();

        List<Mese> elencoMesi = Utility.GetMesi();

        #region Chart Ore Per Mese
        public LabelsAndDatasets GetNumeroDiOrePerMese(
            string risorsa_FK,
            int anno)
        {
            try
            {
                List<ValuesXYaxis<int, float>> elenco = new List<ValuesXYaxis<int, float>>(); // Valori dalla query linq
                List<ValuesXYaxis<string, string>> elencoDefinitivo = new List<ValuesXYaxis<string, string>>(); // Elenco ddefinitivo con tutti i mesi

                using (var context = new TimesheetEntities())
                {
                    var result = from t in context.TimeSheet
                                 where t.Data.Year == anno && t.Risorse_FK == risorsa_FK
                                 group t by t.Data.Month into raggruppamento
                                 select raggruppamento;
                    foreach (var g in result)
                    {
                        elenco.Add(new ValuesXYaxis<int, float> { XAxes = g.Key, YAxes = g.Sum(s => s.LavoratoInMinuti.Value) / 60F });
                    }

                    // Completo tutti i mesi
                    foreach (var m in elencoMesi)
                    {
                        ValuesXYaxis<string, string> nuovo = new ValuesXYaxis<string, string>();
                        nuovo.XAxes = m.mese;
                        var temp = elenco.Where(t => t.XAxes == m.indice);
                        if (temp != null && temp.Count() > 0)
                        {
                            nuovo.YAxes = temp.First().YAxes.ToString().Replace(',', '.');
                        }
                        elencoDefinitivo.Add(nuovo);
                    }
                }

                LabelsAndDatasets labelsAndDatasets = GetChartData<string, string>(elencoDefinitivo, ChartType.Bar);

                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Chart Ore Per Mese Per Figura professionale
        public LabelsAndDatasets GetNumeroDiOrePerMesePerFiguraProfessionale(
            string risorsa_FK,
            int anno)
        {
            try
            {
                List<List<ValuesXYaxis<string, string>>> elencoDefinitivo = new List<List<ValuesXYaxis<string, string>>>(); // Elenco ddefinitivo con tutti i mesi di tutte le serie

                // Recupero le figure professiionali
                List<FigureProfessionali> elencoFigureProfessionai = GetFigureProfessionali(risorsa_FK, anno);
                List<string> descrizioniFigure = new List<string>();

                foreach (FigureProfessionali figura in elencoFigureProfessionai)
                {
                    elencoDefinitivo.Add(GetNumeroDiOrePerMeseDiRisorsaPerFigura(risorsa_FK, anno, figura.Codice));
                    descrizioniFigure.Add(figura.Descrizione);
                }

                LabelsAndDatasets labelsAndDatasets = GetChartData<string, string>(elencoDefinitivo, ChartType.Line, descrizioniFigure);

                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private List<ValuesXYaxis<string, string>> GetNumeroDiOrePerMeseDiRisorsaPerFigura(
            string risorsa_FK,
            int anno,
            string figura_FK)
        {
            List<ValuesXYaxis<int, float>> elenco = new List<ValuesXYaxis<int, float>>(); // Valori dalla query linq
            List<ValuesXYaxis<string, string>> elencoDefinitivo = new List<ValuesXYaxis<string, string>>(); // Elenco ddefinitivo con tutti i mesi

            using (var context = new TimesheetEntities())
            {
                var result = from t in context.TimeSheet
                             where t.Data.Year == anno &&
                                   t.Risorse_FK == risorsa_FK &&
                                   t.FigureProfessionali_FK == figura_FK
                             group t by t.Data.Month into raggruppamento
                             select raggruppamento;
                foreach (var g in result)
                {
                    elenco.Add(new ValuesXYaxis<int, float> { XAxes = g.Key, YAxes = g.Sum(s => s.LavoratoInMinuti.Value) / 60F });
                }

                // Completo tutti i mesi
                foreach (var m in elencoMesi)
                {
                    ValuesXYaxis<string, string> nuovo = new ValuesXYaxis<string, string>();
                    nuovo.XAxes = m.mese;
                    var temp = elenco.Where(t => t.XAxes == m.indice);
                    if (temp != null && temp.Count() > 0)
                    {
                        nuovo.YAxes = temp.First().YAxes.ToString().Replace(',', '.');
                    }
                    elencoDefinitivo.Add(nuovo);
                }
            }

            return elencoDefinitivo;
        }
        #endregion

        #region Chart Task Per Mese
        public LabelsAndDatasets GetNumeroDiTasksPerMese(
        string risorsa_FK,
        int anno)
        {
            try
            {
                List<ValuesXYaxis<int, int>> elenco = new List<ValuesXYaxis<int, int>>(); // Valori dalla query linq
                List<ValuesXYaxis<string, string>> elencoDefinitivo = new List<ValuesXYaxis<string, string>>(); // Elenco ddefinitivo con tutti i mesi

                using (var context = new TimesheetEntities())
                {
                    var result = from t in context.TimeSheet
                                 join l in context.TasksLavorati on t.Id equals l.TimeSheet_FK
                                 where t.Data.Year == anno && t.Risorse_FK == risorsa_FK
                                 group new { t, l } by t.Data.Month into raggruppamento
                                 select raggruppamento;
                    foreach (var g in result)
                    {
                        elenco.Add(new ValuesXYaxis<int, int> { XAxes = g.Key, YAxes = g.Count() });
                    }

                    // Completo tutti i mesi
                    foreach (var m in elencoMesi)
                    {
                        ValuesXYaxis<string, string> nuovo = new ValuesXYaxis<string, string>();
                        nuovo.XAxes = m.mese;
                        var temp = elenco.Where(t => t.XAxes == m.indice);
                        if (temp != null && temp.Count() > 0)
                        {
                            nuovo.YAxes = temp.First().YAxes.ToString();
                        }
                        elencoDefinitivo.Add(nuovo);
                    }
                }

                LabelsAndDatasets labelsAndDatasets = GetChartData(elencoDefinitivo, ChartType.Bar);

                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Chart Task Per Mese Per Figura Professionale
        public LabelsAndDatasets GetNumeroDiTasksPerMesePerFiguraProfessionale(
            string risorsa_FK,
            int anno)
        {
            try
            {
                List<List<ValuesXYaxis<string, string>>> elencoDefinitivo = new List<List<ValuesXYaxis<string, string>>>(); // Elenco ddefinitivo con tutti i mesi di tutte le serie

                // Recupero le figure professiionali
                List<FigureProfessionali> elencoFigureProfessionai = GetFigureProfessionali(risorsa_FK, anno);
                List<string> descrizioniFigure = new List<string>();

                foreach (FigureProfessionali figura in elencoFigureProfessionai)
                {
                    elencoDefinitivo.Add(GetNumeroDiTasksPerMeseDiRisorsaPerFigura(risorsa_FK, anno, figura.Codice));
                    descrizioniFigure.Add(figura.Descrizione);
                }

                LabelsAndDatasets labelsAndDatasets = GetChartData(elencoDefinitivo, ChartType.Line, descrizioniFigure);

                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private List<ValuesXYaxis<string, string>> GetNumeroDiTasksPerMeseDiRisorsaPerFigura(
            string risorsa_FK,
            int anno,
            string figura_FK)
        {
            try
            {
                List<ValuesXYaxis<int, int>> elenco = new List<ValuesXYaxis<int, int>>(); // Valori dalla query linq
                List<ValuesXYaxis<string, string>> elencoDefinitivo = new List<ValuesXYaxis<string, string>>(); // Elenco ddefinitivo con tutti i mesi

                using (var context = new TimesheetEntities())
                {
                    // Ciclo le figure prefessionali. Pper ogni figura avrò una serie 

                    var result = from t in context.TimeSheet
                                 join l in context.TasksLavorati on t.Id equals l.TimeSheet_FK
                                 where t.Data.Year == anno &&
                                       t.Risorse_FK == risorsa_FK &&
                                       t.FigureProfessionali_FK == figura_FK
                                 group new { t, l } by t.Data.Month into raggruppamento
                                 select raggruppamento;
                    foreach (var g in result)
                    {
                        elenco.Add(new ValuesXYaxis<int, int> { XAxes = g.Key, YAxes = g.Count() });
                    }

                    // Completo tutti i mesi
                    foreach (var m in elencoMesi)
                    {
                        ValuesXYaxis<string, string> nuovo = new ValuesXYaxis<string, string>();
                        nuovo.XAxes = m.mese;
                        var temp = elenco.Where(t => t.XAxes == m.indice);
                        if (temp != null && temp.Count() > 0)
                        {
                            nuovo.YAxes = temp.First().YAxes.ToString();
                        }
                        elencoDefinitivo.Add(nuovo);
                    }
                }

                return elencoDefinitivo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        public LabelsAndDatasets GetNumeroDiTasksPerProgetto(string risorsa_FK, int anno)
        {
            try
            {
                List<ValuesXYaxis<string, int>> elenco = new List<ValuesXYaxis<string, int>>(); // Valori dalla query linq
                List<ValuesXYaxis<string, string>> elencoDefinitivo = new List<ValuesXYaxis<string, string>>(); // Elenco ddefinitivo con tutti i mesi

                using (var context = new TimesheetEntities())
                {
                    var result = from t in context.TimeSheet
                                 join l in context.TasksLavorati on t.Id equals l.TimeSheet_FK
                                 join ts in context.Tasks on l.Task_FK equals ts.Id
                                 where t.Data.Year == anno && t.Risorse_FK == risorsa_FK
                                 group new { ts, l } by ts.Progetto_FK into raggruppamento
                                 select raggruppamento;
                    foreach (var g in result)
                    {
                        elenco.Add(new ValuesXYaxis<string, int> { XAxes = g.Key, YAxes = g.Count() });
                    }
                }

                LabelsAndDatasets labelsAndDatasets = GetChartData(elenco, ChartType.Bar);

                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<int> GetAnniTaskValidi()
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var anniPresenti = context.TimeSheet
                        .Where(t => t.Data.Year >= 2014)
                        ?.Select(s => s.Data.Year)
                        .Distinct()
                        .OrderByDescending(o => o)
                        .ToList() ?? new List<int>();

                    if (!anniPresenti.Contains(DateTime.Now.Year))
                    {
                        anniPresenti.Insert(0, DateTime.Now.Year);
                    }
                    return anniPresenti.ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public LabelsAndDatasets GetChartData<axesX, axesY>(
            List<List<ValuesXYaxis<axesX, axesY>>> dataSet,
            ChartType type,
            List<string> descrizioniFigure)
        {
            try
            {
                // Oggetto di ritorno
                LabelsAndDatasets labelsAndDatasets = new LabelsAndDatasets();

                // Lista di datasets (ogni datasets sarà una serie sul grafico)
                List<DataSetPerChart> datasets = new List<DataSetPerChart>();

                // Creo le labels
                CreaLabels(dataSet.First(), labelsAndDatasets); // Le labels dell'asse X sono uguali per tutte le serie quindi le creo solo 1 volta

                // Creo i datasets
                CreaDatasets(dataSet, type, labelsAndDatasets, descrizioniFigure);

                // Ritorno l'oggetto completo
                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public LabelsAndDatasets GetChartData<axesX, axesY>(List<ValuesXYaxis<axesX, axesY>> dataSet, ChartType type)
        {
            try
            {
                // Oggetto di ritorno
                LabelsAndDatasets labelsAndDatasets = new LabelsAndDatasets();

                // Lista di datasets (ogni datasets sarà una serie sul grafico)
                List<DataSetPerChart> datasets = new List<DataSetPerChart>();

                // Creo le labels
                CreaLabels(dataSet, labelsAndDatasets); // Le labels dell'asse X sono uguali per tutte le serie quindi le creo solo 1 volta

                // Creo i datasets
                CreaDatasets(dataSet, type, labelsAndDatasets);

                // Ritorno l'oggetto completo
                return labelsAndDatasets;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CreaLabels<axesX, axesY>(List<ValuesXYaxis<axesX, axesY>> dataSet, LabelsAndDatasets labelsAndDatasets)
        {
            List<string> labels = new List<string>();
            foreach (var d in dataSet)
            {
                labels.Add(d.XAxes != null ? d.XAxes.ToString() : string.Empty);
            }
            labelsAndDatasets.labels = labels;
        }

        private void CreaDatasets<axesX, axesY>(
            List<List<ValuesXYaxis<axesX, axesY>>> dataSet,
            ChartType type,
            LabelsAndDatasets labelsAndDatasets,
            List<string> descrizioniFigure)
        {
            List<DataSetPerChart> elenco = new List<DataSetPerChart>(); // Elenco di dataset. 1 dataset rappresenta una serie sul grafico
            int indiceDescrioniFigure = 0;

            foreach (List<ValuesXYaxis<axesX, axesY>> singolaSerie in dataSet)
            {
                DataSetPerChart dataSetPerChart = new DataSetPerChart();

                // Label
                dataSetPerChart.label = descrizioniFigure[indiceDescrioniFigure];

                // Inserisco i dati
                List<string> dati = new List<string>();
                foreach (var d in singolaSerie)
                {
                    dati.Add(d.YAxes != null ? d.YAxes.ToString() : string.Empty);
                }
                dataSetPerChart.data = dati;

                // Completo con colori e bordo
                if (type == ChartType.Bar)
                {
                    CreaColoriPerBar(dataSetPerChart);
                }
                else
                {
                    CreaColoriLine(dataSetPerChart, indiceDescrioniFigure);
                }

                // Aggiungo all'elenco di datasets
                elenco.Add(dataSetPerChart);

                indiceDescrioniFigure++;
            }

            // Aggancio i dataset all'oggetto finale
            labelsAndDatasets.datasets = elenco;
        }

        private void CreaDatasets<axesX, axesY>(
            List<ValuesXYaxis<axesX, axesY>> dataSet,
            ChartType type,
            LabelsAndDatasets labelsAndDatasets)
        {
            List<DataSetPerChart> elenco = new List<DataSetPerChart>(); // Elenco di dataset. 1 dataset rappresenta una serie sul grafico

            DataSetPerChart dataSetPerChart = new DataSetPerChart();

            // Inserisco i dati
            List<string> dati = new List<string>();
            foreach (var d in dataSet)
            {
                dati.Add(d.YAxes != null ? d.YAxes.ToString() : string.Empty);
            }
            dataSetPerChart.data = dati;

            // Completo con colori e bordo
            CreaColoriPerBar(dataSetPerChart);

            // Aggiungo all'elenco di datasets
            elenco.Add(dataSetPerChart);

            // Aggancio i dataset all'oggetto finale
            labelsAndDatasets.datasets = elenco;
        }

        private void CreaColoriPerBar(DataSetPerChart dataSetPerChart)
        {
            // Aggiungo i backgrouncolor
            List<string> backgroundColors = new List<string>
            {
                "rgba(255, 99, 132, 0.2)",
                "rgba(54, 162, 235, 0.2)",
                "rgba(255, 206, 86, 0.2)",
                "rgba(75, 192, 192, 0.2)",
                "rgba(153, 102, 255, 0.2)",
                "rgba(255, 159, 64, 0.2)",
                "rgba(255, 99, 132, 0.2)",
                "rgba(54, 162, 235, 0.2)",
                "rgba(255, 206, 86, 0.2)",
                "rgba(75, 192, 192, 0.2)",
                "rgba(153, 102, 255, 0.2)",
                "rgba(255, 159, 64, 0.2)"
            };
            dataSetPerChart.backgroundColor = backgroundColors;

            List<string> borderColors = new List<string>
            {
                "rgba(255, 99, 132, 1)",
                "rgba(54, 162, 235, 1)",
                "rgba(255, 206, 86, 1)",
                "rgba(75, 192, 192, 1)",
                "rgba(153, 102, 255, 1)",
                "rgba(255, 159, 64, 1)",
                "rgba(255, 99, 132, 1)",
                "rgba(54, 162, 235, 1)",
                "rgba(255, 206, 86, 1)",
                "rgba(75, 192, 192, 1)",
                "rgba(153, 102, 255, 1)",
                "rgba(255, 159, 64, 1)"
            };
            dataSetPerChart.borderColor = borderColors;

            dataSetPerChart.borderWidth = 1;
        }

        private void CreaColoriLine(DataSetPerChart dataSetPerChart, int indiceDescrioniFigure)
        {
            dataSetPerChart.backgroundColor = "rgba(0, 0, 0, 0)";

            List<string> borderColors = new List<string>
            {
                "rgba(255, 99, 132, 1)",
                "rgba(54, 162, 235, 1)",
                "rgba(255, 206, 86, 1)",
                "rgba(75, 192, 192, 1)",
                "rgba(153, 102, 255, 1)",
                "rgba(255, 159, 64, 1)",
                "rgba(255, 99, 132, 1)",
                "rgba(54, 162, 235, 1)",
                "rgba(255, 206, 86, 1)",
                "rgba(75, 192, 192, 1)",
                "rgba(153, 102, 255, 1)",
                "rgba(255, 159, 64, 1)"
            };
            dataSetPerChart.borderColor = borderColors[indiceDescrioniFigure];

            dataSetPerChart.borderWidth = 1;
        }

        private List<FigureProfessionali> GetFigureProfessionali(string risorsa_FK, int anno)
        {
            try
            {
                List<FigureProfessionali> elencoFigureProfessionai;
                if (anno == DateTime.Now.Year)
                {
                    elencoFigureProfessionai = fc.GetFigureByCodiceRisorsa(risorsa_FK);
                }
                else
                {
                    elencoFigureProfessionai = fc.GetFigureProfessionaliUsateByCodiceRisosaConAnno(risorsa_FK, anno);
                }
                return elencoFigureProfessionai;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    #region Oggetti Da Serializare
    public class ValuesXYaxis<axisX, axisY>
    {
        public axisX XAxes { get; set; }
        public axisY YAxes { get; set; }
    }
    #endregion

    #region Oggetti Serializzati da usare nel javascript
    public class LabelsAndDatasets
    {
        public List<string> labels { get; set; } // Label dell'asse X
        public List<DataSetPerChart> datasets { get; set; }
    }

    public class DataSetPerChart
    {
        public string label { get; set; } // Label della serie

        public List<string> data { get; set; } // Valori dell'asse Y

        public object backgroundColor { get; set; }

        public object borderColor { get; set; }

        public int borderWidth { get; set; }
    }

    public enum ChartType
    {
        Bar,
        Line
    }
    #endregion
}