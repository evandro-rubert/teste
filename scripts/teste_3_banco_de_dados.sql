-- tabela para carregar os dados das demonstrações contábeis
CREATE TABLE if not EXISTS dem_con (
    DATA VARCHAR(255),
    REG_ANS VARCHAR(255),
    CD_CONTA_CONTABIL VARCHAR(255),
    DESCRICAO VARCHAR(255),
    VL_SALDO_INICIAL VARCHAR(255),
    VL_SALDO_FINAL VARCHAR(255)
);

-- tabela para os dados de cadastro
CREATE TABLE IF NOT EXISTS dados_cad (
    Registro_ANS VARCHAR(255),
    CNPJ VARCHAR(255),
    Razao_Social VARCHAR(255),
    Nome_Fantasia VARCHAR(255),
    Modalidade VARCHAR(255),
    Logradouro VARCHAR(255),
    Numero VARCHAR(255),
    Complemento VARCHAR(255),
    Bairro VARCHAR(255),
    Cidade VARCHAR(255),
    UF VARCHAR(255),
    CEP VARCHAR(255),
    DDD VARCHAR(255),
    Telefone VARCHAR(255),
    Fax VARCHAR(255),
    Email VARCHAR(255),
    Representante VARCHAR(255),
    Cargo_Representante VARCHAR(255),
    Data_Registro_ANS DATE
);

-- 10 operadoras com maiores despesas em "EVENTOS/SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE" 
-- no último trimestre
SELECT dados_cad.Registro_ANS, dados_cad.Razao_Social AS Operadora, 
       SUM(dem_con.VL_SALDO_FINAL - dem_con.VL_SALDO_INICIAL) AS Despesas_Ultimo_Trimestre
FROM dem_con
JOIN dados_cad ON dem_con.REG_ANS = dados_cad.Registro_ANS
WHERE dem_con.DESCRICAO = 'EVENTOS/SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE' 
	AND dem_con.DATA = '2023-07-01'
GROUP BY dados_cad.Registro_ANS, dados_cad.Razao_Social
ORDER BY Despesas_Ultimo_Trimestre DESC
LIMIT 10;


-- 10 operadoras com maiores despesas em "EVENTOS/SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE" 
-- no último ano
SELECT dados_cad.Registro_ANS, dados_cad.Razao_Social AS Operadora, 
       SUM(dem_con.VL_SALDO_FINAL - dem_con.VL_SALDO_INICIAL) AS Despesas_Ultimo_Ano
FROM dem_con
JOIN dados_cad ON dem_con.REG_ANS = dados_cad.Registro_ANS
WHERE dem_con.DESCRICAO = 'EVENTOS/SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE' 
    AND dem_con.DATA >= '2023-01-01'
    AND dem_con.DATA <= '2023-07-01'
GROUP BY dados_cad.Registro_ANS, dados_cad.Razao_Social
ORDER BY Despesas_Ultimo_Ano DESC
LIMIT 10;



-- Tentei carregar os dados assim, mas nao funcionou no meu computador
-- tive varios erros e parece que era algo relacionado a permissao para acessar
-- a pasta e carregar as tabelas.
-- Por isso decidi carregar os dados e enviá-los para MySQL através do Python
LOAD DATA INFILE 'C:/Users/evandro/Documents/projetos/data/1T2022.csv'
INTO TABLE DemonstracoesContabeis
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

select @@secure_file_priv;