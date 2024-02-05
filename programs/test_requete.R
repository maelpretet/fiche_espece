
library(here)
library(dplyr)
library(RMySQL)

readRenviron(".env")

source("fonctions/function_import_from_mosaic.R")

query <- read_sql_query("SQL/export_a_plat_OPJ.sql")

df_papillons = import_from_mosaic(query = query,
                                  database_name = "spgp")

colnames(df_papillons)

df_summary = list()

for (i in 1:ncol(df_papillons)) {
  col_tmp = df_papillons[,i]
  if (typeof(col_tmp) == "character") {
    col_tmp = as.factor(col_tmp)
  }
  df_summary[[i]] = summary(col_tmp)
  #names(df_summary[i]) = colnames(df_papillons[,i])
}

colnames(df_papillons)
summary(df_papillons)

df_pap_min = df_papillons %>% 
  mutate(date_collection = as.Date(date_collection),
         date_sem = paste0(annee, "-S", num_semaine)) %>%
  select(date_collection, date_sem, abondance, longitude, latitude, dept_code,
         code_postal, user_id, jardin_id, nom_espece, freq_passage,
         type_environnement, surface)



