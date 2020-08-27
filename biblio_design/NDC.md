# Note De Clarification - Bibliothèque

1. Contexte du Projet
2. Objectif
3. Acteurs du projet
4. Livrables
5. Contraintes technologiques
6. Risques
7. Reformulation du cahier des charges
   1. Les différents objets
   2. Caractéristiques des objets 
   3. Remarques
8. Relations
9. Fonctionnalités du produit
   1. Remarques

## 1. Contexte du Projet

Une bibliothèque municipale souhaite informatiser ses activités et nous sommes chargés de concevoir un système de gestion pour celle-ci. Devront être pris en compte le catalogage, les consultations, la gestion des utilisateurs, les prêts,... Nous définirons plus bas les besoins avancés.

## 2. Objectif

Des objectifs bien précis sont spécifiés. En plus de créer une base de données efficace pour la bibliothèque, il faudra porter un intérêt tout particulier sur les points suivant:

- Faciliter aux adhérents la recherche de documents et la gestion de leurs emprunts.

- Faciliter la gestion des ressources documentaires : ajouter des documents,

- modifier leur description, ajouter des exemplaires d'un document, etc.

- Faciliter au personnel la gestion des prêts, des retards et des réservation.

- Faciliter la gestion des utilisateurs et de leurs données.

- Établir des statistiques sur les documents empruntés par les adhérents, cela permettra par exemple d'établir la liste des documents populaires, mais aussi d'étudier le profil des adhérents pour pouvoir leur suggérer des documents.

## 3. Acteurs du projet

Client: l’Université de Technologie de Compiègne
Maître d’Ouvrage : CORREA-VICTORINO Alessandro
La maîtrise d’oeuvre est co-réalisée par : GRIMAL Paul, PENVERNE Léonard, REN Luqin, BASTA Ilan

## 4. Livrables

Les livrables attendus pour ce projet sont :

1. **README** comportant les noms des membres

2. **NDC** : Note de clarification au format markdown
   Organisation : PENVERNE Léonard
   Réalisation : l’équipe au complet lors d’une réunion
   Revue : BASTA Ilan

3. **MCD** : Modèle conceptuel de données au format .plantuml
   Organisation : GRIMAL Paul
   Réalisation : l’équipe au complet
   Revue: REN Luqin

4. **MLD** : Modèle logique de données
   Organisation : REN Luqin
   Réalisation: l’équipe au complet
   Revue: GRIMAL Paul

5. **BDD** : tables et vues, données de test, questions attendues (vues)
   Organisation: BASTA Ilan
   Réalisation: l’équipe au complet
   Revue: PENVERNE Léonard

6. Il faudra intégrer : héritage, contraintes, composition, vues, requêtes statistiques (agrégats), normalisation, transaction et optimisation

Les livrables sont disponibles sur https://gitlab.utc.fr/grimalpa/biblio_nf17.

## 5. Contraintes technologiques

Le déploiement du projet doit se faire via une architecture LAPP sur les serveurs de l'UTC.
L’équipe doit s’approprier les outils basiques de Linux via au choix : les postes de l’UTC,
l’installation d’un dual-boot ou d’une machine virtuelle. Il faudra aussi la prise en mains d'outils comme plantum, postgresql et la rédiaction de fichier sous le format markdown.

## 6. Risques

Nous avons identifié les risques suivants qui pourraient nuire à la réalisation du projet:

- Mauvaise organisation au sein du groupe, il faudra particulèrement faire attention à la gestion du délais (1 semaine).

- Une mauvaise modélisation conceptuelle qui pourrait entraîner une corruption des données (pertes d’informations, une base de donnée non fonctionnelle).

- Des mauvais choix lors du passages aux relationnels qui complexifieront le problème. 

- Mauvaise entente/compréhension entre les membres du groupe

## 7. Reformulation du cahier des charges

Dans cette partie nous allons  détaillés les différents objets, leurs attibruts, ainsi que les spécificité à prendre en compte pour chacun que nous avons analysé à la lecture du sujet. 

#### 1. Les différents objets

Voici la liste des objets que nous avons identifiés pour ce projet:

