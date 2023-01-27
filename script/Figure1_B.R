library(ggplot2)

Dir_out = "img/Figure_1B_6D/"
dir.create(Dir_out)
List = c("Ctrl.mp4.csv", "elav-fru-IR.mp4.csv", "Mutant-clone.mp4.csv", "promE-fru-IR-Hnf4-EP-OE.mp4.csv", "promE-fru-IR-Hnf4-HA-OE.mp4.csv", "promE-fru-IR-v330035-fruB-OE.mp4.csv", "promE-fru-Trip.mp4.csv", "promE-fru-v330035.mp4.csv", "promE-Hnf4-IR-BL29375.mp4.csv", "promE-Hnf4-IR-BL64988.mp4.csv")

raw_Dir = "data/csv2"
Clss_n = c(0, 1, 2, 3, 4, 5)
Clss_t = c("Fly", "Head", "Gromming", "Chasing", "FW", "TC")
F_level = c("Fly", "Chasing", "FW", "TC")

for(i in List){
    File = paste(raw_Dir, "/", i, sep ="" )
    A = read.table(File, header= F)
    A$Class = ""
    for(ii in Clss_n){
    A$Class[which(A$V2==ii)] = Clss_t[ii+1]
    }
    options(repr.plot.width=5.7, repr.plot.height=5.4)
    #TMP = A[which(A$V1%%45==0),]
    TMP <-  A
    TMP <- TMP[TMP$Class != "Head",]
    TMP <- TMP[TMP$V1 <= 30*60*1.5,]
    P <- ggplot(TMP[TMP$Class=="Fly",], aes(x=V3, y = V4)) + geom_point(color = "grey",alpha = .1,)+
        theme( axis.ticks = element_blank(),
            axis.text = element_blank(),
            axis.title = element_blank(),
            panel.background = element_blank())+
        labs(title = i)+
        geom_point(data= TMP[TMP$Class=="Chasing",], color = "steelblue",alpha = .3,)+
        geom_point(data= TMP[TMP$Class=="FW",], color = "salmon",alpha = .3,)+
        geom_point(data= TMP[TMP$Class=="TC",], color ="yellow",alpha = .5,size=2)+
        theme(plot.title = element_text(hjust = .5))
        ggsave(paste(Dir_out,i,"_plate.svg", sep=""), w = 5.7, h = 5.9)
    print(P)
}