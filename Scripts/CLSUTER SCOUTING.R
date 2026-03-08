#nombre de clusters par poste
library(factoextra)

vars_cluster_attack <- pca_table_attack_2d %>%
  select(PC1, PC2)

fviz_nbclust(vars_cluster_attack, kmeans, method = "wss")

fviz_nbclust(vars_cluster_attack, kmeans, method = "silhouette")

vars_cluster_mid <- pca_table_mid %>%
  select(PC1, PC2, PC3)

fviz_nbclust(vars_cluster_mid, kmeans, method = "wss")

fviz_nbclust(vars_cluster_mid, kmeans, method = "silhouette")

vars_cluster_def <- pca_table_def %>%
  select(PC1, PC2)

fviz_nbclust(vars_cluster_def, kmeans, method = "wss")

fviz_nbclust(vars_cluster_def, kmeans, method = "silhouette")


table(pca_table_attack_2d$cluster)
table(pca_table_mid$cluster)
table(pca_table_def$cluster)

#Clustering des ATT (3 clusters)
set.seed(123)

kmeans_attack <- kmeans(vars_cluster_attack, centers = 3, nstart = 25)

pca_table_attack_2d$cluster <- kmeans_attack$cluster
ggplot(pca_table_attack_2d, aes(x = PC1, y = PC2, color = factor(cluster))) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = player_name), size = 3) +
  labs(
    title = "Clusters des attaquants U23",
    x = "PC1 - Finition",
    y = "PC2 - Créativité",
    color = "Cluster"
  ) +
  theme_minimal()
#Clustering des MILL (2 clusters)
set.seed(123)

vars_cluster_mid <- pca_table_mid %>%
  dplyr::select(PC1, PC2, PC3)

kmeans_mid <- kmeans(vars_cluster_mid, centers = 2, nstart = 25)

pca_table_mid$cluster <- kmeans_mid$cluster
pca_table_mid %>%
  arrange(cluster) %>%
  select(cluster, player_name, team_name, league, age)

#Clustering des DEF (6 clusters)
set.seed(123)

kmeans_def <- kmeans(vars_cluster_def, centers = 6, nstart = 25)

pca_table_def$cluster <- kmeans_def$cluster