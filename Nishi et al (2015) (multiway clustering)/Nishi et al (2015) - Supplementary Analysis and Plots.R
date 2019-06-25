library(data.table)
library(plyr)
library(multiwayvcov)
library(lmtest)
library(ggplot2)
library(cowplot)
df.s <- as.data.table(read.csv(file = "Nishi et al (2015) - Session Data (Replication).csv"))
df.i <- as.data.table(read.csv(file = "Nishi et al (2015) - Individual Data (Replication).csv"))
df.s.o <- as.data.table(read.csv(file = "Nishi et al (2015) - Session Data (Original).csv"))
df.i.o <- as.data.table(read.csv(file = "Nishi et al (2015) - Individual Data (Original).csv"))


# This file contains some extra analysis comparing original and replication
# results. It also provides the code for plotting the graphs in the replication
# report.

################################################################################
# Summary Stats
print(df.s[round == 0, as.list(summary(n_par)), by = .(showScore)])

print(as.data.table(merge(
    df.s[round == 0, .(game, showScore, "n_par_first" = n_par)],
    df.s[round == 10, .(game, showScore, "n_par_last" = n_par)]
    ))[, .("Avg dropouts per game" = mean(n_par_first - n_par_last)),
    by = showScore])

################################################################################
# PLOTS

# Figure 3: average (and sd) for 4 measures over different groups

# (a) Changes in average wealth
a.df <- df.i[, .(mean(cumulativePayoff, na.rm = TRUE)),
    by = .(round, game, showScore)][,
    .(mean(V1), sqrt(var(V1)/.N)), by = .(round, showScore)]
a <- ggplot(aes(x = round, y = V1, color = showScore), data = a.df) +
     geom_line() + geom_linerange(aes(ymin = V1-V2, ymax = V1+V2)) +
     labs(y = "Mean Wealth", x = "Round") +
     theme(legend.position="none")

# (b) cooperation rate
b.df <- df.i[, .(mean(behavior, na.rm = TRUE)),
    by = .(round, game, showScore)][,
    .(mean(V1), sqrt(var(V1)/.N)), by = .(round, showScore)]
b <- ggplot(aes(x = round, y = V1, color = showScore), data = b.df) +
    geom_line() + geom_linerange(aes(ymin = V1-V2, ymax = V1+V2)) +
    labs(y = "Mean Cooperation Rate", x = "Round") +
    theme(legend.position="none")

# (c) network degree (number of connecting neighbours)
c.df <- df.i[, .(mean(e_degree, na.rm = TRUE)),
    by = .(round, game, showScore)][,
    .(mean(V1), sqrt(var(V1)/.N)), by = .(round, showScore)]
c <- ggplot(aes(x = round, y = V1, color = showScore), data = c.df) +
    geom_line() + geom_linerange(aes(ymin = V1-V2, ymax = V1+V2)) +
    labs(y = "Mean Degree", x = "Round") +
    theme(legend.position="none")

# (d) and network transitivity (probability of a focal subject’s two neighbours being connected)
d.df <- df.i[, .(mean(local_cluster, na.rm = TRUE)),
    by = .(round, game, showScore)][,
    .(mean(V1), sqrt(var(V1)/.N)), by = .(round, showScore)]
d <- ggplot(aes(x = round, y = V1, color = showScore), data = d.df) +
    geom_line() + geom_linerange(aes(ymin = V1-V2, ymax = V1+V2)) +
    labs(y = "Mean Transitivity", x = "Round") +
    theme(legend.position="none")

pg <- plot_grid(a, b, c, d, labels = c("a", "b", "c", "d"), ncol = 2)
legend <- get_legend(a + theme(legend.position="bottom"))
pg <- plot_grid(pg, legend, ncol = 1, rel_heights = c(1, .2))
ggsave("figure3.pdf", plot = pg)

# Gini Plot
# Calculate Gini funcion
calc_gini <- function(w) {
    w <- na.omit(w)
    n <- length(w)
    sum(abs((outer(w, w, "-")))) / (2 * n^2 * mean(w))
}

gini.df <- df.i[, .(calc_gini(cumulativePayoff)),
    by = .(round, game, showScore)][,
    .(mean(V1, na.rm = TRUE), sqrt(var(V1, na.rm = TRUE)/.N)),
    by = .(round, showScore)]

g <- ggplot(aes(x = round, y = V1, color = showScore), data = gini.df) +
    geom_line() + geom_linerange(aes(ymin = V1-V2, ymax = V1+V2)) +
    labs(y = "Mean Gini", x = "Round") +
    theme(legend.position="none")

ggsave("figure1.pdf", plot = g)
