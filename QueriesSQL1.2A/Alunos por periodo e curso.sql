SELECT DISTINCT 

SMATRICPL.RA        AS 'Matricula',
upper(PPESSOA.NOME) AS 'Nome',
SCURSO.NOME         AS 'Curso',
SPLETIVO.CODPERLET  AS 'Periodo letivo',
SDISCIPLINA.NOME    AS 'Disciplinas',
SSTATUS.DESCRICAO AS 'Status_Disciplinas'
FROM

SPLETIVO
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SMATRICULA (NOLOCK) ON
			SMATRICULA.RA = SMATRICPL.RA
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
	INNER JOIN STURMADISC (NOLOCK) ON
			 STURMADISC.IDTURMADISC = SMATRICULA.IDTURMADISC
	INNER JOIN SDISCIPLINA (NOLOCK) ON 
			 SDISCIPLINA.CODDISC = STURMADISC.CODDISC
    INNER JOIN SSTATUS  (NOLOCK) ON
	        SSTATUS.CODSTATUS = SMATRICULA.CODSTATUS


WHERE
SSTATUS.DESCRICAO = 'Cursando'
AND SPLETIVO.CODPERLET IN ('2021.2');

