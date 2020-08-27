/* Commandes pour supprimer les views*/

DROP VIEW IF EXISTS vExemplaireDisponible;
DROP VIEW IF EXISTS vCheckRessourceReference;
DROP VIEW IF EXISTS vCheckRessourceExemplaire;
DROP VIEW IF EXISTS vEmprunt_actuels;
DROP VIEW IF EXISTS vHistorique;
DROP VIEW IF EXISTS vAdherent_Avoir_Droit_Pret;
DROP VIEW IF EXISTS vNb_Emprunts_Actuels_Par_Personne;
DROP VIEW IF EXISTS vTendances;
DROP VIEW IF EXISTS vSanctionNonAcquitte;
DROP VIEW IF EXISTS vBLACKLIST;

/*Commandes pour supprimer les tables*/

DROP TABLE IF EXISTS Compose;
DROP TABLE IF EXISTS Interprete_musique;
DROP TABLE IF EXISTS Ecrit;
DROP TABLE IF EXISTS Joue;
DROP TABLE IF EXISTS Dirige;

DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Pret;
DROP TABLE IF EXISTS Sanction;
DROP TABLE IF EXISTS livre;
DROP TABLE IF EXISTS musique;
DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS RessourceCategorie;
DROP TABLE IF EXISTS RessourceLangage;
DROP TABLE IF EXISTS Adhesion;

DROP TABLE IF EXISTS Acteur;
DROP TABLE IF EXISTS Auteur;
DROP TABLE IF EXISTS realisateur;
DROP TABLE IF EXISTS interprete;
DROP TABLE IF EXISTS Compositeur;


DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Contributeur;
DROP TABLE IF EXISTS exemplaire;
DROP TABLE IF EXISTS langage;


DROP TABLE IF EXISTS ressource;
DROP TABLE IF EXISTS Adherent;
DROP TABLE IF EXISTS Membre;


CREATE TABLE Contributeur(
    Id VARCHAR PRIMARY KEY,
    Nom VARCHAR NOT NULL,
    Prenom VARCHAR NOT NULL,
    Date_Naissance DATE NOT NULL,
    Nationalite VARCHAR NOT NULL
);


CREATE TABLE Auteur (
    Cle VARCHAR PRIMARY KEY,
    FOREIGN KEY (Cle) REFERENCES Contributeur(Id)
);

CREATE TABLE Acteur (
    Cle VARCHAR PRIMARY KEY,
    FOREIGN KEY (Cle) REFERENCES Contributeur(Id)
);

CREATE TABLE Realisateur (
    Cle VARCHAR PRIMARY KEY,
    FOREIGN KEY (Cle) REFERENCES Contributeur(Id)
);

CREATE TABLE Interprete (
    Cle VARCHAR PRIMARY KEY,
    FOREIGN KEY (Cle) REFERENCES Contributeur(Id)
);

CREATE TABLE Compositeur (
    Cle VARCHAR PRIMARY KEY,
    FOREIGN KEY (Cle) REFERENCES Contributeur(Id)
);


CREATE TABLE Ressource (
    Code VARCHAR PRIMARY KEY,
    Titre VARCHAR NOT NULL,
    Date_Publication DATE NOT NULL,
    Code_Classification VARCHAR NOT NULL,
    Editeur VARCHAR NOT NULL,
    Prix FLOAT NOT NULL
);

CREATE TABLE Livre(
    Code_Livre VARCHAR PRIMARY KEY,
    ISBN VARCHAR UNIQUE NOT NULL,
    Resume VARCHAR NOT NULL,
    FOREIGN KEY (Code_Livre) REFERENCES Ressource(Code)
);

CREATE TABLE Musique(
    Code_Musique VARCHAR PRIMARY KEY,
    Duree INTEGER NOT NULL,
    FOREIGN KEY (Code_Musique) REFERENCES Ressource(Code)
);

CREATE TABLE Film(
    Code_Film VARCHAR PRIMARY KEY,
    Duree INTEGER  NOT NULL,
    Synopsis VARCHAR NOT NULL,
    FOREIGN KEY (Code_Film) REFERENCES Ressource(Code) ON DELETE CASCADE
);

CREATE TABLE Langage (
    Langue VARCHAR PRIMARY KEY
);

