
SELECT 
	SPLETIVO.CODPERLET	[PERIODO_LETIVO],
	SSTATUS.DESCRICAO STATUS,
	SMODALIDADECURSO.DESCRICAO	MODALIDADE,
	SMATRICPL.RA	MATRICULA,
	SCURSO.NOME		CURSO

FROM
	SMATRICPL
	INNER JOIN SPLETIVO ON
			SPLETIVO.IDPERLET = SMATRICPL.IDPERLET
	INNER JOIN SSTATUS ON
			SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS
	INNER JOIN SHABILITACAOFILIAL ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMODALIDADECURSO ON
			SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO

WHERE 
	SPLETIVO.CODPERLET IN ('2020.1', '2020.2')
	AND SMATRICPL.CODSTATUS IN (5, 12, 101, 111)
	AND SMODALIDADECURSO.DESCRICAO = 'EAD'