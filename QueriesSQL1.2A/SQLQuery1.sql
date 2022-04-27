
SELECT DISTINCT 
	SALUNO.RA													[MATR�CULA],
	PPESSOA.NOME												[ALUNO],
	CONVERT(VARCHAR(10), DTNASCIMENTO, 103)						[DTNASCIMENTO],
	PPESSOA.EMAIL,
	PPESSOA.TELEFONE1,
	PPESSOA.TELEFONE2,
	SCURSO.NOME													[CURSO],
	SGRADE.DESCRICAO									        [MATRIZ],
	STATUSCURSO.DESCRICAO										[STATUS CURSO],
	(SELECT TOP (1) 
	CONVERT(VARCHAR,DTALTERACAO, 103)							
	FROM SLOGPLETIVO 
	WHERE SLOGPLETIVO.RA = LOGPL.RA AND SLOGPLETIVO.CODSTATUS IS NOT NULL 
	ORDER BY SLOGPLETIVO.DTALTERACAO DESC
	)						[DATA ALTERA��O STATUS CURSO],
	CONVERT(VARCHAR,SHABILITACAOALUNO.DTINGRESSO,103)			[DATA INGRESSO CURSO],
	SPLETIVO.CODPERLET											[PER�ODO LETIVO],
	STATUSPL.DESCRICAO											[STATUS MATRICULA PLETIVO],
	CONVERT(VARCHAR, SMATRICPL.DTMATRICULA,103)					[DATA MATRICULA PLETIVO],
	SDISCIPLINA.NOME											[DISCIPLINA],
	STATUSMATRICULA.DESCRICAO									[STATUS MATRICULA DISCIPLINA],
	CONVERT(VARCHAR, SMATRICULA.DTMATRICULA	,103)				[DATA MATRICULA DISCIPLINA]
	
FROM SALUNO	(NOLOCK)
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.CODCOLIGADA = SALUNO.CODCOLIGADA
		AND SMATRICPL.RA = SALUNO.RA
	INNER JOIN SPLETIVO (NOLOCK) ON
			SPLETIVO.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SPLETIVO.CODFILIAL = SMATRICPL.CODFILIAL
		AND SPLETIVO.IDPERLET = SMATRICPL.IDPERLET
	INNER JOIN SMATRICULA (NOLOCK) ON
			SMATRICULA.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SMATRICULA.IDPERLET = SMATRICPL.IDPERLET
		AND SMATRICULA.RA = SMATRICPL.RA
	INNER JOIN STURMADISC (NOLOCK) ON
			STURMADISC.CODCOLIGADA = SMATRICULA.CODCOLIGADA
		AND STURMADISC.IDTURMADISC = SMATRICULA.IDTURMADISC
		AND STURMADISC.IDPERLET = SMATRICULA.IDPERLET
		AND STURMADISC.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SDISCIPLINA (NOLOCK) ON
			SDISCIPLINA.CODCOLIGADA = STURMADISC.CODCOLIGADA
		AND SDISCIPLINA.CODDISC = STURMADISC.CODDISC
	INNER JOIN SSTATUS STATUSPL (NOLOCK) ON
			STATUSPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND STATUSPL.CODSTATUS = SMATRICPL.CODSTATUS
	INNER JOIN SSTATUS STATUSMATRICULA (NOLOCK) ON
			STATUSMATRICULA.CODCOLIGADA = SMATRICULA.CODCOLIGADA
		AND STATUSMATRICULA.CODSTATUS = SMATRICULA.CODSTATUS
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
		AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
		AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
	INNER JOIN SHABILITACAOALUNO (NOLOCK) ON
			SHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
		AND SHABILITACAOALUNO.RA = SMATRICPL.RA
	INNER JOIN SSTATUS STATUSCURSO (NOLOCK) ON
			STATUSCURSO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
		AND STATUSCURSO.CODSTATUS = SHABILITACAOALUNO.CODSTATUS
	INNER JOIN SLOGPLETIVO LOGPL (NOLOCK) ON
			LOGPL.RA = SALUNO.RA
	INNER JOIN SGRADE (NOLOCK) ON
	        SCURSO.CODAREA = SGRADE.CODCOLIGADA
		AND SCURSO.CODCURSO = SGRADE.CODCOLIGADA

WHERE 
SMODALIDADECURSO.CODMODALIDADECURSO IN (2,3)
AND SALUNO.RA = 2021211148
