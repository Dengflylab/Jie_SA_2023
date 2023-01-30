# Calculate with bash

```bash
for ii in $(awk -F, '{print $1}' ../Group_list2.csv| sort | uniq); do
	  for  i in $(grep -w $ii ../Group_list2.csv| awk '{print $2}'| sed 's/"//');do
			File=$(ls ../csv_800/*| grep -w $i.csv);
			FLY=$(grep " 0 " $File|wc -l);
			CH=$(grep " 3 " $File|wc -l);
			FW=$(grep " 4 " $File|wc -l);
			TC=$(grep " 5 " $File|wc -l);
			RESULT_C=$(echo 10000\*$CH/$FLY|bc);
			RESULT_F=$(echo 10000\*$FW/$FLY|bc);
			RESULT_T=$(echo 10000\*$TC/$FLY|bc);
			echo $ii $File $RESULT_C $RESULT_F $RESULT_T
		done;done  > Beha.csv &
```

# Readed in R and plot the Fan and bar

```r
library(stringr)
library(ggplot2)
library(ggthemes)
library(ggrepel)
TB <- read.table("Beha.csv", sep=" ")
TB$V2 <- str_replace(TB$V2, "../csv_800/", "")
colnames(TB) <- c("Group", "Sample", "CH", "FW", "TC")
TB[c("CH", "FW", "TC")] = TB[c("CH", "FW", "TC")]/100
write.csv(TB,"../Fan_plot/BOX_ALL_CH.csv")
# Single sample
for(i in TB$Sample){
ggplot(TB[ TB$Sample==i,], aes(x= Sample)) +   
  geom_bar(aes(y=100), stat =  "identity", alpha= 1, fill = "grey") +
  geom_bar(aes(y=CH), stat =  "identity", alpha= 0.7, fill = "steelblue") +
  geom_bar(aes(y=FW), stat =  "identity", alpha= 0.7, fill = "salmon")+
  geom_bar(aes(y=TC), stat =  "identity", alpha= 0.7, fill = "yellow")+
  coord_polar(theta = "y") + theme_map()+
  geom_text(aes(y=(CH+FW)/2, label=paste(CH, "%")))+
  geom_text(aes(y=(FW+TC)/2, label=paste(FW, "%")),nudge_x = 0.1,  nudge_y = 5)+
  geom_text(aes(y=(TC)/2, label=paste(TC, "%")), nudge_x = 0.2, nudge_y=1 )+
  geom_text(aes(y=(CH+100)/2, label=paste(100, "%")))+
  ggtitle(label = str_replace(i, ".mp4.csv", "")) +
  theme(plot.title = element_text(hjust = 0.5))
ggsave(paste("../Fan_plot",str_replace(i, ".mp4.csv", ".svg"),sep="/"),w=4, h=2.6)
}

# Group plot
for(i in unique(TB$Group)){
TMP = TB[ TB$Group==i ,]
ggplot(TMP, aes(x= Sample)) +
  geom_bar(aes(y=100), stat =  "identity", fill = "gray91") +    
  geom_bar(aes(y=CH), stat =  "identity", fill = "lightskyblue") +    
  geom_bar(aes(y=FW), stat =  "identity", fill = "salmon")+    
  coord_polar(theta = "y") +     
  #geom_text(aes(y=(CH+FW)/2, label=paste(CH, "%")), angle= 90 - 90*((TMP$CH+TMP$FW)/2/33.3), hjust=0.5)+    
  #geom_text(aes(y=0, label=paste(FW, "%")), angle = 90, hjust=0) +
  #geom_text(aes(y=(CH+100)/2, label=paste(100, "%")), angle = 90 - 90*(TMP$CH+100)/2/33.3)+    
  #geom_text(aes(y=100, label=str_replace(Sample, ".mp4.csv", "")), hjust= 0)+    
  expand_limits(x=c(-3,8), y= c(-100/3, 100)) +
  ggtitle(label = i)+ theme(plot.title = element_text(hjust = 0.5))+
  theme_bw()+ theme(axis.text.y = element_blank(), axis.ticks = element_blank(),  axis.title = element_blank() , panel.border = element_blank())
ggsave(paste("../Fan_plot/",i,".svg",sep=""),w=5.61, h=4.6)
}
```

