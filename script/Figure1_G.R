library(ggplot2)
library(repr)
library(ggthemes)
library(stringr)

List = c("img/Figure_1F/20210803_no_head_promE-fru-IR-V330035-VS-Wild-typeC0171_Trim.mp4.csv_Well_1_1.5min.csv",
"img/Figure_1F/20210818no_head_Elav-fru-IR-V330035_male-VS-Wild-type_male_C0217_Trim.mp4.csv_Well_1_1.5min.csv",
"img/Figure_1F/20211007-No_head_w1118_female___fru-IRV330035_2C0266_Trim.mp4.csv_Well_2_1.5min.csv",
"img/Figure_1F/20210804_no_head_Wild-type-male-VS-promE-fru-IR-V330035_male_C0178_Trim.mp4.csv_Well_2_1.5min.csv")






Group <- read.table("data/Group_nohead.list")

NO_HEAD <- data.frame()
for(Num in c(1:nrow(Group))){
    i = Group[Num,2]
    ii = str_replace(Group[1,3],"Well","Well_")
    TB <- read.csv(paste("img/Figure_1G/", i, ".mp4.csv_",ii ,"_1.5min.csv", sep =""))
    CH_r = nrow(TB[TB$X5=="steelblue",])/nrow(TB)
    FW_r = nrow(TB[TB$X5=="salmon",])/nrow(TB)
    TC_r = nrow(TB[TB$X5=="yellow",])/nrow(TB)
    TMP = data.frame(Y = c(1, CH_r, FW_r, TC_r) , Be = c("Fly", "Chasing", "FW", "TC"), 
                     Group = Group$V1[Group$V2==i][1], Sample=paste(i,ii,sep="_"))
    options(repr.plot.width=5, repr.plot.height=1)
    NO_HEAD <- rbind(NO_HEAD, TMP)
}



TB <- NO_HEAD[NO_HEAD$Be=="Chasing",]
TB_BAR = data.frame()
for(i in unique(TB$Group)){
    TMP = TB[ TB$Group==i ,]
    ME  = mean(TMP$Y)
    if(sum(TMP$Y) !=0){
        SE  = sd(TMP$Y)/sqrt(length(TMP$Be))
        }
    else{
        SE = 0
    }
    TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

TB_1 <- TB_BAR

TB <- NO_HEAD[NO_HEAD$Be=="FW",]
TB_BAR = data.frame()
for(i in unique(TB$Group)){
    TMP = TB[ TB$Group==i ,]
    ME  = mean(TMP$Y)
    if(sum(TMP$Y) !=0){
        SE  = sd(TMP$Y)/sqrt(length(TMP$Be))
        }
    else{
        SE = 0
    }
    TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

TB_1 <- TB_BAR
TB <- NO_HEAD[NO_HEAD$Be=="TC",]
TB_BAR = data.frame()
for(i in unique(TB$Group)){
    TMP = TB[ TB$Group==i ,]
    ME  = mean(TMP$Y)
    if(sum(TMP$Y) !=0){
        SE  = sd(TMP$Y)/sqrt(length(TMP$Be))
        }
    else{
        SE = 0
    }
    TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

TB_1 <- TB_BAR
TB <- NO_HEAD[NO_HEAD$Be=="Chasing",]
TB_BAR = data.frame()
for(i in unique(TB$Group)){
    TMP = TB[ TB$Group==i ,]
    ME  = mean(TMP$Y)
    if(sum(TMP$Y) !=0){
        SE  = sd(TMP$Y)/sqrt(length(TMP$Be))
        }
    else{
        SE = 0
    }
    TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

TB_1 <- TB_BAR
TB <- NO_HEAD[NO_HEAD$Be=="FW",]
TB_BAR = data.frame()
for(i in unique(TB$Group)){
    TMP = TB[ TB$Group==i ,]
    ME  = mean(TMP$Y)
    if(sum(TMP$Y) !=0){
        SE  = sd(TMP$Y)/sqrt(length(TMP$Be))
        }
    else{
        SE = 0
    }
    TB_BAR = rbind(TB_BAR, data.frame(Group=i, ME=ME, SE=SE))
}

TB_2 <- TB_BAR

TB_1$Be = "CH"
TB_2$Be = "FW"
TB_plot <- rbind(TB_1, TB_2)

TB_back <- TB_plot
TB_back$ME= 1

GG = "Group2"
for(GG in c("Group1", "Group2", "Group3", "Group4")){
    options(repr.plot.width=3.3, repr.plot.height=0.75)
    P <- ggplot(TB_plot[TB_plot$Group==GG,])+ 
        geom_bar(data= TB_back[TB_back$Group==GG,], aes(x=Be, y =ME,), stat='identity', 
                     fill="gray91", width = 1)+
        geom_bar(aes(x=Be, y =ME, fill=Be), stat = 'identity', position = 'dodge', width = 1)+
        geom_errorbar(aes(x=Be, y=ME, ymin=ME-SE, ymax=ME+SE), width=0.4)+
        coord_flip()+ theme_map() +
        theme(legend.position = "none", strip.background = element_blank())+
        geom_text(aes(x=Be, y=.95, label=paste(round(ME*100,2),"%")), hjust=1, size = 6)+
        scale_fill_manual(values=c("salmon","LightSkyBlue"))
    print(P)
    ggsave(paste("img/Figure_1G/Fig1_G_", GG,"_.svg", sep=""), w=3.3,h=0.75)
}

