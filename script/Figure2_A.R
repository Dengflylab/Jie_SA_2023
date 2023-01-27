library(stringr)
library(ggplot2)
library(reshape2)
library(ggkaboom)

dir.create('img/Figure_2A/')
File_list = head(list.files("data/Video_post/"), 15)
Group <- read.csv("data/Group_list2.csv",sep=',', header = F)

TB = data.frame()
for (i in File_list){
    TB=rbind(TB, read.csv(paste("data/Video_post/", i, sep="")))
}

TB$Group <- Group$V1[match(TB$Video, Group$V3)]
TB$X = as.factor("1")

tmp <- Kaboom_bar(TB[c("Nst_dist", "Nst_num", "X", "Video")], "X", Col = 'Video', Facet = F, fill='X',  Facet_row = "Video", Show_N_Group = F)[[2]]
tmp$Group <- Group$V1[match(tmp$Video, Group$V3)]
write.table(tmp, "img/Figure_2A/neasrt_index.csv",  sep='\t', quote = F)
tmp <- read.table("img/Figure_2A/neasrt_index.csv")

tmp$Group <- factor(tmp$Group, levels = c("Group8", "Group4"))
ggplot(tmp, aes(Group, Mean, fill=Group)) + geom_boxplot(width=.7, alpha=.75) +
    facet_wrap(Variable~., scales = 'free')+ theme_bw() +
    scale_fill_manual(values = c("#377EB8", "#E41A1C"))

ggsave("img/Figure_2A//neasrt_index.svg")

tmp$Variable <- as.factor(tmp$Variable)

Test <- Kaboom_bar(tmp[c("Variable", "Group", "Mean")], "Variable", Col = "Group", fill="Group", Facet = F, P_test = "ttest")
write.csv(Test[[2]], "img/Figure_2A//neasrt_index_ttest.csv")