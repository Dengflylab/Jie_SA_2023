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



# social distance for mixed group video
# social distance
TB_all = data.frame()
for (file in list.files("data2/tracking/Video_post/")){
    tmp <- read.csv(paste("data2/tracking/Video_post", file, sep = '/'))
    tmp$Group = 'exp'
    tmp$Group[tmp$Fly_s %in% paste('fly_', c(0:5), sep ='')] = 'ctl'
    tmp_tb <- data.frame(
            Video = str_remove(file, "_1_17900.csv"),
            Nst_dist = mean(tmp$Nst_dist),
            Nst_num = mean(tmp$Nst_num)
            #Mean_dist = mean(tmp$Nst_dist),
            #Mean_num = mean(tmp$Nst_num),
            #dist_ctl  = mean(tmp$Nst_dist[tmp$Group == 'ctl']),
            #dist_exp  = mean(tmp$Nst_dist[tmp$Group == 'exp']),
            #nnum_ctl  = mean(tmp$Nst_num[tmp$Group == 'ctl']),
            #nnum_exp  = mean(tmp$Nst_num[tmp$Group == 'exp'])
    )
    TB_all = rbind(TB_all, tmp_tb)
}

TB_all$Group = 'mix'
tmp2 <- melt(TB_all, id.vars = c('Video', 'Group'))
colnames(tmp2)[3:4] <- c("Variable", "Mean")

# separate data
tmp <- read.table("img/Figure_2A/neasrt_index.csv")
tmp <- rbind(tmp[colnames(tmp2)], tmp2)
tmp$Group <- factor(tmp$Group, levels = c("Group8", "mix", "Group4"))

ggplot(tmp, aes(Group, Mean, fill=Group)) + geom_boxplot(width=.7, alpha=.5) +
    facet_wrap(Variable~., scales = 'free')+ theme_bw() +
    scale_fill_manual(values = c("#377EB8" ,"purple", "#E41A1C"))

ggsave("img/Figure_2A//neasrt_index1.svg")



tmp$Group <- factor(tmp$Group, levels = c("Group8", "Group4", "mix"))

ggplot(tmp, aes(Group, Mean, fill=Group)) + geom_boxplot(width=.7, alpha=.5) +
    facet_wrap(Variable~., scales = 'free')+ theme_bw() +
    scale_fill_manual(values = c("#377EB8", "#E41A1C" ,"purple"))

ggsave("img/Figure_2A//neasrt_index2.svg")


tmp$Variable <- as.factor(tmp$Variable)
Test <- Kaboom_bar(tmp[c("Variable", "Group", "Mean")], "Variable", Col = "Group", fill="Group", Facet = F, P_test = "ttest")
write.csv(Test[[2]], "img/Figure_2A//neasrt_index_ttest.csv")



one.way <- aov(Mean ~ Group, data = tmp[tmp$Variable =='Nst_dist',])
Dist_anova <- TukeyHSD(one.way)$Group
write.csv(Dist_anova, "img/Figure_2A//neasrt_distance_anova.csv")

one.way <- aov(Mean ~ Group, data = tmp[tmp$Variable =='Nst_num',])
Num_anova <- TukeyHSD(one.way)$Group
write.csv(Num_anova, "img/Figure_2A//neasrt_number_anova.csv")
