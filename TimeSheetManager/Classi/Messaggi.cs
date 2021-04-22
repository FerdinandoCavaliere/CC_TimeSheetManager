using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeSheetManager.Classi
{
    public class MessaggiAlert
    {
        public const string OPERAZIONE_SUCCESSO = "Operazione avvenuta con successo";
        public const string PERIODO_GIA_CONSOLIDATO = "Il periodo risulta già consolidato";
        public const string RICERCA_NO_RISULTATI = "La ricerca non ha prodotto risultati";
        public const string VALORI_CONSENTITI_RENDICONTATE = "I valori in minuti del campo Ore Rrendicontate possono essere 00, 15, 30, 45";
        public const string IMPOSSIBILE_CERCARE_SE_CAMPI_RISORSA_E_GIORNATE_NON_VALORIZZATI = "Non è possibile effettuare ricercche se i campi delle giornate per risorsa sono valorizzati";
        public const string INSERIRE_NUMERO_GIORNATE_PER_FIGURA = "Inserire una numero di giornate di task per figura valido";
        public const string INSERIRE_ALMENO_UN_NUMERO_GIORNATE_PER_FIGURA = "Inserire un numero di giornate di task almeno per una figura professionale";
        public const string GIORNATE_TOTALI_NON_CONFORME_A_SINGOLE_FIGURE = "Il totale delle giornate inserito non è conforme al numero di giornate per figura professionale. Continuare con l'inserimento?";
        public const string IMPOSSIBILE_REPERIRE_DATI_TASK = "Non è stato possibile reperire i dati del task";
        public const string INSERIRE_NUMERO_TASK_VALIDO = "Inserire un Numero di task valido";
        public const string INSERIRE_DATA_RICHIESTA_TASK_VALIDA = "Inserire una data richiesta di task valida";
        public const string INSERIRE_NUMERO_GIORNATE_TOTALE_TASK_VALIDO = "Inserire una numero di totale giornate di task valido";
        public const string SELEZIONARE_TASK= "Selezionare un task";
        public const string INSERIRE_ORE_LAVORATE = "Inserire ore lavorate";
    }

    public class MessaggiLabels
    {
        public const string MESE_DA_CONSOLIDARE = "Mese da consolidare";
        public const string SEMESTRE_DA_CONSOLIDARE = "Semestre da consolidare";
    }
}