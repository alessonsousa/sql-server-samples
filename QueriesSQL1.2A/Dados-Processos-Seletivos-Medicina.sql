-- SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SPSAREAOFERTADA';

SELECT DISTINCT
	SPSPROCESSOSELETIVO.NOME AS 'PROCESSO SELETIVO',
	SPSUSUARIO.NOME AS 'NOME DO CANDITADO',
	SPSUSUARIO.EMAIL AS 'EMAIL DO CANDITADO',
	SPSUSUARIO.TELEFONE2 AS 'TELEFONE',
	SPSAREAINTERESSE.NOME AS 'CURSO',

	CASE
	WHEN SPSINSCRICAOAREAOFERTADA.STATUS = 1 THEN 'PAGO'
	WHEN SPSINSCRICAOAREAOFERTADA.STATUS = 0 THEN 'PENDENTE DE PAGAMENTO'
	ELSE 'INSCRI��O CANCELADA'
END AS 'SITUA��O DE INSCRI��O'

FROM SPSINSCRICAOAREAOFERTADA
	INNER JOIN SPSUSUARIO (NOLOCK) ON	
		SPSINSCRICAOAREAOFERTADA.CODUSUARIOPS = SPSUSUARIO.CODUSUARIOPS
	INNER JOIN SPSAREAOFERTADA (NOLOCK) ON	
		SPSAREAOFERTADA.IDPS = SPSINSCRICAOAREAOFERTADA.IDPS
	INNER JOIN SPSOPCAOINSCRITO (NOLOCK) ON	
		SPSOPCAOINSCRITO.IDPS = SPSAREAOFERTADA.IDPS
	INNER JOIN SPSPROCESSOSELETIVO (NOLOCK) ON	
		SPSAREAOFERTADA.IDPS = SPSPROCESSOSELETIVO.IDPS
	INNER JOIN SPSAREAINTERESSE ON
		SPSAREAINTERESSE.IDAREAINTERESSE = SPSAREAOFERTADA.IDAREAINTERESSE

WHERE	
--ENEM - 225 / Tradicional - 229
SPSINSCRICAOAREAOFERTADA.IDPS IN (225, 229)
	--UNIFAP - 1 / FAP FORTALEZA - 2 / FAP ARARIPINA - 4
	AND SPSINSCRICAOAREAOFERTADA.IDCAMPUS = 4
	-- C�DIGO: INSCRI��O PAGO - 1 / INSCRI��O A PAGAR - 0 / INSCRI��O CANCELADA - 8
	AND SPSINSCRICAOAREAOFERTADA.STATUS IN (0, 1)

