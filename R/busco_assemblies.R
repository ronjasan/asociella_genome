library(tidyverse)

assemblies <- read_tsv("data/busco_stats.tsv")

busco <- assemblies %>%
    filter(grepl("BUSCO", Stat)) %>%
    pivot_longer(cols = c(2:6), names_to = "assembly") %>%
    filter(Stat != "BUSCO completeness (%)") %>%
    mutate(Stat = fct_relevel(Stat, rev(c("BUSCO single-copy (%)", "BUSCO duplicate (%)", "BUSCO fragmented (%)", "BUSCO missing (%)")))) %>%
    mutate(assembly = fct_relevel(assembly, rev(c("Canu (standard)", "Canu (0.01)", "Canu (0.02)", "Canu (0.03)", "Polished"))))

busco_fig <- ggplot(busco, aes(x = value, y = assembly, fill = Stat)) +
    geom_col() +
    scale_fill_manual(values = c("#69a257", "#40606D", "#e3d19c", "#C4024D")) +
    labs(x = "", y = "") +
    theme_classic() +
    theme(
        panel.border = element_blank(),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        axis.ticks = element_line(color = "black", linewidth = 0.75),
        axis.text = element_text(color = "black", size = 14),
        axis.ticks.length = unit(0.2, "cm"),
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        plot.margin = margin(1, 1, 1, 1, "cm"),
        legend.position = "bottom"
    ) +
    guides(fill = guide_legend(ncol = 2, reverse = TRUE))
