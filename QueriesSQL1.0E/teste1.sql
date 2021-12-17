DECLARE @IDTURMADISC INT = (
SELECT
	IDTURMADISC
FROM 
	SESTAGIOCONTRATO
WHERE
		IDESTAGIOCONTRATO = 10		--:IDESTAGIOCONTRATO1
	AND CODCOLIGADA = 1				--:CODCOLIGADA1
	AND RA = '2019110084'			--:RA1
	)


DECLARE @ESTAGIOOBRIGATORIO VARCHAR(5) = (
SELECT
	ESTAGIOOBRIGATORIO
FROM 
	SESTAGIOCONTRATO
WHERE
		IDESTAGIOCONTRATO = 10		--:IDESTAGIOCONTRATO1
	AND CODCOLIGADA = 1				--:CODCOLIGADA1
	AND RA = '2019110084'			--:RA1
	)


DECLARE @CATEGORIA INT = (
SELECT
	CATEGORIA
FROM 
	SESTAGIOCONTRATO
	INNER JOIN SEMPRESA ON
			SEMPRESA.IDEMPRESA = SESTAGIOCONTRATO.IDEMPRESA
WHERE
		IDESTAGIOCONTRATO = 10		--:IDESTAGIOCONTRATO1
	AND CODCOLIGADA = 1				--:CODCOLIGADA1
	AND RA = '2019110084'			--:RA1
	)			


SELECT
	*
INTO 
	#CONSULTA1
