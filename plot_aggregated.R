#!/usr/bin/env Rscript

library(data.table)
library(argparse)
library(ggplot2)

parser <- ArgumentParser(description='plot aggregated')
parser$add_argument('aggregated', nargs=1)
parser$add_argument('output', nargs=1)
args <- parser$parse_args()

aggregated = fread(args$aggregated)[B > 0.1]

print(aggregated[, .(
        mean_R = mean(R),
        mean_A = mean(A),
        mean_B = mean(B)),
    by="name"])

plot = ggplot(aggregated) + 
    geom_point(aes(x=A, y=R, group=name, colour=name)) +
    scale_color_brewer(type="qual", palette="Paired",
                       breaks=unique(aggregated$name)) +
    labs(
         x="transmission",
         y="R",
         colour="Material") +
     scale_x_continuous(expand=c(0,0)) +
     scale_y_continuous(expand=c(0,0))

X11(width=14, height=10)
print(plot)
##warnings()
width = 14
factor = 0.618
height = width * factor
ggsave(args$output, plot, width=width, height=height, dpi=300)
invisible(readLines(con="stdin", 1))
