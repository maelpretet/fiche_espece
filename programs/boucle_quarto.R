# Librairies
library(dplyr)
# library(fs)
library(here)
library(quarto)
library(stringr)

# Fonctions
readRenviron(".env")
source("fonctions/function_import_from_mosaic.R")
source("programs/texte_quarto_dashboard.R")

# Départements avec numéro et région
reg_dep = read.csv2("data/departements-france.csv", sep=",")

# Data frame des espèces
df_all_sp = import_from_mosaic(query = read_sql_query("SQL/export_a_plat_OPJ.sql"),
                               database_name = "spgp") %>%
  filter(!is.na(dept_code),         # suppression des départements nuls
         str_length(dept_code)==2,  # suppression des drom-com
         annee >= 2018) %>%         # suppression des données avant 2018
  mutate(an_sem = if_else(as.numeric(num_semaine) < 10,
                          paste0(annee, "-S0", num_semaine),
                          paste0(annee, "-S", num_semaine)) ) %>%
  left_join(reg_dep, by = c("dept_code" = "code_departement")) # ajout des départements


time = Sys.time()
# Boucle sur les noms d'espèces
for (sp_name in unique(df_all_sp$nom_espece)) {
  filename = paste0("dashboard_espece_", sp_name, ".html")
  quarto_render(input = "dashboard_espece.qmd",
                execute_params = list("sp_name" = sp_name),
                output_file = filename)

  file.copy(from = filename,
            to = paste0("out/", filename), overwrite = TRUE)
  file.remove(filename)
}
print(Sys.time() - time)

# for (sp_name in unique(df_all_sp$nom_espece)) {
#   dir_name = paste0("dashboard_espece_", sp_name, "_files")
#   qmd_filename = paste0("dashboard_espece_", sp_name, ".qmd")
#   html_filename = paste0("dashboard_espece_", sp_name, ".html")
#   # Création du dashboard adapté à une espèce
#   cat(create_qmd_file(sp_name),
#       file = (con <- file(qmd_filename, "w", encoding="UTF-8")) )
#   close(con)
#   # Lancement du render
#   quarto_render(input = qmd_filename, 
#                 execute_params = list("sp_name" = sp_name))
#   # Déplacements des output
#   file.copy(from = html_filename,
#             to = paste0("out/", html_filename),
#             overwrite = TRUE)
#   # dir_copy(path = dir_name,
#   #          new_path = paste0("out/", dir_name),
#   #          overwrite = TRUE)
#   
#   file.remove(qmd_filename)
#   file.remove(html_filename)
#   # dir_delete(path = dir_name)
# 
# }