* Personne
  
  Nous avons défini qu'un utilisateur ne pouvait pas être un contributeur. 
  
  * Utilisateur qui hérite de Personne
    
    * Membre qui hérite d'utilisateur
    
    * Adhérent qui hérite d'utilisateur
      
      Adhesion qui est une agregation avec Adhesion : un Adherent peut avoir plusieurs Adhesion au cours de sa vie. Exemple : il peut s'être inscrit une année, puis ne pas avoir prolongé son abonnement. Des années après il peut revenir s'inscrire. Cette objet permet donc de garder une trace des multiples adhésions de cette personne.
  
  * Contributeur qui hérite de Personne
    
    * Auteur qui hérite de Contributeur
    
    * Compositeur qui hérite de Contributeur
    
    * Interprète qui hérite de Contributeur
    
    * Réalisateur qui hérite de Contributeur
    
    * Acteur qui hérite de Contributeur
      
      Il est important de noter que nous avons défini qu'un contributeur peu avoir plusieurs rôles de contributeur. Nous pouvons par exemple citer de nombreux acteurs qui sont aussi des réalisateurs.

* Ressource : cette objet est une représentation abstraite d'un livre, d'un film d'une musique. Ce n'est pas l'objet défini par ses supports. Exemple : _Germinal_ d'Emile Zola édition Hachette et non pas les livres _Germinal_ qui existe physiquement dans la bibliothèque. 
  
  * Livres qui hérite de Ressource
  
  * Acteur qui hérite de Ressource
  
  * Film qui hérite de Ressource
  
  * Language qui hérite de Ressource
  
  * Categorie qui hérite de Ressource

* Exemplaire : c'est la classe qui défini l'objet par son support. Exemple : 5 BD de Tintin _On a marché sur la Lune_.

* Langage : cet objet permet de définir la ou les langue(s) utilisée(s) dans une ressource.

* Categorie : cet objet permet de définir la ou les catégories dans lequel s'inscrit un objet. Exemple : Comédie, Tragédie, Pop, Jazz, Encyclopédie...

Nous avons identifié des classes d'associations :

- La classe d'association Reservation entre Adherent et Exemplaire : cet objet doit permettre la reservation de document par des Adherents. 

- La classe d'association Pret entre Adherent et Exemplaire : cet objet doit permettre le pret de documents par des Adherents.

- La classe d'association Sanction entre Membre et Adherent : cet objet doit permettre de sanctionner les Adherents qui ne respectent pas les conditions d'utilisation de la bibilothèque (retard, dégradation,...)

Dans la seconde partie nous allons reprendre nos différents objets et donner leurs différentes caractéristiques.

#### 2. Caractéristiques des objets

**Ressource** comme classe abstraite

- **Code** de type varchar qui est une _clef_

- Titre de type varchar

- Date_apparation de type date

- Editeur de type varchar. Exemple : Hachette, Universal Studio

- Code de classification de type varchar (de longueur normalisée)

- Prix de type float. Prix d'achat de la ressource

- est_libre() : Methode qui permet de verifier qu'il existe un exemplaire qui n'est pas perdu, abime, emprunté ou reservé.
  
  **Catégorie** relation simple (N:M) avec **Ressource**
  
  - genre de type varchar
  
  - **Livre** hérité de Ressource
    
    - ISBN de type int
    
    - Resume de type varchar
  
  - **Film** hérité de Ressource
    
    - Duree de type int
    
    - Synopsis de type varchar
  
  - **Musique** hérité de Ressource
    
    - Duree de type int
  
  - **Langage** comme classe liée à Ressource (N:M)
    
    - langue de type varchar

**Catégorie** relation simple (N:M) avec **Ressource**

- Genre de type varchar qui est une _clef_

**Langage** relation simple (N:M) avec **Ressource**

- Langue de type varchar qui est une _clef_

Voyons maintenant les classes files de **Ressource**.

**Livre**

- ISBN de type varchar qui est une _clef_
- Resume de type varchar

**Film**

- Duree de type integer

- Un synopsis de type varchar

**Musique**

- Duree de type integer

**Exemplaire** est une composition avec **Ressource**. **Exemplaire** est le composant et **Ressource** est le composite. 

- Etat de type énumération avec {neuf, bon, abime, perdu}

**Personne** comme classe abstraite.

- Nom comme varchar

- Prénom comme varchar

- Date_naisance de type date
  
  **Contributeur** qui hérite de personne est une classe abstraite
  
  - Id de type varchar qui est une _clef_
  
  - Nom de type varchar
  
  - Prenom de type varchar
  
  - Date_naissance de type date
  
  - Nationalité de type varchar 
  
  **Utilisateur** est elle aussi une classe abstraite.
  
  - Login de type varchar et qui est une *clef*
  
  - Password de type varchar
  
  - Adresse de type varchar

