ECF – MediBook – Tests E2E Robot Framework (Local + CI)
======================================================

Ce dépôt contient des tests End-to-End (E2E) pour l’application MediBook, écrits avec Robot Framework et SeleniumLibrary (pattern Page Object Model).
Les tests peuvent être exécutés :
- en local (application MediBook lancée via Docker Compose)
- en CI via GitHub Actions (exécution automatique + rapports téléchargeables)

------------------------------------------------------------
1) PRÉREQUIS (LOCAL)
------------------------------------------------------------

Outils nécessaires :
- Docker + Docker Compose
- Python 3 + pip

Installer Robot Framework + SeleniumLibrary :
  pip install robotframework robotframework-seleniumlibrary

Remarque :
En CI, le navigateur est fourni via un conteneur Selenium.
En local, si vous exécutez les tests en Chrome “local”, Chrome/chromedriver peuvent être nécessaires selon votre machine.

------------------------------------------------------------
2) EXÉCUTION EN LOCAL
------------------------------------------------------------

2.1 Démarrer l’application MediBook (Docker)
Depuis la racine du dépôt :
  ./medibook-tests/scripts/setup.sh

Ce script :
- démarre la stack MediBook via Docker Compose
- attend que le frontend réponde sur http://localhost:3000

Vérification :
- Frontend : http://localhost:3000

2.2 Lancer les tests Robot

Lancer tous les tests :
  robot -d medibook-tests/results medibook-tests/tests

Lancer un test spécifique (ex : test 01) :
  robot -d medibook-tests/results medibook-tests/tests/01_registration.robot

2.3 Consulter les rapports (local)

Les rapports sont générés dans :
- medibook-tests/results/log.html
- medibook-tests/results/report.html
- medibook-tests/results/output.xml

Sur macOS :
  open medibook-tests/results/log.html

2.4 Arrêter l’environnement MediBook

Stop (conserve la DB / les données) :
  ./medibook-tests/scripts/teardown.sh local

Stop + reset complet (supprime volumes / DB) :
  ./medibook-tests/scripts/teardown.sh ci

Note :
Si vous lancez ./medibook-tests/scripts/teardown.sh sans argument, le mode "local" est utilisé (par défaut).

------------------------------------------------------------
3) EXÉCUTION EN CI (GITHUB ACTIONS)
------------------------------------------------------------

Le workflow GitHub Actions exécute automatiquement les tests :
- à chaque push
- à chaque pull request

Fonctionnement du pipeline :
1) Checkout du dépôt
2) Démarrage de MediBook via Docker Compose
3) Démarrage d’un navigateur Chrome via selenium/standalone-chrome
4) Exécution des tests Robot via Remote WebDriver
5) Publication des rapports Robot en Artifacts

3.1 Récupérer les rapports en CI

Après un run :
1) GitHub → onglet Actions
2) Ouvrir le run du workflow
3) Descendre à la section Artifacts
4) Télécharger l’artifact "robot-results"

Le zip contient :
- log.html
- report.html
- output.xml

------------------------------------------------------------
4) COMMANDES RAPIDES
------------------------------------------------------------

Local (start → test → stop) :
  ./medibook-tests/scripts/setup.sh
  robot -d medibook-tests/results medibook-tests/tests
  ./medibook-tests/scripts/teardown.sh local

Reset complet (start → test → stop + DB reset) :
  ./medibook-tests/scripts/setup.sh
  robot -d medibook-tests/results medibook-tests/tests
  ./medibook-tests/scripts/teardown.sh ci