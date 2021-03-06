USE [Timesheet]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCalendario]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Base per Calendario
-- =============================================
CREATE FUNCTION [dbo].[GetCalendario] 
(
	-- Add the parameters for the function here
	@t1 date, 
	@t2 date
)
RETURNS 
@Calendario TABLE 
(
	-- Add the column definitions for the TABLE variable here
	data date, 
	lavorativo bit
)
AS
BEGIN
	
with Periodo(data)
as
(
	select @t1 as data
	union all
	select dateadd(dd, 1, data) as data 
	from Periodo
	where dateadd(dd, 1, data) <= @t2
)

Insert into @Calendario (data, lavorativo)

select data, 
	case WHEN DATEPART(Weekday, data) = 6 THEN 0
		 WHEN DATEPART(Weekday, data) = 7 THEN 0
		 WHEN (MONTH(data) = 1 AND DAY(data) = 1)    THEN 0
		 WHEN (MONTH(data) = 1 AND DAY(data) = 6)  	 THEN 0
		 WHEN (MONTH(data) = 4 AND DAY(data) = 25)   THEN 0
		 WHEN (MONTH(data) = 5 AND DAY(data) = 1)    THEN 0
		 WHEN (MONTH(data) = 6 AND DAY(data) = 2)    THEN 0
		 WHEN (MONTH(data) = 6 AND DAY(data) = 29)   THEN 0
		 WHEN (MONTH(data) = 8 AND DAY(data) = 15)   THEN 0
		 WHEN (MONTH(data) = 11 AND DAY(data) = 1)   THEN 0
		 WHEN (MONTH(data) = 12 AND DAY(data) = 8)   THEN 0
		 WHEN (MONTH(data) = 12 AND DAY(data) = 25)  THEN 0
		 WHEN (MONTH(data) = 12 AND DAY(data) = 26)  THEN 0
	else 1
	end as Lavorativo
from Periodo 
	


	RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetDataDaGiorniLavorativi]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 10-10-2014
-- Description:	Ottiene una data fine a partire da una data inizio e un numero di giorni lavorativi
-- =============================================
CREATE FUNCTION [dbo].[GetDataDaGiorniLavorativi] 
(
	@date date, 
	@gl int
)
RETURNS date
AS
BEGIN
	
	DECLARE @ResultVar date

	--select  @date = '2014-10-16', @gl = 1

	declare @i int, @d as date, @w int, @gg int

	set @gg = @gl
	set @i = 1

	while @i <= @gg
	begin
		set @d = dateadd(dd, @i, @date)
		set @w = datepart(dw, @d) 
		--select @w
		if( @w >= 6)
			set @gg = @gg + 1
	
		set @i = @i +1
	end
 
	select @ResultVar = dateadd(dd, @gg, @date)
	
	RETURN @ResultVar

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetLavorato]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 18/03/2014
-- Description:	Ottiene il lavorato in giorni (decimale)
-- =============================================
CREATE FUNCTION [dbo].[GetLavorato]
(
	-- Add the parameters for the function here
	@idTimesheet int
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result float

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = --    (DATEDIFF(MINUTE, Ingresso , Uscita )/cast(60.0 as decimal(18,4)) - DATEDIFF(MINUTE, Pausa, Rientro)/cast(60.0 as decimal(18,4)) ) / cast(8.0 as decimal(18,4))
			cast( DATEDIFF(MINUTE, Ingresso , Uscita ) - DATEDIFF(MINUTE, PausaPranzo, Rientro) as float)  / cast(60.0 * 8 as float) 
	from TimeSheet where id = @idTimesheet

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetLavoratoGG]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[GetLavoratoGG] 
(
	-- Add the parameters for the function here
	@minuti int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = cast(	@minuti / cast(60.0 * 8 as float) as int)

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetLavoratoHH]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[GetLavoratoHH] 
(
	-- Add the parameters for the function here
	@minuti int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = (@minuti / 60.0) % 8  

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetLavoratoMinutiTotali]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Dato un IdTimesheet restituisce i Minuti Totali
-- =============================================
CREATE FUNCTION [dbo].[GetLavoratoMinutiTotali]
(
	-- Add the parameters for the function here
	@idTimeSheet int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result =    (DATEDIFF(MINUTE, Ingresso , Uscita ) - DATEDIFF(MINUTE, PausaPranzo, Rientro)) 
	from TimeSheet 
	where id = @idTimesheet

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetLavoratoMM]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[GetLavoratoMM] 
(
	-- Add the parameters for the function here
	@minuti int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result =  @minuti % 60 

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumeroTask] [int] NOT NULL,
	[Progetto_FK] [nvarchar](10) NOT NULL,
	[Titolo] [nvarchar](100) NOT NULL,
	[DataRichiesta] [date] NOT NULL,
	[PreventivoGGUU] [decimal](5, 2) NOT NULL,
	[InGaranzia] [bit] NOT NULL,
	[PreventivoInviato] [bit] NOT NULL,
	[Terminato] [bit] NOT NULL,
	[Descrizione] [nvarchar](max) NULL,
	[FiglioDi] [int] NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_Tasks] UNIQUE NONCLUSTERED 
(
	[NumeroTask] ASC,
	[Progetto_FK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreventivoTask]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreventivoTask](
	[Task_FK] [int] NOT NULL,
	[FigureProfessionali_FK] [nvarchar](5) NOT NULL,
	[PreventivoGGUU] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_PreventivoTask] PRIMARY KEY CLUSTERED 
(
	[Task_FK] ASC,
	[FigureProfessionali_FK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VwPreventivoTask_OLD]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VwPreventivoTask_OLD]
AS
SELECT Progetto_FK + ' ' + cast(t .NumeroTask AS varchar) AS task, DataRichiesta AS data_richiesta, Titolo, Descrizione, gg_AP, gg_BD, gg_CP, 
            dbo.GetDataDaGiorniLavorativi(DataRichiesta, (gg_AP + gg_BD + gg_CP)) AS data_fine
FROM  Tasks t 
INNER JOIN (SELECT pvt.Task_FK, isnull(AP16, 0) AS gg_AP, isnull(BD16, 0) AS gg_BD, isnull(CP16, 0) AS gg_CP
             FROM  PreventivoTask pt PIVOT (sum([PreventivoGGUU]) FOR pt.FigureProfessionali_FK IN (AP16, BD16, CP16)) AS pvt) AS pvt ON pvt.Task_FK = t .Id