- Email de type varchar qui est une _clef_

5 classes héritent de contributeur. Elle ne possède pas d'attribut. L'héritage n'est pas exclusif.

- **Auteur**

- **Réalisateur**

- **Acteur**

- **Compositeur**

- **Interprète**

Nous avons trouvé deux classes qui héritent de manière exclusive d'**Utilisateur** :

- **Membre** du personnel
  
  - +blaclister(Adherent) : cette méthode permet de blacklister un Adherent

- **Adhérent**
  
  - Nocarte de type int 
  
  - Telephone de type int
  
  - Blacklist de type boolean
  
  - +nombre_sanction() : retourne le nombre de sanction de l'Adherent
  
  - +méthode_nombredemprunts() : retourne le nombre d'emprunt actuellement de l'Adherent
  
  - +peut_emprunter() : si le nombre d'emprunt actuel est infèrieur à 10 et que l'adherent est acquitté de toute ses sanctions (toutes les Date_Acquittement < date_actuelle) et qu'il n'emprunte pas cette oeuvre en ce moment même et que l'exemplaire n'est pas réservé et que l'oeuvre n'est pas dans un état abimé ou perdu, alors la fonction retourne un True, sinon False. *(Voir Pret et Reservation)*
  
  - +emprunter() : fonction d'emprunt d'une oeuvre qui fait appel à la fonction peut_emprunter. *(Voir Pret et Reservation)*
  
  - peut_reserver() : si le nombre de reservation actuel est infèrieur à 4 et que l'adherent est acquitté de toute ses sanctions (toutes les Date_Acqguittement < date_actuelle) et qu'il ne réserve pas déjà cette oeuvre actuellement et qu'il n'emprunte pas déjà cette oeuvre actuellement, alors la fonction retourne un True, sinon False. *(Voir Pret et Reservation)*
  
  - +reserver() : fonction qui permet de reserver une oeuvre utilisant la fonction peut_reserver() pour être sûr qu'il respecte les conditions. *(Voir Pret et Reservation)*

La classe **Adhésion** est une agrégation avec **Adherent**. C'est une relation 1:N. Un Adherent peut avoir plusieurs Adhésion au cours de sa vie. Une Adhésion a un Adhérent. Ses attributs sont : 

- Debut de type date

- Fin de type date, cet attribut peut être nul tant l'**Adherent** a son abonnement à la bibliothèque

Nous avons une classe d'association entre **Membre** et **Adherent** : la classe Sanction. Celle ci est composé des attributs suivants :

- Id de type varchar qui est ue _clef_

- Date_Sanction de type date

- Type de type enumeration {Perte, Degradation, Retard}

