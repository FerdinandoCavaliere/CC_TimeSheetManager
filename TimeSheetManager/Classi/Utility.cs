using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Classi
{
    public class Utility
    {
        public static List<Mese> GetMesi()
        {
            List<Mese> elencoMesi = new List<Mese>();
            elencoMesi.Add(new Mese { mese = "Gennaio", indice = 1 });
            elencoMesi.Add(new Mese { mese = "Febbraio", indice = 2 });
            elencoMesi.Add(new Mese { mese = "Marzo", indice = 3 });
            elencoMesi.Add(new Mese { mese = "Aprile", indice = 4 });
            elencoMesi.Add(new Mese { mese = "Maggio", indice = 5 });
            elencoMesi.Add(new Mese { mese = "Giugno", indice = 6 });
            elencoMesi.Add(new Mese { mese = "Luglio", indice = 7 });
            elencoMesi.Add(new Mese { mese = "Agosto", indice = 8 });
            elencoMesi.Add(new Mese { mese = "Settembre", indice = 9 });
            elencoMesi.Add(new Mese { mese = "Ottobre", indice = 10 });
            elencoMesi.Add(new Mese { mese = "Novembre", indice = 11 });
            elencoMesi.Add(new Mese { mese = "Dicembre", indice = 12 });
            return elencoMesi;
        }
    }

    public class Mese
    {
        public string mese { get; set; }
        public Int32 indice { get; set; }
    }
}