/*
Disciplinas:
	- 'Contabilidade B�sica'
	- 'Projeto de Forma��o e Carreira: Conhecimento, Habilidades e Atitudes'
	- 'Economia, Pol�tica econ�mica brasileira e regionalidade'
	- 'Gest�o de produtos, servi�os e terceiriza��o'
	- 'Projeto Integrador: Desenvolvimento de produtos/servi�os e Branding'
*/

SELECT
	SMATRICULA.RA						[MATRICULA],
	PPESSOA.NOME						[ALUNO],
	CONVERT(VARCHAR, SMATRICPL.DTMATRICULA, 103)				[DTMATRICULA],
	SCURSO.NOME							[CURSO],
	SDISCIPLINA.NOME					[DISCIPLINA],
	SSTATUS.DESCRICAO					[STATUS],
	SETAPAS.DESCRICAO					[ETAPA],
	SNOTAETAPA.NOTAFALTA				[NOTA]

FROM SMATRICULA
	INNER JOIN SMATRICPL ON
			SMATRICPL.RA = SMATRICULA.RA
		AND SMATRICPL.IDPERLET = SMATRICULA.IDPERLET
	INNER JOIN SNOTAETAPA ON
			SNOTAETAPA.IDTURMADISC = SMATRICULA.IDTURMADISC
		AND SNOTAETAPA.RA = SMATRICULA.RA
	INNER JOIN STURMADISC ON
			STURMADISC.IDTURMADISC = SMATRICULA.IDTURMADISC
	INNER JOIN SDISCIPLINA ON
			SDISCIPLINA.CODDISC = STURMADISC.CODDISC
	INNER JOIN SSTATUS ON
			SSTATUS.CODSTATUS = SMATRICULA.CODSTATUSRES
	INNER JOIN SETAPAS ON
			SETAPAS.IDTURMADISC = SMATRICULA.IDTURMADISC
		AND SETAPAS.CODETAPA = SNOTAETAPA.CODETAPA
		AND SETAPAS.TIPOETAPA = 'N'
	INNER JOIN SHABILITACAOFILIAL ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMODALIDADECURSO ON
			SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
	INNER JOIN SALUNO ON
			SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
WHERE
		SNOTAETAPA.TIPOETAPA = 'N'
	AND SMATRICULA.IDPERLET = 167
	AND SDISCIPLINA.NOME IN (
			'Contabilidade B�sica',
			'Projeto de Forma��o e Carreira: Conhecimento, Habilidades e Atitudes',
			'Economia, Pol�tica econ�mica brasileira e regionalidade',
			'Gest�o de produtos, servi�os e terceiriza��o',
			'Projeto Integrador: Desenvolvimento de produtos/servi�os e Branding')
	AND SMATRICPL.CODSTATUS IN (12, 101, 111)
	AND SMODALIDADECURSO.CODMODALIDADECURSO IN (2, 3)

ORDER BY PPESSOA.NOME