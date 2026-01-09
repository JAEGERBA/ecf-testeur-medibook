Pour des tests E2E fiables, il faut maîtriser l’état de l’application (comptes, rendez-vous, etc.). Dans notre projet, MediBook tourne via Docker Compose (frontend + API + PostgreSQL), ce qui permet de contrôler l’environnement et de repartir facilement d’un état propre.

1) Principes
	•	Données dynamiques : quand un test doit créer un compte (inscription), on utilise des identifiants uniques (ex. email e2e+<timestamp>@example.com) pour éviter les collisions “email déjà utilisé”.
	•	Isolation : chaque scénario Robot doit être autonome (pas de dépendance entre tests). Si une connexion est nécessaire, elle est faite dans le scénario.
	•	Données identifiables : le préfixe e2e+ permet de repérer les données générées par l’automatisation.

2) Local vs CI
	•	Local (dev) : on peut conserver les volumes Docker pour itérer vite. Les tests restent robustes grâce aux données uniques. Si l’état devient “sale”, on peut faire un reset complet manuellement.
	•	CI (GitHub Actions) : on vise la reproductibilité. L’environnement est éphémère et on garantit une base propre à chaque run en supprimant les volumes en fin de job (reset PostgreSQL).

3) Setup / Teardown utilisés
	•	setup.sh : démarre la stack Docker Compose et attend que le frontend soit accessible.
	•	teardown.sh local : stoppe les conteneurs sans supprimer la base (volumes conservés).
	•	teardown.sh ci : stoppe les conteneurs et supprime les volumes (down -v) → nettoyage complet des données (DB reset), idéal en CI.

Cette stratégie est cohérente avec notre implémentation : tests Robot + application en Docker, et garantit des exécutions stables en CI tout en restant pratique en local.