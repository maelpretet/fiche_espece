# HEADER --------------------------------------------
#
# Author:     Maël Pretet
# Copyright     Copyright 2024 - Maël Pretet
# Email:      mael.pretet1@mnhn.fr
#
# Date:     2024-03-26
#
# Script Name:    fonctions/create_df_all_sp.R
#
# Script Description:   Création du data frame opération papillons avec toutes
#   les espèces. Interrogation de la base de données mosaic et enregistrement
#   dans un fichier rds. Si le fichier existe déjà et qu'il date de moins d'une
#   semaine, celui-ci est directement lu.
#
#
# ------------------------------------

library(dplyr)
library(here)

readRenviron(".env")
source("fonctions/function_import_from_mosaic.R")


if (file.exists("data/rdata/df_all_sp.rds") &                                   # Test de l'existence du fichier rds
    Sys.Date()-as.Date(file.info("data/rdata/df_all_sp.rds")$ctime) <= 7) {     # Vérification qu'il date de moins de 7 jours
  
  # Lecture du fichier RDS
  df_all_sp = readRDS("data/rdata/df_all_sp.rds")
  
}else{
  # Lecture depuis la base mosaic
  df_all_sp = import_from_mosaic(query = read_sql_query("SQL/export_a_plat_OPJ.sql"),
                                 database_name = "spgp")
  # Sauvegarde du df en format RDS
  saveRDS(object = df_all_sp, file = "data/rdata/df_all_sp.rds")
}

