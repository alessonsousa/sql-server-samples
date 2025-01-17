/*
Dados da Empresa:
	- Nome, Endere�o, CNPJ, Respons�vel Legal (SEMPRESA)

Dados do Aluno:
	- Nome
		SALUNO(CODPESSOA) -> PPESSOA(CODIGO) - PPESSOA(NOME)
	- Curso
		SMATRICPL(IDHABILITACAOFILIAL) -> SHABILITACAOFILIAL(CODCURSO) -> SCURSO(NOME)
	- Endere�o, Telefone
		PPESSOA

Dados do Orientador:
	- Nome
		SESTAGIOCONTRATO(CODPESSOAORIENTADOR) -> PPESSOA(NOME)

Dados do Est�gio:
	- Carga hor�ria Semanal
		SESTAGIOCONTRATO(CHSEMANAL)
	- Hora Inicial
		SESTAGIOCONTRATO(HRINICIALEXPEDIENTE)
	- Hora Final 
		SESTAGIOCONTRATO(HRFINALEXPEDIENTE)
	- Nome do Supervisor
		SESTAGIOCONTRATO(IDFUNCIONARIO) -> SEMPRESAFUNCIONARIO(NOME)
	- Atividades a serem realizadas
		SESTAGIOCONTRATO(OBJETIVO)
	- Datas de Inicio e Fim do est�gio
		SESTAGIOCONTRATO(DTINICIOESTAGIO) e SESTAGIOCONTRATO(DTFINALESTAGIO)

Tabelas Necess�rias
SEMPRESA, SALUNO, PPESSOA, SMATRICPL, SHABILITACAOFILIAL, SCURSO, SESTAGIOCONTRATO, SEMPRESAFUNCIONARIO
*/

SELECT
	-- Dados da Empresa
	SEMPRESA.NOME,
	SEMPRESA.NOMEFANTASIA,
	SEMPRESA.RUA,
	SEMPRESA.NUMERO,
	SEMPRESA.COMPLEMENTO,
	SEMPRESA.BAIRRO,
	GMUNICIPIO.NOMEMUNICIPIO	[MUNICIPIO],
	GMUNICIPIO.CODETDMUNICIPIO	[ESTADO],
	SEMPRESA.CNPJ,
	SEMPRESAFUNCIONARIO.NOME	[SUPERVISOR],
	RESPONSAVEL.NOME			[RESPONSAVEL],
	-- Dados do Aluno
	P_ALUNO.NOME				[ALUNO],
	SCURSO.NOME					[CURSO],
	P_ALUNO.RUA,
	P_ALUNO.NUMERO,
	P_ALUNO.COMPLEMENTO,
	P_ALUNO.BAIRRO



FROM
	SESTAGIOCONTRATO
	INNER JOIN SEMPRESA ON
			SEMPRESA.IDEMPRESA = SESTAGIOCONTRATO.IDEMPRESA
	INNER JOIN SEMPRESAFUNCIONARIO ON
			SEMPRESAFUNCIONARIO.IDFUNCIONARIO = SESTAGIOCONTRATO.IDFUNCIONARIO
	LEFT JOIN SEMPRESAFUNCIONARIO RESPONSAVEL ON
			RESPONSAVEL.IDEMPRESA = SEMPRESAFUNCIONARIO.IDEMPRESA
		AND RESPONSAVEL.FUNCAO = 3
	INNER JOIN SALUNO ON
			SALUNO.RA = SESTAGIOCONTRATO.RA
	INNER JOIN PPESSOA P_ORIENTADOR ON
			P_ORIENTADOR.CODIGO = SESTAGIOCONTRATO.CODPESSOAORIENTADOR
	INNER JOIN PPESSOA P_ALUNO ON
			P_ALUNO.CODIGO = SALUNO.CODPESSOA
	INNER JOIN SHABILITACAOFILIAL ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SESTAGIOCONTRATO.IDHABILITACAOFILIAL
	INNER JOIN SCURSO ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN GMUNICIPIO ON
			GMUNICIPIO.CODMUNICIPIO = SEMPRESA.CODMUNICIPIO


			