WHERE  t .PreventivoInviato = 0
GO
/****** Object:  View [dbo].[VwPreventivoTask]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VwPreventivoTask]
AS

--SELECT Progetto_FK + ' ' + cast(t .NumeroTask AS varchar) AS task, DataRichiesta AS data_richiesta, Titolo, Descrizione, gg_AP, gg_BD, gg_CP, 
--            dbo.GetDataDaGiorniLavorativi(DataRichiesta, (gg_AP + gg_BD + gg_CP)) AS data_fine
--FROM  Tasks t 
--INNER JOIN (SELECT pvt.Task_FK, isnull(AP16, 0) AS gg_AP, isnull(BD16, 0) AS gg_BD, isnull(CP16, 0) AS gg_CP
--             FROM  PreventivoTask pt PIVOT (sum([PreventivoGGUU]) FOR pt.FigureProfessionali_FK IN (AP16, BD16, CP16)) AS pvt) AS pvt ON pvt.Task_FK = t .Id
--WHERE  t .PreventivoInviato = 0

SELECT T.Progetto_FK + ' ' + cast(T.NumeroTask AS varchar) AS task, T.DataRichiesta AS data_richiesta, 
	case 
		when T.FiglioDi is not null
		then T.Titolo + ' (task padre: ' + cast(TPadre.NumeroTask as varchar) + ')'
		else T.Titolo 
	end as Titolo, 
	T.Descrizione, gg_AP, gg_BD, gg_CP, 
	dbo.GetDataDaGiorniLavorativi(T.DataRichiesta, (gg_AP + gg_BD + gg_CP)) AS data_fine
FROM  Tasks T 
INNER JOIN (SELECT pvt.Task_FK, isnull(AP16, 0) AS gg_AP, isnull(BD16, 0) AS gg_BD, isnull(CP16, 0) AS gg_CP
             FROM  PreventivoTask pt PIVOT (sum([PreventivoGGUU]) FOR pt.FigureProfessionali_FK IN (AP16, BD16, CP16)) AS pvt) AS pvt ON pvt.Task_FK = t .Id
LEFT JOIN Tasks TPadre on T.FiglioDi = TPadre.Id
WHERE  T.PreventivoInviato = 0

GO
/****** Object:  Table [dbo].[Aziende]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aziende](
	[Codice] [nvarchar](10) NOT NULL,
	[Descrizione] [nvarchar](256) NULL,
	[Indirizzo] [nvarchar](512) NULL,
	[Mail] [nvarchar](256) NULL,
 CONSTRAINT [PK_Aziende] PRIMARY KEY CLUSTERED 
(
	[Codice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AziendePerContratto]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AziendePerContratto](
	[Azienda_FK] [nvarchar](10) NOT NULL,
	[Contratto_FK] [int] NOT NULL,
	[Budget] [money] NULL,
	[DataInizio] [date] NULL,
	[DataFine] [date] NULL,
 CONSTRAINT [PK_AziendePerContratto] PRIMARY KEY CLUSTERED 
(
	[Azienda_FK] ASC,
	[Contratto_FK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Consolidamento]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Consolidamento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Contratto_FK] [int] NOT NULL,
	[Anno] [int] NOT NULL,
	[Mese] [int] NOT NULL,
	[Risorse_FK] [nvarchar](5) NOT NULL,
	[Nominativo] [nvarchar](128) NOT NULL,
	[FigureProfessionali_FK] [nvarchar](5) NOT NULL,
	[ErogatoTot] [float] NOT NULL,
	[ErogatoInFattura] [float] NOT NULL,
	[ErogatoInGaranzia] [float] NOT NULL,
 CONSTRAINT [PK_Consolidamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConsolidamentoSemestre]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsolidamentoSemestre](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Contratto_FK] [int] NOT NULL,
	[Anno] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Aziende_FK] [nvarchar](10) NOT NULL,
	[FiguraProfessionale] [nvarchar](256) NULL,
	[Tariffa] [float] NOT NULL,
	[ErogatoTot] [float] NOT NULL,
	[ErogatoInFattura] [float] NOT NULL,
	[ErogatoInGaranzia] [float] NOT NULL,
	[Importo] [float] NOT NULL,
 CONSTRAINT [PK_ConsolidamentoSemestre] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConsolidamentoTrimestre]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsolidamentoTrimestre](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Contratto_FK] [int] NOT NULL,
	[Anno] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Aziende_FK] [nvarchar](10) NOT NULL,
	[Risorse_FK] [nvarchar](5) NOT NULL,
	[Nominativo] [nvarchar](128) NOT NULL,
	[FigureProfessionali_FK] [nvarchar](5) NOT NULL,
	[Tariffa] [float] NOT NULL,
	[ErogatoTot] [float] NOT NULL,
	[ErogatoInFattura] [float] NOT NULL,
	[ErogatoInGaranzia] [float] NOT NULL,
	[Importo] [float] NOT NULL,
 CONSTRAINT [PK_Fattura] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contratti]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contratti](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [nvarchar](10) NOT NULL,
	[Data] [date] NOT NULL,
	[Anno] [int] NOT NULL,
	[Descizione] [nvarchar](4000) NULL,
	[Budget] [money] NOT NULL,
	[Default] [bit] NULL,
	[StipulatoDa] [nvarchar](4000) NULL,
 CONSTRAINT [PK_Contratti] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FigureProfessionali]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FigureProfessionali](
	[Codice] [nvarchar](5) NOT NULL,
	[Descrizione] [nvarchar](256) NULL,
	[TariffaGiornaliera] [money] NOT NULL,
	[NumeroGiornatePreviste] [int] NULL,
	[Contratti_Fk] [int] NOT NULL,
	[Visibile] [bit] NULL,
	[DescrizioneBreve] [nvarchar](256) NULL,
 CONSTRAINT [PK_ConfigFigureProfessionali] PRIMARY KEY CLUSTERED 
(
	[Codice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogMonitor]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogMonitor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tabella] [nvarchar](200) NULL,
	[RecordId] [int] NULL,
	[OperazioneTipo] [nvarchar](2) NULL,
	[OperazioneData] [datetime] NULL,
	[Operazione] [nvarchar](1000) NULL,
	[Operatore] [nvarchar](50) NULL,
	[ComaCodi] [nvarchar](10) NULL,
	[Comando] [nvarchar](1000) NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [PK_LogMonitor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Progetti]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Progetti](
	[Nome] [nvarchar](10) NOT NULL,
	[Descrizione] [nvarchar](4000) NULL,
	[Valido] [bit] NOT NULL,
 CONSTRAINT [PK_Progetti] PRIMARY KEY CLUSTERED 
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[R_Risorse_FigureProfessionali]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[R_Risorse_FigureProfessionali](
	[CodiceRisorsa_FK] [nvarchar](5) NOT NULL,
	[CodiceFiguraProfessionale_FK] [nvarchar](5) NOT NULL,
	[RuoloDefault] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Risorse]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Risorse](
	[Codice] [nvarchar](5) NOT NULL,
	[Nominativo] [nvarchar](128) NOT NULL,
	[Account] [nvarchar](64) NOT NULL,
	[CostoGiornaliero] [money] NULL,
	[Aziende_FK] [nvarchar](10) NOT NULL,
	[FiguraProfessionaleDefault_FK] [nvarchar](5) NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[Ingresso] [time](7) NULL,
	[Uscita] [time](7) NULL,
	[IsCustomer] [bit] NOT NULL,
	[IsValid] [bit] NULL,
 CONSTRAINT [PK_Risorse] PRIMARY KEY CLUSTERED 
(
	[Codice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TasksLavorati]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TasksLavorati](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TimeSheet_FK] [int] NOT NULL,
	[Task_FK] [int] NOT NULL,
	[Lavorato] [time](7) NULL,
	[Note] [varchar](max) NULL,
 CONSTRAINT [PK_TasksLavorati] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSheet]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSheet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Data] [date] NOT NULL,
	[Risorse_FK] [nvarchar](5) NOT NULL,
	[FigureProfessionali_FK] [nvarchar](5) NOT NULL,
	[Ingresso] [time](7) NOT NULL,
	[PausaPranzo] [time](7) NULL,
	[Rientro] [time](7) NULL,
	[Uscita] [time](7) NOT NULL,
	[Attivita] [nvarchar](4000) NULL,
	[Lavorato]  AS ([dbo].[GetLavorato]([Id])),
	[GG]  AS ([dbo].[GetLavoratoGG]([dbo].[GetLavoratoMinutiTotali]([id]))),
	[HH]  AS ([dbo].[GetLavoratoHH]([dbo].[GetLavoratoMinutiTotali]([id]))),
	[MM]  AS ([dbo].[GetLavoratoMM]([dbo].[GetLavoratoMinutiTotali]([id]))),
	[LavoratoInMinuti]  AS ([dbo].[GetLavoratoMinutiTotali]([id])),
	[Validazione] [datetime] NULL,
	[Validato]  AS (case when [Validazione] IS NOT NULL then (1) else (0) end),
	[OreRendicontate] [decimal](18, 7) NOT NULL,
	[OreLavorate]  AS ([dbo].[GetLavoratoMinutiTotali]([id])/(60.0)),
	[ValidazioneArma] [datetime] NULL,
	[ValidatoArma]  AS (case when [ValidazioneArma] IS NOT NULL then (1) else (0) end),
	[InGaranzia] [bit] NOT NULL,
 CONSTRAINT [PK_TimeSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[R_Risorse_FigureProfessionali] ADD  CONSTRAINT [DF_R_Risorse_FigureProfessionali_Ruolo]  DEFAULT ((0)) FOR [RuoloDefault]
GO
ALTER TABLE [dbo].[Risorse] ADD  CONSTRAINT [DF_Risorse_FiguraProfessionale_FK]  DEFAULT (N'AP') FOR [FiguraProfessionaleDefault_FK]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_PreventivoInviato]  DEFAULT ((0)) FOR [PreventivoInviato]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_Terminato]  DEFAULT ((0)) FOR [Terminato]
GO
ALTER TABLE [dbo].[TimeSheet] ADD  CONSTRAINT [DF_TimeSheet_InGaranzia]  DEFAULT ((0)) FOR [InGaranzia]
GO
ALTER TABLE [dbo].[AziendePerContratto]  WITH CHECK ADD  CONSTRAINT [FK_AziendePerContratto_Aziende] FOREIGN KEY([Azienda_FK])
REFERENCES [dbo].[Aziende] ([Codice])
GO
ALTER TABLE [dbo].[AziendePerContratto] CHECK CONSTRAINT [FK_AziendePerContratto_Aziende]
GO
ALTER TABLE [dbo].[AziendePerContratto]  WITH CHECK ADD  CONSTRAINT [FK_AziendePerContratto_Contratti] FOREIGN KEY([Contratto_FK])
REFERENCES [dbo].[Contratti] ([Id])
GO
ALTER TABLE [dbo].[AziendePerContratto] CHECK CONSTRAINT [FK_AziendePerContratto_Contratti]
GO
ALTER TABLE [dbo].[Consolidamento]  WITH CHECK ADD  CONSTRAINT [FK_Consolidamento_Contratti] FOREIGN KEY([Contratto_FK])
REFERENCES [dbo].[Contratti] ([Id])
GO
ALTER TABLE [dbo].[Consolidamento] CHECK CONSTRAINT [FK_Consolidamento_Contratti]
GO
ALTER TABLE [dbo].[Consolidamento]  WITH CHECK ADD  CONSTRAINT [FK_Consolidamento_FigureProfessionali] FOREIGN KEY([FigureProfessionali_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[Consolidamento] CHECK CONSTRAINT [FK_Consolidamento_FigureProfessionali]
GO
ALTER TABLE [dbo].[Consolidamento]  WITH CHECK ADD  CONSTRAINT [FK_Consolidamento_Risorse] FOREIGN KEY([Risorse_FK])
REFERENCES [dbo].[Risorse] ([Codice])
GO
ALTER TABLE [dbo].[Consolidamento] CHECK CONSTRAINT [FK_Consolidamento_Risorse]
GO
ALTER TABLE [dbo].[ConsolidamentoSemestre]  WITH CHECK ADD  CONSTRAINT [ConsolidamentoSemestre_FK_Fattura_Contratti] FOREIGN KEY([Contratto_FK])
REFERENCES [dbo].[Contratti] ([Id])
GO
ALTER TABLE [dbo].[ConsolidamentoSemestre] CHECK CONSTRAINT [ConsolidamentoSemestre_FK_Fattura_Contratti]
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre]  WITH CHECK ADD  CONSTRAINT [FK_Fattura_Contratti] FOREIGN KEY([Contratto_FK])
REFERENCES [dbo].[Contratti] ([Id])
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre] CHECK CONSTRAINT [FK_Fattura_Contratti]
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre]  WITH CHECK ADD  CONSTRAINT [FK_Fattura_FigureProfessionali] FOREIGN KEY([FigureProfessionali_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre] CHECK CONSTRAINT [FK_Fattura_FigureProfessionali]
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre]  WITH CHECK ADD  CONSTRAINT [FK_Fattura_Risorse] FOREIGN KEY([Risorse_FK])
REFERENCES [dbo].[Risorse] ([Codice])
GO
ALTER TABLE [dbo].[ConsolidamentoTrimestre] CHECK CONSTRAINT [FK_Fattura_Risorse]
GO
ALTER TABLE [dbo].[FigureProfessionali]  WITH CHECK ADD  CONSTRAINT [FK_ConfigFigureProfessionali_Contratti] FOREIGN KEY([Contratti_Fk])
REFERENCES [dbo].[Contratti] ([Id])
GO
ALTER TABLE [dbo].[FigureProfessionali] CHECK CONSTRAINT [FK_ConfigFigureProfessionali_Contratti]
GO
ALTER TABLE [dbo].[PreventivoTask]  WITH CHECK ADD  CONSTRAINT [FK_PreventivoTask_FigureProfessionali] FOREIGN KEY([FigureProfessionali_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[PreventivoTask] CHECK CONSTRAINT [FK_PreventivoTask_FigureProfessionali]
GO
ALTER TABLE [dbo].[PreventivoTask]  WITH CHECK ADD  CONSTRAINT [FK_PreventivoTask_Tasks] FOREIGN KEY([Task_FK])
REFERENCES [dbo].[Tasks] ([Id])
GO
ALTER TABLE [dbo].[PreventivoTask] CHECK CONSTRAINT [FK_PreventivoTask_Tasks]
GO
ALTER TABLE [dbo].[R_Risorse_FigureProfessionali]  WITH CHECK ADD  CONSTRAINT [FK_R_Risorse_FigureProfessionali_FigureProfessionali] FOREIGN KEY([CodiceFiguraProfessionale_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[R_Risorse_FigureProfessionali] CHECK CONSTRAINT [FK_R_Risorse_FigureProfessionali_FigureProfessionali]
GO
ALTER TABLE [dbo].[R_Risorse_FigureProfessionali]  WITH CHECK ADD  CONSTRAINT [FK_R_Risorse_FigureProfessionali_Risorse] FOREIGN KEY([CodiceRisorsa_FK])
REFERENCES [dbo].[Risorse] ([Codice])
GO
ALTER TABLE [dbo].[R_Risorse_FigureProfessionali] CHECK CONSTRAINT [FK_R_Risorse_FigureProfessionali_Risorse]
GO
ALTER TABLE [dbo].[Risorse]  WITH CHECK ADD  CONSTRAINT [FK_Risorse_Aziende] FOREIGN KEY([Aziende_FK])
REFERENCES [dbo].[Aziende] ([Codice])
GO
ALTER TABLE [dbo].[Risorse] CHECK CONSTRAINT [FK_Risorse_Aziende]
GO
ALTER TABLE [dbo].[Risorse]  WITH CHECK ADD  CONSTRAINT [FK_Risorse_FigureProfessionali] FOREIGN KEY([FiguraProfessionaleDefault_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[Risorse] CHECK CONSTRAINT [FK_Risorse_FigureProfessionali]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Progetti] FOREIGN KEY([Progetto_FK])
REFERENCES [dbo].[Progetti] ([Nome])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Progetti]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Tasks_Padre_Figlio] FOREIGN KEY([FiglioDi])
REFERENCES [dbo].[Tasks] ([Id])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Tasks_Padre_Figlio]
GO
ALTER TABLE [dbo].[TasksLavorati]  WITH CHECK ADD  CONSTRAINT [FK_TasksLavorati_Tasks] FOREIGN KEY([Task_FK])
REFERENCES [dbo].[Tasks] ([Id])
GO
ALTER TABLE [dbo].[TasksLavorati] CHECK CONSTRAINT [FK_TasksLavorati_Tasks]
GO
ALTER TABLE [dbo].[TasksLavorati]  WITH CHECK ADD  CONSTRAINT [FK_TasksLavorati_TimeSheet] FOREIGN KEY([TimeSheet_FK])
REFERENCES [dbo].[TimeSheet] ([Id])
GO
ALTER TABLE [dbo].[TasksLavorati] CHECK CONSTRAINT [FK_TasksLavorati_TimeSheet]
GO
ALTER TABLE [dbo].[TimeSheet]  WITH CHECK ADD  CONSTRAINT [FK_TimeSheet_FigureProfessionali] FOREIGN KEY([FigureProfessionali_FK])
REFERENCES [dbo].[FigureProfessionali] ([Codice])
GO
ALTER TABLE [dbo].[TimeSheet] CHECK CONSTRAINT [FK_TimeSheet_FigureProfessionali]
GO
ALTER TABLE [dbo].[TimeSheet]  WITH CHECK ADD  CONSTRAINT [FK_TimeSheet_Risorse] FOREIGN KEY([Risorse_FK])
REFERENCES [dbo].[Risorse] ([Codice])
GO
ALTER TABLE [dbo].[TimeSheet] CHECK CONSTRAINT [FK_TimeSheet_Risorse]
GO
/****** Object:  StoredProcedure [dbo].[uspCheckOreTimesheet]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Roberto Lorenzin
-- Create date: 19/03/2014
-- Description:	Vista Delta Ore
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckOreTimesheet] 
	-- Add the parameters for the stored procedure here
	@t1 date, 
	@t2 date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT        
		t.Risorse_FK
		, t.FigureProfessionali_FK
		, r.Aziende_FK
		, r.Nominativo
		, round(SUM(t.Lavorato),2) AS Lavorato
		, round(SUM(t.OreLavorate),2) AS OreLavorate
FROM            dbo.TimeSheet AS t 
INNER JOIN dbo.Risorse AS r ON r.Codice = t.Risorse_FK
WHERE   t.data BETWEEN @t1 AND @t2
GROUP BY t.Risorse_FK, t.FigureProfessionali_FK, r.Aziende_FK, r.Nominativo
ORDER BY r.Aziende_FK, t.FigureProfessionali_FK, r.Nominativo

END

GO
/****** Object:  StoredProcedure [dbo].[uspCheckResiduoContratto]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 08/09/2014
-- Description:	Ottiene il lavorato e il previsto per il contratto (puoi passare un idContratto preciso o solo l'anno di riferimento)
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckResiduoContratto] 
	-- Add the parameters for the stored procedure here
	@annoContratto int = null, 
	@idContratto int = null
AS
BEGIN
	SET NOCOUNT ON;


	select c.anno, fp.Codice, fp.NumeroGiornatePreviste,  t.Validato , t.Lavorato, fp.NumeroGiornatePreviste - t.Lavorato as Residuo
	from FigureProfessionali fp
	inner join Contratti c on c.Id = fp.Contratti_Fk
	left join (
		SELECT        FigureProfessionali_FK, sum(Lavorato) as Lavorato, Validato
		FROM            TimeSheet
		group by FigureProfessionali_FK, Validato
	) AS t on t.FigureProfessionali_FK = fp.Codice
	where 
		c.Anno = isnull(@annoContratto, c.Anno) or isnull(@idContratto, c.Id) = c.Id

	select c.anno, c.Budget,  t.Validato , sum(t.Lavorato) as Lavorato, c.Budget - sum(t.Lavorato) as Residuo
	from Contratti c 
	left join (
		SELECT			FigureProfessionali_FK, fp.Contratti_Fk, sum(Lavorato) * FP.TariffaGiornaliera as Lavorato, Validato
		FROM            TimeSheet 
		inner join		Tasks on Tasks.Id = TimeSheet.Task_FK and Tasks.InGaranzia = 0
		inner join		FigureProfessionali fp on fp.Codice = TimeSheet.FigureProfessionali_FK
		group by FigureProfessionali_FK, fp.Contratti_Fk, FP.TariffaGiornaliera, Validato
	) AS t on t.Contratti_Fk = c.id	
	where 
		c.Anno = isnull(@annoContratto, c.Anno) or isnull(@idContratto, c.Id) = c.Id
	group by c.anno, c.Budget,   t.Validato
END

GO
/****** Object:  StoredProcedure [dbo].[uspCheckResiduoContratto_NEW]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 08/09/2014
-- Description:	Ottiene il lavorato e il previsto per il contratto (puoi passare un idContratto preciso o solo l'anno di riferimento)
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckResiduoContratto_NEW] 
	-- Add the parameters for the stored procedure here
	@annoContratto int = null, 
	@idContratto int = null
AS
BEGIN
	SET NOCOUNT ON;

	SELECT c.anno, fp.Codice, fp.NumeroGiornatePreviste, ROUND(SUM(LavoratoValidato),2) AS LavoratoValidato,
	ROUND(SUM(LavoratoNonValidato),2) AS LavoratoNonValidato, 
	fp.NumeroGiornatePreviste - ROUND(SUM(LavoratoValidato),2) - ROUND(SUM(LavoratoNonValidato),2) AS Residuo
	FROM FigureProfessionali fp
	INNER JOIN Contratti c ON c.Id = fp.Contratti_Fk
	LEFT JOIN (
		SELECT FigureProfessionali_FK, ROUND(SUM(Lavorato),2) AS LavoratoValidato, 0 AS LavoratoNonValidato
		FROM TimeSheet WHERE validato = 1
		GROUP BY FigureProfessionali_FK, Validato
		UNION
		SELECT FigureProfessionali_FK, 0 AS LavoratoValidato, ROUND(SUM(Lavorato),2) AS LavoratoNonValidato
		FROM TimeSheet WHERE validato = 0
		GROUP BY FigureProfessionali_FK, Validato
	) AS t ON t.FigureProfessionali_FK = fp.Codice
	WHERE (c.Anno = ISNULL(@annoContratto, c.Anno) OR ISNULL(@idContratto, c.Id) = c.Id) AND fp.Codice <> 'CC'
	GROUP BY c.anno, fp.Codice, fp.NumeroGiornatePreviste

	SELECT c.anno, c.Budget, ROUND(SUM(t.LavoratoValidato),2) AS LavoratoValidato, 
	ROUND(SUM(t.LavoratoNonValidato),2) AS LavoratoNonValidato,
	c.Budget - ROUND(SUM(t.LavoratoValidato),2)- ROUND(SUM(t.LavoratoValidato),2) AS Residuo
	FROM Contratti c 
	LEFT JOIN (
		SELECT FigureProfessionali_FK, fp.Contratti_Fk, Validato, SUM(Lavorato) * FP.TariffaGiornaliera AS LavoratoValidato, 
		0 as NonValidato, 0 AS LavoratoNonValidato	
		FROM TimeSheet 
		INNER JOIN Tasks ON Tasks.Id = TimeSheet.Task_FK and Tasks.InGaranzia = 0
		INNER JOIN FigureProfessionali fp ON fp.Codice = TimeSheet.FigureProfessionali_FK
		WHERE validato = 1
		GROUP BY FigureProfessionali_FK, fp.Contratti_Fk, FP.TariffaGiornaliera, Validato
		UNION
		SELECT FigureProfessionali_FK, fp.Contratti_Fk, 0 AS Validato, 0 AS LavoratoValidato, 
		1 AS NonValidato, SUM(Lavorato) * FP.TariffaGiornaliera AS LavoratoNonValidato	
		FROM TimeSheet 
		INNER JOIN Tasks ON Tasks.Id = TimeSheet.Task_FK AND Tasks.InGaranzia = 0
		INNER JOIN FigureProfessionali fp ON fp.Codice = TimeSheet.FigureProfessionali_FK
		WHERE validato = 0
		GROUP BY FigureProfessionali_FK, fp.Contratti_Fk, FP.TariffaGiornaliera, Validato
	) AS t on t.Contratti_Fk = c.id	
	WHERE 
		c.Anno = ISNULL(@annoContratto, c.Anno) OR ISNULL(@idContratto, c.Id) = c.Id AND Validato = 1
	GROUP BY c.anno, c.Budget
END

GO
/****** Object:  StoredProcedure [dbo].[uspConsolidaSemestre]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Roberto Lorenzin
-- Create date: 01/04/2016
-- Description:	Riepilogo Fatturazione per Contratto
-- =============================================
CREATE PROCEDURE [dbo].[uspConsolidaSemestre] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@anno int = 0,
	@semestre int = null
AS
BEGIN 
	SET NOCOUNT ON;

BEGIN TRANSACTION
	DELETE ConsolidamentoSemestre
	WHERE Contratto_FK = @idContratto
	AND Anno = @anno
	AND Semestre =  @semestre


	INSERT INTO ConsolidamentoSemestre 
	SELECT @idContratto AS Contr, @anno AS Anno, @semestre AS Sem, Aziende_FK AS Ditta,  
		FP.DescrizioneBreve AS FP, TariffaGiornaliera AS Tariffa,
		SUM(ErogatoTot) AS ErogTot, SUM(ErogatoInFattura) AS ErogFatt,
		SUM(ErogatoInGaranzia) AS ErogGar, 
		round(sum(ErogatoInFattura) * TariffaGiornaliera, 2) AS Importo		
	FROM Consolidamento AS CO
	LEFT JOIN FigureProfessionali AS FP ON CO.FigureProfessionali_FK = FP.Codice
	LEFT JOIN Risorse AS RI on CO.Risorse_FK = RI.Codice
	WHERE(
		(@semestre = 1 AND Mese BETWEEN 1 AND 6) OR
		(@semestre = 2 AND Mese BETWEEN 7 AND 12) 
		)
		AND Anno = @anno
		AND Contratto_FK = @idContratto
	GROUP BY Aziende_FK, FigureProfessionali_FK, TariffaGiornaliera, FP.DescrizioneBreve
	ORDER BY Aziende_FK, FigureProfessionali_FK 
COMMIT TRANSACTION
END 

GO
/****** Object:  StoredProcedure [dbo].[uspGetDeltaOre]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Vista Delta Ore
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDeltaOre] 
	-- Add the parameters for the stored procedure here
	@t1 date, 
	@t2 date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT        
		t.Risorse_FK, r.Aziende_FK, r.Nominativo, 
		SUM(t.Lavorato) AS Lavorato, 
		dbo.GetLavoratoGG(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS GG, 
        dbo.GetLavoratoHH(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS HH, 
		dbo.GetLavoratoMM(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS MM, 
		SUM(t.OreLavorate) AS OreLavorate, 
		SUM(t.OreRendicontate) AS OreRendicontate, 
		SUM(t.OreLavorate) - SUM(t.OreRendicontate) AS DeltaOre, 
		dbo.GetLavoratoGG((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaGG, 
		dbo.GetLavoratoHH((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaHH, 
        dbo.GetLavoratoMM((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaMM

FROM            dbo.TimeSheet AS t 
INNER JOIN dbo.Risorse AS r ON r.Codice = t.Risorse_FK
where   t.data between @t1 and @t2
GROUP BY t.Risorse_FK, r.Aziende_FK, r.Nominativo

END

GO
/****** Object:  StoredProcedure [dbo].[uspGetDeltaOrePerContratto]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Vista Delta Ore
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDeltaOrePerContratto] 
	@idContratto int = 0,
	@annoContratto int = 0,
	@t1 date, 
	@t2 date
AS
BEGIN

	SET NOCOUNT ON;

	IF(@annoContratto > 0 AND @idContratto <= 0)
		SELECT @idContratto = Contratti.Id FROM Contratti WHERE Contratti.Anno = @annoContratto

    SELECT        
		t.Risorse_FK, r.Aziende_FK, r.Nominativo, t.FigureProfessionali_FK,
		round(SUM(t.Lavorato), 2) AS Lavorato, 
		dbo.GetLavoratoGG(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS GG, 
        dbo.GetLavoratoHH(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS HH, 
		dbo.GetLavoratoMM(SUM(dbo.GetLavoratoMinutiTotali(t.Id))) AS MM, 
		round(SUM(t.OreLavorate), 2) AS OreLavorate, 
		SUM(t.OreRendicontate) AS OreRendicontate, 
		round(SUM(t.OreLavorate) - SUM(t.OreRendicontate), 2) AS DeltaOre, 
		dbo.GetLavoratoGG((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaGG, 
		dbo.GetLavoratoHH((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaHH, 
        dbo.GetLavoratoMM((SUM(t.OreLavorate) - SUM(t.OreRendicontate)) * 60) AS DeltaMM

	FROM  dbo.TimeSheet AS t 
	INNER JOIN dbo.Risorse AS r 
		ON r.Codice = t.Risorse_FK
	INNER JOIN dbo.FigureProfessionali fp 
		ON t.FigureProfessionali_FK = fp.Codice 
		AND (@idContratto = 0 or fp.Contratti_Fk = @idContratto)

	WHERE t.data BETWEEN @t1 AND @t2
	GROUP BY t.Risorse_FK, r.Aziende_FK, r.Nominativo, t.FigureProfessionali_FK
	ORDER BY r.Aziende_FK, t.FigureProfessionali_FK DESC, r.Nominativo

END

GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoFattura]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Riepilogo Fatturazione per Contratto con arrotondamento mensile parametrizzato
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoFattura] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@annoContratto int = 0,
	@t1 date = null, 
	@t2 date = null,
	@round int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@annoContratto > 0 and @idContratto <= 0)
		select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

	select 
		--c.id, c.Numero, + ' del ' + convert(varchar(10),c.Data,103) as Contratto , c.Budget,
		month(t.Data) as Mese,
		a.Codice as Azienda, a.Descrizione as DescrizioneAzienda,
		R.Codice as Risorsa, r.Nominativo,
		FP.Codice as FP, FP.Descrizione as FiguraProfessionale, FP.TariffaGiornaliera,
		round(SUM(t.LAVORATO), @round)		as ErogatoTot,
		CASE when isnull(Tasks.InGaranzia,0) = 1 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInFattura,
		CASE when isnull(Tasks.InGaranzia,0) = 0 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInGaranzia,
		CASE when isnull(Tasks.InGaranzia,0) = 1 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInFattura,
		CASE when isnull(Tasks.InGaranzia,0) = 0 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInGaranzia
		
	into #fattureMensili
	FROM 
		Timesheet t 
	INNER JOIN Risorse r ON   t.Risorse_FK = R.Codice
	INNER JOIN [dbo].[FigureProfessionali] FP ON T.FigureProfessionali_FK = FP.Codice 
	INNER JOIN Aziende a on r.Aziende_FK = a.Codice
	INNER JOIN [dbo].[Contratti] c on fp.Contratti_Fk = c.Id
	left join Tasks on Tasks.Id = t.Task_FK
	where 
		c.id = @idContratto
		and t.data between isnull(@t1, getdate()) and isnull(@t2, getdate())
	group by 
	
		--c.id, c.Numero, c.Data, c.Budget,
		month(t.Data),	---------------------- MESE -------------------
		a.Codice,		--Azienda
		a.Descrizione,	--DescrizioneAzienda
		R.Codice,		--Risorsa
		r.Nominativo,	--
		FP.Codice ,		--FP
		FP.Descrizione, --FiguraProfessionale
		FP.TariffaGiornaliera,
		isnull(Tasks.InGaranzia,0)


	select Azienda, DescrizioneAzienda, Risorsa, Nominativo, FP, FiguraProfessionale, TariffaGiornaliera,
			sum(ErogatoTot) as ErogatoTot,
			sum(ErogatoInFattura) as ErogatoInFattura,
			sum(ErogatoInGaranzia) as ErogatoInGaranzia,
			--sum(ImportoInFattura) as ImportoInFattura,
			--sum(ImportoInGaranzia) as ImportoInGaranzia
			round(TariffaGiornaliera * sum(ErogatoInFattura) , @round) as ImportoInFattura,
			round(TariffaGiornaliera * sum(ErogatoInGaranzia) ,@round) as ImportoInGaranzia
	from #fattureMensili
	group by Azienda, DescrizioneAzienda, Risorsa, Nominativo, FP, FiguraProfessionale, TariffaGiornaliera
	order by Azienda, FP desc, Nominativo
	
	select * from #fattureMensili 
	order by Mese, Azienda, FP desc, Nominativo

	drop table #fattureMensili
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoFatturaBase]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Riepilogo Fatturazione per Contratto
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoFatturaBase] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@annoContratto int = 0,
	@t1 date = null, 
	@t2 date = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@annoContratto > 0 and @idContratto <= 0)
		select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

	select 
		--c.id, c.Numero, + ' del ' + convert(varchar(10),c.Data,103) as Contratto , c.Budget,
		a.Codice as Azienda, a.Descrizione as DescrizioneAzienda,
		R.Codice as Risorsa, r.Nominativo,
		FP.Codice as FP, FP.Descrizione as FiguraProfessionale, FP.TariffaGiornaliera,
		SUM(t.LAVORATO)		as ErogatoTot,
		CASE when Tasks.InGaranzia = 1 then 0 else  SUM(t.LAVORATO) end as ErogatoInFattura,
		CASE when Tasks.InGaranzia = 0 then 0 else  SUM(t.LAVORATO) end as ErogatoInGaranzia,
		CASE when Tasks.InGaranzia = 1 then 0 else  SUM(t.LAVORATO) end * FP.TariffaGiornaliera as ImportoInFattura,
		CASE when Tasks.InGaranzia = 0 then 0 else  SUM(t.LAVORATO) end * FP.TariffaGiornaliera as ImportoInGaranzia

	FROM 
		Timesheet t 
	INNER JOIN Risorse r ON   t.Risorse_FK = R.Codice
	INNER JOIN [dbo].[FigureProfessionali] FP ON T.FigureProfessionali_FK = FP.Codice 
	INNER JOIN Aziende a on r.Aziende_FK = a.Codice
	INNER JOIN [dbo].[Contratti] c on fp.Contratti_Fk = c.Id
	left join Tasks on Tasks.Id = t.Task_FK
	where 
		c.id = @idContratto
		and t.data between isnull(@t1, getdate()) and isnull(@t2, getdate())
	group by 
	
		--c.id, c.Numero, c.Data, c.Budget,
		a.Codice, a.Descrizione,
		R.Codice, r.Nominativo,
		FP.Codice , FP.Descrizione, FP.TariffaGiornaliera,
		InGaranzia
END

GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoFatturaBaseNEW]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Roberto Lorenzin
-- Create date: 01/04/2016
-- Description:	Riepilogo Fatturazione per Contratto
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoFatturaBaseNEW] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@anno int = 0,
	@trimestre int = null
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @idContratto AS Contr, @anno AS Anno, @trimestre AS Trim, Aziende_FK AS Ditta, Risorse_FK AS Cod, CO.Nominativo AS Risorsa, 
		FigureProfessionali_FK AS FP, TariffaGiornaliera AS Tariffa,
		SUM(ErogatoTot) AS ErogTot, SUM(ErogatoInFattura) AS ErogFatt,
		SUM(ErogatoInGaranzia) AS ErogGar,
		round(sum(ErogatoInFattura) * TariffaGiornaliera, 2) AS Importo
	FROM Consolidamento AS CO
	LEFT JOIN FigureProfessionali AS FP ON CO.FigureProfessionali_FK = FP.Codice
	LEFT JOIN Risorse AS RI on CO.Risorse_FK = RI.Codice
    --WHERE 1 = 
    --  CASE @trimestre
    --     WHEN 1 THEN CASE WHEN Mese IN (1, 2, 3) THEN 1 ELSE 0 END
    --     WHEN 2 THEN CASE WHEN Mese IN (4, 5, 6) THEN 1 ELSE 0 END
    --     WHEN 3 THEN CASE WHEN Mese IN (7, 8, 9) THEN 1 ELSE 0 END
    --     WHEN 3 THEN CASE WHEN Mese IN (7, 8, 9) THEN 1 ELSE 0 END
    --  END
	WHERE(
		(@trimestre = 1 AND Mese IN ( 1,  2,  3)) OR
		(@trimestre = 2 AND Mese IN ( 4,  5,  6)) OR
		(@trimestre = 3 AND Mese IN ( 7,  8,  9)) OR
		(@trimestre = 4 AND Mese IN (10, 11, 12))
		)
		AND Anno = @anno
		AND Contratto_FK = @idContratto
	GROUP BY Aziende_FK, risorse_FK, CO.Nominativo, FigureProfessionali_FK, TariffaGiornaliera
	ORDER BY Aziende_FK, FigureProfessionali_FK DESC, Risorse_FK 

END

GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoMese]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Riepilogo Fatturazione per Contratto con arrotondamento mensile parametrizzato
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoMese] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@annoContratto int = 0,
	@t1 date = null, 
	@t2 date = null,
	@round int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@annoContratto > 0 and @idContratto <= 0)
		select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

	select 
		--c.id, c.Numero, + ' del ' + convert(varchar(10),c.Data,103) as Contratto , c.Budget,
		year(t.Data) as Anno,
		month(t.Data) as Mese,
		--a.Codice as Azienda, a.Descrizione as DescrizioneAzienda,
		R.Codice as Risorsa, r.Nominativo,
		FP.Codice as FP, --FP.Descrizione as FiguraProfessionale, FP.TariffaGiornaliera,
		round(SUM(t.LAVORATO), @round)		as ErogatoTot,
		CASE when isnull(t.InGaranzia,0) = 1 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInFattura,
		CASE when isnull(t.InGaranzia,0) = 0 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInGaranzia
		--CASE when isnull(Tasks.InGaranzia,0) = 1 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInFattura,
		--CASE when isnull(Tasks.InGaranzia,0) = 0 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInGaranzia
		
	into #fattureMensili
	FROM 
		Timesheet t 
	INNER JOIN Risorse r ON   t.Risorse_FK = R.Codice
	INNER JOIN [dbo].[FigureProfessionali] FP ON T.FigureProfessionali_FK = FP.Codice 
	INNER JOIN Aziende a on r.Aziende_FK = a.Codice
	INNER JOIN [dbo].[Contratti] c on fp.Contratti_Fk = c.Id
	--LEFT JOIN TasksLavorati tl ON tl.TimeSheet_FK = t.Id
	--left join Tasks on Tasks.Id = tl.Task_FK
	where 
		c.id = @idContratto
		and t.data between isnull(@t1, getdate()) and isnull(@t2, getdate())
	group by 
		--c.id, c.Numero, c.Data, c.Budget,
		year(t.Data),	---------------------- ANNO -------------------
		month(t.Data),	---------------------- MESE -------------------
		a.Codice,		--Azienda
		--a.Descrizione,	--DescrizioneAzienda
		R.Codice,		--Risorsa
		r.Nominativo,	--
		FP.Codice ,		--FP
		--FP.Descrizione, --FiguraProfessionale
		FP.TariffaGiornaliera,
		isnull(t.InGaranzia,0)
	
	select Anno, Mese, Risorsa, Nominativo, FP, SUM(ErogatoTot) as ErogatoTot, SUM(ErogatoInFattura) as ErogatoInFattura, 
		SUM(ErogatoInGaranzia) as ErogatoInGaranzia
	from #fattureMensili 
	group by Anno, Mese, Risorsa, Nominativo, FP
	order by Anno, Mese, --Azienda, 
	FP desc, Nominativo

	drop table #fattureMensili
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoMese_NEW]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Riepilogo Fatturazione per Contratto con arrotondamento mensile parametrizzato
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoMese_NEW] 
	-- Add the parameters for the stored procedure here
	@t1 date = null, 
	@t2 date = null,
	@round int
AS
BEGIN
	SET NOCOUNT ON;

	select 
		--c.id, c.Numero, + ' del ' + convert(varchar(10),c.Data,103) as Contratto , c.Budget,
		C.Descizione as Contratto,
		year(t.Data) as Anno,
		month(t.Data) as Mese,
		--a.Codice as Azienda, a.Descrizione as DescrizioneAzienda,
		R.Codice as Risorsa, r.Nominativo,
		FP.Codice as FP, --FP.Descrizione as FiguraProfessionale, FP.TariffaGiornaliera,
		round(SUM(T.LAVORATO), @round)		as ErogatoTot,
		CASE when isnull(TS.InGaranzia,0) = 1 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInFatturaGiorni,
		CASE when isnull(TS.InGaranzia,0) = 1 then 0 else round(SUM(t.OreLavorate), @round) end as ErogatoInFatturaOre,
		CASE when isnull(TS.InGaranzia,0) = 0 then 0 else round(SUM(t.LAVORATO), @round) end as ErogatoInGaranzia
		--CASE when isnull(Tasks.InGaranzia,0) = 1 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInFattura,
		--CASE when isnull(Tasks.InGaranzia,0) = 0 then 0 else /*round(*/cast(round(SUM(t.LAVORATO), @round) as decimal(12,2)) * FP.TariffaGiornaliera/*, @round)*/ end as ImportoInGaranzia
		
	into #fattureMensili
	FROM Timesheet as T 
	INNER JOIN Risorse as R 
		ON T.Risorse_FK = R.Codice
	INNER JOIN FigureProfessionali as FP 
		ON T.FigureProfessionali_FK = FP.Codice 
	INNER JOIN Aziende as A 
		ON R.Aziende_FK = A.Codice
	INNER JOIN Contratti as C 
		ON FP.Contratti_Fk = C.Id
	left join Tasks as TS
		ON TS.Id = T.Task_FK
	where T.data between isnull(@t1, getdate()) and isnull(@t2, getdate())
	group by 
	
		--c.id, c.Numero, c.Data, c.Budget,
		C.Descizione,
		year(T.Data),	---------------------- ANNO -------------------
		month(T.Data),	---------------------- MESE -------------------
		A.Codice,		--Azienda
		--a.Descrizione,	--DescrizioneAzienda
		R.Codice,		--Risorsa
		R.Nominativo,	--
		FP.Codice ,		--FP
		--FP.Descrizione, --FiguraProfessionale
		FP.TariffaGiornaliera,
		isnull(TS.InGaranzia,0)
	
	select Contratto, Anno, Mese, Risorsa, Nominativo, FP, convert(decimal(5,2), ErogatoTot) as [Erogato Tot], 
	convert(decimal(5,2), ErogatoInFatturaGiorni) as [Erogato In Fattura Giorni], ErogatoInFatturaOre as [Erogato Ore],
	convert(decimal(5,2), ErogatoInGaranzia) as [Erogato In Garanzia]
	from #fattureMensili 
	order by Contratto, Anno, Mese, FP desc, Nominativo

	drop table #fattureMensili
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoSemestre]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ferdinando cavaliere
-- Create date: 19/03/2014
-- Description:	Riepilogo Fatturazione per Contratto con arrotondamento mensile parametrizzato
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoSemestre] 
	-- Add the parameters for the stored procedure here
	@idContratto int = 0,
	@anno int = 0,
	@semestre int = null
