# 📊 LinkedIn Job Analytics avec Snowflake + Streamlit

Ce projet présente une analyse de données d’offres d’emploi LinkedIn à l’aide de **Snowflake** (ETL + SQL) et de **Streamlit intégré dans Snowflake** pour les visualisations interactives.

---

## 🧾 Objectifs pédagogiques

- Manipulation de données structurées (CSV, JSON) dans Snowflake
- Création de vues analytiques via SQL
- Déploiement d'applications Streamlit **directement dans Snowflake**
- Publication d’un dépôt GitHub structuré

---

## 🔄 Pipeline de traitement

| Étape | Description |
|-------|-------------|
| 1.    | Création des bases, schémas, file formats |
| 2.    | Création et peuplement des tables à partir de S3 |
| 3.    | Transformation des données (types, timestamps, jointures) |
| 4.    | Création de vues analytiques |
| 5.    | Création d'applications Streamlit dans Snowflake |

---

## 📂 SQL détaillé

Chaque fichier `.sql` contient des commentaires :

- `0_init.sql` : création de la base de données
- `1_creation_Import_Table.sql` : schéma des tables CSV & JSON + COPY depuis S3
- `02_Creation_View.sql` : jointures, enrichissements, creation des vieaws
- `03_KPI.sql` : vues analytiques par indicateur

---

## 📊 Analyses et Visualisations (Streamlit)

Chaque visualisation est codée dans un fichier `.py` exécuté depuis Streamlit dans Snowflake.

---
✅ A. Top 10 titres de postes les plus publiés par industrie
Vue SQL : vw_top_titles_by_industry

Visualisation : graphique à barres verticales (ou horizontales) — représentation du nombre de postes par titre et par industrie

✅ B. Top 10 postes les mieux rémunérés par industrie
Vue SQL : vw_top_salaries_by_industry

Visualisation : graphique à barres horizontales

✅ C. Répartition des offres par taille d'entreprise
Vue SQL : vw_jobs_by_company_size

Visualisation : diagramme circulaire (st.pyplot avec matplotlib)

✅ D. Répartition des offres par secteur d’activité
Vue SQL : vw_jobs_by_industry

Visualisation : graphique en barres

✅ E. Répartition des offres par type d’emploi
Vue SQL : vw_jobs_by_type

Visualisation : camembert ou histogramme

## 🛠️ Problèmes rencontrés et solutions apportées

Problème : La table job_postings chargée depuis le fichier CSV contenait 27 colonnes, alors que la table cible n’en attendait que 25.

* Cause : Certaines lignes contenaient des champs mal encodés ou des séparateurs , non échappés dans des descriptions longues.

* Solution :

* * Création d’une table intermédiaire job_postings_stage avec tous les champs en type STRING ou FLOAT
* * Utilisation de la commande :
COPY INTO job_postings_stage FROM @linkedin_stage/job_postings.csv FILE_FORMAT = csv_format ON_ERROR = 'CONTINUE';


* * Vérification du schéma avec :
DESC TABLE job_postings_stage;
SELECT * FROM job_postings_stage LIMIT 10;

* * Ensuite, transformation explicite et contrôlée dans une table job_postings finale avec types et conversions (TO_TIMESTAMP_NTZ()).