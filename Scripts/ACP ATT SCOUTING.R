# =========================
# ACP ATTAQUANTS : diagnostics complets
# Prérequis :
# - vars_attack existe
# - pca_attack existe
# - pca_table_attack existe
# =========================
install.packages("factoextra")
library(factoextra)
# 1) Valeurs propres / variance expliquée
eig_attack <- as.data.frame(pca_attack$eig)
colnames(eig_attack) <- c("eigenvalue", "variance_percent", "cumulative_variance_percent")
eig_attack$axis <- paste0("PC", seq_len(nrow(eig_attack)))
eig_attack <- eig_attack[, c("axis", "eigenvalue", "variance_percent", "cumulative_variance_percent")]

print(eig_attack)

# 2) Nombre d’axes à garder
# Critère de Kaiser : eigenvalue > 1
axes_kaiser <- eig_attack %>%
  dplyr::filter(eigenvalue > 1)

cat("\nAxes retenus selon Kaiser (eigenvalue > 1):\n")
print(axes_kaiser)

# Critère de variance cumulée : premier nombre d’axes atteignant au moins 70%
n_axes_70 <- which(eig_attack$cumulative_variance_percent >= 70)[1]
cat("\nNombre minimal d'axes pour atteindre 70% de variance cumulée :", n_axes_70, "\n")

# 3) Scree plot / test du coude
fviz_eig(
  pca_attack,
  addlabels = TRUE,
  main = "Scree plot - Attaquants"
)

# 4) Cercle des corrélations
fviz_pca_var(
  pca_attack,
  col.var = "contrib",
  gradient.cols = c("lightblue", "orange", "red"),
  repel = TRUE,
  title = "Cercle des corrélations - Attaquants"
)

# 5) Contributions des variables aux axes 1 et 2
fviz_contrib(
  pca_attack,
  choice = "var",
  axes = 1,
  top = nrow(vars_attack)
)

fviz_contrib(
  pca_attack,
  choice = "var",
  axes = 2,
  top = nrow(vars_attack)
)

# 6) Corrélations variables-axes
var_coord_attack <- as.data.frame(pca_attack$var$coord)
var_coord_attack$variable <- rownames(var_coord_attack)
var_coord_attack <- var_coord_attack[, c("variable", "Dim.1", "Dim.2")]
colnames(var_coord_attack) <- c("variable", "PC1_corr", "PC2_corr")

cat("\nCorrélations des variables avec PC1 et PC2 :\n")
print(var_coord_attack)

# 7) Contributions des variables
var_contrib_attack <- as.data.frame(pca_attack$var$contrib)
var_contrib_attack$variable <- rownames(var_contrib_attack)
var_contrib_attack <- var_contrib_attack[, c("variable", "Dim.1", "Dim.2")]
colnames(var_contrib_attack) <- c("variable", "PC1_contrib_percent", "PC2_contrib_percent")

cat("\nContributions des variables à PC1 et PC2 :\n")
print(var_contrib_attack)

# 8) Qualité de représentation des variables (cos2)
var_cos2_attack <- as.data.frame(pca_attack$var$cos2)
var_cos2_attack$variable <- rownames(var_cos2_attack)
var_cos2_attack <- var_cos2_attack[, c("variable", "Dim.1", "Dim.2")]
colnames(var_cos2_attack) <- c("variable", "PC1_cos2", "PC2_cos2")

cat("\nQualité de représentation des variables sur PC1 et PC2 :\n")
print(var_cos2_attack)

# 9) Projection des joueurs sur PC1-PC2
fviz_pca_ind(
  pca_attack,
  label = "none",
  habillage = attackers$source_league_name,
  addEllipses = FALSE,
  title = "Projection des attaquants sur PC1-PC2"
)

# 10) Biplot
fviz_pca_biplot(
  pca_attack,
  label = "var",
  habillage = attackers$source_league_name,
  addEllipses = FALSE,
  repel = TRUE,
  title = "Biplot PCA - Attaquants"
)

# 11) Table interprétable des composantes des joueurs
# Si pca_table_attack existe déjà, on garde seulement PC1/PC2 si besoin
pca_table_attack_2d <- pca_table_attack %>%
  dplyr::select(player_name, team_name, league, age, Dim.1, Dim.2) %>%
  dplyr::rename(PC1 = Dim.1, PC2 = Dim.2)

cat("\nAperçu des coordonnées des joueurs sur PC1-PC2 :\n")
print(head(pca_table_attack_2d, 10))

# 12) Interprétation automatique simple des axes
pc1_top <- var_contrib_attack %>%
  dplyr::arrange(desc(PC1_contrib_percent)) %>%
  dplyr::slice_head(n = 3)

pc2_top <- var_contrib_attack %>%
  dplyr::arrange(desc(PC2_contrib_percent)) %>%
  dplyr::slice_head(n = 3)

cat("\nVariables dominant PC1 :\n")
print(pc1_top)

cat("\nVariables dominant PC2 :\n")
print(pc2_top)

cat("\nINTERPRÉTATION GUIDÉE :\n")
cat("- PC1 se lit à partir des variables qui contribuent le plus à l’axe 1.\n")
cat("- PC2 se lit à partir des variables qui contribuent le plus à l’axe 2.\n")
cat("- Si goals/shots/shots_on dominent PC1, alors PC1 = axe de finition / volume offensif.\n")
cat("- Si dribbles/key_passes dominent PC2, alors PC2 = axe de créativité / déséquilibre.\n")
cat("- Pour retenir le nombre d’axes : combine Kaiser (eigenvalue > 1), scree plot et variance cumulée.\n")

library(ggplot2)

ggplot(pca_table_attack_2d, aes(x = PC1, y = PC2, color = league)) +
  geom_point(size = 3) +
  geom_text(aes(label = player_name), vjust = -0.5, size = 3) +
  labs(
    title = "ACP des attaquants U23",
    x = "PC1 - Finition / volume offensif",
    y = "PC2 - Créativité / percussion",
    color = "League"
  ) +
  theme_minimal()