AS
BEGIN
	SELECT @idContratto AS Contratto_FK, @anno AS Anno, @semestre AS Semestre, Aziende_FK,  
		FP.DescrizioneBreve AS FiguraProfessionale, 
		TariffaGiornaliera AS Tariffa,
		SUM(ErogatoTot) AS ErogatoTot, SUM(ErogatoInFattura) AS ErogatoInFattura,
		SUM(ErogatoInGaranzia) AS ErogatoInGaranzia, 
		round(sum(ErogatoInFattura) * TariffaGiornaliera, 2) AS Importo		
	FROM Consolidamento AS CO
	LEFT JOIN FigureProfessionali AS FP ON CO.FigureProfessionali_FK = FP.Codice
	LEFT JOIN Risorse AS RI on CO.Risorse_FK = RI.Codice
	WHERE(
		(@semestre = 1 AND Mese BETWEEN 1 AND 6) OR
		(@semestre = 2 AND Mese BETWEEN 7 AND 12) 
		)
		AND Anno = @anno
		AND Contratto_FK = @idContratto
	GROUP BY Aziende_FK, FigureProfessionali_FK, TariffaGiornaliera, FP.DescrizioneBreve
	ORDER BY Aziende_FK, FigureProfessionali_FK 
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoTask]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Stored Procedure per Riepilogo Task
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoTask] 
	@idContratto int = 0,
	@annoContratto int = 0,
	@progetto nvarchar(10) = null,
	@t1 date , 
	@t2 date  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	if(@annoContratto > 0 and @idContratto <= 0)
		select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

