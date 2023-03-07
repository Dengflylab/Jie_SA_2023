TB <- read.csv("img/Figure_2B/Two_video_feed.csv")[-1]
colnames(TB)[1] <- 'Group'

ggplot(TB, aes(variable, value)) + geom_boxplot() + theme_bw() + coord_cartesian(ylim = c(0,10000))



library(ggplot2)
library(stringr)
library(reshape2)

Fil_loc = 'data2/tracking/'
Feed_lst <- list.files(Fil_loc)[grep("_feed.csv", list.files(Fil_loc))]

Mix_lst <- Feed_lst[-grep('single', Feed_lst)]
Sig_lst <- Feed_lst[grep('single', Feed_lst)]

TB_mix <- data.frame(row.names = paste("fly", c(0:11), sep = "_"))
for (file in Mix_lst){
    tmp_tb <- read.csv(paste(Fil_loc, file, sep=''))
    TB_mix[str_remove(file, '.MP4_feed.csv')] <- tmp_tb[[2]][match(row.names(TB_mix), tmp_tb$X)]
}

TB_mix[is.na(TB_mix)] <- 0
TB_mix <- TB_mix
TB_mix['Group'] <- 'ctl'
TB_mix$Group[6:12] <- 'exp'

TB_mixL <- melt(TB_mix)
TB2 <- rbind(TB, TB_mixL[colnames(TB)])
TB2$X = "ctl"
TB2$X[TB2$Group %in% c("Video2", "exp")] = 'exp'

TB2$Group <- factor(TB2$Group, levels =unique(TB2$Group))

ggplot(TB2, aes(X, value, fill = Group))  + geom_boxplot(alpha = .5) +
    geom_point(position = position_dodge(.75) ) +  
    scale_fill_manual(values = c("#377EB8", "#E41A1C", "#B2DF8A", "purple")) +
    coord_cartesian(ylim = c(0,10000)) + 
    theme(panel.background = element_blank(), panel.border = element_rect(colour = 'black', fill = NA))

ggsave('img/Figure_2B/fead_mix.svg', w = 4, h = 3.35)

TB_wilcox <- data.frame( Pair = c("Ctl:Sp_vs_Mix", "Exp:Sp_vs_Mix"),
            P.value = c(wilcox.test(TB2$value[TB2$Group=='ctl'], TB2$value[TB2$Group == 'Vdeio1'])$p.value,
                    wilcox.test(TB2$value[TB2$Group=='exp'], TB2$value[TB2$Group == 'Video2'])$p.value)
)



TB_mix <- data.frame(row.names = paste("fly", c(0:7), sep = "_"))
for (file in Sig_lst){
    tmp_tb <- read.csv(paste(Fil_loc, file, sep=''))
    TB_mix[str_remove(file, '.MP4_feed.csv')] <- tmp_tb[[2]][match(row.names(TB_mix), tmp_tb$X)]
}
TB_mix[is.na(TB_mix)] <- 0
TB_mix$fly = row.names(TB_mix)
TB_mixL <- melt(TB_mix)

Group <- read.table(paste(Fil_loc, 'group.csv', sep=''))
Group$V1 <- paste("single", Group$V1, sep='')
Group$V2 <- paste("fly", Group$V2, sep='_')


TB_mixL$Group = 'down'
TB_mixL$Group[which(paste(TB_mixL[[1]], TB_mixL[[2]]) %in% paste(Group$V2, Group$V1))] <- 'up'
TB2 <- rbind(TB, TB_mixL[colnames(TB)])
TB2$X = "ctl"
TB2$X[TB2$Group %in% c("Video2", "up")] = 'exp'

TB2$Group <- factor(TB2$Group, levels = unique(TB2$Group))

ggplot(TB2, aes(X, value, fill = Group))  + geom_boxplot(alpha = .5) +
    geom_point(position = position_dodge(.75) ) +  
    scale_fill_manual(values = c("#377EB8", "#E41A1C", "#B2DF8A", "purple")) +
    coord_cartesian(ylim = c(0,10000)) + 
    theme(panel.background = element_blank(), panel.border = element_rect(colour = 'black', fill = NA))

ggsave('img/Figure_2B/fead_single.svg', w = 4, h = 3.35)


TB_wilcox <- rbind(TB_wilcox,  data.frame( Pair = c("Ctl:Sp_vs_Single", "Exp:Sp_vs_Single", "Sp:Ctl_vs_Exp"),
    P.value = c(wilcox.test(TB2$value[TB2$Group=='down'], TB2$value[TB2$Group == 'Vdeio1'])$p.value,
        wilcox.test(TB2$value[TB2$Group=='up'], TB2$value[TB2$Group == 'Video2'])$p.value,
        wilcox.test(TB2$value[TB2$Group=='Vdeio1'], TB2$value[TB2$Group == 'Video2'])$p.value)
))
write.table(TB_wilcox, 'img/Figure_2B/wilcox_test.csv', row.names = F, quote = F, sep = '\t')
ggplot(TB2, aes(x= value)) + geom_density() + facet_wrap(~Group, scales = 'free_y') + theme_bw()
ggsave('img/Figure_2B/Non-Gaussian_Distribution.svg', w = 8.35, h = 3.78)
