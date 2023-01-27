library(ggplot2)
library(stringr)

Dir_out = "img/Figure_1C_6E/"
dir.create(Dir_out)

TB <- read.table("data/Beha.csv")
colnames(TB) <- c("Group", "Sample", "CH", "FW", "TC")



for(i in unique(TB$Group)){
  TMP = TB[ TB$Group==i ,]
  ggplot(TMP, aes(x= Sample)) +
    geom_bar(aes(y=100), stat =  "identity", fill = "gray91") +    
    geom_bar(aes(y=CH/100), stat =  "identity", fill = "lightskyblue") +    
    geom_bar(aes(y=FW/100), stat =  "identity", fill = "salmon")+    
    coord_polar(theta = "y") +     
    expand_limits(x=c(-3,8), y= c(-100/3, 100)) +
    ggtitle(label = i)+ theme(plot.title = element_text(hjust = 0.5))+
    theme_bw()+ theme(axis.text.y = element_blank(), axis.ticks = element_blank(),  axis.title = element_blank() , panel.border = element_blank())
  ggsave(paste(Dir_out,i,".svg",sep=""),w=5.61, h=4.6)
}