#Scores attaquants
attackers_scores <- attackers %>%
  mutate(
    score_attack =
      0.30 * z_goals_per90_shrunk +
      0.15 * z_shots_per90_shrunk +
      0.15 * z_shots_on_per90_shrunk +
      0.10 * z_dribbles_success_per90_shrunk +
      0.10 * z_key_passes_per90_shrunk +
      0.10 * z_duels_won_per90_shrunk +
      0.10 * z_assists_per90_shrunk
    
  )


attackers_scores1 <- attackers_scores %>%
  select(
    player_name,
    source_league_name,
    age,
    score_attack
  ) %>%
  arrange(desc(score_attack))

#Scores Milieux
midfielders_scores <- midfielders %>%
  mutate(
    score_midfield =
      0.20 * z_key_passes_per90_shrunk +
      0.20 * z_assists_per90_shrunk +
      0.15 * z_dribbles_success_per90_shrunk +
      0.15 * z_duels_won_per90_shrunk +
      0.15 * z_interceptions_per90_shrunk +
      0.10 * z_passes_per90_shrunk
  )
midfielders_scores1 <- midfielders_scores %>%
  select(
    player_name,
    source_league_name,
    age,
    score_midfield
  ) %>%
  arrange(desc(score_midfield))

#Scores Défenseurs

defenders_scores <- defenders %>%
  mutate(
    score_defense =
      0.20 * z_tackles_per90_shrunk +
      0.25 * z_interceptions_per90_shrunk +
      0.30 * z_duels_won_per90_shrunk +
      0.15 * z_passes_per90_shrunk -
      0.05 * z_fouls_committed_per90_shrunk +
      0.05 * z_key_passes_per90_shrunk
    
  )
defenders_scores1 <- defenders_scores %>%
  select(
    player_name,
    source_league_name,
    age,
    score_defense
  ) %>%
  arrange(desc(score_defense))