SELECT        
	--dbo.Contratti.Numero AS NumeroContratto, 
	--dbo.Contratti.Data AS DataContratto, 
	--dbo.Contratti.Anno AS AnnoContratto, 
	isnull(dbo.Tasks.Progetto_FK, '') as Progetto, 
	isnull(dbo.Tasks.NumeroTask, '') as NumeroTask,
	isnull(dbo.Tasks.Titolo, '') as Titolo,
	--isnull(dbo.Tasks.InGaranzia, cast(0 as bit) ) as InGaranzia,
	dbo.Tasks.DataRichiesta,
	isnull(dbo.PreventivoTask.PreventivoGGUU, 0) as GiorniUomoPreventivati, 
	isnull(dbo.PreventivoTask.FigureProfessionali_FK, '-') as FiguraInPreventivo, 
	--dbo.FigureProfessionali.Descrizione,
	MIN(dbo.TimeSheet.Data) AS DataInizio, 
	MAX(dbo.TimeSheet.Data) AS DataFine,
	round(SUM(dbo.TimeSheet.Lavorato),2) AS GiorniUomoConsuntivati,
	dbo.TimeSheet.FigureProfessionali_FK as Figura,
	round(isnull(dbo.PreventivoTask.PreventivoGGUU, 0) - SUM(dbo.TimeSheet.Lavorato),2) as DeltaPreventivoConsuntivo,
	case 
		when (datediff(DD, dbo.Tasks.DataRichiesta, MIN(dbo.TimeSheet.Data))) < 0 Then 'Error'
		else 'OK' 
	end as InizioDopoRichiesta
