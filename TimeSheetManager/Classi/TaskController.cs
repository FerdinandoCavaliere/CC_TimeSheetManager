using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimeSheetManager.Model;

namespace TimeSheetManager.Classi
{
    public class TaskController
    {
        public List<Tasks> GetTasks(Int32? id,
            Int32? numeroTask,
            string progetto_Fk,
            string titolo,
            DateTime? dataRichiestaDa,
            DateTime? dataRichiestaA,
            decimal? preventivoGGUU,
            Boolean? inGaranzia,
            List<string> progetti,
            Boolean getValoriConcatenati)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var taskTmp = (from f1 in context.Tasks 
                                   join p1 in context.Progetti on f1.Progetto_FK equals p1.Nome
                                    where
                                    (
                                        (id == null || f1.Id == id) &&
                                        (numeroTask == null || f1.NumeroTask == numeroTask) &&
                                        (progetto_Fk == string.Empty || f1.Progetto_FK == progetto_Fk) &&
                                        (titolo == string.Empty || f1.Titolo == titolo) &&
                                        (dataRichiestaDa == null || f1.DataRichiesta >= dataRichiestaDa) &&
                                        (dataRichiestaA == null || f1.DataRichiesta <= dataRichiestaA) &&
                                        (preventivoGGUU == null || f1.PreventivoGGUU == preventivoGGUU) &&
                                        (inGaranzia == null || f1.InGaranzia == inGaranzia) && 
                                        f1.Terminato == false &&
                                        f1.PreventivoGGUU > 0 &&
                                        p1.Valido == true
                                    )
                                    orderby f1.Progetto_FK ascending, f1.NumeroTask descending
                                    select f1).ToList<Tasks>();

