using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Model
{
    public partial class PreventivoTask
    {
        public decimal giornateSpese { get; set; }
        //public decimal giornateRestanti { get; set; }
        public decimal giornateRestanti => Math.Round(PreventivoGGUU - giornateSpese, 2);
    }
}