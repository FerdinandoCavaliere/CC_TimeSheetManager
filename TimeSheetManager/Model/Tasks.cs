using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Model
{
    public partial class Tasks
    {
        public string ValoriConcatenati { get; set; }
        public string DescrizioneProgetto { get; set; }
        public Boolean IsUtilizzato { get; set; }
        public Int32 IdContratto { get; set; }
        public Int32 NumeroTaskPadre { get; set; }
    }
}