- Date_Acquittement de type date. C'est le moment ou la personne s'acquitte de son dû (exemples : remboursement de l'oeuvre dégradé, fin de sa période de bannissement pour le retard, ...). Cette date marque le retour à la normale des activités de l'adhérent dans la bibliothèque. Il peut à nouveau jouir des droits d'emprunter et de réserver des oeuvres.

- Prix de type float qui peut être nul. En effet dans le cas d'un retard de prêt la personne n'a pas à rembourser l'exemplaire.

Nous avons créer une classe association **Pret** et **Reservation** entre **Exemplaire** et **Adherent**. Voici le détail de ces classes.

La classe association **Prêt** :

- Time_pret de type date. Elle marque le moment où le livre est emprunté par l'utilisateur.

- Time_retour: de type date. C'est la date où l'adherent rend l'oeuvre. Cette attribut peut être NULL. En effet tant que le l'oeuvre n'est pas rendu, on n'a pas de date de retour sur NULL.

- +méthode_emprunt()

- +duree_Pret() : retourne la date limite du retour du prêt. Un délai limite est en effet mis en place par la bibiliothèque. Un article ne peut pas être emprunté indéfiniment. 
  
  Pour cette classe il est essentielle de noter que nous avons une relation N:M. Nous avons mis en place cela car il est important pour la bibliothèque de pouvoir, à partir des emprunts des utilisateurs, mettre en place un système de recommendation. Pour cela il faut conserver un historique des emprunts, et non pas juste quand une oeuvre est rendue, supprimer l'emprunt de la base de donnée. Nous avons fait le choix dans notre UML de mettre une relation 0..\*. Mais nous faisons le choix de limiter le nombre d'emprunts à 10 oeuvres. Cette limitation se fera donc par la méthode *peut_emprunter()* qui est dans la classe Adherent.  Il faut aussi noter qu'une dégradation est considéré à partir du moment où un exemplaire d'une oeuvre est rendu dans un état abimé. Un exemplaire d'une oeuvre ne peut pas être emprunté ou réservé si son état est perdu ou abimé.

Classe association **Reservation** entre Exemplaire et Adherent

- Time_demande  de type date.

- Time_disponible de type date, peut etre NULL tant qu'un exemplaire de l'oeuvre n'est pas disponible.

- +Res_Depassee( ) : si la reservation est disponible depuis un certain temps  et que l'utilisateur ne l'a pas cherché, la réservation est supprimé.
  
  Une reservation une fois qu'elle est est cherché par un adhérent est supprimé de la table de reservation.

#### 3. Remarques

Nous avons défini qu'à partir de 5 sanctions, un adhérent serait blacklisté. Il peut aussi être blacklister par un adhérent sans avoir eu 5 sanctions.

Le nombre de réservation disponible pour un adherent est de 4 et son nombre d'emprunts de 10.

Notre système mis en place permet de garder un historique des adhésions passés ainsi que de tous les emprunts.

Pour gérer la popularité des documents, on utilisera un vue par rapport au nombre d'emprunt des ressources (en prenant en compte les exemplaires similaires). On ordonera de façon décroissantes. On affichera si l'oeuvre est emprunté plus de 20 fois.

Pour avoir les documents disponible il faudra chercher le nombre d'exemplaire d'une oeuvre et vérifier qu'au moins un des exemplaires n'es ni emprunté, ni réservé, ni abimé ou perdu.

### 8. Relations

Ici nous reprenons toutes les relations.

- Acteurs, Auteur, Réalisateur, Compositeurs, Interprètes héritées de Contributeur

- Plusieurs acteurs peuvent jouer dans plusieurs films et plusieurs film peut être tourné avec plusieurs acteurs

- Plusieurs auteurs peuvent écrire plusieurs livres et plusieurs livres peuvent être écrits par plusieurs auteurs

- Plusieurs réalisateurs peuvent réaliser plusieurs films et inversement

- Plusieurs compositeurs peuvent et composer plusieurs musiques et inversement

- Plusieurs interprètes peuvent jouer plusieurs musiques et inversement

- Adhérent et Personnel héritées d'Utilisateur

- Adhésion est une classe liée par agrégation à Adhérent. Le choix de l'agrégation se fait pour garder une trace des adhésions

- La classe association prêt qui relie Adhérent et Exemplaire (gestion des emprunts)

- La classe association réservation qui relie Exemplaire et Adhérent (gestion des réservations)

- La classe Language reliée à ressource (N:M) car un livre peut être en plusieurs langues, tout comme une musique ou un film.

- La classe association Sanction est relié à la classe Membre et Adherent.

### 9. Fonctionnalités du produit

Nous avons crée des vues pour faciliter l'utilisation de la bibliothèque. 

Les vues que nous implementons sont les suivantes :

- vEmprunts_actuels : vue pour voir les emprunts qui ne sont pas rendu par les Adhérent de la bibliothèque.

- vHistorique : vue pour voir l'historique des emprunts d'un adhérent

- vNb_Emprunts_Actuels_Par_Personne : vue permettant de voir le nombre d'empruntd actuels par personne

- vTendances : on affiche le nombre de fois qu'une oeuvre est emprunté du plus emprunté au moins emprunté.

- vSanctionNonAcquitte : on affiche les personnes qui ne se sont pas acquitté de leur sanction.

- vBLACKLIST : on affiche les personnes blacklistées par la bibliothèque.

- vAdherent_Avoir_Droit_Pret : on affiche les personnes qui peuvent emprunter dans la bibliothèque, qui sont non blacklistées, non sanctionnées et dont le nombre de documents en main est inférieur à 10.

- vCheckRessourceExemplaire : vue pour vérifier le nombre d'exemplaire par ressources

- vCheckRessourceReference : vue pour respecter les contraintes d'héritage de Ressources

- vExemplaireDisponible : vue pour regarder les exemplaires disponibles 

Nous avons placé à la fin de notre SQL des Test qui permettent de vérifier des contraintes ainsi que des tests de mise à jour, de suppression, de requête.
