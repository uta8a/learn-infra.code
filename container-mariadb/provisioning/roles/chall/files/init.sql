CREATE DATABASE IF NOT EXISTS chall;

CREATE TABLE IF NOT EXISTS chall.container_mariadb(
  `ID` INT(20) UNSIGNED NOT NULL AUTO_INCREMENT primary key,
  `First_Name` VARCHAR(20) NOT NULL,
  `Last_Name` VARCHAR(20) NOT NULL,
  `Age` INT NOT NULL,
  `Sex` VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO chall.container_mariadb (First_Name, Last_Name, Age, Sex) VALUES ("Tarou", "Yamada", 23, "MAN");
INSERT INTO chall.container_mariadb (First_Name, Last_Name, Age, Sex) VALUES ("Emi", "Uchiyama", 23, "WOMAN");
INSERT INTO chall.container_mariadb (First_Name, Last_Name, Age, Sex) VALUES ("Ryo", "Sato", 25, "MAN");
INSERT INTO chall.container_mariadb (First_Name, Last_Name, Age, Sex) VALUES ("Yuki", "Tayama", 22, "WOMAN");
INSERT INTO chall.container_mariadb (First_Name, Last_Name, Age, Sex) VALUES ("Yuto", "Takahashi", 21, "MAN");
