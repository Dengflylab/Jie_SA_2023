library(ggplot2)
library(reshape2)
library(stringr)


OUT_dir = "img/Figure_1D_6F/"
dir.create(OUT_dir)

Color_TB <- data.frame(Color =  
  c('#A6CEE3','#1F78B4','#B2DF8A',
    '#33A02C','#FB9A99','#E31A1C',
    '#FDBF6F','#FF7F00','#CAB2D6',
    '#6A3D9A','#FFFF99','#B15928'),
Group = "")


C_map_fig1_chain <- c('lightskyblue', '#B2DF8A', '#33A02C', 'salmon', '#FDBF6F','#6A3D9A')
C_map_fig6_chain <- c('lightskyblue', 'salmon', '#B2DF8A', '#33A02C', '#6A3D9A')


TB <- read.table("data/Beha.csv")
TB$V2 <- str_replace(TB$V2, "data/csv/", "")

colnames(TB) <- c("Group", "Sample", "CH", "FW", "TC")
TB[c("CH", "FW", "TC")] = TB[c("CH", "FW", "TC")]/100


Group <- read.table("data/Group_list2.csv")
Group <- as.data.frame(str_split_fixed(Group$V1, ",", 3))
Group <- Group[-1,]
colnames(Group) <- c("Group", "", "Video")



List <- c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
Group <- Group[Group$Group %in%  List,]
#Group$Video <- as.data.frame(str_split_fixed(Group$Video,"\t",2))[[2]]


Chain_TB <- data.frame()
for(i in Group$Video){
	FLY<-read.csv(paste("data/csv/", i,  ".csv", sep=""), sep=" ", header = F)
	TMP <- read.csv(paste("data/Chian_result/", i,  ".csv_Chain.csv", sep=""))
	GROUP <- Group$Group[Group$Video == i]
	SUM <- sum(TMP$Counts)/length(FLY$V2[FLY$V2==0])
	Chain_TB <- rbind(Chain_TB, data.frame(Group = GROUP, Sample = i, Sum = SUM))
}

Chain_TB$Group <- factor(Chain_TB$Group, levels= rev.default(List))



###
### Calculating the significant between groups
###

Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(Sum~Group , data = Chain_TB[ Chain_TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(Sum~Group , data = Chain_TB[ Chain_TB$Group %in% c("Group4","Group5"),])
X = c("Group5","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"

ggplot() +
  geom_boxplot(data=Chain_TB, aes(x=Group, y=Sum, fill= Group), width=0.7)+  
  theme_bw()+ coord_flip(y=c(0.018, 0.382),x=c(1.15,5.85))+
  scale_fill_manual(values=rev.default( C_map_fig1_chain))+  
  theme(panel.border = element_rect(colour = 'lightgrey'),
      panel.grid = element_blank(),  
      legend.position = 'none',
      axis.ticks.y = element_blank(),
      axis.text.y = element_blank(), axis.title = element_blank())

ggsave("img/Figure_1D_6F/Fig1_Chaining_box.svg", w=4/2, h = 5.72/2)

write.csv(TB_anov, "img/Figure_1D_6F/Fig1_box_ch_anova.csv")
write.csv(Chain_TB,"img/Figure_1D_6F/Fig1_box_ch.csv")
#



Group <- read.table("data/Group_list2.csv")
Group <- as.data.frame(str_split_fixed(Group$V1, ",", 3))
Group <- Group[-1,]
colnames(Group) <- c("Group", "", "Video")


List <- c("Group8", "Group4", "Group9", "Group10", "Group7")
Group <- Group[Group$Group %in%  List,]

Chain_TB <- data.frame()
for(i in Group$Video){
	FLY<-read.csv(paste("data/csv/", i,  ".csv", sep=""), sep=" ", header = F)
	TMP <- read.csv(paste("data/Chian_result/", i,  ".csv_Chain.csv", sep=""))
	GROUP <- Group$Group[Group$Video == i]
	SUM <- sum(TMP$Counts)/length(FLY$V2[FLY$V2==0])
	Chain_TB <- rbind(Chain_TB, data.frame(Group = GROUP, Sample = i, Sum = SUM))
}

Chain_TB$Group <- factor(Chain_TB$Group, levels= rev.default(List))


Num = 0
TB_anov = data.frame()
for (i in c(4,9,10)){
	Num = Num +1
  result = aov(Sum~Group , data = Chain_TB[ Chain_TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(Sum~Group , data = Chain_TB[ Chain_TB$Group %in% c("Group4","Group7"),])
X = c("Group7","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"


ggplot() +
  geom_boxplot(data=Chain_TB, aes(x=Group, y=Sum, fill= Group), width=0.7)+  
  theme_bw()+ coord_flip(y=c(0.018, 0.382),x=c(1.15,4.85))+
  scale_fill_manual(values=rev.default( C_map_fig6_chain))+  
  theme(panel.border = element_rect(colour = 'lightgrey'),
      panel.grid = element_blank(),  
      legend.position = 'none',
      axis.ticks.y = element_blank(),
      axis.text.y = element_blank(), axis.title = element_blank())
ggsave("img/Figure_1D_6F/Fig6_Chaining_box.svg", w=3.27/2, h = 4.73/2)


write.csv(TB_anov,"img/Figure_1D_6F/Fig6_box_ch_anova.csv")
write.csv(Chain_TB,"img/Figure_1D_6F/Fig6_box_ch.csv")




# Supplemental

List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(FW~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(FW~Group , data = TB[ TB$Group %in% c("Group4","Group5"),])
X = c("Group5","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"
#TB_anov$X = factor(TB_anov$X , levels = List)


TB_1$PValue = TB_anov$PValue[match(TB_1$Group, TB_anov$X)]
ggplot() +
  geom_boxplot(data=TB_1, aes(x=Group, y=FW, fill= Group), width=0.55)+
	scale_fill_manual(values=C_map_fig1_chain)+ theme_bw()+
	coord_cartesian(y= c(0, 13))+
	theme(panel.grid = element_blank())




dir.create("img/Figure_S2A")
ggsave("img/Figure_S2A/Figure_right.png", w=5.89, h = 2.96)
write.csv(TB_1,"img/Figure_S2A/Fig1_box_fw.csv")



ggplot() +
  geom_boxplot(data=TB_1, aes(x=Group, y=CH, fill= Group), width=0.55)+
	scale_fill_manual(values=C_map_fig1_chain)+ theme_bw()+
	coord_cartesian(y= c(0, 65))+
	theme(panel.grid = element_blank())

ggsave("img/Figure_S2A/Figure_left.png", w=5.89, h = 2.96)