FROM (
	SELECT
		-- DADOS Q VOU PRECISAR
		*
	FROM (
		-- Dados da Empresa
		SELECT
			SEMPRESA.NOME				[NOME_EMPRESA],				
			SEMPRESA.NOMEFANTASIA		[NOMEFANTASIA_EMPRESA],		
			FUNCIONARIOS.CARTIDENTIDADE,
			FUNCIONARIOS.UFCARTIDENT,
			SEMPRESA.CEP				[CEP_EMPRESA],
			SEMPRESA.RUA				[RUA_EMPRESA],	
			SEMPRESA.NUMERO				[NUMERO_EMPRESA],
			SEMPRESA.BAIRRO				[BAIRRO_EMPRESA],
			GMUNICIPIO.NOMEMUNICIPIO	[MUNICIPIO_EMPRESA],
			GMUNICIPIO.CODETDMUNICIPIO	[ESTADO_EMPRESA],
			SEMPRESA.CNPJ,
			SUPERVISOR.NOME				[SUPERVISOR],
			FUNCIONARIOS.NOME			[RESPONSAVEL],
			SUPERVISOR.CPF				[CPF_SUPERVISOR],
			SUPERVISOR.TELEFONE			[TEL_SUPERVISOR],
			SUPERVISOR.EMAIL			[EMAIL_SUPERVISOR],
			SUPERVISOR.CARGO			[CARGO_SUPERVISOR]
		FROM
			SESTAGIOCONTRATO (NOLOCK) 
		INNER JOIN SPLETIVO (NOLOCK) ON
				SPLETIVO.IDPERLET = SESTAGIOCONTRATO.IDPERLET
		INNER JOIN SMATRICPL (NOLOCK) ON
				SMATRICPL.RA = SESTAGIOCONTRATO.RA
			AND SMATRICPL.CODCOLIGADA = SESTAGIOCONTRATO.CODCOLIGADA
			AND SMATRICPL.IDHABILITACAOFILIAL = SESTAGIOCONTRATO.IDHABILITACAOFILIAL
		INNER JOIN SEMPRESA (NOLOCK) ON
				SEMPRESA.IDEMPRESA = SESTAGIOCONTRATO.IDEMPRESA
		INNER JOIN SEMPRESAFUNCIONARIO SUPERVISOR (NOLOCK) ON
				SUPERVISOR.IDFUNCIONARIO = SESTAGIOCONTRATO.IDFUNCIONARIO
		LEFT JOIN SEMPRESAFUNCIONARIO FUNCIONARIOS (NOLOCK) ON
				FUNCIONARIOS.IDEMPRESA = SUPERVISOR.IDEMPRESA
			AND FUNCIONARIOS.FUNCAO IN (3, 4)
		INNER JOIN GMUNICIPIO (NOLOCK) ON
				GMUNICIPIO.CODMUNICIPIO = SEMPRESA.CODMUNICIPIO
		) AS DADOS_EMPRESA

		INNER JOIN (
		-- Dados do Estágio
		SELECT 
		PPESSOA.NOME																											[ORIENTADOR],
		CONVERT(INT, SESTAGIOCONTRATO.CHSEMANAL)																				[CHSEMANAL],
		SESTAGIOCONTRATO.HRINICIALEXPEDIENTE 																					[HRINICIO],
		SESTAGIOCONTRATO.HRFINALEXPEDIENTE																						[HRFIM],
		CONVERT(VARCHAR(12), SESTAGIOCONTRATO.DTINICIOESTAGIO, 103)																[DTINICIOESTAGIO],
		CONVERT(VARCHAR(12), SESTAGIOCONTRATO.DTFINALESTAGIO, 103)																[DTFINALESTAGIO],
		DATEDIFF(HOUR, CAST(SESTAGIOCONTRATO.HRINICIALEXPEDIENTE AS TIME), CAST(SESTAGIOCONTRATO.HRFINALEXPEDIENTE AS TIME)) AS [CHDIARIO],
		SESTAGIOCONTRATO.OBJETIVO																								[OBJETIVO],
		SESTAGIOCONTRATO.VLRBOLSA																								[VLRBOLSA],
		SESTAGIOCONTRATO.VLRBENEFICIOS																							[VLRBENEFICIOS],
		SESTAGIOAPOLICE.NOMECIASEGUROS																							[NOMECIASEGUROS],
		SESTAGIOAPOLICE.NRAPOLICE																								[NRAPOLICE]

		FROM
			SESTAGIOCONTRATO (NOLOCK)
			INNER JOIN SPLETIVO (NOLOCK) ON
					SPLETIVO.IDPERLET = SESTAGIOCONTRATO.IDPERLET
			LEFT JOIN SPROFESSOR (NOLOCK) ON
					SPROFESSOR.CODPROF = SESTAGIOCONTRATO.CODPROFORIENTADOR
			LEFT JOIN PPESSOA (NOLOCK) ON
					PPESSOA.CODIGO = 
					CASE 
						WHEN SPROFESSOR.CODPESSOA IS NULL THEN SESTAGIOCONTRATO.CODPESSOAORIENTADOR
						ELSE SPROFESSOR.CODPESSOA
					END
			LEFT JOIN SESTAGIOAPOLICE (NOLOCK) ON
					SESTAGIOAPOLICE.IDESTAGIOCONTRATO = SESTAGIOCONTRATO.IDESTAGIOCONTRATO
				AND SESTAGIOAPOLICE.RA = SESTAGIOCONTRATO.RA
			) AS DADOS_ESTAGIO ON
					DADOS_ESTAGIO.IDESTAGIOCONTRATO = DADOS_EMPRESA.IDESTAGIOCONTRATO

		INNER JOIN (
		-- Dados do Aluno
		SELECT 
			P_ALUNO.NOME					[ALUNO],
			SCURSO.NOME						[CURSO_ALUNO],
			P_ALUNO.RUA						[RUA_ALUNO],
			P_ALUNO.NUMERO					[NUMERO_ALUNO],
			P_ALUNO.BAIRRO					[BAIRRO_ALUNO],
			P_ALUNO.CIDADE					[MUNICIPIO_ALUNO],
			P_ALUNO.ESTADO					[ESTADO_ALUNO],
			P_ALUNO.TELEFONE2				[TELEFONE_ALUNO],
			P_ALUNO.CPF						[CPF_ALUNO],
			STURNO.NOME 					[TURNO_ALUNO],
			SMATRICPL.PERIODO				[PERIODO_ALUNO]

		FROM 
			SESTAGIOCONTRATO (NOLOCK)
			INNER JOIN SPLETIVO (NOLOCK) ON
					SPLETIVO.IDPERLET = SESTAGIOCONTRATO.IDPERLET
			INNER JOIN SALUNO (NOLOCK) ON
					SALUNO.RA = SESTAGIOCONTRATO.RA
			INNER JOIN PPESSOA P_ORIENTADOR (NOLOCK) ON
					P_ORIENTADOR.CODIGO = SESTAGIOCONTRATO.CODPESSOAORIENTADOR
			INNER JOIN PPESSOA P_ALUNO (NOLOCK) ON
					P_ALUNO.CODIGO = SALUNO.CODPESSOA
			INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
					SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SESTAGIOCONTRATO.IDHABILITACAOFILIAL
			INNER JOIN SCURSO (NOLOCK) ON
					SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
			INNER JOIN SMATRICPL (NOLOCK) ON
					SMATRICPL.IDPERLET = SESTAGIOCONTRATO.IDPERLET
				AND SMATRICPL.IDHABILITACAOFILIAL = SESTAGIOCONTRATO.IDHABILITACAOFILIAL
				AND SMATRICPL.RA = SESTAGIOCONTRATO.RA
			INNER JOIN STURNO (NOLOCK) ON
					STURNO.CODTURNO = SHABILITACAOFILIAL.CODTURNO
			) AS DADOS_ALUNO ON
					DADOS_ALUNO.IDESTAGIOCONTRATO = DADOS_ESTAGIO.IDESTAGIOCONTRATO
	)




--IF ((@IDTURMADISC IS NOT NULL) AND (@ESTAGIOOBRIGATORIO = 'S') AND (@CATEGORIA <> 5))
	SELECT * FROM #CONSULTA1

	DROP TABLE #CONSULTA1