# Bar and box plot

```r
ggplot(TB, aes(Group, CH, fill= Group)) + geom_boxplot(width=0.5)+
  geom_point(alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()
ggsave("../Fan_plot/BOX_ALL_CH.svg", w= 8, h = 3.5)

ggplot(TB, aes(Group, FW, fill= Group)) + geom_boxplot(width=0.5)+
  geom_point(alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()
ggsave("../Fan_plot/BOX_ALL_FW.svg", w= 8, h = 3.5)

ggplot(TB, aes(Group, TC, fill= Group)) + geom_boxplot(width=0.5)+
  geom_point(alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()
ggsave("../Fan_plot/BOX_ALL_TC.svg", w= 8, h = 3.5)
```


## Bar

```r
# CH
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$CH)
	SE  = sd(TMP$CH)/sqrt(length(TMP$CH))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

write.csv(TB_BAR,"../Fan_plot/Bar_ALL_CH.csv")

ggplot(TB_BAR, aes(Group, ME, fill=Group)) + geom_bar(stat = 'identity', width=0.6)+
  geom_errorbar(aes(ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()

ggsave("../Fan_plot/Bar_ALL_CH.svg", w= 8, h = 3.5)

#
# FW
#

TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$FW)
	SE  = sd(TMP$FW)/sqrt(length(TMP$FW))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}
write.csv(TB_BAR,"../Fan_plot/Bar_ALL_FW.csv")


ggplot(TB_BAR, aes(Group, ME, fill=Group)) + geom_bar(stat = 'identity', width=0.6)+
  geom_errorbar(aes(ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()

ggsave("../Fan_plot/Bar_ALL_FW.svg", w= 8, h = 3.5)

#
# TC
#

TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$TC)
	SE  = sd(TMP$TC)/sqrt(length(TMP$TC))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}
write.csv(TB_BAR,"../Fan_plot/Bar_ALL_TC.csv")

ggplot(TB_BAR, aes(Group, ME, fill=Group)) + geom_bar(stat = 'identity', width=0.6)+
  geom_errorbar(aes(ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()

ggsave("../Fan_plot/Bar_ALL_TC.svg", w= 8, h = 3.5)

```

## one-way anova Example

```r
for (i in c(1:4)){
        result = aov(CH~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
        print(c(paste("Group",1,sep=""), "Group8"))
        print(summary(result)[[1]]["Pr(>F)"][[1]][1])
    }
```

### FIg1_chasing

#### Box
```r
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
```

#### Bar
```r
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 40+Group*5, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 42+Group*5, label=label), hjust=0)

ggsave("../Fan_plot/Fig1_bar_ch.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_bar_ch.csv")
```





### FIg1_FW

#### Box
```r
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


ggsave("../Fan_plot/Fig1_box_fw.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_box_fw.csv")
```

#### Bar
```r
# FW
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$FW)
	SE  = sd(TMP$FW)/sqrt(length(TMP$FW))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 6+Group*1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 6.4+Group*1, label=label), hjust=0)

ggsave("../Fan_plot/Fig1_bar_fw.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_bar_fw.csv")
```


###

### FIg1_TC

#### Box
```r
List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group4","Group5"),])
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
ggplot() +
  geom_boxplot(data=TB_1, aes(x=Group, y=TC, fill= Group), width=0.3)+
  #geom_point(data=TB_1, aes(x=Group, y=TC, fill= Group),alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*0.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*0.1, label=label), hjust=0)


ggsave("../Fan_plot/Fig1_box_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_box_tc.csv")
```

#### Bar
```r
# TC
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$TC)
	SE  = sd(TMP$TC)/sqrt(length(TMP$TC))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5")
TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in c(1:4)){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(paste("Group",i,sep=""), "Group8"),])
  X = c(paste("Group",i,sep=""), "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group4","Group5"),])
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*.1, label=label), hjust=0)

ggsave("../Fan_plot/Fig1_bar_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig1_bar_tc.csv")
```


