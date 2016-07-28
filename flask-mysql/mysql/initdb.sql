CREATE DATABASE IF NOT EXIST VaultDemo;

CREATE TABLE IF NOT EXIST `VaultDemo`.`todolist` (
      `task_id` BIGINT NOT NULL AUTO_INCREMENT,
      `title` VARCHAR(20) NULL,
      `body` VARCHAR(100) NULL,
      PRIMARY KEY (`task_id`));
