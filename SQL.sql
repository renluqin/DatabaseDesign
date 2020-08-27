/* Commandes pour supprimer les views*/
DROP VIEW IF EXISTS vMonth_Expense;
DROP VIEW IF EXISTS vActive_LabMembers;
DROP VIEW IF EXISTS vNb_Proposal_Responsed_Accepted;
DROP VIEW IF EXISTS vNb_Proposal_Accepted;
DROP VIEW IF EXISTS vNb_Proposal_Responsed;
DROP VIEW IF EXISTS vCall_Without_Proposal;
DROP VIEW IF EXISTS vProjectCurrent;
DROP VIEW IF EXISTS vProjectsHaveBudget;
DROP VIEW IF EXISTS vProjectBudget;
DROP VIEW IF EXISTS vProjectInternalMember;
DROP VIEW IF EXISTS vProjectExpense;
DROP VIEW IF EXISTS vCheckProposalLabMember;
DROP VIEW IF EXISTS vCheckOrganizationLegalEntity;
DROP VIEW IF EXISTS vCheckPersonLabMemberEmployeeLE;
DROP VIEW IF EXISTS vDoctor;
DROP VIEW IF EXISTS vResearchEngineer;
DROP VIEW IF EXISTS vTeacherResearcher;

/*Commandes pour supprimer les tables*/
DROP TABLE IF EXISTS ProjectMember;
DROP TABLE IF EXISTS Expense;
DROP TABLE IF EXISTS ProposalLabMember;
DROP TABLE IF EXISTS ProposalLabel;
DROP TABLE IF EXISTS Label;
DROP TABLE IF EXISTS Budget;
DROP TABLE IF EXISTS Proposal;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Call;
DROP TABLE IF EXISTS EmployeeContact;
DROP TABLE IF EXISTS EmployeeLE;
DROP TABLE IF EXISTS LabMember;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS LegalEntityOrganization;
DROP TABLE IF EXISTS Organization;
DROP TABLE IF EXISTS LegalEntity;


CREATE TABLE LegalEntity(
    Code VARCHAR PRIMARY KEY,
    Name VARCHAR,
    Start_date DATE NOT NULL, 
    End_date DATE, 
    Type VARCHAR CHECK (Type IN ('company', 'country', 'region', 'city', 'organization', 'laboratory')) NOT NULL
);

CREATE TABLE Organization(
    Code VARCHAR PRIMARY KEY,
    Name VARCHAR,
    Date_Creation DATE NOT NULL,
    Duration INTEGER
);

CREATE TABLE LegalEntityOrganization(
    LegalEntity VARCHAR NOT NULL REFERENCES LegalEntity(Code),
    Organization VARCHAR NOT NULL REFERENCES Organization(Code),
    PRIMARY KEY (LegalEntity,Organization)
);

CREATE TABLE Person(
    id INTEGER PRIMARY KEY,
    Name JSON NOT NULL,
    Email JSON NOT NULL,
    LegalEntity VARCHAR NOT NULL REFERENCES LegalEntity(Code)
);

CREATE TABLE LabMember(
    id INTEGER PRIMARY KEY,
    Type VARCHAR CHECK (Type IN ('TeacherResearcher', 'ResearchEngineer', 'Doctor')) NOT NULL,
    Research_time_quota INTEGER, 
    Edu_establishment VARCHAR, 
    Speciality VARCHAR, 
    Thesis_start_date DATE, 
    Thesis_end_date DATE, 
    Thesis_subject VARCHAR,
    FOREIGN KEY (id) REFERENCES Person(id),
    CHECK ((Type = 'TeacherResearcher' AND Research_time_quota IS NOT NULL AND Edu_establishment IS NOT NULL AND Speciality IS NULL AND Thesis_start_date IS NULL AND Thesis_end_date IS NULL AND Thesis_subject IS NULL) 
    OR (Type = 'ResearchEngineer' AND Research_time_quota IS NULL AND Edu_establishment IS NULL AND  Speciality IS NOT NULL AND Thesis_start_date IS NULL AND Thesis_end_date IS NULL AND Thesis_subject IS NULL)
    OR (Type = 'Doctor' AND Research_time_quota IS NULL AND Edu_establishment IS NULL AND  Speciality IS NULL AND Thesis_start_date IS NOT NULL AND Thesis_subject IS NOT NULL)
    )
);