---


### FIg6_chasing

#### Box
```r
List = c("Group8", "Group4", "Group9", "Group10", "Group7")
List2 = c("Group4", "Group9", "Group10")
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(CH~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(CH~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"
#TB_anov$X = factor(TB_anov$X , levels = List)

C_map_fig6_chain <- c('lightskyblue', 'salmon', '#B2DF8A', '#33A02C', '#6A3D9A')

TB_1$PValue = TB_anov$PValue[match(TB_1$Group, TB_anov$X)]
ggplot() +
  geom_boxplot(data=TB_1, aes(x=Group, y=CH, fill= Group), width=0.55)+
	scale_fill_manual(values=C_map_fig6_chain)+ theme_bw()+
	coord_cartesian(y= c(0, 65))+
	theme(panel.grid = element_blank())

ggsave("../Fan_plot/Fig6_box_ch.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_box_ch.csv")
```

#### Bar
```r
# CH
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$CH)
	SE  = sd(TMP$CH)/sqrt(length(TMP$CH))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(CH~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(CH~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 40+Group*5, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 42+Group*5, label=label), hjust=0)

ggsave("../Fan_plot/Fig6_bar_ch.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_bar_ch.csv")
```


### FIg1_FW

#### Box
```r
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)

Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(FW~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(FW~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
	scale_fill_manual(values=C_map_fig6_chain)+ theme_bw()+
	coord_cartesian(y= c(0, 13))+
	theme(panel.grid = element_blank())



ggsave("../Fan_plot/Fig6_box_fw.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_box_fw.csv")
```

#### Bar
```r
# FW
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$FW)
	SE  = sd(TMP$FW)/sqrt(length(TMP$FW))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(FW~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(FW~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 6+Group*1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 6.4+Group*1, label=label), hjust=0)

ggsave("../Fan_plot/Fig6_bar_fw.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_bar_fw.csv")
```


###

### FIg1_TC

#### Box
```r
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)

Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_boxplot(data=TB_1, aes(x=Group, y=TC, fill= Group), width=0.3)+
  #geom_point(data=TB_1, aes(x=Group, y=TC, fill= Group),alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*0.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*0.1, label=label), hjust=0)


ggsave("../Fan_plot/Fig6_box_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_box_tc.csv")
```

#### Bar
```r
# TC
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$TC)
	SE  = sd(TMP$TC)/sqrt(length(TMP$TC))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*.1, label=label), hjust=0)

ggsave("../Fan_plot/Fig6_bar_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_bar_tc.csv")
```


## NO Head


#### Box
```r
TB_1 = TB[ TB$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)

Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_boxplot(data=TB_1, aes(x=Group, y=TC, fill= Group), width=0.3)+
  #geom_point(data=TB_1, aes(x=Group, y=TC, fill= Group),alpha = .4)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*0.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*0.1, label=label), hjust=0)


ggsave("../Fan_plot/Fig6_box_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_box_nohead.csv")
```

#### Bar
```r
# TC
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$TC)
	SE  = sd(TMP$TC)/sqrt(length(TMP$TC))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = Group*.1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = Group*.1, label=label), hjust=0)

ggsave("../Fan_plot/Fig6_bar_tc.svg", w=5.89, h = 2.96)
write.csv(TB_1,"../Fan_plot/Fig6_bar_nohead.csv")
```




## Bar to ring

### Fig 1

