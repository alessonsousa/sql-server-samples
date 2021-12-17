SELECT DISTINCT

	SALUNO.RA AS 'RA',
	DBO.INITCAP(PPESSOA.NOME) AS 'ALUNO',
	PPESSOA.TELEFONE2

FROM SPLETIVO (NOLOCK)
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA
		AND SMATRICPL.CODFILIAL = SPLETIVO.CODFILIAL
		AND SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SMATRICULA (NOLOCK) ON
			SMATRICULA.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SMATRICULA.RA  = SMATRICPL.RA
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SHISTHABILITACAOALUNO (NOLOCK) ON
			SHISTHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHISTHABILITACAOALUNO.RA = SMATRICPL.RA
		AND SHISTHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
		AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
		AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
	INNER JOIN SSTATUS STATUSPL (NOLOCK) ON
			STATUSPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND STATUSPL.CODSTATUS = SMATRICPL.CODSTATUS
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA

WHERE SMATRICPL.CODCOLIGADA = 1
AND SMATRICPL.CODSTATUS IN (110)
AND SPLETIVO.CODPERLET IN ('2021.2')
AND SMODALIDADECURSO.DESCRICAO NOT IN ('EAD','SEMIPRESENCIAL')
AND SMATRICPL.CODFILIAL NOT IN (2,4)
AND SHISTHABILITACAOALUNO.CODSTATUS = 19
AND SHISTHABILITACAOALUNO.QTDPENDDISCOBR > 0
