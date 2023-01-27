library(reshape2)
library(ggplot2)
library(stringr)


TB <- read.csv("1-CHCs.csv")[1:4]
colnames(TB) <- str_replace(colnames(TB), "[.]", " ")

TB_box <- melt(TB)
TB_bar <- Kaboom_bar(TB_box,  "variable", "Treat", P_test = "DunTest")[[2]]
TB_bar$variable <- as.data.frame(str_split_fixed(TB_bar$variable, "\n", 2))[[1]]
TB_bar$variable <- factor(TB_bar$variable, levels =  unique(TB_bar$variable))
TB_bar$Treat <- factor(TB_bar$Treat, levels =  unique(TB_bar$Treat))

ggplot(TB_bar, aes(x= Treat, y = Mean, fill=Treat)) + geom_bar(alpha=.7, stat='identity') +
    facet_wrap(~variable, scales = 'free')+ theme_bw()+
    geom_errorbar(aes(ymin=Mean-Sem, ymax=Mean+Sem), width=0.2)+
    theme(strip.background = element_rect(fill = "white"),
    axis.text.x = element_blank(), axis.ticks.x = element_blank())+
    scale_fill_manual(values = c("#1F78B4", "#33A02C", "salmon"))
ggsave('1-CHCs.svg', w = 5.77, h = 2.38)
write.csv(TB_bar, "1-CHCs.csv.csv")

# for 2-4
NAME = "-CHCs.csv"
for (ID in c(2:4)){
    TB <- read.csv(paste(ID, NAME, sep= ""))[1:4]
    colnames(TB) <- str_replace(colnames(TB), "[.]", " ")

    TB_box <- melt(TB)
    TB_bar <- Kaboom_bar(TB_box,  "variable", "Treat", P_test = "DunTest")[[2]]
    TB_bar$variable <- as.data.frame(str_split_fixed(TB_bar$variable, "\n", 2))[[1]]
    TB_bar$variable <- factor(TB_bar$variable, levels =  unique(TB_bar$variable))
    TB_bar$Treat <- factor(TB_bar$Treat, levels =  unique(TB_bar$Treat))

    ggplot(TB_bar, aes(x= Treat, y = Mean, fill=Treat)) + geom_bar(alpha=.7, stat='identity') +
    facet_wrap(~variable, scales = 'free')+ theme_bw()+
    geom_errorbar(aes(ymin=Mean-Sem, ymax=Mean+Sem), width=0.2)+
    theme(strip.background = element_rect(fill = "white"),
    axis.text.x = element_blank(), axis.ticks.x = element_blank())+
    scale_fill_manual(values = c("#1F78B4", "salmon", "#33A02C"))
ggsave(paste(ID, NAME,".svg", sep= ""), w = 5.77, h = 2.38)
write.csv(TB_bar, paste(ID, NAME,".csv", sep= ""))

}

#data[12]
library(ggplot2)
library(ggkaboom)
TB <- read.csv("data2.csv")
colnames(TB)[1] <- "Treat"
TB <- melt(TB)
TB$Treat <-  as.factor(TB$Treat)
TB$variable <-  as.factor(TB$variable)
TB_bar <- Kaboom_bar(TB , "variable", 'Treat', Facet = F, fill='Treat', P_test = "Tukey", Facet_row = "variable")[[2]]
TB_bar$variable <- as.data.frame(str_split_fixed(TB_bar$variable, "\n", 2))[[1]]
TB_bar$variable <- factor(TB_bar$variable, levels =  unique(TB_bar$variable))
TB_bar$Treat <- factor(TB_bar$Treat, levels =  unique(TB_bar$Treat))

ggplot(TB_bar, aes(x= Treat, y = Mean, fill=Treat)) + geom_bar(alpha=.7, stat='identity') +
    facet_wrap(~variable, scales = 'free')+ theme_bw()+
    geom_errorbar(aes(ymin=Mean-Sem, ymax=Mean+Sem), width=0.2)+
    theme(strip.background = element_rect(fill = "white"),
    axis.text.x = element_blank(), axis.ticks.x = element_blank())+
    scale_fill_manual(values = c("#1F78B4", "salmon", "#33A02C", "grey"))
ggsave('data2.svg', w = 5.77, h = 2.38)

TB_bar2 <- Kaboom_bar(TB , "variable", 'Treat', Facet = F, fill='Treat', P_test = "Tukey", Facet_row = "variable")[[3]]
write.csv(TB_bar2, "data2.csv.csv")
