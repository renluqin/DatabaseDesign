# Note De Clarification - Gestion de projets de recherche

1. Contexte du Projet
2. Objectif
3. Acteurs du projet
4. Livrables
5. Contraintes technologiques
6. Risques
7. Reformulation du cahier des charges
-   7.1. Les différents objets
-   7.2. Caractéristiques des objets 
-   7.3. Remarques
8. Relations
9. Fonctionnalités du produit

## 1. Contexte du Projet

Un laboratoire de recherche veut créer un logiciel de base de données pour tenir à jour l'ensemble de ses projets de recherche.

Il existe plusieurs organismes de projet, créés par des financeurs (entreprise, pays, région, organisation). Les organismes projet publient des appels, sur un thème particulier, auquel répondent les laboratoires avec des propositions de projet, qui peuvent être acceptées ou refusées. Une proposition de projet est un document écrit, rédigé par des membres du laboratoire, avec un budget particulier. Si elle est acceptée, un projet est créé, avec le même budget que la proposition, mais des membres du laboratoire peut être différents. Le laboratoire veut suivre les dépenses du projet, en particulier pour chaque dépense qui l'a effectuée (forcément un membre du projet), le type de financement (fonctionnement ou matériel), et la date.

## 2. Objectif

Des objectifs bien précis sont spécifiés. En plus de créer une base de données efficace pour le laboratoire, il faudra porter un intérêt tout particulier sur les points suivant:

-	Gérer les informations liées aux projets et propositions de projet du laboratoire.
-	Gérer les informations des organismes projets, des appels à projets et des financeurs.
-	Gérer les informations des membres des projet, internes ou externes.
-	Permettre de réaliser des recherches sur les projets (comme les projets pour lesquels il reste du budget à dépenser, les projets en cours, les appels d'offre en cours non répondus, etc.) et des études statistiques (nombre de propositions répondues par type d'organisme projet avec le nombre de projet accepté, membres du laboratoire affectés au plus grand nombre de projet en cours, mois de l'année où on fait le plus de dépenses de projet au laboratoire, etc.)


## 3. Acteurs du projet

-   Client: l’Université de Technologie de Compiègne
-   Maître d’Ouvrage : CORREA-VICTORINO Alessandro
-   Maîtrise d’oeuvre : REN Luqin

## 4. Livrables

Les livrables attendus pour ce projet sont :

1. **NDC** : Note de clarification au format markdown

2. **MCD** : Modèle conceptuel de données au format .plantuml

3. **MLD** : Modèle logique de données

4. **BDD** : tables et vues, données de test, questions attendues (vues)

5. Il faudra intégrer : héritage, contraintes, composition, vues, requêtes statistiques (agrégats), normalisation, transaction et optimisation

Les livrables sont disponibles sur https://gitlab.utc.fr/renluqin/nf17_p20_29gestionprojet.

## 5. Contraintes technologiques

Le déploiement du projet doit se faire via une architecture LAPP sur les serveurs de l'UTC.
Je dois s’approprier les outils basiques de Linux via au choix : les postes de l’UTC,
l’installation d’un dual-boot ou d’une machine virtuelle. Il faudra aussi la prise en mains d'outils comme plantuml, postgresql et la rédiaction de fichier sous le format markdown.

## 6. Risques

J'ai identifié les risques suivants qui pourraient nuire à la réalisation du projet:

- Une mauvaise modélisation conceptuelle qui pourrait entraîner une corruption des données (pertes d’informations, une base de donnée non fonctionnelle).

- Des mauvais choix lors du passages aux relationnels qui complexifieront le problème. 

## 7. Reformulation du cahier des charges

Dans cette partie je vais détailler les différents objets, leurs attibruts, ainsi que les spécificité à prendre en compte pour chacun que j'ai analysé à la lecture du sujet. 

#### 7.1. Les différents objets

Voici la liste des objets que j'ai identifiés pour ce projet:

* **Person**

  * ProjectMember : Les membres du projet peuvent appartenir au laboratoire(Interne) ou à une autre entité juridique(Externe). ProjectMember a deux attributs, Position et Role. Position représente la fonction du membre dans le projet. Le rôle indique si le membre est interne ou externe.
  
  * EmployeeLE : employés d'entité juridique(Externe)
    
    * EmployeeContact qui hérite d'EmployeeLE
    
  * LabMember : employés du laboratoire(Interne)
    
    * TeacherResearcher qui hérite de LabMember
    
    * ResearchEngineer qui hérite de LabMember
    
    * Doctor qui hérite de LabMember
      
      Les employés du laboratoire peuvent être :des enseignants-chercheurs, des ingénieurs de recherche et des doctorants.Ces trois identités ne se chevauchent généralement pas, j'ai donc choisi l'héritage exclusif.


* **Organization**

  * Organization : Un organisme projet est créé à une date précise, pour une durée déterminée ou non. Il peut disparaître. Il a un nom, et plusieurs financeurs.

  * LegalEntity : entités juridiques(pays, région, ville, entreprise, laboratoire, etc.) qui ont une date de début et de fin d'activités (par exemple au dépôt de bilan d'une entreprise, où lors de la réaffectation de régions). 
  
  * Funder : financeurs qui hérite de LegalEntity

