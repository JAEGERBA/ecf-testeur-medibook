# ECF - Automatisation des Tests Logiciels

## Titre de l'épreuve
**Mise en place de l'automatisation des tests pour l'application MediBook**

**Durée : 1 jour (7 heures)**

---

## 1. CONTEXTE

### L'entreprise : HealthTech Solutions

Startup française de 45 collaborateurs spécialisée dans les solutions numériques de santé. L'équipe QA réalise actuellement tous les tests manuellement et n'arrive plus à suivre le rythme des livraisons.

### Objectifs

| Indicateur | Situation actuelle | Objectif |
|------------|-------------------|----------|
| Temps de validation par release | 5 jours | 1 jour |
| Régressions détectées en production | ~10/mois | < 2/mois |
| Couverture de tests automatisés | 0% | 60% |

### L'application : MediBook

Application web de prise de rendez-vous médicaux en ligne.

**Fonctionnalités principales :**
- Inscription et connexion des patients
- Recherche de praticiens par spécialité et ville
- Prise de rendez-vous en ligne
- Gestion des rendez-vous (consultation, annulation)

**Stack technique :**
- Frontend : React.js
- Backend : Node.js / Express
- Base de données : PostgreSQL
- CI/CD : GitLab CI ou GitHub Actions (au choix)

---

## 2. TRAVAIL DEMANDÉ

Vous devez produire **3 livrables** démontrant votre capacité à mettre en place une automatisation des tests.

---

### LIVRABLE 1 : Stratégie d'automatisation
**Compétences évaluées : C.3.1.1 et C.3.1.2**

Rédigez un document (5-8 pages) contenant :

**A. Périmètre de l'automatisation**
- Types de tests à automatiser (smoke, régression, E2E)
- Critères d'éligibilité : comment décider si un test doit être automatisé ?
- Environnements cibles (DEV, RECETTE, PRE-PROD)
- Choix de l'outil d'automatisation avec justification

**B. Organisation**
- Analyse de l'organisation Agile : avantages et inconvénients pour l'automatisation
- Intégration du shift-left testing
- Utilisation du BDD avec Gherkin

---

### LIVRABLE 2 : Scripts d'automatisation
**Compétence évaluée : C.3.2.1**

Développez des scripts de tests automatisés pour les 3 scénarios suivants :

#### Scénario 1 : Inscription d'un patient

```gherkin
Fonctionnalité: Inscription patient

  Scénario: Inscription réussie
    Etant donné que je suis sur la page d'inscription
    Quand je saisis "Test" dans le champ "Prénom"
    Et je saisis "Automatise" dans le champ "Nom"
    Et je saisis "test.auto@email.com" dans le champ "Email"
    Et je saisis "Password123!" dans le champ "Mot de passe"
    Et je saisis "Password123!" dans le champ "Confirmer le mot de passe"
    Et je coche "J'accepte les CGU"
    Et je clique sur "Créer mon compte"
    Alors je vois le message "Compte créé avec succès"

  Scénario: Inscription échouée - Email déjà utilisé
    Etant donné que je suis sur la page d'inscription
    Quand je saisis un email déjà existant "jean.dupont@email.com"
    Et je remplis les autres champs correctement
    Et je clique sur "Créer mon compte"
    Alors je vois le message d'erreur "Email déjà utilisé"
```

#### Scénario 2 : Recherche de praticien

```gherkin
Fonctionnalité: Recherche de praticien

  Scénario: Recherche par spécialité et ville
    Etant donné que je suis sur la page de recherche
    Quand je sélectionne "Médecin généraliste" dans le filtre spécialité
    Et je saisis "Paris" dans le champ ville
    Et je clique sur "Rechercher"
    Alors je vois une liste de praticiens
    Et chaque résultat affiche le nom, la spécialité et la ville

  Scénario: Recherche sans résultat
    Etant donné que je suis sur la page de recherche
    Quand je recherche un "Cardiologue" à "Village Inexistant"
    Alors je vois le message "Aucun praticien trouvé"
```

#### Scénario 3 : Prise de rendez-vous

```gherkin
Fonctionnalité: Prise de rendez-vous

  Scénario: Réservation d'un créneau
    Etant donné que je suis connecté comme patient
    Et que je suis sur la page du Dr. Claire Martin
    Quand je sélectionne une date disponible
    Et je sélectionne un créneau horaire
    Et je clique sur "Confirmer le rendez-vous"
    Alors je vois le message "Rendez-vous confirmé"
    Et le rendez-vous apparaît dans "Mes rendez-vous"
```

**Exigences techniques :**
- Utiliser un framework d'automatisation (Cypress, Playwright, ou Selenium)
- Appliquer le pattern Page Object Model
- Documenter le code avec des commentaires
- Les scripts doivent s'exécuter sans erreur

---

### LIVRABLE 3 : Intégration CI/CD et gestion des données
**Compétences évaluées : C.3.2.2, C.3.2.3, C.3.3.1, C.3.3.2**

**A. Gestion des données de test**

Fournissez :
- Un script de création des données de test (setup)
- Un script de nettoyage après exécution (teardown)
- Une stratégie pour gérer les données sur différents environnements

**B. Intégration CI/CD**

Fournissez un fichier de configuration CI pour **GitLab CI** ou **GitHub Actions** (au choix) permettant :
- L'exécution automatique des tests sur un push
- La génération d'un rapport de résultats
- La définition des étapes : install → test → report

| Plateforme | Fichier à fournir |
|------------|-------------------|
| GitLab CI | `.gitlab-ci.yml` |
| GitHub Actions | `.github/workflows/tests.yml` |

**C. Gestion de version**

Décrivez :
- La structure du repository Git pour les tests
- La stratégie de branching
- La procédure de rollback en cas de problème

---

## 3. RESSOURCES

### Application MediBook

L'application est fournie et se lance avec Docker :

```bash
cd medibook
docker-compose up -d
```

| Service | URL |
|---------|-----|
| Application | http://localhost:3000 |
| API | http://localhost:4000 |
| Documentation API | http://localhost:4000/api-docs |
| Emails (Mailhog) | http://localhost:8025 |

### Comptes de test

| Profil | Email | Mot de passe |
|--------|-------|--------------|
| Patient existant | jean.dupont@email.com | Patient123! |
| Praticien | dr.martin@medibook.fr | Praticien123! |

### Pages principales à tester

| Page | URL |
|------|-----|
| Accueil | http://localhost:3000 |
| Inscription | http://localhost:3000/register |
| Connexion | http://localhost:3000/login |
| Recherche | http://localhost:3000/search |
| Détail praticien | http://localhost:3000/practitioners/{id} |
| Mes rendez-vous | http://localhost:3000/appointments |

---

## 4. LIVRABLES ATTENDUS

À rendre en fin de journée :

| Livrable | Format |
|----------|--------|
| Document de stratégie | PDF ou Markdown (5-8 pages) |
| Scripts d'automatisation | Dossier avec code source |
| Configuration CI/CD | `.gitlab-ci.yml` ou `.github/workflows/tests.yml` |
| Scripts de données | Fichiers SQL ou JavaScript |
| README | Instructions pour exécuter les tests |

---

## 5. CONSEILS

1. **Commencez par lancer l'application** et explorez-la manuellement
2. **Rédigez la stratégie en premier** (1h30 max)
3. **Concentrez-vous sur des scripts qui fonctionnent** plutôt que sur la quantité
4. **Testez vos scripts régulièrement** pendant le développement
5. **Documentez au fur et à mesure**

**Bon courage !**