```r
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$CH)
	SE  = sd(TMP$CH)/sqrt(length(TMP$CH))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


List = c("Group8", "Group1", "Group2", "Group4", "Group3", "Group5", "Group6", "Group7")
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 40+Group*5, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 42+Group*5, label=label), hjust=0)

TB_CH <- TB_1
#####################
## FW
#####################

TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$FW)
	SE  = sd(TMP$FW)/sqrt(length(TMP$FW))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
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
  geom_bar(data = TB_1, aes(x=Group, y=ME, fill=Group), stat = 'identity', width=0.4)+
  geom_errorbar(data = TB_1, aes(x=Group, y=ME, fill=Group, ymin=ME-SE, ymax=ME+SE), width=0.2)+
  scale_fill_brewer(palette = "Paired")+ theme_bw()+
  geom_line(data=TB_anov, aes(x=X, y = 6+Group*1, group=Group))+
  geom_text(data=TB_anov[c(1:nrow(TB_anov))%%2==0,], aes(x=X, y = 6.4+Group*1, label=label), hjust=0)
TB_FW <- TB_1


#################
## TC
#################

# TC
TB_BAR = data.frame()
for(i in unique(TB$Group)){
	TMP = TB[ TB$Group==i ,]
	ME  = mean(TMP$TC)
	SE  = sd(TMP$TC)/sqrt(length(TMP$TC))
	TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}


TB_1 = TB_BAR[ TB_BAR$Group %in% List,]
TB_1$Group = factor(TB_1$Group , levels = List)


Num = 0
TB_anov = data.frame()
for (i in List2){
	Num = Num +1
  result = aov(TC~Group , data = TB[ TB$Group %in% c(i , "Group8"),])
  X = c(i, "Group8")
  label = summary(result)[[1]]["Pr(>F)"][[1]][1]
  TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))
}

Num = Num +1
result = aov(TC~Group , data = TB[ TB$Group %in% c("Group7","Group4"),])
X = c("Group7","Group4")
label = summary(result)[[1]]["Pr(>F)"][[1]][1]
TB_anov = rbind(TB_anov, data.frame(X=X, Group= Num, PValue = label))

TB_anov$label = TB_anov$PValue
TB_anov$label[TB_anov$PValue < 0.05] = "*"
TB_anov$label[TB_anov$PValue < 0.01] = "**"
TB_anov$label[TB_anov$PValue < 0.001] = "***"
TB_anov$label[TB_anov$PValue == 0] = "****"
#TB_anov$X = factor(TB_anov$X , levels = List)


TB_1$PValue = TB_anov$PValue[match(TB_1$Group, TB_anov$X)]
TB_TC <- TB_1
```

Now, let's do it!

```r
TB_CH$Be = "CH"
TB_FW$Be = "FW"
TB_TC$Be = "TC"
TB_FL <- TB_CH
TB_FL$Be = "Fly"
TB_FL$ME = 100
TB_FL$SE = 0
TB_plot <- rbind(TB_CH, TB_FW, TB_TC, TB_FL)
i = "Group1"
TMP = TB_plot[TB_plot$Group==i,]
ggplot() +
	geom_bar(data=TMP[TMP$Be=="Fly",], aes(x=Group, y=ME),
		stat= "identity", fill = 'lightgrey')+
	geom_bar(data=TMP[TMP$Be=="CH",], aes(x=Group, y=ME),
		stat= "identity", fill = 'lightskyblue')+
	geom_bar(data=TMP[TMP$Be=="FW",], aes(x=Group, y=ME),
		stat= "identity", fill = 'salmon')+
	geom_bar(data=TMP[TMP$Be=="TC",], aes(x=Group, y=ME),
		stat= "identity", fill = 'yellow')




ggplot() +
  geom_bar(data=TMP[TMP$Be=="Fly",], aes(x=Group, y=ME),
	  stat= "identity", fill = 'lightgrey')+
  geom_bar(data=TMP[TMP$Be=="CH",], aes(x=Group, y=ME),
	  stat= "identity", fill = 'lightskyblue')+
  geom_bar(data=TMP[TMP$Be=="FW",], aes(x=Group, y=ME),
	  stat= "identity", fill = 'salmon')+
  geom_bar(data=TMP[TMP$Be=="TC",], aes(x=Group, y=ME),
	  stat= "identity", fill = 'yellow')+
  coord_polar( theta = 'y' )+
  expand_limits(x=c(-1,1), y= c(-100/3, 100))+
  theme_bw()+ theme(axis.text.y = element_blank(), axis.ticks = element_blank(),  axis.title = element_blank() , panel.border = element_blank())		
```
