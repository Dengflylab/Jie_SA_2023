
List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(CH~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(CH~Group , data = TB[ TB$Group %in% c("Group4","Group5"),])
X = c("Group5","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"
#TB_anov$X = factor(TB_anov$X , levels = List)

C_map_fig1_chain <- c('lightskyblue', '#B2DF8A', '#33A02C', 'salmon', '#FDBF6F','#6A3D9A')

TB_1$PValue = TB_anov$PValue[match(TB_1$Group, TB_anov$X)]
# CH
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$CH)
	SE  = sd(TMP$CH)/sqrt(length(TMP$CH))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}










List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(CH~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(CH~Group , data = TB[ TB$Group %in% c("Group4","Group5"),])
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
  geom_boxplot(data=TB_1, aes(x=Group, y=CH, fill= Group), width=0.55)+
	scale_fill_manual(values=C_map_fig1_chain)+ theme_bw()+
	coord_cartesian(y= c(0, 65))+
	theme(panel.grid = element_blank())


ggsave("../Fan_plot/Fig1_box_ch.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_box_ch.csv")