CREATE TABLE `Voluntario`(
    `idVoluntario` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `telefone` VARCHAR(20) NULL,
    `funcao` VARCHAR(50) NOT NULL
);
CREATE TABLE `Canteiro`(
    `idCanteiro` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `localizacao` VARCHAR(100) NULL
);
CREATE TABLE `Planta`(
    `idPlanta` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `tipo` VARCHAR(50) NULL
);
CREATE TABLE `Cultivo`(
    `idCultivo` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `idVoluntario` INT NOT NULL,
    `idCanteiro` INT NOT NULL,
    `idPlanta` INT NOT NULL,
    `dataPlantio` DATE NULL
);
CREATE TABLE `Colheita`(
    `idColheita` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `idCultivo` INT NOT NULL,
    `dataColheita` DATE NULL,
    `quantidade` DECIMAL(10, 2) NULL
);
CREATE TABLE `Doacao`(
    `idDoacao` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `dataDoacao` DATE NULL,
    `responsavel` VARCHAR(100) NULL
);
CREATE TABLE `Instituicao`(
    `idInstituicao` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `endereco` VARCHAR(150) NULL
);
CREATE TABLE `Colheita_Doacao`(
    `idColheita` INT NOT NULL,
    `idDoacao` INT NOT NULL,
    PRIMARY KEY(`idColheita`)
);
ALTER TABLE
    `Colheita_Doacao` ADD PRIMARY KEY(`idDoacao`);
CREATE TABLE `Doacao_Instituicao`(
    `idDoacao` INT NOT NULL,
    `idInstituicao` INT NOT NULL,
    PRIMARY KEY(`idDoacao`)
);
ALTER TABLE
    `Doacao_Instituicao` ADD PRIMARY KEY(`idInstituicao`);
ALTER TABLE
    `Colheita` ADD CONSTRAINT `colheita_idcultivo_foreign` FOREIGN KEY(`idCultivo`) REFERENCES `Cultivo`(`idCultivo`);
ALTER TABLE
    `Cultivo` ADD CONSTRAINT `cultivo_idvoluntario_foreign` FOREIGN KEY(`idVoluntario`) REFERENCES `Voluntario`(`idVoluntario`);
ALTER TABLE
    `Colheita` ADD CONSTRAINT `colheita_idcolheita_foreign` FOREIGN KEY(`idColheita`) REFERENCES `Colheita_Doacao`(`idColheita`);
ALTER TABLE
    `Doacao` ADD CONSTRAINT `doacao_iddoacao_foreign` FOREIGN KEY(`idDoacao`) REFERENCES `Colheita_Doacao`(`idDoacao`);
ALTER TABLE
    `Cultivo` ADD CONSTRAINT `cultivo_idplanta_foreign` FOREIGN KEY(`idPlanta`) REFERENCES `Planta`(`idPlanta`);
ALTER TABLE
    `Doacao` ADD CONSTRAINT `doacao_iddoacao_foreign` FOREIGN KEY(`idDoacao`) REFERENCES `Doacao_Instituicao`(`idDoacao`);
ALTER TABLE
    `Instituicao` ADD CONSTRAINT `instituicao_idinstituicao_foreign` FOREIGN KEY(`idInstituicao`) REFERENCES `Doacao_Instituicao`(`idInstituicao`);
ALTER TABLE
    `Cultivo` ADD CONSTRAINT `cultivo_idcanteiro_foreign` FOREIGN KEY(`idCanteiro`) REFERENCES `Canteiro`(`idCanteiro`);