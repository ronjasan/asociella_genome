library(tidyverse)
library(ggtree)
library(aplot)
library(ape)

larvae_tree <- read.tree("data/tree/SpeciesTree_rooted.txt")

geno.info <- read_tsv("data/tree/moth_info.tsv") %>%
    relocate(file, .before = Family) %>%
    mutate(file = str_remove(file, ".fna")) %>%
    rename(label = file)


bs_tibble <- tibble(
    node = 1:Nnode(larvae_tree) + Ntip(larvae_tree),
    bootstrap = larvae_tree$node.label
)

d_dummy <- data.frame(
    label = larvae_tree$tip.label,
    category = as.character(1:length(larvae_tree$tip.label))
)
p_dummy <- ggplot(data = d_dummy, aes(y = label, x = category)) +
    theme_void()

ggt <- ggtree(larvae_tree) %<+% geno.info %<+% bs_tibble +
    geom_tiplab(aes(color = Type, label = Species),
        fontface = "italic",
        align = TRUE,
        offset = 0,
        size = 5
    ) +
    geom_text(aes(label = bootstrap), hjust = -0.1, size = 3) +
    scale_color_manual(values = c("#c4024d", "black")) +
    ggtitle("tree") +
    theme(legend.position = "none", title = element_text(face = "bold")) +
    xlim(0, 1)
ggt

ass_lvl <- ggplot(filter(geno.info), aes(x = label, y = 0, label = assembly_level, color = Type)) +
    geom_text(hjust = 0, size = 5) +
    scale_color_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    theme_void() +
    ggtitle("Ass_lvl") +
    theme(legend.position = "none", title = element_text(face = "bold"))

seq <- ggplot(filter(geno.info), aes(x = label, y = 0, label = Sequencing, color = Type)) +
    geom_text(hjust = 0, size = 5) +
    scale_color_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    theme_void() +
    ggtitle("Seq") +
    theme(legend.position = "none", title = element_text(face = "bold"))

genome_size <- ggplot(filter(geno.info), aes(x = label, y = genomeSize_Mb, fill = Type, width = 0.8)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    ggtitle("Size") +
    theme(legend.position = "none", title = element_text(face = "bold"))


busco_comp <- ggplot(filter(geno.info), aes(x = label, y = BUSCO_complete, fill = Type, width = 0.8)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    ggtitle("Complete") +
    theme(legend.position = "none", title = element_text(face = "bold"))

busco_dup <- ggplot(filter(geno.info), aes(x = label, y = BUSCO_dup, fill = Type, width = 0.8)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    ggtitle("Dup") +
    theme(legend.position = "none", title = element_text(face = "bold"))


coverage <- ggplot(filter(geno.info), aes(x = label, y = Coverage, fill = Type, width = 0.8)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("#c4024d", "black")) +
    coord_flip() +
    theme_tree2() +
    ggtitle("Coverage") +
    theme(legend.position = "none", title = element_text(face = "bold"))


plot <- p_dummy %>%
    insert_left(ggt, width = 25) %>%
    insert_right(ass_lvl, width = 5) %>%
    insert_right(seq, width = 5) %>%
    insert_right(genome_size, width = 4) %>%
    insert_right(busco_comp, width = 4) %>%
    insert_right(busco_dup, width = 4) %>%
    insert_right(coverage, width = 4)
