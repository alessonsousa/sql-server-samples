SELECT
	SQL1.CURSO																									[CURSO],
	SQL1.NOME																									[ALUNO],
	SQL1.[ANO DE INGRESSO],	
	CONVERT(DECIMAL(10,2), (SQL1.[COEFICIENTE DE RENDIMENTO]))													[CR],
	SQL1.ENEM,
	SQL1.[SITUA��O NO CURSO],
	SQL1.[CARGA HORARIA CUMPRIDA] + SQL1.[CARGA HORARIA ATIV]													[CH CURSADA],
	CONVERT(DECIMAL(10,2), ((SQL1.[CARGA HORARIA CUMPRIDA] + SQL1.[CARGA HORARIA ATIV])/SQL1.[CH MATRIZ])*100)	[PERCENTUAL],
	CASE
		WHEN SQL1.[DISC. PENDENTES] = 0 THEN '2021.1'
		WHEN SQL1.[DISC. PENDENTES] BETWEEN 1 AND 6 THEN '2021.2'
		WHEN SQL1.[DISC. PENDENTES] BETWEEN 7 AND 12 THEN '2022.1'
		WHEN SQL1.[DISC. PENDENTES] BETWEEN 13 AND 18 THEN '2022.2'
		WHEN SQL1.[DISC. PENDENTES] BETWEEN 19 AND 24 THEN '2023.1'
	END																											[PREVIS�O]
FROM (
SELECT 
	PPESSOA.NOME, 
	(SELECT COUNT(IDPERLET) FROM SMATRICPL (NOLOCK) WHERE SMATRICPL.RA = SALUNO.RA AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL AND SMATRICPL.CODSTATUS = 5)	[SEMESTRES CURSADOS],
	(SELECT COUNT(SHISTDISCPENDENTES.CODDISC) FROM  SHISTDISCPENDENTES (NOLOCK) WHERE SHISTDISCPENDENTES.RA = SALUNO.RA AND SHISTDISCPENDENTES.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL AND (SHISTDISCPENDENTES.CODSTATUS <> 19 OR (SHISTDISCPENDENTES.CODSTATUS IS NULL AND SHISTDISCPENDENTES.GREQUIV IS NULL)))	[DISC. PENDENTES],
	CONVERT(INTEGER, (SELECT SHISTHABILITACAOALUNO.QTDCONCATVCUR FROM SHISTHABILITACAOALUNO (NOLOCK) WHERE SHISTHABILITACAOALUNO.RA = SALUNO.RA AND SHISTHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL))	[CARGA HORARIA ATIV],
	CONVERT(INTEGER, (SELECT SUM(SHISTDISCCONCLUIDAS.CH) FROM SHISTDISCCONCLUIDAS (NOLOCK) WHERE SHISTDISCCONCLUIDAS.RA = SALUNO.RA AND SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL))	[CARGA HORARIA CUMPRIDA],
	SGRADE.CARGAHORARIA [CH MATRIZ],
	SCURSO.NOME			[CURSO],
	YEAR(SHABILITACAOALUNO.DTINGRESSO)	[ANO DE INGRESSO],
	SHABILITACAOALUNO.CR				[COEFICIENTE DE RENDIMENTO],
	SSTATUS.DESCRICAO					[SITUA��O NO CURSO],
	CASE
		WHEN SHABILITACAOALUNO.CODTIPOINGRESSO = 35 THEN 'SIM'
		ELSE 'N�O'
	END [ENEM]
FROM SPLETIVO (NOLOCK)
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA
		AND SMATRICPL.CODFILIAL = SPLETIVO.CODFILIAL
		AND SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SHABILITACAOALUNO (NOLOCK) ON
			SHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHABILITACAOALUNO.RA = SMATRICPL.RA
		AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
		AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.RA = SHABILITACAOALUNO.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
	INNER JOIN SGRADE (NOLOCK) ON
			SGRADE.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
		AND SGRADE.CODCURSO = SHABILITACAOFILIAL.CODCURSO
		AND SGRADE.CODGRADE = SHABILITACAOFILIAL.CODGRADE
		AND SGRADE.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO
	INNER JOIN SPERIODO (NOLOCK) ON
			SPERIODO.CODCOLIGADA = SGRADE.CODCOLIGADA
		AND SPERIODO.CODCURSO = SGRADE.CODCURSO
		AND SPERIODO.CODGRADE = SGRADE.CODGRADE
		AND SPERIODO.CODHABILITACAO = SGRADE.CODHABILITACAO
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SSTATUS (NOLOCK) ON
			SSTATUS.CODSTATUS = SHABILITACAOALUNO.CODSTATUS
WHERE SPLETIVO.CODPERLET = '2021.1'
AND SHABILITACAOFILIAL.CODCURSO IN ('1')
AND SMATRICPL.CODSTATUS IN (12,101,111)
GROUP BY SALUNO.RA, PPESSOA.NOME, SHABILITACAOALUNO.DTPROCESSOSELETIVO, SHABILITACAOFILIAL.IDHABILITACAOFILIAL, SGRADE.CARGAHORARIA, SCURSO.NOME, SHABILITACAOALUNO.DTINGRESSO, SHABILITACAOALUNO.CODTIPOINGRESSO, SHABILITACAOALUNO.CR, SSTATUS.DESCRICAO) SQL1
WHERE SQL1.[DISC. PENDENTES] BETWEEN 0 AND 24
ORDER BY [PREVIS�O], NOME