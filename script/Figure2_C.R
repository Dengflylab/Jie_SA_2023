library(stringr)
library(ggplot2)
library(reshape2)
library(ggkaboom)

dir.create("img/Figure_2C")

File_list = head(list.files("data/Video_post/"), 15)
Group <- read.csv("data/Video_mate.csv")
Sample_list <- head(Group$Video_Name, 16)

TB = data.frame()
for(i in Sample_list){
    File_loc = paste("data/Video_post/",i,"_3000_17900.csv", sep="")
    TB = rbind(TB, read.csv(File_loc))
}


##############
## Motion
##############


TMP = as.data.frame(table(TB[c("Motion", "Video", "Fly_s")]))
TMP$Group <- Group$Group[match(TMP$Video, Group$Video_Name)]
TMP$Group <- factor(TMP$Group, levels = c("promE-GFP", "promE-fru-IR-v330035"))
TMP <- TMP[order(TMP$Group),]

P <- Kaboom_bar(TMP[-c(2:3)], "Motion", Col = "Group", fill="Group", Facet = T, P_test = "ttest", Var = 'SEM')
P[[1]] + facet_wrap(Motion~., scales = 'free', nrow = 1) +
    scale_fill_manual(values = c("#377EB8", "#E41A1C"))

ggsave("img/Figure_2C/Movies_Significant_SEM.svg", w = 8.67, h = 2.77)

write.table(P[[2]], "img/Figure_2C/Movies_Significant.csv",  sep='\t', quote = F)






























#