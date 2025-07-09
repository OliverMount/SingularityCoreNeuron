
library(tidyverse)

df<- read.csv("results/benchmark.csv")

df_plot<- df %>% group_by(System,Resource) %>% summarise(ME=mean(SOLVER_TIME),SD=sd(SOLVER_TIME))

# Filter for Karina only
karina_df <- df_plot %>% filter(System == "Karina")

ggplot(karina_df, aes(x = factor(Resource), y = ME)) +
  geom_col(fill = "steelblue") +
  geom_errorbar(aes(ymin = ME - SD, ymax = ME + SD), width = 0.2) +
  geom_text(aes(label = round(ME)), vjust = -0.5, size = 5) +
  labs(x = "Number of GPUs", y = "Solver Time (Mean ± SD)", title = "Karina: Solver Time by Number of GPUs") +
  theme_minimal()


ggplot(df, aes(x = factor(Resource), y = SOLVER_TIME)) +
  geom_boxplot(fill = "steelblue") +
  labs(
    x = "Number of GPUs",
    y = "Equation Solver Time (sec)",
    title = "Karina: Solver Time by Number of GPUs"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))




# Filter for GPU 1 and 2 only
compare_df <- df_plot %>% filter(Resource %in% c(1, 2))

ggplot(compare_df, aes(x = factor(Resource), y = ME, fill =  System)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_errorbar(aes(ymin = ME - SD, ymax = ME + SD), 
                position = position_dodge(width = 0.8), width = 0.2) +
  labs(x = "GPUs", y = "Solver Time (Mean ± SD)", fill = "HPC",
       title = "Solver Time: Karina vs v100 (1 & 2 GPUs)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))