FROM            
	dbo.TimeSheet 
INNER JOIN
        dbo.FigureProfessionali ON dbo.TimeSheet.FigureProfessionali_FK = dbo.FigureProfessionali.Codice 
INNER JOIN
        dbo.Contratti ON dbo.FigureProfessionali.Contratti_Fk = dbo.Contratti.Id
LEFT JOIN 
		dbo.Tasks on dbo.TimeSheet.Task_FK = dbo.Tasks.Id
LEFT JOIN dbo.PreventivoTask on dbo.PreventivoTask.Task_FK = dbo.Tasks.Id and dbo.PreventivoTask.FigureProfessionali_FK = dbo.FigureProfessionali.Codice

where   
	Contratti.id = @idContratto and
	TimeSheet.data between @t1 and @t2
	and (@progetto is null or (isnull(@progetto,'') = isnull(dbo.Tasks.Progetto_FK, '')))
GROUP BY 
	--dbo.Contratti.Numero , 
	--dbo.Contratti.Data , 
	--dbo.Contratti.Anno , 
	isnull(dbo.Tasks.Progetto_FK, '') , 
	isnull(dbo.Tasks.NumeroTask, ''),
	isnull(dbo.Tasks.Titolo, ''),
	isnull(dbo.PreventivoTask.PreventivoGGUU, 0), 
	isnull(dbo.Tasks.InGaranzia, 0),  
	dbo.Tasks.DataRichiesta,
	dbo.TimeSheet.FigureProfessionali_FK,
	isnull(dbo.PreventivoTask.FigureProfessionali_FK, '-')
