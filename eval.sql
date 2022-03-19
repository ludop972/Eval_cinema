CREATE DATABASE IF NOT EXISTS theater;

CREATE TABLE user (
    id CHAR(36) PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    date_of_birth DATETIME NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(60) NOT NULL
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE administrator (
    id CHAR(36) PRIMARY KEY NOT NULL,
    user_id CHAR(36) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE roles
(
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE user_roles
(
    user_id CHAR(36) NOT NULL,
    role_id INT(11) NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE customers (
    id CHAR(36) PRIMARY KEY NOT NULL,
    user_id CHAR(36) NOT NULL,
    type_customer VARCHAR(60) NOT NULL,
    price_ticket DECIMAL(4,2),
    FOREIGN KEY (user_id) REFERENCES user(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE cinema (
    id INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    phone INT(11) NOT NULL,
    address VARCHAR(100) NOT NULL,
    zip_code INT(11) NOT NULL,
    city VARCHAR(20) NOT NULL,
    admin_id CHAR(36) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES administrator(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE movie_room (
    id CHAR(36) PRIMARY KEY NOT NULL,
    cinema_id INT(11) NOT NULL,
    number_rooms INT(11) NOT NULL,
    number_places INT(200) NOT NULL,
    FOREIGN KEY (cinema_id) REFERENCES cinema(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE projections (
    id CHAR(36) PRIMARY KEY NOT NULL,
    movie_rooms_id CHAR(36) NOT NULL,
    projection_time DATETIME NOT NULL,
    FOREIGN KEY (movie_rooms_id) REFERENCES movie_room(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE reservation (
    id INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    customer_id CHAR(36) NOT NULL,
    date_reservation DATETIME NOT NULL,
    projection_id CHAR(36) NOT NULL,
    type_payment VARCHAR(20) NOT NULL,
    date_payment DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (projection_id) REFERENCES projections(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE genre (
    id INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;

CREATE TABLE movies (
    id INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    genre_id INT(11) NOT NULL,
    projection_id CHAR(36) NOT NULL,
    name VARCHAR(200) NOT NULL,
    created_by VARCHAR(100),
    FOREIGN KEY (genre_id) REFERENCES genre(id),
    FOREIGN KEY (projection_id) REFERENCES projections(id)
)DEFAULT CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci' ENGINE = InnoDB;


-- CREATION D'UN USER ADMIN --

CREATE USER 'ADMIN'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON theater.* TO 'ADMIN'@'localhost';

-- INSERTION DE DONNEES --

INSERT INTO user (id, firstname, lastname, date_of_birth, email, username, password)
VALUES
       (UUID(),'Bank','Yurukhin','2001-07-11','byurukhin0@reddit.com','byurukhin0','$2y$10$lZf8hLm/PpNTHK29fh3BH.aea38yhCOlpb9Ms.Ae4QEQq4k0Nmgki'),
       (UUID(),'Tim','Cave','1989-02-17','tcave1@lulu.com','tcave1','$2y$10$2WGoKxXf/OwCDscz3LDq5uD8hc5Uptwl5TLFcAPmNGzoWmEv.wU6i'),
       (UUID(),'Devonna','Hammerson','2005-09-12','dhammerson2@youku.com','dhammerson2','$2y$10$fo6gprxE.szxsBN3L3Gvp.VfDwcs4XWUcPFgZRuob1Zs.HDNjqA4C'),
       (UUID(),'Vale','Szapiro','2010-08-22','vszapiro3@homestead.com','vszapiro3','$2y$10$VM99iqF7.NArz2SJw1lku.QfBa/tvMVmHjDiF5Y6PGgPUBkSNQslu'),
       (UUID(),'Quentin','O\'Halloran','1994-08-17','qohalloran4@linkedin.com','qohalloran4','$2y$10$o26ev4n1mlWdR7AMIn/O8.3.ZEAfJbc.WYXcGWca/f2HnkSdho9xG');


-- Insertion de l'admin par un uuid

INSERT INTO administrator (id, user_id)
VALUES
        (UUID(),(SELECT id from user WHERE id = '6dffaa3a-a7ab-11ec-9d62-088fc30fcb64')),
        (UUID(),(SELECT id from user WHERE id = '6dffab45-a7ab-11ec-9d62-088fc30fcb64'));

INSERT INTO roles (name)
VALUES
        ('ADMIN');

INSERT INTO user_roles (user_id, role_id)
VALUES
        ((SELECT id FROM user WHERE id = '6dffaa3a-a7ab-11ec-9d62-088fc30fcb64'),'1');


-- insertion des clients selon leur catégorie
INSERT INTO  customers (id, user_id, type_customer, price_ticket)
VALUES
        (UUID(),(SELECT id FROM user WHERE email = 'byurukhin0@reddit.com'),'plein tarif',9.20),
        (UUID(),(SELECT id FROM user WHERE email = 'dhammerson2@youku.com'),'etudiant',7.60),
        (UUID(),(SELECT id FROM user WHERE email = 'vszapiro3@homestead.com'),'moins de 14 ans',5.90);

INSERT INTO cinema (name, phone, adress, zip_code, city, admin_id)
    VALUES ('Madiana',12774538,'0 Cardinal Court',96925,'Asan-Maina Village', (SELECT id from administrator WHERE id = '3c8c71db-a7b3-11ec-9d62-088fc30fcb64')),
           ('Cine Star',063825422,'15357 Prairieview Way',97600,'Xiyang',(SELECT id from administrator WHERE id = '3c8c748a-a7b3-11ec-9d62-088fc30fcb64'));

INSERT INTO movie_room (id, cinema_id, number_rooms, number_places)
VALUES
        (UUID(),1,14,250),
        (UUID(),2,20,267);

INSERT INTO projections (id, movie_rooms_id, projection_time)
VALUES
        (UUID(),(SELECT id FROM movie_room WHERE id = '8e756189-a7b4-11ec-9d62-088fc30fcb64'),'2022-07-12 22:07:00'),
        (UUID(),(SELECT id FROM movie_room WHERE id = '8e7564f8-a7b4-11ec-9d62-088fc30fcb64'),'2022-08-13 21:30:00');

INSERT INTO reservation (customer_id, date_reservation, projection_id, type_payment, date_payment)
VALUES ((SELECT id FROM customers WHERE id = 'f924caf8-a7af-11ec-9d62-088fc30fcb64'),'2022-01-01 10:01:52',(SELECT id FROM projections WHERE id = 'e267bab9-a7b5-11ec-9d62-088fc30fcb64'),'bank transfer','2022-01-01 10:01:52'),
       ((SELECT id FROM customers WHERE id = 'f924cd77-a7af-11ec-9d62-088fc30fcb64'),'2022-02-03 14:04:02',(SELECT id FROM projections WHERE id = 'e2696b68-a7b5-11ec-9d62-088fc30fcb64'),'credit card','2022-02-03 14:04:02');

INSERT INTO genre (name)
VALUES
        ('Action|Adventure'),
        ('Comedy|Romance'),
        ('Comedy|Drama'),
        ('Drama');

INSERT INTO movies (genre_id, projection_id, name, created_by)
VALUES
        (2,(SELECT id FROM projections WHERE id = 'e267bab9-a7b5-11ec-9d62-088fc30fcb64'),'Le Roi Lion', 'John DOE'),
        (1,(SELECT id FROM projections WHERE id = 'e2696b68-a7b5-11ec-9d62-088fc30fcb64'), 'MATRIX', 'Jean DUPONT');


