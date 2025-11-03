-- ===================================================
-- HORTA COMUNITARIA
-- ===================================================

DROP DATABASE IF EXISTS horta_comunitaria;
CREATE DATABASE horta_comunitaria
	DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE horta_comunitaria;

-- ---------------------------------------------------
-- Voluntario
-- ---------------------------------------------------
CREATE TABLE Voluntario (
IdVoluntario INT UNSIGNED NOT NULL AUTO_INCREMENT,
Nome VARCHAR(100) NOT NULL,
Telefone VARCHAR(25),
Funcao VARCHAR(50),
PRIMARY KEY (IdVoluntario)
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Canteiro
-- ---------------------------------------------------
CREATE TABLE Canteiro (
IdCanteiro INT UNSIGNED NOT NULL AUTO_INCREMENT,
Nome VARCHAR(100) NOT NULL,
Localizacao VARCHAR(100),
PRIMARY KEY (IdCanteiro)
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Planta
-- ---------------------------------------------------
CREATE TABLE Planta (
IdPlanta INT UNSIGNED NOT NULL AUTO_INCREMENT,
Nome VARCHAR(100) NOT NULL,
Tipo VARCHAR(50),
PRIMARY KEY (IdPlanta)
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Cultivo
-- ---------------------------------------------------
CREATE TABLE Cultivo (
IdCultivo INT UNSIGNED NOT NULL AUTO_INCREMENT,
IdVoluntario INT UNSIGNED NOT NULL,
IdCanteiro INT UNSIGNED NOT NULL,
IdPlanta INT UNSIGNED NOT NULL,
DataPlantio DATE,
PRIMARY KEY (IdCultivo),
KEY idxcultivo_voluntario (IdVoluntario),
KEY idx_cultivo_canteiro   (IdCanteiro),
KEY idx_cultivo_planta     (IdPlanta),
CONSTRAINT fk_cultivo_voluntario FOREIGN KEY (IdVoluntario)
REFERENCES Voluntario(IdVoluntario)
ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk_cultivo_canteiro FOREIGN KEY (IdCanteiro)
REFERENCES Canteiro(IdCanteiro)
ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk_cultivo_planta FOREIGN KEY (IdPlanta)
REFERENCES Planta(IdPlanta)
ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
    
-- ---------------------------------------------------
-- Colheita
-- ---------------------------------------------------
CREATE TABLE Colheita (
IdColheita   INT UNSIGNED NOT NULL AUTO_INCREMENT,
IdCultivo    INT UNSIGNED NOT NULL,
DataColheita DATE,
Quantidade   DECIMAL(10,2),
PRIMARY KEY (IdColheita),
KEY idx_colheita_cultivo (IdCultivo),
CONSTRAINT fk_colheita_cultivo FOREIGN KEY (IdCultivo)
REFERENCES Cultivo(IdCultivo)
ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Doacao
-- ---------------------------------------------------
CREATE TABLE Doacao (
IdDoacao    INT UNSIGNED NOT NULL AUTO_INCREMENT,
DataDoacao  DATE,
Responsavel VARCHAR(100),
PRIMARY KEY (IdDoacao)
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Instituicao
-- ---------------------------------------------------
CREATE TABLE Instituicao (
IdInstituicao INT UNSIGNED NOT NULL AUTO_INCREMENT,
Nome          VARCHAR(100) NOT NULL,
Endereco      VARCHAR(150),
PRIMARY KEY (IdInstituicao)
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Colheita_Doacao
-- ---------------------------------------------------
CREATE TABLE Colheita_Doacao (
IdColheita INT UNSIGNED NOT NULL,
IdDoacao   INT UNSIGNED NOT NULL,
PRIMARY KEY (IdColheita, IdDoacao),
CONSTRAINT fk_colheitadoacao_colheita FOREIGN KEY (IdColheita)
REFERENCES Colheita(IdColheita)
ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk_colheitadoacao_doacao FOREIGN KEY (IdDoacao)
REFERENCES Doacao(IdDoacao)
ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- Doacao_Instituicao
-- ---------------------------------------------------
CREATE TABLE Doacao_Instituicao (
IdDoacao       INT UNSIGNED NOT NULL,
IdInstituicao  INT UNSIGNED NOT NULL,
PRIMARY KEY (IdDoacao, IdInstituicao),
CONSTRAINT fk_doacaoinstituicao_doacao FOREIGN KEY (IdDoacao)
REFERENCES Doacao(IdDoacao)
ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk_doacaoinstituicao_instituicao FOREIGN KEY (IdInstituicao)
REFERENCES Instituicao(IdInstituicao)
ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------
-- DADOS DE EXEMPLO
-- ---------------------------------------------------
INSERT INTO Voluntario (Nome, Telefone, Funcao) VALUES
('João Silva', '9999-1111', 'Coordenadora'),
('Maria Santos', '9888-2222', 'Responsável pelo plantio'),
('Pedro Lima', '9777-3333', 'Ajudante de colheita');

INSERT INTO Canteiro (Nome, Localizacao) VALUES
('Canteiro 1', 'Setor A'),
('Canteiro 2', 'Setor B');

INSERT INTO Planta (Nome, Tipo) VALUES
('Alface', 'Verdura'),
('Tomate', 'Fruta'),
('Cenoura', 'Raiz');

INSERT INTO Cultivo (IdVoluntario, IdCanteiro, IdPlanta, DataPlantio) VALUES
(1, 1, 1, '2025-08-10'),
(2, 2, 2, '2025-09-01'),
(3, 1, 3, '2025-09-15');

INSERT INTO Colheita (IdCultivo, DataColheita, Quantidade) VALUES 
(1, '2025-09-20', 10.5),
(2, '2025-10-05', 15.0),
(3, '2025-10-10', 12.3);

INSERT INTO Doacao (DataDoacao, Responsavel) VALUES
('2025-09-19', 'Raquel Guerra'),
('2025-10-21', 'João Silva'),
('2025-10-22', 'Maria Santos');

INSERT INTO Instituicao (Nome, Endereco) VALUES
('Lar Esperança', 'Rua das Flores, 123'),
('Casa do Pão', 'Av. Central, 456'),
('Alimentando Necessidades', 'Vale do Itajai, 789');

INSERT INTO Colheita_Doacao (IdColheita, IdDoacao) VALUES
(1, 1),
(2, 1),
(3, 2);

INSERT INTO Doacao_Instituicao (IdDoacao, IdInstituicao) VALUES
(1, 1),
(1, 2),
(2, 3);

-- ---------------------------------------------------
-- Liste todos os voluntários cadastrados e suas respectivas funções
-- ---------------------------------------------------
SELECT 
Nome AS NomeVoluntario,
Funcao AS FuncaoVoluntario
FROM Voluntario;

-- ---------------------------------------------------
-- Mostre as plantas cultivadas em cada canteiro, com o nome do canteiro e a data do plantio
-- ---------------------------------------------------
SELECT 
p.Nome AS Planta,
c.Nome AS Canteiro,
cu.DataPlantio
FROM Cultivo cu
JOIN Planta p ON cu.IdPlanta = p.IdPlanta
JOIN Canteiro c ON cu.IdCanteiro = c.IdCanteiro;

-- ---------------------------------------------------
-- Exiba os nomes dos voluntários e as plantas que eles cultivaram
-- ---------------------------------------------------
SELECT 
v.Nome AS Voluntario,
p.Nome AS PlantaCultivada
FROM Cultivo cu
JOIN Voluntario v ON cu.IdVoluntario = v.IdVoluntario
JOIN Planta p ON cu.IdPlanta = p.IdPlanta;

-- ---------------------------------------------------
-- Liste todas as colheitas realizadas, mostrando o canteiro e a quantidade colhida (em kg)
-- ---------------------------------------------------
SELECT 
co.IdColheita,
ca.Nome AS Canteiro,
co.Quantidade AS QuantidadeKg,
co.DataColheita
FROM Colheita co
JOIN Cultivo cu ON co.IdCultivo = cu.IdCultivo
JOIN Canteiro ca ON cu.IdCanteiro = ca.IdCanteiro;

-- ---------------------------------------------------
-- Mostre as instituições que receberam doações e as quantidades doadas
-- ---------------------------------------------------
SELECT 
i.Nome AS Instituicao,
SUM(co.Quantidade) AS TotalDoadoKg
FROM Doacao_Instituicao di
JOIN Instituicao i ON di.IdInstituicao = i.IdInstituicao
JOIN Doacao d ON di.IdDoacao = d.IdDoacao
JOIN Colheita_Doacao cd ON d.IdDoacao = cd.IdDoacao
JOIN Colheita co ON cd.IdColheita = co.IdColheita
GROUP BY i.Nome;

-- ---------------------------------------------------
-- Liste o total de quilos doados por instituição (use GROUP BY)
-- ---------------------------------------------------
SELECT 
i.Nome AS Instituicao,
SUM(co.Quantidade) AS TotalKgDoado
FROM Instituicao i
JOIN Doacao_Instituicao di ON i.IdInstituicao = di.IdInstituicao
JOIN Doacao d ON di.IdDoacao = d.IdDoacao
JOIN Colheita_Doacao cd ON d.IdDoacao = cd.IdDoacao
JOIN Colheita co ON cd.IdColheita = co.IdColheita
GROUP BY i.Nome;

-- ---------------------------------------------------
-- Mostre os canteiros que ainda não tiveram colheitas (use LEFT JOIN)
-- ---------------------------------------------------
SELECT  
c.Nome AS CanteiroSemColheita
FROM Canteiro c
LEFT JOIN Cultivo cu ON c.IdCanteiro = cu.IdCanteiro
LEFT JOIN Colheita co ON cu.IdCultivo = co.IdCultivo
WHERE co.IdColheita IS NULL;

-- ---------------------------------------------------
-- Exiba o voluntário que realizou o maior número de cultivos (use COUNT e ORDER BY)
-- ---------------------------------------------------
SELECT 
v.Nome AS Voluntario,
COUNT(cu.IdCultivo) AS TotalCultivos
FROM Voluntario v
JOIN Cultivo cu ON v.IdVoluntario = cu.IdVoluntario
GROUP BY v.Nome
ORDER BY TotalCultivos DESC
LIMIT 1;

-- ---------------------------------------------------
-- Mostre as plantas que ainda não foram colhidas (utilizando subconsulta ou LEFT JOIN)
-- ---------------------------------------------------
SELECT 
p.Nome AS PlantaNaoColhida
FROM Planta p
JOIN Cultivo cu ON p.IdPlanta = cu.IdPlanta
LEFT JOIN Colheita co ON cu.IdCultivo = co.IdCultivo
WHERE co.IdColheita IS NULL;

-- ---------------------------------------------------
-- Liste todas as doações realizadas em setembro de 2025, com o nome da instituição e a data da doação
-- ---------------------------------------------------
SELECT 
i.Nome AS Instituicao,
d.DataDoacao
FROM Doacao d
JOIN Doacao_Instituicao di ON d.IdDoacao = di.IdDoacao
JOIN Instituicao i ON di.IdInstituicao = i.IdInstituicao
WHERE MONTH(d.DataDoacao) = 9 AND YEAR(d.DataDoacao) = 2025;