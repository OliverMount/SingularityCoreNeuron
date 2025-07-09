
library(tidyverse)

df<- read.csv("results/benchmark.csv")
df <- df %>%
  mutate(System = recode(System,
                         "Karina" = "Turing",
                         "v100" = "Volta"))


df_plot<- df %>% group_by(System,Resource) %>% summarise(ME=mean(SOLVER_TIME),SD=sd(SOLVER_TIME))

# Filter for Karina only
karina_df <- df_plot %>% filter(System == "Turing")


ggplot(karina_df, aes(x = factor(Resource), y = ME)) +
  geom_col(fill = "steelblue",width = 0.6) + theme_classic() +
  geom_errorbar(aes(ymin = ME - SD, ymax = ME + SD), width = 0.2) +
  geom_text(aes(label = round(ME)), vjust = -0.5, size = 7) + 
  theme(legend.position= "none",
        legend.key.size =  unit(4, "lines"),
        legend.spacing.x = unit(0.1,"mm"),
        legend.text = element_text(size=18),
        strip.text = element_text(size = 20),  # facet text size
        #strip.background = element_blank() , 
        #strip.background =element_rect(fill = facet_colors[levels(four_rois_data$roi)], color = NA), # Apply colors
        legend.margin = margin(t = -40),  # spacing between x axis and legend
        axis.ticks.length.x = unit(3,'mm'),
        axis.ticks.length.y = unit(3,'mm'), 
        axis.text = element_text(size=28),
        #axis.text.x =  element_blank(),
        axis.title.x = element_text(size=28),
        axis.title.y = element_text(size=28),
        plot.title = element_text(size=28,hjust = 0.5), 
        legend.title = element_blank()) +
  scale_y_continuous(breaks = c(150,300),limits = c(0,350),
                     expand = c(0,0))  +
  labs(x = "Number of GPUs", y = "Solver Time (sec) ", title = "Turing: Solver Time vs. GPUs")   
  

 



# Filter for GPU 1 and 2 only
compare_df <- df_plot %>% filter(Resource %in% c(1, 2))

ggplot(compare_df, aes(x = factor(Resource), y = ME, fill =  System)) + theme_classic() +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_errorbar(aes(ymin = ME - SD, ymax = ME + SD), 
                position = position_dodge(width = 0.8), width = 0.2) + 
  geom_text(aes(label = round(ME)), 
            position = position_dodge(width = 0.8), 
            vjust = -0.5, size = 5) +
  labs(x = "Number of GPUs", y = "Solver Time (sec)", fill = "HPC env.",
       title = "") +
  theme(legend.position= c(0.8,0.8),
        legend.key.size =  unit(1.5, "lines"),
        legend.spacing.x = unit(0.5,"mm"),
        legend.text = element_text(size=18),
        strip.text = element_text(size = 20),  # facet text size
        #strip.background = element_blank() , 
        #strip.background =element_rect(fill = facet_colors[levels(four_rois_data$roi)], color = NA), # Apply colors
        legend.margin = margin(t = -40),  # spacing between x axis and legend
        axis.ticks.length.x = unit(3,'mm'),
        axis.ticks.length.y = unit(3,'mm'), 
        axis.text = element_text(size=28),
        #axis.text.x =  element_blank(),
        axis.title.x = element_text(size=28),
        axis.title.y = element_text(size=28),
        plot.title = element_text(size=28,hjust = 0.5), 
        legend.title = element_blank()) +
  scale_y_continuous(breaks = c(150,300),limits = c(0,350),
                     expand = c(0,0))
  
# theme(plot.title = element_text(hjust = 0.5))
