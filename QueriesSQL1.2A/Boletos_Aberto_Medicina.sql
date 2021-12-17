-- SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SPSAREAOFERTADA';

SELECT
    FLAN.IDLAN,
    FBOLETO.IDBOLETO,
    FBOLETO.IPTE,
    FBOLETO.NOSSONUMERO


FROM
    SPSINSCRICAOAREAOFERTADA
    INNER JOIN SPSUSUARIO ON
			SPSUSUARIO.CODUSUARIOPS = SPSINSCRICAOAREAOFERTADA.CODUSUARIOPS
    INNER JOIN FLAN ON 
			FLAN.IDLAN = SPSINSCRICAOAREAOFERTADA.IDLAN
    INNER JOIN FLANBOLETO ON
			FLANBOLETO.IDLAN = FLAN.IDLAN
    INNER JOIN FBOLETO ON
			FBOLETO.IDBOLETO = FLANBOLETO.IDBOLETO

WHERE
	FBOLETO.STATUS = 0
    AND SPSINSCRICAOAREAOFERTADA.IDPS IN (225, 229)


/*
FBOLETO.IPTE
FBOLETO.IDBOLETO
FBOLETO.NOSSONUMERO
FBOLETO.STATUS = 0 (Em Aberto)
FLAN.IDLAN
SPSINSCRICAOAREAOFERTADA.IDLAN
SPSINSCRICAOAREAOFERTADA.IDPS
*/