Contexte et objectifs

HealthTech Solutions (45 personnes) sort des versions assez souvent de son logiciel, et à ce rythme-là une validation 100% manuelle devient vite compliquée à tenir. Concrètement, soit on passe trop de temps à tester et on ralentit la livraison, soit on teste “moins” et on prend le risque de laisser passer des régressions. L’idée de l’automatisation, sur MediBook, c’est donc surtout de gagner en régularité et en vitesse, en sécurisant les parcours importants.

Les objectifs visés sont simples : faire tomber le temps de validation d’une release d’environ 5 jours à 1 jour, réduire clairement les régressions qui arrivent en prod (on part sur l’ordre de grandeur ~10/mois pour viser <2/mois), et atteindre autour de 60% de couverture automatisée, mais en restant pragmatique : on automatise surtout les parcours critiques (inscription / connexion / recherche / prise de RDV).

⸻

Périmètre de l’automatisation

L’automatisation ne doit pas tout faire. Si on essaie de tout automatiser, on se retrouve avec une suite énorme et pénible à maintenir. L’approche la plus logique, c’est de viser en priorité ce qui apporte le plus de valeur : ce qui est rejoué souvent et ce qui casse “cher”.

On peut découper l’automatisation en trois niveaux.

D’abord, les smoke tests, à exécuter en CI dès qu’on push ou qu’on ouvre une PR. Le but est de répondre rapidement à la question : “est-ce que l’appli est utilisable ?”. Sur MediBook, ça veut dire typiquement vérifier que le front répond, que les pages principales ne sont pas cassées, qu’on peut se connecter avec un compte de test, qu’une recherche simple renvoie quelque chose, et qu’on arrive bien jusqu’à une fiche praticien. C’est volontairement court, car si ces tests prennent 20 minutes, ils ne servent plus vraiment au quotidien.

Ensuite, il y a la régression fonctionnelle, plutôt sur main et/ou en nightly. Là on couvre des scénarios plus complets, ceux qu’on ne veut pas casser d’une release à l’autre : inscription (cas OK + email déjà utilisé), login patient existant, recherche avec résultat et recherche sans résultat, prise de rendez-vous et visibilité dans “Mes rendez-vous”. Si l’annulation existe, c’est aussi un bon test de régression (et souvent source de bugs). On ajoute aussi les contrôles de validation (champs obligatoires, messages d’erreur) parce que ce sont des points qui cassent facilement avec une modification UI.

Enfin, on garde les E2E complets (recette / pré-prod). C’est le niveau “parcours patient de bout en bout” : inscription → connexion → recherche → réservation → consultation du rendez-vous. Ça donne beaucoup de confiance, mais c’est plus long et plus sensible aux changements UI, donc ce n’est pas forcément ce qu’on lance 15 fois par jour. Par contre, avant une release candidate, c’est typiquement ce qui rassure.

⸻

Critères d’éligibilité : automatiser ou garder en manuel

Pour décider ce qu’on automatise, je pars sur des critères assez concrets. On automatise en priorité quand le test est répétitif (régression à chaque release), quand c’est critique pour le produit (login, prise de RDV, recherche), quand c’est stable (l’écran ne change pas toutes les semaines), et quand le résultat est déterministe (si on maîtrise les données, on sait exactement ce qu’on doit obtenir). Il faut aussi que le ROI soit bon : si un test est long/pénible à faire en manuel mais facile à automatiser, c’est un bon candidat.

À l’inverse, on garde du manuel quand la feature bouge énormément (refonte UX), quand il y a trop d’aléas (dépendances externes, résultats non prévisibles), ou quand c’est du test exploratoire / UX / accessibilité visuelle. L’automatisation ne remplace pas ça, elle enlève surtout la répétition.

⸻

Environnements cibles

Même si dans l’exercice on est surtout sur du local + CI, en vrai on raisonne souvent avec plusieurs environnements. En DEV local, on veut itérer vite : smoke + régression ciblée pour ne pas perdre une demi-journée à tester. En recette, on est souvent sur un environnement partagé où on valide de l’intégration : là on peut lancer une régression plus complète et des E2E. En pré-prod, c’est l’étape “release candidate”, avec des conditions proches de la prod : les E2E complets sont particulièrement utiles.

