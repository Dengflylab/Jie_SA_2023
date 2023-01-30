library(ggplot2)
library(readxl)
library(stringr)
library(reshape2)
library(ggthemes)

List <- list.files("data/Video_post/")
List <- List[grep("Correct_", List)]
FLY_ID = read_excel("data/Fly_id.xlsx")

for( FILE in List){
    NAME  = str_replace(FILE, "Correct_", "")
    NAME = paste(str_split(NAME, ".mp4")[[1]][1], 'mp4', sep = '.')

    TB <- read.csv(paste("data/Video_post/",FILE, sep=""))
    ggplot(TB, aes(X,Y)) + geom_point(aes(color=Fly_s), alpha=.1)  + theme_map()
    ggsave(paste("img/", NAME, ".png", sep=""), w=5.27, h= 5.29)
}