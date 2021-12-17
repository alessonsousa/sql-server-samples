SELECT 
	DISTINCT 
	SHABILITACAOALUNO.RA AS 'RA', 
	PPESSOA.NOME AS 'NOME DO ALUNO', 
	SSTATUS.DESCRICAO AS 'SITUA��O DE MATRICULA',
	STIPOINGRESSO.DESCRICAO AS ' FORMA DE INGRESSO',
	SPSPROCESSOSELETIVO.NOME AS 'PROCESSO SELETIVO',
	CONVERT(VARCHAR(12), SMATRICPL.DTMATRICULA, 103) AS 'DATA MATRICULA'
FROM SHABILITACAOALUNO (NOLOCK)

	FULL OUTER JOIN STIPOINGRESSO (NOLOCK) ON
			STIPOINGRESSO.CODTIPOINGRESSO = SHABILITACAOALUNO.CODTIPOINGRESSO

	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.RA = SHABILITACAOALUNO.RA

	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA

	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.RA = SHABILITACAOALUNO.RA
		AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL

	FULL OUTER JOIN SPSPROCESSOSELETIVO (NOLOCK) ON
			SPSPROCESSOSELETIVO.IDPS = SMATRICPL.IDPS

	INNER JOIN SSTATUS (NOLOCK) ON
			SSTATUS.CODSTATUS = SHABILITACAOALUNO.CODSTATUS

	INNER JOIN SPLETIVO (NOLOCK) ON
			SPLETIVO.IDPERLET = SMATRICPL.IDPERLET

WHERE YEAR(DTINGRESSO) >= 2021
	AND MONTH(DTINGRESSO) >= 08
	AND SHABILITACAOALUNO.CODTIPOINGRESSO <> 36
	AND SPLETIVO.CODPERLET = '2021.2'
ORDER BY PPESSOA.NOME