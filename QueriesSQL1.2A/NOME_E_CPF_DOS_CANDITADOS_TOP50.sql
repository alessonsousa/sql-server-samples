-- SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SPSAREAOFERTADA';

SELECT
    SPSUSUARIO.NOME,
    SPSUSUARIO.CPF

FROM SPSINSCRICAOAREAOFERTADA
    INNER JOIN SPSUSUARIO (NOLOCK) ON	
		SPSUSUARIO.CODUSUARIOPS = SPSINSCRICAOAREAOFERTADA.CODUSUARIOPS
        
WHERE	
	SPSINSCRICAOAREAOFERTADA.IDPS IN (231,232,233)
	