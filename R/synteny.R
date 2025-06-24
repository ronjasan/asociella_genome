library(tidyverse)
library(scales)
library(cowplot)

alignments <- c("agri_asoc", "gmel_asoc", "ccep_asoc")


for (alignment in alignments) {
    paf <- read_tsv(paste0("/glittertind/home/ronjasan/spaceface/larvae/synteny/minimap2/", alignment, ".paf"),
        col_names = c(
            "query", "query_length", "query_start", "query_end", "strand",
            "target", "target_length", "target_start", "target_end",
            "matches", "block_length", "map_quality"
        ),
        col_types = "cnnnccnnnnnn------"
    ) %>%
        filter(map_quality == 60)
    query_quintiles <- quantile(paf$query_length, probs = seq(0, 1, by = 0.2), na.rm = TRUE)
    target_quintiles <- quantile(paf$target_length, probs = seq(0, 1, by = 0.2), na.rm = TRUE)

    query_limit <- query_quintiles[2]
    target_limit <- target_quintiles[2]


    paf2 <- filter(paf, query_length >= query_limit | target_length >= target_limit)

    seq_query <- select(paf2, query, query_length) %>%
        distinct() %>%
        arrange(query)
    seq_target <- select(paf2, target, target_length) %>%
        distinct() %>%
        arrange(target)
    seq_query$add_query <- c(0, cumsum(seq_query$query_length)[-nrow(seq_query)])
    seq_target$add_target <- c(0, cumsum(seq_target$target_length)[-nrow(seq_target)])

    paf2 <- left_join(paf2, seq_query) %>%
        left_join(seq_target) %>%
        mutate(
            query_start = query_start + add_query,
            query_end = query_end + add_query,
            target_start = target_start + add_target,
            target_end = target_end + add_target
        ) %>%
        select(-add_query, -add_target)

    input <- paf2
    lines_query <- select(seq_query, -query_length)
    lines_target <- select(seq_target, -target_length)

    segment_colors <- c("#c4024d", "#40606d")

    names(input)[3] <- "query_start"
    names(input)[8] <- "target_start"
    names(input)[4] <- "query_end"
    names(input)[9] <- "target_end"

    strand_column <- 5
    nb_strand <- length(unique(input$strand))

    names(input)[strand_column] <- "strand"

    toReverse <- which(input[, "strand"] == "-" | input[, "strand"] == -1)
    k <- input[toReverse, "target_start"]
    input[toReverse, "target_start"] <- input[toReverse, "target_end"]
    input[toReverse, "target_end"] <- k

    input <- input[, c(3, 4, 8, 9, strand_column)]
    segment_colors <- rep(segment_colors, ceiling((nb_strand) / length(segment_colors)))[1:nb_strand]
    segment_sizes <- rep(0.7, nb_strand)

    alldata <- input
    allColors <- segment_colors
    sizes <- segment_sizes

    line_column_query <- 2
    line_column_target <- 2

    data_lines_query <- data.frame(
        query_start = lines_query$add_query,
        query_end = lines_query$add_query,
        target_start = 0,
        target_end = max(alldata[, "target_end"], lines_target[, line_column_target], na.rm = T), strand = "scaffoldx"
    )

    nb_lines_query <- nrow(data_lines_query)
    id_scaffolds_query_f <- mutate(data_lines_query,
        name = lines_query$query,
        id = 1:nb_lines_query,
        dist = c(data_lines_query[-1, "query_start"] - data_lines_query[-nb_lines_query, "query_start"] + 1, max(1, alldata$query_end - lines_query$add_query[nb_lines_query] + 1, na.rm = T))
    )
    id_scaffolds_query_x <- id_scaffolds_query_f[which(id_scaffolds_query_f[, "dist"] > 1000000), ]

    alldata <- rbind(alldata, data_lines_query)
    allColors <- c(allColors, "#bfbebe")
    sizes <- c(sizes, 0.1)

    data_lines_target <- data.frame(
        query_start = 0,
        query_end = max(alldata[, "query_end"], lines_query[, line_column_query], na.rm = T),
        target_start = lines_target$add_target,
        target_end = lines_target$add_target, strand = "scaffoldy"
    )
    nb_lines_target <- nrow(data_lines_target)
    id_scaffolds_target_f <- mutate(data_lines_target,
        name = lines_target$target,
        id = 1:nb_lines_target,
        dist = c(data_lines_target[-1, "target_start"] - data_lines_target[-nb_lines_target, "target_start"] + 1, max(1, alldata$target_end - lines_target$add_target[nb_lines_target] + 1, na.rm = T))
    )
    id_scaffolds_target_y <- id_scaffolds_target_f[which(id_scaffolds_target_f[, "dist"] > 1000000), ]

    alldata <- rbind(alldata, data_lines_target)
    allColors <- c(allColors, "#bfbebe")
    sizes <- c(sizes, 0.1)

    target_name <- paste0(ifelse(alignment == "agri_asoc", "Achroia grisella", ifelse(alignment == "gmel_asoc", "Galleria mellonella", "Corcyra cephalonica")))

    plot <- ggplot(input, aes(y = target_start, yend = target_end, x = query_start, xend = query_end, color = strand)) +
        geom_point(size = 0.5) +
        scale_color_manual(values = c("+" = "#40606d", "-" = "#c4024d")) +
        labs(
            y = paste0(target_name),
            x = "Aphomia sociella",
            color = "Strand"
        ) +
        scale_y_continuous(
            labels = unit_format(unit = "Mb", scale = 1e-6),
            breaks = seq(0, max(data_lines_target$target_start), by = 1e8),
            minor_breaks = data_lines_target$target_start
        ) +
        scale_x_continuous(
            labels = unit_format(unit = "Mb", scale = 1e-6),
            breaks = seq(0, max(data_lines_query$query_start), by = 1e8),
            minor_breaks = data_lines_query$query_start
        ) +
        theme_minimal() +
        theme(
            panel.border = element_rect(color = "black", linewidth = 0.5, fill = NA),
            panel.background = element_blank(),
            panel.grid = element_line(color = "gray", linewidth = 0.1),
            legend.text = element_text(size = 12),
            legend.title = element_text(size = 14, face = "bold"),
            axis.ticks = element_line(color = "black", linewidth = 0.75),
            axis.text = element_text(color = "black", size = 14),
            axis.ticks.length = unit(0.2, "cm"),
            axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
            axis.text.y = element_text(margin = margin(0, 5, 0, 0)),
            axis.title = element_text(size = 14, face = "bold"),
            axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
            axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            plot.margin = margin(1, 1, 1, 1, "cm"),
            legend.position = "none"
        )

    assign(paste0("plot_", alignment), plot)
}


plot_both <- plot_grid(
    plot_ccep_asoc,
    plot_gmel_asoc,
    plot_agri_asoc,
    ncol = 3,
    labels = c("A", "B", "C"),
    label_size = 20,
    label_fontface = "bold",
    align = "hv"
)
plot_both

ggsave("/glittertind/home/ronjasan/spaceface/larvae/synteny/R/synteny_asoc.pdf", plot_both, width = 55, height = 15, units = "cm")
