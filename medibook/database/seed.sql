-- ============================================
-- MediBook - Données de test (Seed)
-- UUID générés par PostgreSQL
-- ============================================

-- ============================================
-- SPÉCIALITÉS MÉDICALES
-- ============================================
INSERT INTO specialties (name, description, icon) VALUES
('Médecin généraliste', 'Médecine générale et soins primaires', 'stethoscope'),
('Dermatologue', 'Spécialiste de la peau et des maladies cutanées', 'hand'),
('Cardiologue', 'Spécialiste du cœur et du système cardiovasculaire', 'heart'),
('Ophtalmologue', 'Spécialiste des yeux et de la vision', 'eye'),
('Dentiste', 'Soins dentaires et bucco-dentaires', 'tooth'),
('Kinésithérapeute', 'Rééducation et thérapie physique', 'activity'),
('Psychologue', 'Santé mentale et accompagnement psychologique', 'brain'),
('Pédiatre', 'Médecine des enfants et adolescents', 'baby'),
('Gynécologue', 'Santé de la femme et suivi gynécologique', 'heart-pulse'),
('ORL', 'Spécialiste oreilles, nez et gorge', 'ear');

-- ============================================
-- UTILISATEURS
-- Mot de passe hashé commun (bcrypt)
-- ============================================

-- Patients
INSERT INTO users (
  email, password_hash, role,
  first_name, last_name, phone,
  date_of_birth, gender, address,
  city, postal_code, is_active, is_verified
) VALUES
(
  'jean.dupont@email.com',
  '$2b$10$rQZ5xzPVZOxKOLXXbQCXhOqJ5XYZ.ABCDEFGHIJKLMNOP',
  'patient',
  'Jean', 'Dupont', '0612345678',
  '1985-03-15', 'male',
  '12 rue de la Paix', 'Paris', '75001',
  true, true
),
(
  'marie.martin@email.com',
  '$2b$10$rQZ5xzPVZOxKOLXXbQCXhOqJ5XYZ.ABCDEFGHIJKLMNOP',
  'patient',
  'Marie', 'Martin', '0623456789',
  '1990-07-22', 'female',
  '45 avenue Victor Hugo', 'Lyon', '69001',
  true, true
),
(
  'pierre.durand@email.com',
  '$2b$10$rQZ5xzPVZOxKOLXXbQCXhOqJ5XYZ.ABCDEFGHIJKLMNOP',
  'patient',
  'Pierre', 'Durand', '0634567890',
  '1978-11-08', 'male',
  '8 boulevard Gambetta', 'Marseille', '13001',
  true, true
),
(
  'lucas.petit@email.com',
  '$2b$10$rQZ5xzPVZOxKOLXXbQCXhOqJ5XYZ.ABCDEFGHIJKLMNOP',
  'patient',
  'Lucas', 'Petit', '0656789012',
  '2000-09-10', 'male',
  '67 rue Nationale', 'Lille', '59000',
  true, false
);

-- Praticiens (users)
INSERT INTO users (
  email, password_hash, role,
  first_name, last_name, phone,
  date_of_birth, gender, is_active, is_verified
) VALUES
(
  'dr.martin@medibook.fr',
  '$2b$10$sRZ6yzQVZPyLPMYYcRDYiPrK6YZA.BCDEFGHIJKLMNOPQ',
  'practitioner',
  'Claire', 'Martin', '0601020304',
  '1975-06-20', 'female', true, true
),
(
  'dr.dubois@medibook.fr',
  '$2b$10$sRZ6yzQVZPyLPMYYcRDYiPrK6YZA.BCDEFGHIJKLMNOPQ',
  'practitioner',
  'François', 'Dubois', '0602030405',
  '1968-12-05', 'male', true, true
),
(
  'dr.leroy@medibook.fr',
  '$2b$10$sRZ6yzQVZPyLPMYYcRDYiPrK6YZA.BCDEFGHIJKLMNOPQ',
  'practitioner',
  'Isabelle', 'Leroy', '0603040506',
  '1980-04-18', 'female', true, true
);

-- Admin
INSERT INTO users (
  email, password_hash, role,
  first_name, last_name, phone,
  is_active, is_verified
) VALUES (
  'admin@medibook.fr',
  '$2b$10$tSZ7zaRWZQzMQNZZdSEZjQsL7ZAB.CDEFGHIJKLMNOPQR',
  'admin',
  'Admin', 'MediBook', '0600000000',
  true, true
);

-- ============================================
-- PRATICIENS (profils)
-- ============================================
INSERT INTO practitioners (
  user_id, specialty_id, license_number, bio,
  consultation_duration, consultation_price,
  accepts_new_patients, teleconsultation_available,
  office_address, office_city, office_postal_code,
  latitude, longitude, average_rating, total_reviews
)
VALUES
(
  (SELECT id FROM users WHERE email = 'dr.martin@medibook.fr'),
  (SELECT id FROM specialties WHERE name = 'Médecin généraliste'),
  'MED-2024-001',
  'Médecin généraliste avec 20 ans d’expérience.',
  30, 25.00, true, true,
  '15 rue de Rivoli', 'Paris', '75004',
  48.8566, 2.3522, 4.8, 45
),
(
  (SELECT id FROM users WHERE email = 'dr.dubois@medibook.fr'),
  (SELECT id FROM specialties WHERE name = 'Cardiologue'),
  'CAR-2024-002',
  'Cardiologue spécialisé en prévention.',
  45, 80.00, true, false,
  '78 avenue des Champs-Élysées', 'Paris', '75008',
  48.8698, 2.3075, 4.6, 32
),
(
  (SELECT id FROM users WHERE email = 'dr.leroy@medibook.fr'),
  (SELECT id FROM specialties WHERE name = 'Dermatologue'),
  'DER-2024-003',
  'Dermatologue esthétique et médicale.',
  30, 60.00, true, true,
  '25 place Bellecour', 'Lyon', '69002',
  45.7578, 4.8320, 4.9, 67
);

-- ============================================
-- CRÉNEAUX DE DISPONIBILITÉ
-- ============================================
INSERT INTO availability_slots (practitioner_id, day_of_week, start_time, end_time)
SELECT id, 1, '09:00', '12:30'
FROM practitioners;

-- ============================================
-- RENDEZ-VOUS
-- ============================================
INSERT INTO appointments (
  patient_id, practitioner_id,
  appointment_date, start_time, end_time,
  status, type, reason
)
VALUES (
  (SELECT id FROM users WHERE email = 'jean.dupont@email.com'),
  (SELECT id FROM practitioners LIMIT 1),
  CURRENT_DATE + INTERVAL '3 days',
  '09:30', '10:00',
  'confirmed', 'in_person',
  'Consultation de routine'
);

-- ============================================
-- AVIS
-- ============================================
INSERT INTO reviews (
  appointment_id, patient_id, practitioner_id,
  rating, comment
)
VALUES (
  (SELECT id FROM appointments LIMIT 1),
  (SELECT id FROM users WHERE email = 'jean.dupont@email.com'),
  (SELECT id FROM practitioners LIMIT 1),
  5,
  'Excellent praticien, très professionnel.'
);

-- ============================================
-- NOTIFICATIONS
-- ============================================
INSERT INTO notifications (
  user_id, type, title, message, data
)
VALUES (
  (SELECT id FROM users WHERE email = 'jean.dupont@email.com'),
  'appointment_confirmed',
  'Rendez-vous confirmé',
  'Votre rendez-vous a été confirmé.',
  jsonb_build_object('source', 'seed')
);
