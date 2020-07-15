using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Model
{
    public partial class TasksLavorati
    {
        public int Numero { get; set; }

        public string Titolo { get; set; }

        public string Descrizione { get; set; }

        public string NomeProgetto { get; set; }
    }
}