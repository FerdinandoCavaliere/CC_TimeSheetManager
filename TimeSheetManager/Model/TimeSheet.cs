using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Model
{
    public partial class TimeSheet
    {
        public string DescrizioneRisorsa { get; set; }

        public string DescrizioneFigura { get; set; }

        public TimeSpan RendicontatoEffettivo { get; set; }

        public TimeSpan LavoratoEffettivo { get; set; }

        public TimeSpan DifferenzaLavoratoConRendicontato { get; set; }

        public List<TasksLavorati> ListaTasksLavorati { get; set; }
    }
}