CREATE TABLE RessourceLangage (
    Langue VARCHAR REFERENCES Langage(Langue),
    Ressource VARCHAR REFERENCES Ressource(Code),
    PRIMARY KEY (Langue,Ressource)
);

CREATE TABLE Categorie (
    Genre VARCHAR PRIMARY KEY
);

CREATE TABLE RessourceCategorie (
    Genre VARCHAR REFERENCES Categorie(Genre),
    Ressource VARCHAR REFERENCES Ressource(Code),
    PRIMARY KEY (Genre,Ressource)
);

CREATE TABLE Exemplaire(
    Code VARCHAR UNIQUE NOT NULL,
    Code_ressource VARCHAR REFERENCES Ressource(Code)  ON DELETE CASCADE,
    Etat VARCHAR CHECK (ETAT IN ('neuf', 'bon', 'abime', 'perdu')) NOT NULL,
    PRIMARY KEY (Code, Code_ressource)
);

CREATE TABLE Adherent (
    Nom VARCHAR NOT NULL,
    Prenom VARCHAR NOT NULL,
    Date_Naissance DATE NOT NULL,
    Login VARCHAR PRIMARY KEY,
    Pwd VARCHAR NOT NULL,
    Adresse VARCHAR NOT NULL,
    Email VARCHAR UNIQUE NOT NULL,
    Telephone VARCHAR UNIQUE NOT NULL,
    NoCard VARCHAR UNIQUE NOT NULL,
    Blacklist BOOLEAN
);

CREATE TABLE Pret (
    Code_exemplaire VARCHAR NOT NULL REFERENCES Exemplaire(Code),
    Code_ressource VARCHAR NOT NULL REFERENCES Ressource(Code),
    Adherent VARCHAR NOT NULL REFERENCES Adherent(Login),
    Time_pret DATE NOT NULL,
    Time_retour DATE,
    PRIMARY KEY (Code_exemplaire, Code_ressource, Adherent, Time_pret),
    UNIQUE(Code_exemplaire, Code_ressource, Adherent, Time_retour)
);

CREATE TABLE Reservation (
    Code_exemplaire VARCHAR NOT NULL REFERENCES Exemplaire(Code),
    Code_ressource VARCHAR NOT NULL REFERENCES Ressource(Code)  ON DELETE CASCADE,
    Adherent VARCHAR NOT NULL REFERENCES Adherent(Login),
    Time_demande DATE NOT NULL,
    Time_disponible DATE,
    PRIMARY KEY (Code_exemplaire, Code_ressource, Adherent, Time_demande),
    UNIQUE(Code_exemplaire, Code_ressource, Adherent, Time_disponible)
);


CREATE TABLE Membre (
    Nom VARCHAR NOT NULL,
    Prenom VARCHAR NOT NULL,
    Date_Naissance DATE NOT NULL,
    Login VARCHAR PRIMARY KEY,
    Pwd VARCHAR NOT NULL,
    Adresse VARCHAR NOT NULL,
    Email VARCHAR UNIQUE NOT NULL
);

CREATE TABLE Ecrit(
    Id_Auteur VARCHAR REFERENCES Auteur(Cle),
    Id_Livre VARCHAR REFERENCES Livre(Code_Livre) ,
    PRIMARY KEY (Id_Auteur, Id_Livre)
);

CREATE TABLE Joue(
    Id_Acteur VARCHAR  REFERENCES Acteur(Cle),
    Id_Film VARCHAR  REFERENCES Film(Code_Film)  ON DELETE CASCADE,
    PRIMARY KEY (Id_Acteur, Id_Film)
);

CREATE TABLE Dirige(
    Id_Realisateur VARCHAR REFERENCES Realisateur(Cle),
    Id_Film VARCHAR  REFERENCES Film(Code_Film)  ON DELETE CASCADE,
    PRIMARY KEY (Id_Realisateur, Id_Film)
);

CREATE TABLE Compose(
    Id_Compositeur VARCHAR REFERENCES Compositeur(Cle),
    Id_Musique VARCHAR REFERENCES Musique(Code_Musique),
    PRIMARY KEY(Id_Compositeur, Id_Musique)
);