CREATE TABLE EmployeeLE(
    id INTEGER PRIMARY KEY,
    Telephone VARCHAR NOT NULL,
    FOREIGN KEY (id) REFERENCES Person(id)
);

CREATE TABLE EmployeeContact(
    id INTEGER PRIMARY KEY,
    Title VARCHAR NOT NULL,
    FOREIGN KEY (id) REFERENCES EmployeeLE(id)
);

CREATE TABLE Call(
    id INTEGER PRIMARY KEY, 
    Date_Launch DATE NOT NULL, 
    Date_Finish DATE NOT NULL, 
    Theme VARCHAR NOT NULL, 
    Description VARCHAR NOT NULL, 
    Committee VARCHAR NOT NULL, 
    Organization VARCHAR NOT NULL REFERENCES Organization(Code) 
);

CREATE TABLE Project(
    id INTEGER PRIMARY KEY, 
    Start_date DATE NOT NULL,
    End_date DATE NOT NULL
);

CREATE TABLE Proposal(
    Call INTEGER NOT NULL REFERENCES Call(id), 
    PID INTEGER NOT NULL, 
    Date_submit DATE NOT NULL, 
    Date_response DATE, 
    Response VARCHAR CHECK (Response IN ('refusal', 'acceptance')),
    Project INTEGER UNIQUE REFERENCES Project(id),
    PRIMARY KEY (Call,PID) 
);

CREATE TABLE Budget(
    Call INTEGER NOT NULL,
    Proposal INTEGER NOT NULL, 
    BID INTEGER NOT NULL, 
    Amount INTEGER NOT NULL, 
    Object VARCHAR NOT NULL, 
    Type VARCHAR CHECK (Type IN ('operating', 'material')) NOT NULL,
	FOREIGN KEY (Call,Proposal) REFERENCES Proposal(Call,PID) ON DELETE CASCADE,
    PRIMARY KEY (Call,Proposal,BID) 
);

CREATE TABLE Label( 
    Name VARCHAR PRIMARY KEY, 
    LegalEntity VARCHAR NOT NULL REFERENCES LegalEntity(Code)
);

CREATE TABLE ProposalLabel( 
    Call INTEGER NOT NULL,
    Proposal INTEGER NOT NULL, 
    Label VARCHAR REFERENCES Label(Name),
	FOREIGN KEY (Call,Proposal) REFERENCES Proposal(Call,PID),
    PRIMARY KEY (Call,Proposal,Label) 
);

CREATE TABLE ProposalLabMember( 
    Call INTEGER NOT NULL,
    Proposal INTEGER NOT NULL, 
    LabMember INTEGER NOT NULL REFERENCES LabMember(id),
	FOREIGN KEY (Call,Proposal) REFERENCES Proposal(Call,PID) ON DELETE CASCADE,
    PRIMARY KEY (Call,Proposal,LabMember) 
);

CREATE TABLE Expense( 
    Project INTEGER NOT NULL REFERENCES Project(id), 
    Demander INTEGER NOT NULL REFERENCES Person(id),  
    Validator INTEGER NOT NULL REFERENCES Person(id), 
    Date DATE NOT NULL, 
    Amount INTEGER NOT NULL, 
    Type VARCHAR CHECK (Type IN ('operating', 'material')) NOT NULL,
    PRIMARY KEY (Project,Demander,Validator) 
);

CREATE TABLE ProjectMember( 
    Project INTEGER NOT NULL REFERENCES Project(id), 
    Member INTEGER NOT NULL REFERENCES Person(id),  
    Position VARCHAR NOT NULL,
    PRIMARY KEY (Project,Member) 
);


INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('FR', 'France', '1792-09-22', 'country');
INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('FT', 'France Telecom', '1988-04-12', 'company');
INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('HF', 'Haut de France', '2014-03-18', 'region');
INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('C', 'Compiegne', '1996-01-30', 'city');
INSERT INTO LegalEntity (Code, Name, Start_date, End_date, Type) VALUES ('TOOC', 'Tokyo Olympic Organizing Committee', '2018-09-22', '2020-12-31', 'organization');
INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('ADIT', 'ADIT Biology', '1987-03-15', 'laboratory');
INSERT INTO LegalEntity (Code, Name, Start_date, Type) VALUES ('MGL', 'Meuilleur Géologie Lab', '2013-09-22', 'laboratory');

INSERT INTO Organization (Code, Name, Date_Creation) VALUES ('FRM', 'Groupe français de recherche météorologique', '1793-09-22');
INSERT INTO Organization (Code, Name, Date_Creation) VALUES ('RFT', 'Groupe de recherche France Télécom', '1999-10-19');
INSERT INTO Organization (Code, Name, Date_Creation, Duration) VALUES ('LPVC', 'Organisation de recherche sur la protection du vieux château', '2015-06-30','365');
INSERT INTO Organization (Code, Name, Date_Creation, Duration) VALUES ('ELB', 'Équipe de conception de lignes de bus', '1998-11-17','200');
INSERT INTO Organization (Code, Name, Date_Creation, Duration) VALUES ('LOT', 'Organisation de soutien logistique olympique de Tokyo', '2018-09-22','400');
INSERT INTO Organization (Code, Name, Date_Creation, Duration) VALUES ('PJOT', 'Organisation de publicité pour les Jeux olympiques de Tokyo', '2018-09-22','400');
INSERT INTO Organization (Code, Name, Date_Creation) VALUES ('OCK', 'Organisation de conservation du koala', '2000-08-01');
INSERT INTO Organization (Code, Name, Date_Creation) VALUES ('MPC', 'Organisation de recherche sur le mouvement des plaques crustales', '1999-10-19');

INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('FR', 'FRM');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('FT', 'RFT');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('HF', 'LPVC');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('C', 'ELB');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('TOOC', 'LOT');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('TOOC', 'PJOT');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('ADIT', 'OCK');
INSERT INTO LegalEntityOrganization (LegalEntity, Organization) VALUES ('MGL', 'MPC');

INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('1', '{"First Name":"Luqin","Last Name":"Ren"}', '["ren@etu.utc.fr", "renluqin@adit.fr"]', 'ADIT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('2', '{"First Name":"Phillipe","Last Name":"Martin"}', '["phillipe@etu.utc.fr", "phillipemartin@adit.fr"]', 'ADIT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('3', '{"First Name":"Alice","Last Name":"Bernard"}', '["alice@gmail.com", "alicebernard@adit.fr"]', 'ADIT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('4', '{"First Name":"Betty","Last Name":"Thomas"}', '["betty@etu.utc.fr", "bettythomas@adit.fr"]', 'ADIT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('5', '{"First Name":"Celine","Last Name":"Petit"}', '["celine@etu.utc.fr", "celinepetit@france.fr"]', 'FR');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('6', '{"First Name":"Durand","Last Name":"Robert"}', '["durand@etu.utc.fr", "robertdurand@compiegne.fr"]', 'C');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('7', '{"First Name":"Emma","Last Name":"Richard"}', '["richard@etu.utc.fr", "emmarichard@hf.fr"]', 'HF');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('8', '{"First Name":"Florence","Last Name":"Durand"}', '["florence@etu.utc.fr", "florencedurand@ft.fr"]', 'FT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('9', '{"First Name":"Gamma","Last Name":"Dubois"}', '["gamma@etu.utc.fr", "duboisgamma@france.fr"]', 'FR');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('10', '{"First Name":"Hilton","Last Name":"Moreau"}', '["hilton@gmail.com"]', 'C');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('11', '{"First Name":"Ilban","Last Name":"Laurent"}', '["ilban@gmail.com"]', 'TOOC');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('12', '{"First Name":"Jimmy","Last Name":"Simon"}', '["jimmy@gmail.com"]', 'ADIT');
INSERT INTO Person (id, Name, Email, LegalEntity) VALUES ('13', '{"First Name":"King","Last Name":"Michel"}', '["king@gmail.com"]', 'MGL');

INSERT INTO LabMember (id, Type, Research_time_quota, Edu_establishment) VALUES ('1', 'TeacherResearcher', '56', 'UTC');
INSERT INTO LabMember (id, Type, Speciality) VALUES ('2', 'ResearchEngineer', 'Biology');
INSERT INTO LabMember (id, Type, Thesis_start_date, Thesis_end_date, Thesis_subject) VALUES ('3', 'Doctor', '2015-02-06', '2019-09-29', 'Importance of enviromental diversity');
INSERT INTO LabMember (id, Type, Thesis_start_date, Thesis_subject) VALUES ('4', 'Doctor', '2018-12-08', 'Database design');

INSERT INTO EmployeeLE (id, Telephone) VALUES ('5', '0664514699');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('6', '0664973465');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('7', '0662754085');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('8', '0608374538');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('9', '0662753544');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('10', '0624555677');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('11', '0645745538');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('12', '0666996790');
INSERT INTO EmployeeLE (id, Telephone) VALUES ('13', '0632680987');

INSERT INTO EmployeeContact (id, Title) VALUES ('7', 'Responsable de suivi');
INSERT INTO EmployeeContact (id, Title) VALUES ('8', 'Responsable de contrat');
INSERT INTO EmployeeContact (id, Title) VALUES ('9', 'Contact du Bureau Education');
INSERT INTO EmployeeContact (id, Title) VALUES ('10', 'Secrétaire');
INSERT INTO EmployeeContact (id, Title) VALUES ('11', 'Responsable de contrat');
INSERT INTO EmployeeContact (id, Title) VALUES ('12', 'Contact du Bureau Education');
INSERT INTO EmployeeContact (id, Title) VALUES ('13', 'Secrétaire');


INSERT INTO Call (id, Date_Launch, Date_Finish, Theme, Description, Committee, organization) VALUES ('1', '2015-02-06', '2019-09-29','Environment','Environment protection','EPCCC','OCK');
INSERT INTO Call (id, Date_Launch, Date_Finish, Theme, Description, Committee, organization) VALUES ('2', '2015-02-06', '2021-09-29','Food','Food nutrition','ABCDE','LOT');
INSERT INTO Call (id, Date_Launch, Date_Finish, Theme, Description, Committee, organization) VALUES ('3', '2017-02-06', '2023-08-31','Earth','Earth mouvement','IYEH','MPC');
INSERT INTO Call (id, Date_Launch, Date_Finish, Theme, Description, Committee, organization) VALUES ('4', '2010-02-06', '2024-10-29','Transport','Transport Design','DJBF','ELB');


INSERT INTO Project (id, Start_date, End_date) VALUES ('2', '2019-04-11', '2020-01-30');
INSERT INTO Project (id, Start_date, End_date) VALUES ('3', '2018-05-02', '2019-12-31');
INSERT INTO Project (id, Start_date, End_date) VALUES ('6', '2019-07-21', '2022-11-07');
INSERT INTO Project (id, Start_date, End_date) VALUES ('7', '2020-08-14', '2023-09-29');
INSERT INTO Project (id, Start_date, End_date) VALUES ('8', '2020-09-05', '2024-10-29');

INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response) VALUES ('1', '1', '2015-03-09', '2015-06-29','refusal');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response) VALUES ('1', '2', '2015-04-09', '2015-07-29','refusal');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response) VALUES ('1', '3', '2015-05-09', '2015-08-29','refusal');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response) VALUES ('1', '4', '2015-06-09', '2015-09-29','refusal');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('1', '5', '2015-07-09', '2015-10-29', 'acceptance', '2');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('1', '6', '2015-08-09', '2015-11-29', 'acceptance', '6');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('2', '1', '2015-03-09', '2015-03-29','acceptance', '3');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('2', '2', '2015-04-09', '2015-05-29','acceptance', '7');
INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('2', '3', '2015-05-09', '2015-05-29','acceptance', '8');
INSERT INTO Proposal (call, PID, Date_submit) VALUES ('3', '1', '2017-06-09');

INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '1', '1', '500','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '1', '2', '600','advertisement','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '1', '3', '700','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '2', '1', '800','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '2', '2', '300','advertisement','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '2', '3', '300','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '6', '1', '300','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '6', '2', '10000','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '1', '1', '700','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '1', '2', '13000','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '2', '1', '600','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '2', '2', '12000','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '5', '1', '300','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('1', '5', '2', '1000','human','operating');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '3', '1', '6000','computer','material');
INSERT INTO Budget (call, proposal, BID, Amount, Object, Type) VALUES ('2', '3', '2', '9000','advertisement','operating');

INSERT INTO Label (Name, LegalEntity) VALUES ('Env', 'ADIT');
INSERT INTO Label (Name, LegalEntity) VALUES ('Trans', 'C');
INSERT INTO Label (Name, LegalEntity) VALUES ('Koala', 'ADIT');
INSERT INTO Label (Name, LegalEntity) VALUES ('Tokyo', 'TOOC');
INSERT INTO Label (Name, LegalEntity) VALUES ('Olympic', 'TOOC');
INSERT INTO Label (Name, LegalEntity) VALUES ('Télécom', 'FT');
INSERT INTO Label (Name, LegalEntity) VALUES ('Earth', 'MGL');
INSERT INTO Label (Name, LegalEntity) VALUES ('Culture', 'FR');
INSERT INTO Label (Name, LegalEntity) VALUES ('Protection', 'HF');
INSERT INTO Label (Name, LegalEntity) VALUES ('Rapid', 'FT');
INSERT INTO Label (Name, LegalEntity) VALUES ('Nutrition', 'ADIT');

INSERT INTO ProposalLabel (call, proposal, label) VALUES ('1', '5','Env');
INSERT INTO ProposalLabel (call, proposal, label) VALUES ('1', '5','Koala');
INSERT INTO ProposalLabel (call, proposal, label) VALUES ('1', '6','Protection');
INSERT INTO ProposalLabel (call, proposal, label) VALUES ('2', '1','Nutrition');
INSERT INTO ProposalLabel (call, proposal, label) VALUES ('2', '1','Protection');
INSERT INTO ProposalLabel (call, proposal, label) VALUES ('2', '1','Rapid');

INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '1', '1');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '2', '2');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '3', '2');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '4', '3');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('2', '1', '4');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('2', '2', '1');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('2', '3', '2');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '5', '3');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('1', '6', '4');
INSERT INTO ProposalLabMember (call, proposal, LabMember) VALUES ('3', '1', '1');


INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('2', '1', '2', '2019-09-11', '100','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('3', '1', '2', '2018-08-02', '100','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('6', '1', '3', '2019-08-24', '500','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('7', '2', '6', '2020-10-14', '200','material');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('8', '2', '7', '2020-11-05', '300','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('2', '2', '8', '2019-07-11', '300','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('3', '3', '1', '2018-07-02', '300','material');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('6', '4', '2', '2019-08-21', '300','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('7', '5', '1', '2020-09-14', '400','material');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('8', '6', '2', '2020-10-05', '200','operating');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('2', '7', '1', '2019-05-11', '100','material');
INSERT INTO Expense (project, demander, validator, Date, Amount, Type) VALUES ('3', '8', '2', '2018-06-02', '200','operating');

INSERT INTO ProjectMember (project, member, Position) VALUES ('2', '1', 'Leader');
INSERT INTO ProjectMember (project, member, Position) VALUES ('2', '2', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('2', '7', 'Cashier');
INSERT INTO ProjectMember (project, member, Position) VALUES ('2', '8', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('3', '1', 'Leader');
INSERT INTO ProjectMember (project, member, Position) VALUES ('3', '2', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('3', '3', 'Cashier');
INSERT INTO ProjectMember (project, member, Position) VALUES ('3', '8', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('6', '1', 'Leader');
INSERT INTO ProjectMember (project, member, Position) VALUES ('6', '2', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('6', '3', 'Cashier');
INSERT INTO ProjectMember (project, member, Position) VALUES ('6', '4', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('7', '2', 'Leader');
INSERT INTO ProjectMember (project, member, Position) VALUES ('7', '6', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('7', '5', 'Cashier');
INSERT INTO ProjectMember (project, member, Position) VALUES ('7', '1', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('8', '2', 'Leader');
INSERT INTO ProjectMember (project, member, Position) VALUES ('8', '6', 'Reseacher');
INSERT INTO ProjectMember (project, member, Position) VALUES ('8', '7', 'Cashier');

/* 
#### VUES à réaliser après la création/le remplissage des tables ###
*/

/*
    VUE pour voir les classes filles dans l'héritage par mère
*/

CREATE VIEW vTeacherResearcher AS
SELECT p.id, p.Name, lm.Research_time_quota, lm.Edu_establishment
FROM LabMember lm, Person p
WHERE lm.id = p.id AND Type = 'TeacherResearcher';

CREATE VIEW vResearchEngineer AS
SELECT p.id, p.Name, lm.Speciality
FROM LabMember lm, Person p
WHERE lm.id = p.id AND Type = 'ResearchEngineer';

CREATE VIEW vDoctor AS
SELECT p.id, p.Name, lm.Thesis_start_date, lm.Thesis_end_date, lm.Thesis_subject
FROM LabMember lm, Person p
WHERE lm.id = p.id AND Type = 'Doctor';

/*
    VUE pour vérifier la contrainte sur l'héritage par référence
	projection(Person,PID) = projection(LabMember, PID) UNION projection(EmployeeLE, PID)
	Le résultat attendu est nul.
*/

CREATE VIEW vCheckPersonLabMemberEmployeeLE AS
SELECT id FROM LabMember
UNION
SELECT id FROM EmployeeLE
EXCEPT
SELECT id FROM Person;

/*
    VUE pour vérifier la contrainte sur l'association Organization "0..N" -- "1..N" LegalEntity
	Projection(Organization, Name) = Projection(LegalEntityOrganization, organization)
	Le résultat attendu est nul.
*/

CREATE VIEW vCheckOrganizationLegalEntity AS
SELECT Code FROM Organization
EXCEPT
SELECT Organization FROM LegalEntityOrganization;

/*
    VUE pour vérifier la contrainte sur l'association Proposal "0..N" -- "1..N" LabMember
    Projection(Proposal, (call,PID)) = Projection(ProposalLabMember, (call,proposal))
	Le résultat attendu est nul.
*/

CREATE VIEW vCheckProposalLabMember AS
SELECT Call, PID FROM Proposal
EXCEPT
SELECT Call, Proposal FROM ProposalLabMember;

/*
    VUE pour voir les dépenses de chaque type de chaque projet
*/

CREATE VIEW vProjectExpense AS
SELECT project, Type, SUM(Amount) AS Expense
FROM Expense
GROUP BY project, Type
ORDER BY project;

/*
    VUE pour voir les membres internes de chaque projet
*/

CREATE VIEW vProjectInternalMember AS
SELECT pm.project, pm.member, pm.position, p.Name
FROM ProjectMember pm, LabMember lm, Person p
WHERE pm.member = lm.id AND p.id = lm.id
ORDER BY pm.project, pm.member;

/*
    VUE pour voir les budgets de chaque type dans la proposition de chaque projet
*/

CREATE VIEW vProjectBudget AS
SELECT p.project, b.Type, SUM(b.Amount) AS Budget
FROM Budget b, Proposal p
WHERE b.proposal = p.pid AND b.call = p.call AND p.response = 'acceptance'
GROUP BY p.project, b.Type
ORDER BY p.project;

/*
    VUE pour voir les projets pour lesquels il reste du budget à dépenser
*/

CREATE VIEW vProjectsHaveBudget AS
SELECT vpb.project, vpb.Type, vpb.Budget, vpe.Expense
FROM vProjectBudget vpb
LEFT JOIN vProjectExpense vpe ON vpe.project = vpb.project AND vpe.type = vpb.type 
WHERE vpb.Budget > vpe.Expense OR vpe.Expense IS NULL
ORDER BY vpb.project;

/*
    VUE pour voir les projets en cours
*/

CREATE VIEW vProjectCurrent AS
SELECT *
FROM Project
WHERE End_date > CURRENT_DATE;

/*
    VUE pour voir les appels d'offre en cours non répondus
*/

CREATE VIEW vCall_Without_Proposal AS
SELECT c.id, c.Date_Launch, c.Date_Finish, c.Theme, c.Description, c.Committee, c.organization
FROM Call c
LEFT JOIN Proposal p ON c.id = p.call
WHERE p.call IS NULL AND c.Date_Finish > CURRENT_DATE;

/*
    VUE pour voir le nombre de propositions répondues par type d'organisme projet
*/

CREATE VIEW vNb_Proposal_Responsed AS
SELECT c.Organization, COUNT(p.Response) AS Nb_Response
FROM Call c
LEFT JOIN Proposal p ON c.id = p.Call
WHERE p.Response IS NOT NULL
GROUP BY c.Organization;

/*
    VUE pour voir le nombre de propositions acceptées par type d'organisme projet
*/

CREATE VIEW vNb_Proposal_Accepted AS
SELECT c.Organization, COUNT(p.Response) AS Nb_Accepted
FROM Call c
LEFT JOIN Proposal p ON c.id = p.Call
WHERE p.Response = 'acceptance'
GROUP BY c.Organization;

/*
    VUE pour voir le nombre de propositions répondues 
    par type d'organisme projet avec le nombre de projet accepté
*/

CREATE VIEW vNb_Proposal_Responsed_Accepted AS
SELECT vnpr.Organization, vnpr.Nb_Response, vnpa.Nb_Accepted
FROM vNb_Proposal_Responsed vnpr, vNb_Proposal_Accepted vnpa
WHERE vnpr.Organization = vnpa.Organization;

/*
    VUE pour voir le mois de l'année où on fait le plus de dépenses de projet au laboratoire
*/

CREATE VIEW vMonth_Expense AS
SELECT EXTRACT (MONTH FROM e.Date) AS Month, SUM(e.Amount) AS Expense
FROM Expense e
GROUP BY Month
ORDER BY Expense DESC;

/*
    VUE JSON pour voir les membres du laboratoire affectés au plus grand nombre de projet en cours (top 5)
*/

CREATE VIEW vActive_LabMembers AS
SELECT pm.member, p.Name #>> '{Last Name}' AS Last_Name, p.Name #>> '{First Name}' AS First_Name, COUNT(pm.project) AS Nb_Project
FROM vProjectCurrent vpc, LabMember lm, ProjectMember pm, Person p
WHERE vpc.id = pm.project AND p.id = lm.id AND lm.id = pm.member
GROUP BY pm.member, p.Name #>> '{Last Name}', p.Name #>> '{First Name}' 
ORDER BY Nb_Project DESC
LIMIT 5;

/*
    VUE JSON pour afficher toutes les adresses e-mail de tout le monde
*/
CREATE VIEW vPerson_Emails AS
SELECT p.Name #>> '{Last Name}' AS Last_Name, p.Name #>> '{First Name}' AS First_Name, pe.* 
FROM Person p, JSON_ARRAY_ELEMENTS(p.Email) pe;


/*
    TEST SUPPRESSION : La suppression d'une Proposal devrait entraîner 
    la suppression de tous les Budgets de cette Proposal.
    Le résultat attendu est nul.
*/

DELETE FROM Proposal WHERE Call = '1' AND PID = '1';
SELECT * FROM Budget WHERE Call = '1' AND Proposal = '1';

/*
    TEST MISE A JOUR  : Accepter une proposition.
*/

UPDATE Proposal set Date_response = CURRENT_DATE, Response = 'acceptance' WHERE call = '3' AND PID = '1';
SELECT * FROM Proposal WHERE call = '3' AND PID = '1';

/*
    TEST INSERTION : Impossible de créer deux projets depuis la même proposition.
	Le résultat attendu est une erreur.

INSERT INTO Proposal (call, PID, Date_submit, Date_response, Response, project) VALUES ('2', '3', '2015-05-09', '2015-05-29','acceptance', '9');
*/

/*
    TEST REQUETE : Afficher les propositions avec plus de deux labels.
*/

SELECT pl.call, pl.proposal, l.LegalEntity, COUNT(pl.label) AS Nb_Label
FROM Label l, ProposalLabel pl
WHERE l.Name = pl.label
GROUP BY pl.call, pl.proposal, l.LegalEntity
HAVING COUNT(pl.label) >= 2
ORDER BY pl.call, pl.proposal;

/*
    GESTION DES DROITS
*/

/*
-- Créer un utilisateur LuqinREN qui ne nécessite pas de mot de passe pour se connecter
CREATE ROLE LuqinREN LOGIN;
-- Créer des utilisateurs qui ont besoin d'un mot de passe pour se connecter
CREATE USER LuqinREN1 WITH PASSWORD 'rlq1';
CREATE USER Alice WITH PASSWORD 'alice';
CREATE USER Betty WITH PASSWORD 'betty';
CREATE USER Celine WITH PASSWORD 'celine';
CREATE USER Davide WITH PASSWORD 'davide';
CREATE USER Emma WITH PASSWORD 'emma';
-- Créer un utilisateur à durée limitée LuqinREN2
CREATE ROLE LuqinREN2 WITH LOGIN PASSWORD 'luqinluqinren' VALID UNTIL '2023-05-30';
-- Créer un administrateur utilisateur avec des autorisations pour créer des bases de données et gérer les rôles
CREATE ROLE admin WITH CREATEDB CREATEROLE;
-- Créer un utilisateur avec des super droits: spadmin
CREATE ROLE spadmin WITH SUPERUSER LOGIN PASSWORD 'spadmin';

-- Autorisation de toutes les tables
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA PUBLIC to LuqinREN;
-- Autorisation de table specifique
GRANT SELECT,INSERT,UPDATE,DELETE ON LegalEntity, LegalEntityOrganization, Organization to Alice;
GRANT SELECT,INSERT,UPDATE,DELETE ON Person, LabMember, EmployeeLE, EmployeeContact to Betty;
GRANT SELECT,INSERT,UPDATE,DELETE ON Call, Proposal, Project, Budget, Label, ProposalLabMember to Celine;
GRANT SELECT,INSERT,UPDATE,DELETE ON Call, Project, Budget, ProposalLabMember, Expense, ProjectMember to Davide;
-- Accorder différents droits en fonction de différentes colonnes de table
GRANT UPDATE (Date_response, Response, Project), INSERT(call, pid, date_submit) ON Proposal to Emma;

-- Autorisation des vues
GRANT SELECT ON vDoctor, vResearchEngineer, vTeacherResearcher TO PUBLIC;
GRANT ALL PRIVILEGES ON vCheckOrganizationLegalEntity TO Alice;
GRANT ALL PRIVILEGES ON vDoctor, vResearchEngineer, vTeacherResearcher, vCheckPersonLabMemberEmployeeLE, vCheckProposalLabMember, vActive_LabMembers TO Betty;
GRANT ALL PRIVILEGES ON vNb_Proposal_Responsed_Accepted, vNb_Proposal_Accepted, vNb_Proposal_Responsed, vCall_Without_Proposal, vCheckProposalLabMember TO Celine;
GRANT ALL PRIVILEGES ON vProjectCurrent, vProjectsHaveBudget, vProjectBudget, vProjectInternalMember, vProjectExpense TO Davide;
*/

/*
    RESUME : 16 tables et 18 vues en total
*/
