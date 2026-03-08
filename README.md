# u23-football-player-analysis
Data-driven analysis of U23 football players using PCA and clustering to identify performance profiles across European leagues.
# Football Player Clustering Analysis

## Project Overview

This project analyzes the statistical performance of **U23 professional football players** using data-driven methods.  
The objective is to identify different **player performance profiles** among attackers, midfielders, and defenders across several European leagues.

The dataset includes players competing in:

- Championship (England)
- Ligue 2 (France)
- Segunda División (Spain)
- Serie B (Italy)

By applying **Principal Component Analysis (PCA)** and **k-means clustering**, the study groups players with similar statistical characteristics and highlights the diversity of playing styles among young football talents.

The complete methodological explanation and detailed player analysis are available in the project report.

---

# Methodology

## Data Preprocessing

Raw match-event statistics were converted into **per-90-minute indicators** in order to allow fair comparisons between players with different playing times.

The dataset was then divided into three positional groups:

- Attackers  
- Midfielders  
- Defenders  

Each position is analyzed using the statistical indicators most relevant to its tactical role.

---

## Shrinkage Adjustment

To reduce statistical volatility, particularly for players with limited playing time, a **shrinkage procedure toward the mean** was applied.

Shrinkage was calculated **separately by league and by position**, ensuring that players are compared with similar players competing in comparable contexts.

The shrunk value is calculated as a weighted average between the player's observed statistic and the group mean.

---

## Standardization

After shrinkage, all variables were standardized using **z-score normalization**.

The final variables used in the analysis follow the format:

z_variable_per90_shrunk

Standardization ensures that all indicators have comparable scales before applying PCA and clustering techniques.

---

## Performance Scores

Three synthetic indicators were constructed to summarize player performance within each position:

- `score_attack`
- `score_midfield`
- `score_defense`

Each score corresponds to a **weighted combination of standardized statistical indicators** relevant to the player's position.

In general form:

Score_i = Σ (w_k × z_ik)

Where:

- `w_k` = weight assigned to variable k  
- `z_ik` = standardized value of variable k for player i  

These scores provide a synthetic measure of statistical contribution and allow quick comparisons between players.

---

## Principal Component Analysis (PCA)

Principal Component Analysis was applied separately for:

- Attackers
- Midfielders
- Defenders

The PCA was implemented in **R using the FactoMineR package**.

The number of retained components follows the rule:

- If PC1 + PC2 explain **at least 70% of total variance** and PC3 has eigenvalue < 1 → retain **2 components**
- Otherwise → retain **3 components**

This approach balances interpretability and explanatory power.

---

## Clustering

After PCA, **k-means clustering** was applied to the PCA coordinates to identify groups of players with similar statistical profiles.

The number of clusters was selected using:

- the **WSS (elbow) method**
- the **silhouette method**

Final cluster structure:

| Position | Number of Clusters |
|--------|--------|
| Attackers | 3 |
| Midfielders | 2 |
| Defenders | 6 |

These clusters represent different **statistical player archetypes**.

---

# Key Results

The analysis highlights several distinct performance profiles among young professional players.

### Attackers

Three main attacking profiles emerge:

- **Finishing-oriented attackers**
- **Creative attackers**
- **Balanced offensive players**

### Midfielders

Two main midfield profiles appear:

- **Creative / attacking midfielders**
- **Possession-oriented or defensive midfielders**

### Defenders

Several defensive profiles are identified, including:

- **Physical ball-winning defenders**
- **Ball-playing defenders involved in build-up**
- **Positional defenders relying on anticipation and interceptions**

These results illustrate the diversity of tactical roles among young football players.

---

# Project Structure

---

# Tools

The analysis was conducted using:

- **R**

---

# Report

The full methodological explanation and detailed player analysis are available in:

**project_report.pdf**

---

# Author

Football data analysis project focused on **statistical player profiling and performance modeling in professional football**.