CREATE TABLE Interprete_musique(
    Id_Interprete  VARCHAR REFERENCES Interprete(Cle),
    Id_Musique VARCHAR  REFERENCES Musique(Code_Musique),
    PRIMARY KEY(Id_Interprete, Id_Musique)
);

CREATE TABLE Adhesion (
    Adherent VARCHAR NOT NULL REFERENCES Adherent(Login),
    Debut DATE NOT NULL,
    Fin DATE,
    PRIMARY KEY(Adherent,Debut)
);

CREATE TABLE Sanction (
    Id INTEGER PRIMARY KEY,
    Adherent VARCHAR NOT NULL REFERENCES Adherent(Login),
    Membre VARCHAR NOT NULL REFERENCES Membre(Login),
    Date_sanction DATE NOT NULL,
    Type VARCHAR NOT NULL CHECK (Type IN ('perte','degradation','retard')),
    Date_Acquittement DATE,
    Prix FLOAT,
    UNIQUE(Adherent,Membre,Date_sanction)
);


INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('1', 'Penverne', 'Leonard','1999-05-07', 'Francais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('2', 'Grimal', 'Paul', '1999-03-05', 'Allemand');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('3', 'Basta', 'Inal','1999-07-22','Francais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('4', 'Ren', 'Luqin', '1999-10-19', 'Chinois');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('5', 'Hugo', 'Victor', '1802-02-26', 'Francais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('6', 'Chopin', 'Frederic', '1810-03-01','Polonais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('7', 'Spielberg', 'Steven', '1946-01-01', 'Americain');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('8','Piaf', 'Edith', '1923-02-02', 'Francais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('9', 'Bay', 'Micheal', '1956-03-03', 'Americain');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('10', 'Gaga', 'Lady', '1989-05-04', 'Britanique');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('11', 'Ovni', 'Jul', '1993-01-14', 'Francais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('12', 'Pitt', 'Brad', '1963-12-18', 'Americain');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('13', 'Hathaway', 'Anne','1982-11-12','Americain');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('14', 'Affleck', 'Ben', '1972-08-15', 'Americain');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('15', 'Nolan', 'Chistopher','1970-07-30','Anglais');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('16', 'Zimmer', 'Hans', '1957-09-12', 'Allemand');
INSERT INTO Contributeur (Id, Nom, Prenom , Date_Naissance, Nationalite) VALUES ('17', 'Gervais', 'Julien', '1999-07-03', 'Francais');


INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('flodup', '1234', 'Compi','f@dupont@neuf.fr', '0673939201','Dupont', 'Florian', '1999-07-22', '1111', False);
INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('Flotov', 'Flotovdu13', 'Marseille', 'Florian.thauvin@mail.com', '0782294049', 'Thauvin', 'Florian', '1999-07-21', '1112', False);
INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('Valere22', '12345', 'Rouen', 'Valere.germain@gmail.com', '0728291034', 'Germain', 'Valere', '1999-07-02', '1113', True);
INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('Mohamed', '123456', 'Argenteuil', 'Mohamedi.henni@gmail.com', '0534291032', 'Henni', 'Mohamed', '1999-07-28', '1114', False);
INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('Francois', '1234556', 'Marseille', 'Francisdu67@gmail.com', '0876432312', 'Crabe', 'Francis', '1999-07-26', '1115', True);
INSERT INTO Adherent (login,Pwd,adresse,email,telephone,nom,prenom,Date_Naissance, nocard, Blacklist) VALUES ('Gauthier', '121212','Paris','Gaucpaxdu92@gmail.com','0928281472','Capelle','Gauthier','1999-06-03', '1116', False);


INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('1','SQL pour les nuls','2020-04-04','E1','Folio', 99);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('2','Jurassic Park','1987-06-09','F1','Universal studio',16);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('3', 'La vie en rose', '1972-06-09', 'M1', 'Universal Music',10.55);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('4', 'Rien 100 rien', '2019-01-14', 'M2', 'D or et de platine',10.99);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('5', 'Interstellar', '2015-03-18', 'F2', 'Universal Studio', 20);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('6', 'Gone Girl', '2014-10-08', 'F2', 'Universal Studio', 15.99);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('7', 'Russian Roulette', '2012-10-23', 'M1', 'Rihanna Studio', 50);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('8','La Corrida', '1970-10-24', 'M1', 'Cabrel Production', 23);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('9', 'Gladiator', '2005-10-12', 'F1', 'Greatest of All Time', 29);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('10', 'LOVNI', '2014-10-13', 'M2', 'RappeurFranchise', 35);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('11', 'Avatar', '2012-12-12', 'F1', 'SpielbergProduction', 19);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('12', 'Une vie', '2008-10-10', 'E2', 'Hachette',8.99);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('13', 'Asterix & Obelix', '1980-10-09', 'E1', 'BDMania', 8);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('14', 'Supporter un vrai club', '2020-04-04', 'E1', 'EditionValeur', 10);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('15', 'Largo Winch', '1980-10-20', 'E3','Dupuis', 14.99);
INSERT INTO Ressource(Code, Titre, Date_Publication, Code_Classification, Editeur, Prix) VALUES ('16', 'Argo', '2013-01-06', 'F2', '2Oth Century Fox',19.99);

INSERT INTO Membre (Nom, Prenom, Date_Naissance, Login, Pwd, Adresse, Email) VALUES ('Juni', 'Juninho','1970-11-21','lebon','azerty', 'Lyon', 'juni@lartiste');
INSERT INTO Membre (Nom, Prenom, Date_Naissance, Login, Pwd, Adresse, Email) VALUES ('Lopez', 'Anthony', '1990-05-31','labrute', '2345','Lyon','a@l');
INSERT INTO Membre (Nom, Prenom, Date_Naissance, Login, Pwd, Adresse, Email) VALUES ('Eyrault', 'Jacques', '1965-02-06', 'letruand', '908','Marseille', 'hhe@om');
INSERT INTO Membre (Nom, Prenom, Date_Naissance, Login, Pwd, Adresse, Email) VALUES ('Aulas', 'Jean-Michel', '1970-10-01', 'lartiste', '567', 'Lyon', 'jma@lebest');



INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('2', 120, 'Des dinosaures dans un parc qui mangent des touristes');
INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('5', 150, 'Aventure dans l espace');
INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('6', 112, 'Un thriller palpitant');
INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('9', 95, 'Un homme se bat pour sa famille et son honneur');
INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('16', 120, 'Des Americains coincés en Iran qui s echappent grace a des Canadiens');
INSERT INTO Film(Code_Film, Duree, Synopsis) VALUES ('11', 128, 'Les schtroumpfs mais en grand');

INSERT INTO Musique(Code_Musique, Duree) VALUES ('3',2);
INSERT INTO Musique(Code_Musique, Duree) VALUES ('4',3);
INSERT INTO Musique(Code_Musique, Duree) VALUES ('7',4);
INSERT INTO Musique(Code_Musique, Duree) VALUES ('8',1);
INSERT INTO Musique(Code_Musique, Duree) VALUES ('10',65);

INSERT INTO Livre(Code_Livre, ISBN, Resume) VALUES ('1', '0-7645-2641-3','Apprendre le SQL de manière amusante');
INSERT INTO Livre(Code_Livre, ISBN, Resume) VALUES ('15', '0-7777-2913-6', 'Un riche qui est dans la sauce');
INSERT INTO Livre(Code_Livre, ISBN, Resume) VALUES ('12','0-7845-2641-3', 'Une magnifique oeuvre autobiographique d une combattante inspirante');
INSERT INTO Livre(Code_Livre, ISBN, Resume) VALUES ('13', '0-7747-2913-6', 'Un village gaulois résiste encore');
INSERT INTO Livre(Code_Livre, ISBN, Resume) VALUES ('14', '0-7727-2913-6', 'La vraie histoire des amoureux du ballon');

INSERT INTO Auteur (Cle) VALUES ('1');
INSERT INTO Auteur (Cle) VALUES ('5');

INSERT INTO Acteur (Cle) VALUES ('12');
INSERT INTO Acteur (Cle) VALUES ('13');
INSERT INTO Acteur (Cle) VALUES ('14');
INSERT INTO Acteur (Cle) VALUES ('17');

INSERT INTO Interprete (Cle) VALUES ('8');
INSERT INTO Interprete (Cle) VALUES ('10');
INSERT INTO Interprete (Cle) VALUES ('11');
INSERT INTO Interprete (Cle) VALUES ('4');

INSERT INTO Realisateur (Cle) VALUES ('7');
INSERT INTO Realisateur (Cle) VALUES ('9');
INSERT INTO Realisateur (Cle) VALUES ('14');
INSERT INTO Realisateur (Cle) VALUES ('2');

INSERT INTO Compositeur(Cle) VALUES('6');
INSERT INTO Compositeur(Cle) VALUES('3');
INSERT INTO Compositeur(Cle) VALUES('16');

INSERT INTO Ecrit (Id_Auteur, Id_Livre) VALUES ('1','1');
INSERT INTO Ecrit (Id_Auteur, Id_Livre) VALUES ('5','12');
INSERT INTO Ecrit (Id_Auteur, Id_Livre) VALUES ('5','14');
INSERT INTO Ecrit (Id_Auteur, Id_Livre) VALUES ('1','15');
INSERT INTO Ecrit (Id_Auteur, Id_Livre) VALUES ('1','13');

INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('12','2');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('12','9');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('13','5');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('14','6');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('14','16');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('17','11');
INSERT INTO Joue(Id_Acteur, Id_Film) VALUES ('17','16');

INSERT INTO Interprete_musique (Id_Interprete, Id_musique) VALUES ('8','3');
INSERT INTO Interprete_musique (Id_Interprete, Id_musique) VALUES ('11','4');
INSERT INTO Interprete_musique (Id_Interprete, Id_musique) VALUES ('10','7');
INSERT INTO Interprete_musique (Id_Interprete, Id_musique) VALUES ('4','8');
INSERT INTO Interprete_musique (Id_Interprete, Id_musique) VALUES ('11','10');

INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('7','2');
INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('9','5');
INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('2','6');
INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('14','9');
INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('2','11');
INSERT INTO Dirige (Id_Realisateur, Id_Film) VALUES ('14','16');

INSERT INTO Compose (Id_Compositeur, Id_Musique)  VALUES ('6', '7');
INSERT INTO Compose (Id_Compositeur, Id_Musique)  VALUES ('3', '4');
INSERT INTO Compose (Id_Compositeur, Id_Musique)  VALUES ('16', '8');
INSERT INTO Compose (Id_Compositeur, Id_Musique) VALUES ('16', '10');
INSERT INTO Compose (Id_Compositeur, Id_Musique) VALUES ('16', '3');

INSERT INTO Langage(Langue) VALUES('Francais');
INSERT INTO Langage(Langue) VALUES('Anglais');
INSERT INTO Langage(Langue) VALUES('Japonais');
INSERT INTO Langage(Langue) VALUES('Chinois');

INSERT INTO Categorie (Genre) VALUES ('Action');
INSERT INTO Categorie (Genre) VALUES ('Comedie');
INSERT INTO Categorie (Genre) VALUES ('Pop');
INSERT INTO Categorie (Genre)  VALUES ('Classique');
INSERT INTO Categorie (Genre) VALUES ('Romance');
INSERT INTO Categorie (Genre) VALUES ('Horreur');

INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','1');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','2');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','3');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','4');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','5');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','6');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','7');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','8');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','9');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','10');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','11');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','12');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','13');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','14');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','15');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Anglais','16');
INSERT INTO RessourceLangage(Langue, Ressource) VALUES('Francais','16');


INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Classique','3');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Romance','1');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','2');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Pop','4');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','5');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','6');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Pop','7');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Classique','8');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','9');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Pop','10');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','11');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Classique','12');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Comedie','13');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Romance','14');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Classique','15');
INSERT INTO RessourceCategorie(Genre, Ressource) VALUES ('Action','16');


INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('1', '1', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('2', '1', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('3', '1', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('4', '2', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('5', '3', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('6', '4', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('7', '4', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('8', '4', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('9', '4', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('10', '5', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('11', '5', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('12', '5', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('13', '5', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('14', '5', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('15', '6', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('16', '7', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('17', '8', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('18', '9', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('19', '9', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('20', '9', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('21', '10', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('22', '11', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('23', '12', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('24', '13', 'abime');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('25', '14', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('26', '14', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('27', '14', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('28', '14', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('29', '14', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('30', '15', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('31', '16', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('32', '16', 'neuf');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('33', '16', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('34', '16', 'bon');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('35', '16', 'perdu');
INSERT INTO EXEMPLAIRE (Code, Code_Ressource, Etat) VALUES ('36', '16', 'neuf');

INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('flodup','2010-02-02',NULL);
INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('Flotov','2011-03-05',NULL);
INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('Valere22','2016-03-02',NULL);
INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('Mohamed','2013-08-23',NULL);
INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('Francois','2014-05-05','2015-01-01');
INSERT INTO Adhesion (Adherent, Debut, Fin) VALUES ('Gauthier','2018-06-24','2020-06-01');

INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('1','1','flodup','2020-03-29', '2020-04-03');
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('16','7','flodup','2020-04-01','2020-04-02');
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('17','8','flodup','2020-04-04', NULL);
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('26','14','Flotov','2020-03-30','2020-03-30');
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('29','14','Flotov','2020-04-01','2020-04-02');
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('30','15','Flotov','2020-04-03', NULL);
INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('31','16','Flotov','2020-03-28','2020-03-31');

INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('15','6','flodup', '2020-03-01', '2020-03-10');
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('16','7','flodup', '2019-03-01', '2019-03-10');
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('17','8','flodup', '2019-03-01', '2019-03-10');
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('15','6','flodup', '2019-04-01','2019-04-10');
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('2','1','Flotov', '2020-04-01', NULL);
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('9','3','flodup', '2020-04-01', NULL);
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('9','4','Flotov','2020-04-01', NULL);
INSERT INTO Pret (Code_exemplaire, Code_ressource, Adherent, Time_pret, Time_retour) VALUES ('24','13','flodup', '2020-04-01', NULL);



INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('1','flodup','labrute','2019-01-03','perte','2019-02-03',16);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('2','flodup','letruand','2019-01-03','retard','2019-01-07', NULL);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('3','Francois','labrute','2020-02-01','degradation', NULL, 99);


INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('4', 'Valere22', 'lartiste', '2019-04-05','retard', '2019-04-15', NULL);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('5', 'Valere22', 'lartiste', '2020-01-03', 'retard', '2020-01-07', NULL);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('6', 'Valere22', 'letruand', '2020-01-15', 'retard', '2020-01-17', NULL);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('7', 'Valere22', 'labrute', '2020-02-05', 'degradation','2020-02-25',10.55);
INSERT INTO Sanction (Id, Adherent, Membre, Date_sanction, Type, Date_Acquittement, Prix) VALUES ('8', 'Valere22', 'lebon', '2020-04-04', 'perte', '2020-04-04',10.99);


/* 
#### VUES à réaliser après la création/le remplissage des tables ###

## VUE pour voir les emprunts actuels (ceux dont la date de retour est supérieur à la date actuelle)

*/ 
CREATE VIEW vEmprunt_actuels AS
SELECT a.nom, a.prenom, r.titre
FROM Pret p, Adherent a, Ressource r
WHERE p.code_ressource=r.code AND p.adherent=a.Login AND p.time_retour IS NULL;

/*  VUE pour regarder l'historique des emprunts d'une personne (ici celui de Florian Dupont)    */

CREATE VIEW vHistorique AS
SELECT a.Nom, a.Prenom, p.Time_pret, r.Titre
FROM Pret p, Adherent a, Ressource r
WHERE p.code_ressource=r.code AND p.adherent=a.Login AND a.Login='flodup' 
ORDER BY p.Time_pret desc;

/* 
    VUE POUR VOIR LE NOMBRE D'EMPRUNTS ACTUELS ET PAR PERSONNE
*/

CREATE VIEW vNb_Emprunts_Actuels_Par_Personne AS
SELECT a.nom, a.prenom, a.login, COUNT(*) AS nombre_pret
FROM Pret p, Adherent a, Ressource r
WHERE p.code_ressource=r.code AND p.adherent=a.Login AND p.time_retour IS NULL
GROUP BY a.nom, a.prenom, a.login;

/*
    VUE POUR LE NOMBRE DE TENDANCES
*/

CREATE VIEW vTendances AS
SELECT r.Titre, COUNT(*) AS nombre_pret
FROM Ressource r, Pret p
WHERE p.code_ressource=r.code
GROUP BY r.Titre
ORDER BY nombre_pret DESC;

/*
    VUE pour les sanctions non acquites
*/
CREATE VIEW vSanctionNonAcquitte AS 
SELECT a.Nom, a.Prenom, a.Login, a.Email, a.Telephone, s.Type, s.Date_sanction
FROM Adherent a, Sanction s
WHERE s.Date_Acquittement IS NULL 
AND a.Login = s.Adherent;


/*
    VUE pour les personnes blacklistées
*/

CREATE VIEW vBLACKLIST AS
SELECT a.Nom, a.Prenom, a.Login
from Adherent a
WHERE a.blacklist IS TRUE;

/*
    VUE pour les personnes qui ont droit de prêt : qui sont non blacklistées, non sanctionnées et 
	le nombre de documents en main est inférieur à 10
*/

CREATE VIEW vAdherent_Avoir_Droit_Pret AS
SELECT nbe.Nom, nbe.Prenom, nbe.Login
FROM vNb_Emprunts_Actuels_Par_Personne nbe
LEFT JOIN vSanctionNonAcquitte sna ON sna.login = nbe.login
LEFT JOIN vBLACKLIST b ON b.login = nbe.login
WHERE sna.login IS NULL AND b.login IS NULL AND nbe.nombre_pret < 10;

/*
    VUE pour vérifier la contrainte sur l'association Exemplaire "1..N" -composition- "1" Ressource
	Projection(Ressource,code) = Projection(Exemplaire,Code_ressource)
	Le résultat attendu est nul.
*/

CREATE VIEW vCheckRessourceExemplaire AS
SELECT Code FROM Ressource
EXCEPT
SELECT Code_ressource FROM Exemplaire;

/*
    VUE pour vérifier la contrainte sur l'héritage par référence
	Projection(Livre,Code_Ressource) UNION Projection(Film, Code_Ressource) UNION Projection(Musique, Code_Ressource) = Projection(Ressource, code)
	Le résultat attendu est nul.
*/

CREATE VIEW vCheckRessourceReference AS
SELECT Code_Livre FROM Livre
UNION
SELECT Code_Film FROM Film
UNION
SELECT Code_Musique FROM Musique
EXCEPT
SELECT Code FROM Ressource;

/*
    VUE pour tous les exemplaires actuellement disponibles 
*/

CREATE VIEW vExemplaireDisponible AS
SELECT r.code AS code_ressource, COUNT(e.code) AS nb_exemplaire, r.titre, r.date_publication, e.etat
FROM Ressource r
INNER JOIN Exemplaire e ON r.code = e.code_ressource
LEFT JOIN Pret p ON p.code_exemplaire = e.code
WHERE (e.etat = 'bon' OR e.etat = 'neuf') AND CURRENT_DATE > p.time_retour
GROUP BY r.code, r.titre, r.date_publication, e.etat
ORDER BY code_ressource;

/*
    TEST SUPPRESSION : La suppression d'une Ressource devrait entraîner 
    la suppression de tous les exemplaires de cette Ressource.
    Le résultat attendu est nul.
*/

DELETE FROM RessourceLangage WHERE ressource = '16';
DELETE FROM RessourceCategorie WHERE ressource = '16';
DELETE FROM Ressource WHERE code = '16';
SELECT * FROM exemplaire WHERE code_ressource = '16';

/*
    TEST MISE A JOUR  : Blacklister un adhérent.
*/

UPDATE Adherent set blacklist = 'True' WHERE Login = 'Gauthier';
SELECT * FROM Adherent WHERE Login = 'Gauthier';

/*
    TEST INSERTION : Les exemplaires qui n'existent pas ne peuvent pas être réservés.
	Le résultat attendu est une erreur.

INSERT INTO Reservation(code_exemplaire, code_ressource, Adherent, Time_demande, Time_disponible) VALUES ('31','15','51','2020-04-05',NULL);
*/

/*
    TEST REQUETE : Afficher les ressources qui ont un seul exemplaire dans la bibliothèque.
*/

SELECT r.code AS code_ressource, COUNT(e.code) AS nb_exemplaire, r.titre, r.date_publication, e.etat
FROM Ressource r, Exemplaire e
WHERE r.code = e.code_ressource
GROUP BY r.code, r.titre, r.date_publication, e.etat
HAVING COUNT(e.code) = 1
ORDER BY code_ressource;