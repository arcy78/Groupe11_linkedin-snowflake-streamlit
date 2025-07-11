import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

# Initialisation de la session
session = get_active_session()

st.set_page_config(page_title="LinkedIn Jobs Analytics", layout="wide")
st.title("📊 Dashboard - LinkedIn Jobs Analytics")

st.markdown("---")

# A. Top 10 titres les plus publiés par industrie
st.subheader("A. 🔝 Titres les plus publiés par industrie")
df_a = session.sql("SELECT * FROM vw_top_titles_by_industry").to_pandas()
st.dataframe(df_a, use_container_width=True)
st.bar_chart(df_a.set_index("TITLE")["NB_POSTES"])

st.markdown("---")

# B. Top 10 postes les mieux rémunérés par industrie
st.subheader("B. 💰 Postes les mieux rémunérés par industrie")
df_b = session.sql("SELECT * FROM vw_top_salaries_by_industry").to_pandas()
st.dataframe(df_b, use_container_width=True)
st.bar_chart(df_b.set_index("TITLE")["SALAIRE_MAX"])

st.markdown("---")

# C. Répartition par taille d’entreprise
st.subheader("C. 🏢 Répartition des offres par taille d’entreprise")
df_c = session.sql("SELECT * FROM vw_jobs_by_company_size").to_pandas()
st.bar_chart(df_c.set_index("COMPANY_SIZE")["TOTAL_OFFRES"])

st.markdown("---")

# D. Répartition des offres par industrie
st.subheader("D. 🏭 Répartition des offres par secteur d’activité")
df_d = session.sql("SELECT * FROM vw_jobs_by_industry").to_pandas()
st.bar_chart(df_d.set_index("INDUSTRY_ID")["TOTAL_OFFRES"])

st.markdown("---")

# E. Répartition des offres par type d’emploi
st.subheader("E. 🧾 Répartition des offres par type d’emploi")
df_e = session.sql("SELECT * FROM vw_jobs_by_type").to_pandas()
st.bar_chart(df_e.set_index("FORMATTED_WORK_TYPE")["TOTAL"])
