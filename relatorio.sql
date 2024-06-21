WITH ultima_entrada AS(

    SELECT DISTINCT
        pc.id_produto,
        pf.codigoexterno
    FROM produtocomplemento pc
    INNER JOIN notaentradaitem nei ON nei.id_produto = pc.id_produto 
    INNER JOIN notaentrada ne ON  ne.id = nei.id_notaentrada AND ne.id_loja = pc.id_loja
    INNER JOIN produtofornecedor pf ON  nei.id_produto = pf.id_produto AND ne.id_fornecedor = pf.id_fornecedor
    WHERE ne.dataentrada = pc.dataultimaentrada AND pc.id_loja = #LOJA:3:loja:::0:true:# AND ne.id_loja = #LOJA:3:loja:::0:true:# --filtro loja
)

SELECT 
    p.descricaocompleta AS "PRODUTO",
    p.id AS "CÓDIGO PRODUTO",
    COALESCE(ue.codigoexterno,'SEM CODIGO EXTERNO') AS "CODIGO EXTERNO",
    CASE
        WHEN pc.id_situacaocadastro = 1 THEN 'ATIVO'
    ELSE
        'EXCLUIDO'
    END AS "SITUAÇÃO CADASTRO",
    CONCAT(p.ncm1, p.ncm2, p.ncm3) as "NCM",
    CONCAT(c.cest1, c.cest2,c.cest3) as "CEST"
FROM 
    produto p
INNER JOIN 
    produtocomplemento pc ON pc.id_produto = p.id
LEFT JOIN 
    cest c on p.id_cest = c.id
LEFT JOIN 
    ultima_entrada ue ON pc.id_produto = ue.id_produto
WHERE 
    pc.id_loja = #LOJA:3:loja:::0:true:# --filtro loja
ORDER BY
    pc.id_situacaocadastro
DESC 