En termes d’exécution, une recommandation classique (et logique) c’est : smoke sur PR, smoke + régression sur main, et régression complète en nightly. Ça évite d’avoir une CI trop lente tout en gardant un filet de sécurité solide.

⸻

Choix de l’outil (et cohérence avec ce qu’on a fait)

Sur le papier, Playwright est souvent un bon choix (auto-waits, diagnostics, etc.). Mais dans notre projet, on a réellement mis en place Robot Framework + SeleniumLibrary, et c’est cohérent. Robot est lisible, surtout quand on veut que les scénarios soient “compréhensibles” et pas juste du code. SeleniumLibrary pilote un vrai navigateur, donc on valide l’app comme un utilisateur.

On a aussi structuré les tests avec un Page Object Model : les actions et les sélecteurs sont dans des fichiers POM, et les scénarios restent propres. Ça aide vraiment dès qu’un sélecteur change, parce qu’on corrige au même endroit au lieu de changer 15 tests.

Le point à surveiller avec Selenium, c’est la stabilité : il faut gérer correctement les waits (sinon on a des erreurs de clic intercepté, des éléments pas encore prêts, etc.). Donc la règle c’est : waits explicites, actions robustes, et si possible des sélecteurs stables (type data-testid).

⸻

Organisation, Agile et shift-left

En Agile, l’intérêt de l’automatisation est évident : on veut du feedback rapide à chaque incrément. L’idéal c’est que les tests fassent partie du flow de dev (la PR passe si les tests passent). Le risque, c’est d’avoir des tests fragiles si l’UI bouge trop. D’où l’importance d’un minimum de discipline : des sélecteurs stables, et une revue des impacts tests quand on modifie une page.

Le shift-left, c’est simplement “tester plus tôt”. Les unit tests / API tests donnent un feedback rapide, et les E2E viennent valider le parcours complet. Dans notre cas, on a surtout construit l’E2E (c’était l’attendu), mais la logique reste la même : obtenir un signal tôt, puis élargir.

⸻

Stratégie de données de test

Les E2E ne tiennent pas longtemps sans stratégie de données. Si on crée un compte une fois et qu’on relance le test, on tombe vite sur “email déjà utilisé”. Donc l’approche la plus simple et efficace, c’est de produire des identifiants uniques, par exemple un email de type e2e+<timestamp>@example.com. Ça évite les collisions et ça permet aussi d’identifier facilement ce qui vient des tests.

En CI, on veut quelque chose de reproductible. Comme l’appli tourne sur Docker Compose, on peut repartir d’un environnement propre à chaque run. Le “nettoyage” le plus fiable reste de reset l’environnement (volumes DB) en fin de pipeline. En local, on garde plutôt la DB pour ne pas perdre du temps, et on reset seulement si nécessaire.

Sur recette/pré-prod (si on en avait), on ne purge pas la DB globale : on utilise des comptes E2E dédiés et des données identifiables, et on nettoie ce qu’on crée (ou on prévoit une purge contrôlée).

⸻

Stratégie CI/CD, rapports et exploitation

Une pipeline simple et efficace suit toujours le même déroulé : installer/préparer, démarrer l’environnement (docker-compose), attendre que les services répondent, lancer les tests, puis publier les rapports. Le point important, c’est que les résultats soient exploitables : un rapport HTML et des logs détaillés, ça fait gagner énormément de temps quand un test échoue.

⸻

KPI et suite logique

Pour piloter l’automatisation, je surveillerais surtout la durée de la suite, le taux de réussite en CI et le flake rate (échecs “bizarres” non reproductibles). Et côté couverture, on raisonne en “parcours critiques couverts” plutôt qu’en nombre brut de tests.

La progression logique, c’est de commencer par un socle E2E fiable (ce qu’on a fait), puis d’ajouter une vraie suite smoke rapide, de compléter la régression (validations, cas négatifs, annulation si dispo), et seulement après de rajouter du volume. Ensuite, si l’API est stable, on peut rajouter des tests API plus rapides pour compléter le filet de sécurité.