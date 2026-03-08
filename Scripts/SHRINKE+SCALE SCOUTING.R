library(dplyr)

# =========================================================
# 0) Base
# =========================================================
players_base <- players_u23_unique %>%
  filter(!is.na(games_minutes), games_minutes > 600)

# =========================================================
# 1) Variables per90 à shrinker
# =========================================================
per90_vars <- names(players_base)[grepl("_per90$", names(players_base))]

# =========================================================
# 2) Moyennes par ligue et par poste
# =========================================================
league_position_means <- players_base %>%
  group_by(source_league_name, games_position) %>%
  summarise(
    across(
      all_of(per90_vars),
      ~ mean(.x, na.rm = TRUE),
      .names = "mean_{.col}"
    ),
    .groups = "drop"
  )

# =========================================================
# 3) Join des moyennes
# =========================================================
players_shrunk <- players_base %>%
  left_join(
    league_position_means,
    by = c("source_league_name", "games_position")
  )

# =========================================================
# 4) Shrinkage robuste sur toutes les variables per90
# =========================================================
k <- 900

for (v in per90_vars) {
  mean_v <- paste0("mean_", v)
  shrunk_v <- paste0(v, "_shrunk")
  
  players_shrunk[[shrunk_v]] <-
    (players_shrunk$games_minutes / (players_shrunk$games_minutes + k)) * players_shrunk[[v]] +
    (k / (players_shrunk$games_minutes + k)) * players_shrunk[[mean_v]]
}

# =========================================================
# 5) Séparer par poste
# =========================================================
attackers <- players_shrunk %>%
  filter(games_position == "Attacker")

midfielders <- players_shrunk %>%
  filter(games_position == "Midfielder")

defenders <- players_shrunk %>%
  filter(games_position == "Defender")

# =========================================================
# 6) Fonction de scaling des variables shrinkées
# =========================================================
scale_shrunk_vars <- function(df) {
  shrunk_vars <- names(df)[grepl("_shrunk$", names(df))]
  
  df %>%
    mutate(
      across(
        all_of(shrunk_vars),
        ~ as.numeric(scale(.x)),
        .names = "z_{.col}"
      )
    )
}

# =========================================================
# 7) Scaling par table
# =========================================================
attackers <- scale_shrunk_vars(attackers)
midfielders <- scale_shrunk_vars(midfielders)
defenders <- scale_shrunk_vars(defenders)

# =========================================================
# 8) Vérifications
# =========================================================
cat("Attaquants :", nrow(attackers), "\n")
cat("Milieux :", nrow(midfielders), "\n")
cat("Défenseurs :", nrow(defenders), "\n\n")

cat("Variables shrinkées :\n")
print(names(players_shrunk)[grepl("_shrunk$", names(players_shrunk))])

cat("\nVariables standardisées attackers :\n")
print(names(attackers)[grepl("^z_.*_shrunk$", names(attackers))])

names(attackers)
names(defenders)
names(midfielders)