order by 
	isnull(dbo.Tasks.Progetto_FK, ''),
	isnull(dbo.Tasks.NumeroTask, ''),
	MIN(dbo.TimeSheet.Data)
END

GO
/****** Object:  StoredProcedure [dbo].[uspGetRiepilogoTask_conRisorse]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Stored Procedure per Riepilogo Task
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRiepilogoTask_conRisorse] 
	@idContratto int = 0,
	--@annoContratto int = 0,
	@progetto nvarchar(10) = null,
	@t1 date , 
	@t2 date  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	--if(@annoContratto > 0 and @idContratto <= 0)
	--	select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

SELECT        
	isnull(dbo.Tasks.Progetto_FK, '') as Progetto, 
	isnull(dbo.Tasks.NumeroTask, '') as Task,
	isnull(dbo.Tasks.Titolo, '') as Titolo,
	--isnull(dbo.Tasks.InGaranzia, cast(0 as bit) ) as InGaranzia,
	dbo.Tasks.DataRichiesta,
	--dbo.TimeSheet.Risorse_FK as Risorsa,
	dbo.Risorse.Nominativo as Risorse
	--round(SUM(dbo.TimeSheet.Lavorato),2) AS GiorniUomoConsuntivati
	into #temp
FROM dbo.TimeSheet 
INNER JOIN dbo.FigureProfessionali 
	ON dbo.TimeSheet.FigureProfessionali_FK = dbo.FigureProfessionali.Codice 
INNER JOIN dbo.Contratti 
	ON dbo.FigureProfessionali.Contratti_Fk = dbo.Contratti.Id
LEFT JOIN dbo.Tasks 
	ON dbo.TimeSheet.Task_FK = dbo.Tasks.Id
LEFT JOIN dbo.PreventivoTask 
	ON dbo.PreventivoTask.Task_FK = dbo.Tasks.Id 
	AND dbo.PreventivoTask.FigureProfessionali_FK = dbo.FigureProfessionali.Codice
LEFT JOIN dbo.Risorse
	ON Risorse.Codice = dbo.TimeSheet.Risorse_FK

where   
	Contratti.id = @idContratto and
	TimeSheet.data between @t1 and @t2
	and (@progetto is null or (isnull(@progetto,'') = isnull(dbo.Tasks.Progetto_FK, '')))
	and dbo.Tasks.InGaranzia = 0
GROUP BY 
	isnull(dbo.Tasks.Progetto_FK, '') , 
	isnull(dbo.Tasks.NumeroTask, ''),
	isnull(dbo.Tasks.Titolo, ''),
	--isnull(dbo.Tasks.InGaranzia, 0),  
	dbo.Tasks.DataRichiesta,
	--dbo.TimeSheet.Risorse_FK,
	dbo.Risorse.Nominativo
order by 
	isnull(dbo.Tasks.Progetto_FK, ''),
	isnull(dbo.Tasks.NumeroTask, ''),
	--dbo.TimeSheet.Risorse_FK,
	MIN(dbo.TimeSheet.Data)



declare @prog varchar(50)
declare @task int
declare @titolo varchar(255)
declare @dataRichiesta date
declare @risorsa varchar(1000)	
set @risorsa = ''	

declare @RisorseRaggruppate table(
	Progetto varchar(50),
	task int,
	titolo varchar(255),
	DataRichiesta date,
	Risorse varchar(1000)
	)

		
		DECLARE cursore_task CURSOR FOR
		select Progetto,task,titolo,DataRichiesta
		from #temp
		group by  Progetto,task,titolo,DataRichiesta
		OPEN cursore_task
			FETCH NEXT FROM cursore_task into
			@prog, @task, @titolo, @dataRichiesta
			WHILE @@FETCH_STATUS = 0
				BEGIN
				set @risorsa = ''
					select @risorsa	= @risorsa + Risorse +', ' 
					from #temp
					where Progetto = @prog
					and task = @task
					and titolo = @titolo
					and DataRichiesta = @dataRichiesta
					insert into @RisorseRaggruppate
					select @prog,@task ,@titolo ,@dataRichiesta, SUBSTRING (@risorsa, 0, len(@risorsa))

				FETCH NEXT FROM cursore_task into
			@prog, @task, @titolo, @dataRichiesta
			END

		CLOSE cursore_task
		DEALLOCATE cursore_task

		select Progetto,task,titolo,DataRichiesta,Risorse from @RisorseRaggruppate

		drop table #temp
	
END


GO
/****** Object:  StoredProcedure [dbo].[uspGetRimanenzaTask]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gianluca Arena
-- Create date: 19/03/2014
-- Description:	Stored Procedure per Riepilogo Task
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRimanenzaTask] 
	@idContratto int = 0,
	@annoContratto int = 0,
	@progetto nvarchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	if(@annoContratto > 0 and @idContratto <= 0)
		select @idContratto = Contratti.Id from Contratti where Contratti.Anno = @annoContratto

SELECT        
	 ISNULL(Tasks.Progetto_FK, '')						as Progetto 
	,ISNULL(Tasks.NumeroTask, '')						as Task
	,ISNULL(Tasks.Id, '')								as Id
	,ISNULL(Tasks.Titolo, '')							as Titolo
	,ISNULL(Tasks.InGaranzia, cast(0 as bit))			as InGaranzia
	,Tasks.DataRichiesta								as DataRichiesta
	,ISNULL(PreventivoTask.FigureProfessionali_FK, '-')	as Figura
	,ISNULL(PreventivoTask.PreventivoGGUU, 0)			as GG_Prev
	,ROUND(SUM(ISNULL(TimeSheet.Lavorato, 0)),2)		as GG_Cons
	,ROUND(ISNULL(PreventivoTask.PreventivoGGUU, 0) - SUM(ISNULL(TimeSheet.Lavorato, 0)), 2) as Delta
FROM PreventivoTask  
LEFT JOIN Tasks 
	ON PreventivoTask.Task_FK = Tasks.Id
LEFT JOIN TimeSheet 
	ON TimeSheet.Task_FK = Tasks.Id and PreventivoTask.FigureProfessionali_FK = TimeSheet.FigureProfessionali_FK
LEFT JOIN FigureProfessionali
	ON PreventivoTask.FigureProfessionali_FK = FigureProfessionali.Codice 
LEFT JOIN Contratti
	ON FigureProfessionali.Contratti_Fk = Contratti.Id
where   
	Contratti.id = @idContratto
	and (@progetto is null or (isnull(@progetto,'') = isnull(dbo.Tasks.Progetto_FK, '')))
GROUP BY 
	Tasks.Progetto_FK , 
	Tasks.NumeroTask,
	Tasks.Id,
	Tasks.Titolo,
	ISNULL(PreventivoTask.PreventivoGGUU, 0), 
	Tasks.InGaranzia,  
	Tasks.DataRichiesta,
	TimeSheet.FigureProfessionali_FK,
	ISNULL(PreventivoTask.FigureProfessionali_FK, '-')
order by 
	ISNULL(Tasks.Progetto_FK, ''),
	ISNULL(Tasks.NumeroTask, '') DESC,
	MIN(TimeSheet.Data)
END

GO
/****** Object:  StoredProcedure [dbo].[uspGetSituazioneSingoloTask]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSituazioneSingoloTask]
	@idTask int 
AS
	BEGIN
		--SELECT T.Progetto_FK + ' ' + cast(T .NumeroTask AS varchar) AS task, 
		--   T.DataRichiesta AS data_richiesta, 
		--   CASE WHEN T .FiglioDi IS NOT NULL 
		--			 THEN T .Titolo + ' (task padre: ' + cast(TPadre.NumeroTask AS varchar) + ')' 
		--		ELSE T .Titolo 
		--   END AS Titolo, T .Descrizione, 
		--   gg_AP, 
		--   gg_BD, 
		--   gg_CP,
		--   DATEADD(dd, T.PreventivoGGUU, T.DataRichiesta) as data_fine 
		--   dbo.GetDataDaGiorniLavorativi(T .DataRichiesta, 
		--   (gg_AP + gg_BD + gg_CP)) AS data_fine
		--FROM Tasks T 
		--left JOIN (SELECT pvt.Task_FK, 
		--				   isnull(AP173, 0) AS gg_AP, 
		--				   isnull(BD173, 0) AS gg_BD, 
		--				   isnull(CP173, 0) AS gg_CP
		--			FROM PreventivoTask pt PIVOT (sum([PreventivoGGUU]) FOR pt.FigureProfessionali_FK IN (AP173, BD173, CP173)) AS pvt
		--		   ) AS pvt ON pvt.Task_FK = t .Id 
		--LEFT JOIN Tasks TPadre ON T .FiglioDi = TPadre.Id
		--WHERE T.Id = @idTask

		select t.Progetto_FK + ' ' + cast(t.NumeroTask AS varchar) AS task,
			   t.DataRichiesta AS data_richiesta, 
				   CASE WHEN T .FiglioDi IS NOT NULL 
							 THEN T .Titolo + ' (task padre: ' + cast(tPadre.NumeroTask AS varchar) + ')' 
						ELSE T .Titolo 
				   END AS Titolo, 
			   t.Descrizione,
			   f.Codice,
			   f.DescrizioneBreve AS DescrizioneFigura,
			   pt.PreventivoGGUU,
			   DATEADD(dd, T.PreventivoGGUU, T.DataRichiesta) as data_fine 
		from PreventivoTask pt join Tasks t on pt.Task_FK = t.Id
							   join FigureProfessionali f on pt.FigureProfessionali_FK = f.Codice
							   left join Tasks tPadre ON t.FiglioDi = tPadre.Id
		where t.Id = @idTask
	END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSituazioneSingoloTask_171]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[uspGetSituazioneSingoloTask_171]
	@idTask int 
AS
	BEGIN
		SELECT T.Progetto_FK + ' ' + cast(T .NumeroTask AS varchar) AS task, 
		   T.DataRichiesta AS data_richiesta, 
		   CASE WHEN T .FiglioDi IS NOT NULL 
					 THEN T .Titolo + ' (task padre: ' + cast(TPadre.NumeroTask AS varchar) + ')' 
				ELSE T .Titolo 
		   END AS Titolo, T .Descrizione, 
		   gg_AP, 
		   gg_BD, 
		   gg_CP, 
		   dbo.GetDataDaGiorniLavorativi(T .DataRichiesta, 
		   (gg_AP + gg_BD + gg_CP)) AS data_fine
		FROM Tasks T 
		inner JOIN (SELECT pvt.Task_FK, 
						   isnull(AP171, 0) AS gg_AP, 
						   isnull(BD171, 0) AS gg_BD, 
						   isnull(CP171, 0) AS gg_CP
					FROM PreventivoTask pt PIVOT (sum([PreventivoGGUU]) FOR pt.FigureProfessionali_FK IN (AP171, BD171, CP171)) AS pvt
				   ) AS pvt ON pvt.Task_FK = t .Id 
		LEFT JOIN Tasks TPadre ON T .FiglioDi = TPadre.Id
		WHERE T.Id = @idTask
	END
GO
/****** Object:  StoredProcedure [dbo].[uspRiepilogoAnno]    Script Date: 15/07/2020 14:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Roberto Lorenzin
-- Create date: 02/11/2018
-- Description:	Riepilogo giorni lavorati in un periodo
-- =============================================
CREATE PROCEDURE [dbo].[uspRiepilogoAnno] 
	-- Add the parameters for the stored procedure here
	@t1 date = null, 
	@t2 date = null,
	@round int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT A.Codice, R.Nominativo, T.Risorse_FK, round(SUM(T.Lavorato), @round)	AS LavoratoTot 
	FROM TimeSheet AS T
	INNER JOIN Risorse R 
		ON  T.Risorse_FK = R.Codice
	INNER JOIN Aziende A 
		ON R.Aziende_FK = A.Codice
	WHERE data between isnull(@t1, getdate()) and isnull(@t2, getdate())
	GROUP BY T.Risorse_FK, R.Nominativo, A.Codice
	ORDER BY A.Codice, R.Nominativo
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VwPreventivoTask_OLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VwPreventivoTask_OLD'
GO
