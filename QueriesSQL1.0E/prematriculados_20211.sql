SELECT
	SALUNO.RA, 
	UPPER(PPESSOA.NOME) [ALUNO],
	-- SSTATUS.DESCRICAO [STATUS], -- Apenas para validar
	SCURSO.NOME [CURSO],
	STURNO.NOME [TURNO],
	-- SPLETIVO.CODPERLET [PERIODO_LETIVO], -- Apenas para validar
	PPESSOA.TELEFONE2 [CONTATO]

FROM SPLETIVO (NOLOCK)
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA
		AND SMATRICPL.CODFILIAL = SPLETIVO.CODFILIAL
		AND SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SSTATUS (NOLOCK) ON
			SMATRICPL.CODSTATUS = SSTATUS.CODSTATUS
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN STURNO (NOLOCK) ON
			STURNO.CODTURNO=SHABILITACAOFILIAL.CODTURNO
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA

WHERE 
		SPLETIVO.IDPERLET = 167
	AND SSTATUS.CODSTATUS = 110

ORDER BY
	PPESSOA.NOME