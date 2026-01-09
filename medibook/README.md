# MediBook - Application de Prise de Rendez-vous Médicaux

Application web complète pour la prise de rendez-vous médicaux en ligne, développée dans le cadre de l'ECF "Automatisation des Tests Logiciels".

## 📋 Description

MediBook permet aux patients de :
- Rechercher des praticiens par spécialité et localisation
- Consulter les disponibilités en temps réel
- Prendre rendez-vous en ligne 24h/24
- Gérer leurs rendez-vous (consultation, annulation)
- Recevoir des confirmations par email

## 🏗️ Architecture

```
medibook/
├── frontend/          # Application React
├── backend/           # API Node.js/Express
├── database/          # Scripts SQL
└── docker-compose.yml # Orchestration Docker
```

## 🚀 Installation et Démarrage

### Prérequis

- Docker et Docker Compose
- Node.js 18+ (pour le développement local)

### Démarrage rapide

```bash
# Cloner le projet
git clone <repository-url>
cd medibook

# Lancer tous les services
docker-compose up -d

# Vérifier que tout fonctionne
docker-compose ps
```

### Accès aux services

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost:3000 | Application React |
| API | http://localhost:4000 | Backend Node.js |
| Swagger | http://localhost:4000/api-docs | Documentation API |
| Mailhog | http://localhost:8025 | Interface emails |
| PostgreSQL | localhost:5432 | Base de données |

## 👥 Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Patient | jean.dupont@email.com | Patient123! |
| Praticien | dr.martin@medibook.fr | Praticien123! |
| Admin | admin@medibook.fr | Admin123! |

## 🔧 Configuration

### Variables d'environnement Backend

```env
NODE_ENV=development
PORT=4000
DATABASE_URL=postgresql://medibook:medibook123@db:5432/medibook
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=24h
SMTP_HOST=mailhog
SMTP_PORT=1025
FRONTEND_URL=http://localhost:3000
```

### Variables d'environnement Frontend

```env
REACT_APP_API_URL=http://localhost:4000/api
```

## 📚 API Documentation

La documentation Swagger est disponible sur `/api-docs`.

### Endpoints principaux

#### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/me` - Profil utilisateur

#### Praticiens
- `GET /api/practitioners` - Recherche de praticiens
- `GET /api/practitioners/:id` - Détails d'un praticien
- `GET /api/practitioners/:id/slots` - Créneaux disponibles

#### Rendez-vous
- `GET /api/appointments` - Liste des RDV
- `POST /api/appointments` - Créer un RDV
- `PUT /api/appointments/:id/cancel` - Annuler un RDV

#### Spécialités
- `GET /api/specialties` - Liste des spécialités

## 🧪 Tests

### Scénarios de test à automatiser

1. **Inscription Patient**
   - Créer un compte avec des données valides
   - Vérifier l'envoi de l'email de confirmation

2. **Connexion**
   - Se connecter avec des identifiants valides
   - Redirection vers le dashboard

3. **Recherche Praticien**
   - Rechercher par spécialité et ville
   - Vérifier les résultats affichés

4. **Prise de Rendez-vous**
   - Sélectionner un praticien
   - Choisir une date et un créneau
   - Confirmer la réservation

5. **Accessibilité**
   - Navigation au clavier
   - Compatibilité lecteur d'écran
   - Conformité WCAG 2.1 AA

## 🔐 Sécurité

- Authentification JWT
- Hashage des mots de passe (bcrypt)
- Validation des entrées
- Protection CSRF
- Headers de sécurité (Helmet)

## 📱 Responsive Design

L'application est responsive et s'adapte aux différentes tailles d'écran :
- Mobile (< 640px)
- Tablette (640px - 1024px)
- Desktop (> 1024px)

## ♿ Accessibilité

- Labels ARIA appropriés
- Navigation au clavier
- Contrastes suffisants
- Messages d'erreur explicites
- Skip links

## 🌱 Éco-conception

- Optimisation des requêtes
- Lazy loading des images
- Minimisation des ressources
- Cache côté client

## 📝 License

Ce projet est développé dans un cadre éducatif (ECF).

---

**HealthTech Solutions** - © 2024