                    if (taskTmp != null && taskTmp.Count() > 0)
                    {
                        if (progetti != null && progetti.Count() > 0)
                        {
                            List<Tasks> elencoTmp = new List<Tasks>();
                            foreach (var singoloTask in taskTmp)
                            {
                                if (progetti.Contains(singoloTask.Progetto_FK))
                                {
                                    elencoTmp.Add(singoloTask);
                                }   
                            }
                            taskTmp = elencoTmp;
                        }

                        if (getValoriConcatenati)
                        {
                            List<Tasks> elenco = new List<Tasks>();
                            Tasks nuovo;
                            foreach (var singoloTask in taskTmp)
                            {
                                nuovo = new Tasks
                                {
                                    Id = singoloTask.Id,
                                    ValoriConcatenati = singoloTask.NumeroTask + " | " + singoloTask.Progetto_FK + " | " + singoloTask.Titolo
                                };
                                elenco.Add(nuovo);
                            }
                            return elenco;
                        }
                        return taskTmp.ToList();
                    }
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Tasks> GetTasks(Int32? id,
            Int32? contratto_FK,
            string progetto_Fk,
            DateTime? dataRichiesta,
            Boolean? inGaranzia,
            Int32? numeroTask,
            string titolo,
            decimal? totaleGiornate,
            string descrizione,
            Boolean? terminato,
            Int32? FiglioDi)
        {
            try
            {
                List<Tasks> elencoDefinitivo = new List<Tasks>();

                using (var context = new TimesheetEntities())
                {
                    var tasksTmp =  from t1 in context.Tasks
                                    join p2 in context.Progetti on t1.Progetto_FK equals p2.Nome
                                    join p1 in context.PreventivoTask on t1.Id equals p1.Task_FK
                                    join f1 in context.FigureProfessionali on p1.FigureProfessionali_FK equals f1.Codice
                                    join c1 in context.Contratti on f1.Contratti_Fk equals c1.Id
                                    where
                                    (
                                        (id == null || t1.Id == id) &&
                                        (contratto_FK == null || c1.Id == contratto_FK) &&
                                        (progetto_Fk == string.Empty || t1.Progetto_FK == progetto_Fk) &&
                                        (dataRichiesta == null || t1.DataRichiesta == dataRichiesta) &&
                                        (inGaranzia == null || t1.InGaranzia == inGaranzia) &&
                                        (numeroTask == null || t1.NumeroTask == numeroTask) &&
                                        (titolo == string.Empty || t1.Titolo.Contains(titolo)) &&
                                        (totaleGiornate == null || t1.PreventivoGGUU == totaleGiornate) &&
                                        (descrizione == string.Empty || t1.Descrizione.Contains(descrizione)) &&
                                        (terminato == null || t1.Terminato == terminato) &&
                                        (FiglioDi == null || t1.FiglioDi == FiglioDi) &&
                                        p2.Valido == true
                                    )
                                    orderby t1.NumeroTask descending, t1.DataRichiesta descending
                                    select new {
                                        t1.Id,
                                        IdContratto = c1.Id,
                                        t1.Progetto_FK,
                                        t1.DataRichiesta,
                                        t1.InGaranzia,
                                        t1.NumeroTask,
                                        t1.Titolo,
                                        t1.PreventivoGGUU,
                                        t1.Descrizione,
                                        t1.Terminato,
                                        t1.Progetti,
                                        t1.FiglioDi,
                                        t1.PreventivoInviato
                                    };
                    if (tasksTmp != null && tasksTmp.Count() > 0)
                    {
                        Tasks nuovo = null;
                        foreach (var singolo in tasksTmp.Distinct())
                        {
                            nuovo = new Tasks
                            {
                                Id = singolo.Id,
                                NumeroTask = singolo.NumeroTask,
                                Titolo = singolo.Titolo.Length > 90 ? singolo.Titolo.Substring(0, 90) + "..." : singolo.Titolo,
                                DataRichiesta = singolo.DataRichiesta,
                                PreventivoGGUU = singolo.PreventivoGGUU,
                                InGaranzia = singolo.InGaranzia,
                                Terminato = singolo.Terminato,
                                Descrizione = singolo.Descrizione,
                                Progetto_FK = singolo.Progetto_FK,
                                DescrizioneProgetto = singolo.Progetti.Descrizione,
                                IsUtilizzato = IsTaskUtilizzato(singolo.Id, context),
                                IdContratto = singolo.IdContratto,
                                FiglioDi = singolo.FiglioDi
                            };
                            if (singolo.FiglioDi != null)
                            {
                                nuovo.NumeroTaskPadre = context.Tasks.Where(w => w.Id == singolo.FiglioDi).FirstOrDefault().NumeroTask;
                            }
                            nuovo.PreventivoInviato = singolo.PreventivoInviato;
                            elencoDefinitivo.Add(nuovo);
                        }
                    }

                    return elencoDefinitivo;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public Tasks GetTaskById(Int32? id)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var tasksTmp = from t1 in context.Tasks
                                   where t1.Id == id
                                   select t1;

                    return tasksTmp.First();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<PreventivoTask> GetPreventivoGiornateByTaskId(Int32 idTask)
        {
            try
            {
                List<PreventivoTask> elencoDefinitivo = new List<PreventivoTask>();

                using (var context = new TimesheetEntities())
                {
                    var preventivoTmp = from p in context.PreventivoTask
                                        where p.Task_FK == idTask
                                        select p;
                    if (preventivoTmp != null && preventivoTmp.Count() > 0)
                    {
                        PreventivoTask nuovo = null;
                        foreach (PreventivoTask singolo in preventivoTmp)
                        {
                            nuovo = new PreventivoTask
                            {
                                FigureProfessionali_FK = singolo.FigureProfessionali_FK,
                                PreventivoGGUU = Math.Round(singolo.PreventivoGGUU, 2),
                                giornateSpese = Math.Round(GetGiornateSpeseByTaskTipoRisorsa(idTask, singolo.FigureProfessionali_FK, context), 2)
                            };
                            nuovo.giornateRestanti = Math.Round(nuovo.PreventivoGGUU - nuovo.giornateSpese, 2);
                            elencoDefinitivo.Add(nuovo);
                        }
                    }
                }

                return elencoDefinitivo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private Boolean IsTaskUtilizzato(Int32 idTask, TimesheetEntities context)
        {
            try
            {
                var tasks = context.TasksLavorati.Where(t => t.Task_FK == idTask);
                return tasks != null && tasks.Count() > 0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private decimal GetGiornateSpeseByTaskTipoRisorsa(Int32 idTask, string FigureProfessionali_FK, TimesheetEntities context)
        {
            try
            {
                decimal valoreLavorato = decimal.Zero;
                // Giornate in cui la figura ha lavorato sul task
                var giornate = from t in context.TimeSheet
                               join tl in context.TasksLavorati on t.Id equals tl.TimeSheet_FK
                               where tl.Task_FK == idTask && t.FigureProfessionali_FK == FigureProfessionali_FK
                               select tl;
                if (giornate != null && giornate.Count() > 0)
                {
                    foreach (var singolo in giornate)
                    {
                        valoreLavorato += Convert.ToDecimal(singolo.Lavorato.Value.TotalMinutes) / 480M; // 480 è dato da 60 (minuti in un ora) * 8 (ore lavorative in un giorno)
                    }
                    return valoreLavorato;
                }
                else
                {
                    return 0;
                } 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Progetti> GetProgetti()
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    return context.Progetti.Where(w => w.Valido == true).OrderBy(o => o.Nome).ToList<Progetti>();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertTask(Tasks task, List<PreventivoTask> elencoGiornatePerRisorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    // Inserisco il task
                    context.Tasks.AddObject(task);
                    
                    // Inserisco le giornate per risorsa
                    InsertGiornate(task, elencoGiornatePerRisorsa, context);

                    // Rendo persistenti le cose sul db
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateTask(Tasks task, List<PreventivoTask> elencoGiornatePerRisorsa)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    // Elimino 
                    DeleteGiornateDaPreventivoByTaskId (task.Id, context);

                    // Modifico dati dei task
                    var taskDaModificare = context.Tasks.Where(w => w.Id == task.Id).FirstOrDefault();
                    taskDaModificare.NumeroTask = task.NumeroTask;
                    taskDaModificare.Progetto_FK = task.Progetto_FK;
                    taskDaModificare.Titolo = task.Titolo;
                    taskDaModificare.DataRichiesta = task.DataRichiesta;
                    taskDaModificare.PreventivoGGUU = task.PreventivoGGUU;
                    taskDaModificare.InGaranzia = task.InGaranzia;
                    taskDaModificare.Descrizione = task.Descrizione;
                    taskDaModificare.FiglioDi = task.FiglioDi;

                    // Inserisco le giornate per risorsa
                    InsertGiornate(taskDaModificare, elencoGiornatePerRisorsa, context);

                    // Rendo persistenti le cose sul db
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void DeleteGiornateDaPreventivoByTaskId(Int32 idTask, TimesheetEntities context)
        {
            try
            {
                var giornateDaEliminare = context.PreventivoTask.Where(w => w.Task_FK == idTask);
                if (giornateDaEliminare != null && giornateDaEliminare.Count() > 0)
                {
                    foreach (PreventivoTask singola in giornateDaEliminare)
                    {
                        context.PreventivoTask.DeleteObject(singola);
                    }    
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void InsertGiornate(Tasks task, List<PreventivoTask> elencoGiornatePerRisorsa, TimesheetEntities context)
        {
            try
            {
                if (elencoGiornatePerRisorsa != null && elencoGiornatePerRisorsa.Count() > 0)
                {
                    foreach (PreventivoTask singola in elencoGiornatePerRisorsa)
                    {
                        singola.Tasks = task;
                        context.PreventivoTask.AddObject(singola);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteTask(Int32 idTask)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    // Elimino dalla tabella PreventivoTask
                    DeleteGiornateDaPreventivoByTaskId(idTask, context);

                    // Elimino dalla tabella TasksLavorati
                    DeleteTasksLavoratiByTaskId(idTask, context);

                    // Elimino il task
                    Tasks task = context.Tasks.Where(w => w.Id == idTask).FirstOrDefault();
                    context.Tasks.DeleteObject(task);

                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void TerminaTask(Int32 idTask)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Tasks task = context.Tasks.Where(w => w.Id == idTask).FirstOrDefault();
                    task.Terminato = true;
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Int32 GetProssimoNumeroTaskByProgettoId(string codiceProgetto)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    Int32 numeroMassimo = context.Tasks.Where(w => w.Progetto_FK == codiceProgetto).Max(m => m.NumeroTask);
                    return numeroMassimo++;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SettaPreventivoInviato(Int32 idTask)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var task = context.Tasks.Where(w => w.Id == idTask).FirstOrDefault();
                    task.PreventivoInviato = true;
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<TasksLavorati> GetTaskLavoratiByTimesheetId(int idTimeSheet)
        {
            try
            {
                List<TasksLavorati> elenco = new List<TasksLavorati>();

                using (var context = new TimesheetEntities())
                {
                    var tmp = from tl in context.TasksLavorati
                              where tl.TimeSheet_FK == idTimeSheet
                              select tl;
                    if (tmp != null)
                    {
                        foreach (var singolo in tmp)
                        {
                            elenco.Add(new TasksLavorati
                            {
                                Id = singolo.Id,
                                Lavorato = singolo.Lavorato,
                                Note = singolo.Note,
                                Numero = singolo.Tasks.NumeroTask,
                                Titolo = singolo.Tasks.Titolo,
                                Descrizione = singolo.Tasks.Descrizione,
                                NomeProgetto = singolo.Tasks.Progetto_FK
                            });
                        }
                    }
                }

                return elenco;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public TasksLavorati GetTaskLavoratoById(int idTaskLavorato)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var tmp = from tl in context.TasksLavorati
                              where tl.Id == idTaskLavorato
                              select tl;
                    if (tmp != null)
                    {
                        return new TasksLavorati
                        {
                            Id = tmp.First().Id,
                            TimeSheet_FK = tmp.First().TimeSheet_FK,
                            Task_FK = tmp.First().Task_FK,
                            Lavorato = tmp.First().Lavorato,
                            Note = tmp.First().Note,
                            NomeProgetto = tmp.First().Tasks.Progetto_FK
                        };
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SaveTaskLavorato(TasksLavorati taskLavorato)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    if (taskLavorato.Id == 0)
                    {
                        // Insert
                        context.TasksLavorati.AddObject(taskLavorato);
                    }
                    else
                    {
                        // Update
                        var taskLavoratoDaModificare = context.TasksLavorati.Where(t => t.Id == taskLavorato.Id).FirstOrDefault();
                        taskLavoratoDaModificare.TimeSheet_FK = taskLavorato.TimeSheet_FK;
                        taskLavoratoDaModificare.Task_FK = taskLavorato.Task_FK;
                        taskLavoratoDaModificare.Lavorato = taskLavorato.Lavorato;
                        taskLavoratoDaModificare.Note = taskLavorato.Note;
                    }

                    context.SaveChanges();
                }   
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteTaskLavorato(int idTaskLavorato)
        {
            try
            {
                using (var context = new TimesheetEntities())
                {
                    var taskLavoratoDaEliminare = context.TasksLavorati.Where(t => t.Id == idTaskLavorato).FirstOrDefault();
                    context.TasksLavorati.DeleteObject(taskLavoratoDaEliminare);
                    context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteTasksLavoratiByTimeSheetId(int idTimesheet, TimesheetEntities context)
        {
            var tasksLavorati = context.TasksLavorati.Where(t => t.TimeSheet_FK == idTimesheet);
            foreach (var t in tasksLavorati)
            {
                context.TasksLavorati.DeleteObject(t);
            }
        }

        public void DeleteTasksLavoratiByTaskId(int idTask, TimesheetEntities context)
        {
            var tasksLavorati = context.TasksLavorati.Where(t => t.Task_FK == idTask);
            foreach (var t in tasksLavorati)
            {
                context.TasksLavorati.DeleteObject(t);
            }
        }
    }
}