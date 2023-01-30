library(ggplot2)
library(readxl)
library(stringr)
library(reshape2)
library(ggthemes)

List <- list.files("data/Video_post/")
List <- List[grep("Correct_", List)]
FLY_ID = read_excel("data/Fly_id.xlsx")
List <- List[grep(paste(FLY_ID$Video, collapse = "|"), List)]
dir.create("img/Figure_S2E")



TB_all = data.frame()
for( FILE in List){
    NAME  = str_replace(FILE, "Correct_", "")
    NAME = paste(str_split(NAME, ".mp4")[[1]][1], 'mp4', sep = '.')
    MALE=paste("fly", FLY_ID$Male[FLY_ID[[1]] == NAME], sep="_")
    FemaleWL=paste("fly", FLY_ID$FemaleWL[FLY_ID[[1]] == NAME], sep="_")
    FemaleW=paste("fly", FLY_ID$FemaleW[FLY_ID[[1]] == NAME], sep="_")

    TB <- read.csv(paste("data/Video_post/",FILE, sep=""))
    TMP <- TB[ TB$Fly_s==MALE,]
    TMP <- TMP[c("Fly_s", "X", "Y", "Sing", "Hold", "Fs_x", "Ft_x", "Video")]
    TMP$Ft_x <- as.character(TMP$Ft_x)
    TMP$Ft_x[TMP$Ft_x==FemaleWL]= "FemaleWL"
    TMP$Ft_x[TMP$Ft_x==FemaleW]= "FemaleW"
    TB_all <- rbind(TB_all, TMP)
}

TB_all$Group <- data.frame(str_split_fixed(TB_all$Video, "_",2))[[1]]


TTMP <- TB_all[TB_all$Group!= "C0090",]

TB_ratio <- data.frame()
for(Video in unique(TTMP$Video)){
    if (Video != "C0091_Trim_3.mp4"){
        tmp <- as.data.frame(t(as.data.frame.array(table(TTMP$Ft_x[TTMP$Video==Video]))))
        tmp$Video = Video
        TB_ratio <- rbind( TB_ratio, tmp)
    }
}

TB_ratio$WR <- TB_ratio$FemaleW/(TB_ratio$FemaleW+TB_ratio$FemaleWL)
TB_ratio$WLR <- TB_ratio$FemaleWL/(TB_ratio$FemaleW+TB_ratio$FemaleWL)
TB_ratio_M <- melt(TB_ratio[-c(1:3)])

TB_ratio_M$variable <- factor(TB_ratio_M$variable, levels =c("WLR", "WR"))

ggplot(TB_ratio_M, aes(variable, y = value, fill=variable)) +
    geom_boxplot(alpha=.7) +
    scale_fill_manual(values = c("Salmon", "steelblue")) +
    theme_bw()

t.test(TB_ratio$WR, TB_ratio$WLR)


ggsave("img/Figure_S2E/", )


for( FILE in List){
    NAME  = str_replace(FILE, "Correct_", "")
    NAME = paste(str_split(NAME, ".mp4")[[1]][1], 'mp4', sep = '.')

    TB <- read.csv(paste("data/Video_post/",FILE, sep=""))
    ggplot(TB, aes(X,Y)) + geom_point(aes(color=Fly_s), alpha=.1)  + theme_map()
    ggsave(paste("img/Figure_S2E/", NAME, ".png", sep=""), w=5.27, h= 5.29)
}