* **Project**

  * Call : Un appel à projet est lancé à une date donnée, pour une période de temps déterminée. L'appel à un thème, une description, et un comité de personnes qui le gèrent.

  * Proposal : Une proposition de projet a un budget. Une proposition est déposée sur un appel d'offre à une date donnée, et est rédigée par plusieurs membres du laboratoire. Une proposition peut avoir des labels. Une proposition a une date de réponse (refus ou acceptation).

  * Budget : composé de plusieurs lignes bugétaires chacune avec un montant, un objet global, et un type de financement (fonctionnement ou matériel).

  * OperatingBudget qui hérite exclusivement de Budget

  * MaterialBudget qui hérite exclusivement de Budget

  * Label : Une proposition peut avoir des labels, qui sont donnés par des entités juridiques.

  * Project : Un projet a une date de début, une date de fin et le budget demandé dans la proposition. Il a des contributeurs internes au laboratoire, mais parfois aussi externes. 
  
  * Expense : Les dépenses d'un projet sont réalisées à une date précise, pour un montant donné et un type de financement spécifique (matériel ou fonctionnement). Chaque dépense a un demandeur (celui qui demande la dépense), et un validateur (celui qui valide la dépense avant qu'elle soit effectuée). Le demandeur et le validateur font forcément partie des membres du projet. Un projet peut bien sûr avoir plusieurs demandeurs, mais aussi validateurs.

  * OperatingExpense qui hérite exclusivement de Expense

  * MaterialExpense qui hérite exclusivement de Expense

  Lors du projet, les dépenses effectuées ne peuvent pas dépasser pour chaque type le montant global du budget de la proposition, mais n'ont pas besoin d'être justifiées sur les lignes budgétaires de la proposition (elles ne sont là qu'à titre indicatif). C'est pourquoi OperatingExpense et OperatingBudget doivent être mis en correspondance, et MaterialExpense et MaterialBudget doivent être mis en correspondance, afin que le laboratoire puisse contrôler chaque type de budget et de dépense réel.

#### 7.2. Caractéristiques des objets

Dans la seconde partie je vais reprendre mes différents objets et donner leurs différentes caractéristiques.

**Person** 

- **ProjectMember** 
  - Position de type varchar
  - Role de type enumération : Internal ou External

- **EmployeeLE**
  - Name de type varchar
  - Telephone de type varchar
  - Email de type varchar

- **EmployeeContact**
  - Title de type varchar

- **LabMember** comme classe abstraite
  - Name de type varchar
  - Email de type varchar

- **Doctor**
  - Thesis_start_date de type date
  - Thesis_end_date de type date qui peut être nul
  - Thesis_subject de type varchar

- **TeacherResearcher**
  - Research_time_quota de type interger
  - Edu_establishment de type varchar

- **ResearchEngineer**
  - Specialty de type varchar

**Organization**

- **LegalEntity** comme classe abstraite
  - Name de type varchar qui est une clé
  - Start_Date de type date
  - End_Date de type date qui peut être nul
  - Type de type enumération : company ou country ou region ou city ou organization ou laboratory

- **Funder**
  - Name de type varchar qui est une clé locale

- **Organization**
  - Name de type varchar qui est une clé
  - Date_Creation de type date
  - Duration de type interger qui peut être nul

**Project**

- **Call**
  - Code de type varchar qui est une clé
  - Date_launch de type date
  - Duration de type interger
  - Theme de type varchar
  - Description de type varchar
  - Committee de type varchar
  - Expired() de type boolean : Les propositions doivent être enregistrées dans la période prédéterminée (Duration) par un appel. Ainsi, la fonction Expired() ici est utilisée pour vérifier si l'appel a expiré.

- **Proposal**
  - Date_submit de type date
  - Date_response de type date qui peut être nul
  - Response de type enumération : refusal ou acceptance
  - TotalBudget() : pour calculer le budget total de cette proposition

- **Budget** comme classe abstraite
  - Amount de type interger
  - Object de type varchar

- **OperatingBudget**

- **MaterialBudget**

- **Label**
  - Name de type varchar qui est une clé

- **Project**
  - Start_date de type date
  - End_date de type date
  - TotalBudget() de type interger : le montant global du budget de la proposition.
  - RestBudget() de type interger pour vérifier le budget restant pour le projet en cours
  - RestOperatingBudget() de type interger pour vérifier le budget de type opétation restant pour le projet en cours
  - RestMaterialBudget() de type interger pour vérifier le budget de type matétiel restant pour le projet en cours

- **Expense** comme classe abstraite
  - Date de type date
  - Amount de type interger 

- **OperationExpense**

- **MaterialExpense**

#### 7.3. Remarques

Lors du projet, les dépenses effectuées ne peuvent pas dépasser pour chaque type le montant global du budget de la proposition, mais n'ont pas besoin d'être justifiées sur les lignes budgétaires de la proposition (elles ne sont là qu'à titre indicatif). Chaque fois qu'une application est dépensée, vérifiez si le budget est suffisant.

Chaque dépense a un demandeur (celui qui demande la dépense), et un validateur (celui qui valide la dépense avant qu'elle soit effectuée). Ils ne peuvent pas être la même personne.

### 8. Relations

Ici je reprends toutes les relations.

- **ProjectMember** est composé de 0 à plusieurs **LabMember** et 0 à plusieurs **EmployeeLE**.

- **Organization** est créé par **Funder**

- **Funder** a une employée de contact (**EmployeeContact**)

- **Organization** peut publier 0 à plusieurs **Call**

- **Call** peut avoir 0 à plusieurs **Proposal**

- **Proposal** est écrit par **LabMember**

- Si une **Proposal** est acceptée, une **Project** peut être créé depuis ce **Proposal**

- **Proposal** peut avoir 0 à plusieurs **Budget**

- **Proposal** peut avoir 0 à plusieurs **Label**

- **Label** est donnée par **LegalEntity**

- La classe association **Expense** qui relie **Project** et **ProjectMember** (gestion des dépenses)


### 9. Fonctionnalités du produit

J'ai crée des vues pour faciliter la gestion du projets de recherche. 

Les vues que j'ai implementées sont les suivantes :

- vProject_Budget : vue pour voir les projets pour lesquels il reste du budget à dépenser

- vProject_Current : vue pour voir les projets en cours

- vCall_Without_Proposal : vue pour voir les appels d'offre en cours non répondus

- vNb_Proposal_Accepted : vue pour voir le nombre de propositions répondues par type d'organisme projet avec le nombre de projet accepté

- vActive_LabMembers : vue pour voir les membres du laboratoire affectés au plus grand nombre de projet en cours (top 30%)

- vMonth_Expense : vue pour voir le mois de l'année où on fait le plus de dépenses de projet au laboratoire

J'ai placé à la fin de mon SQL des Test qui permettent de vérifier des contraintes ainsi que des tests de mise à jour, de suppression, de requête.
