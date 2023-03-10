import os, operator
from collections import namedtuple
import pandas as pd

import seaborn as sns
import matplotlib.pyplot as plt

Rectangle = namedtuple('Rectangle', 'xmin ymin xmax ymax')
MATCH_result = None
def area(a, b):  # returns None if rectangles don't intersect
    dx = min(a.xmax, b.xmax) - max(a.xmin, b.xmin)
    dy = min(a.ymax, b.ymax) - max(a.ymin, b.ymin)
    if (dx>=0) and (dy>=0):
        return dx*dy

List = [i for i in os.listdir("data/csv") if "o_head" not in i and ".mp4.csv" in i]

def Chase_TB(Video):
    File = 'data/csv/' + Video
    F= open(File, 'r').read().split("\n")
    TB = pd.DataFrame([i.split(" ") for i in F])

    Chasing_TB = TB[TB[1] == "3"]
    Frame = Chasing_TB[0]
    Frames = list(set([int(i) for i in Frame]))

    Chain_dic =  {}
    for F in Frames:
        Chain_dic.update({F:0})
        # Calculate the overlaped chasing box
        Result= []
        if len(Chasing_TB[Chasing_TB[0]==str(F)]) >1:
            TB_TMP = TB[TB[0]==str(F)]
            ChBox = Chasing_TB[Chasing_TB[0]==str(F)]
            for i in range(len(ChBox.index)):
                index_i = ChBox.index [i]
                CH_i = ChBox[ChBox.index== index_i].iloc[:,2:6].to_numpy()[0].astype(float)
                CH_i = Rectangle(CH_i[0]-CH_i[2]/2, CH_i[1]-CH_i[3]/2, CH_i[0]+CH_i[2]/2, CH_i[1]+CH_i[3]/2)
                if i + 1 <= len(ChBox.index) -1:
                    ii = i 
                    while ii+1 < len(ChBox.index) :
                        ii += 1
                        index_ii = ChBox.index [ii]
                        CH_ii = ChBox[ChBox.index==index_ii].iloc[:,2:6].to_numpy()[0].astype(float)
                        CH_ii = Rectangle(CH_ii[0] - CH_ii[2]/2, CH_ii[1] - CH_ii[3]/2,  CH_ii[0] + CH_ii[2]/2, CH_ii[1] + CH_ii[3]/2)
                        R = area(CH_i, CH_ii)
                        if R !=None:
                            Result += [[index_i, index_ii]]

        # if there are over lapped box
        if len(Result) != 0:
            for Pair_Box in Result:
                Pair_flies = []
                Body_TB = TB_TMP[TB_TMP[1]=="0"]
                for Ch_box_id in Pair_Box:
                    Ch_fly = {}
                    Ch_box = TB_TMP[TB_TMP.index==Ch_box_id].iloc[:,2:6].to_numpy()[0].astype(float)
                    Ch_box = Rectangle(Ch_box[0] - Ch_box[2]/2, Ch_box[1] - Ch_box[3]/2,
                                    Ch_box[0] + Ch_box[2]/2, Ch_box[1] + Ch_box[3]/2)

                    for body_index in Body_TB.index:
                        body_tmp = TB_TMP[TB_TMP.index==body_index].iloc[:,2:6].to_numpy()[0].astype(float)
                        body_loc = Rectangle(body_tmp[0] - body_tmp[2]/2, body_tmp[1] - body_tmp[3]/2,
                                            body_tmp[0] + body_tmp[2]/2, body_tmp[1] + body_tmp[3]/2)
                        R = area(Ch_box, body_loc)
                        if R != None:
                            R = R/(body_loc[2]*body_loc[3])
                            Ch_fly.update({body_index:R})
                    if len(Ch_fly) >= 2:
                        Ch_fly = dict( sorted(Ch_fly.items(), key=operator.itemgetter(1),reverse=True))
                        Pair_flies += list(Ch_fly.keys())[:2]
                print(F, Pair_flies)
                if len(set(Pair_flies)) == 3:
                    Chain_dic[F] += 1

    Chaing_TB = pd.DataFrame(Chain_dic.items(), columns=['Frame', 'Counts'])
    Chaing_TB.to_csv("data/Chian_result/" + File.split("/")[-1]+"_Chain.csv")

    File = "data/Chian_result/" + File.split("/")[-1]+"_Chain.csv"

    Chaing_TB = pd.read_csv(File, names = None)
    Chaing_TB["Second"]= Chaing_TB["Frame"]/30
    Chaing_TB["Min"]= [str(int(i/30/60))+":"+str(int(i/30%60)) for i in  Chaing_TB["Frame"] ]
    Frame = Chaing_TB["Frame"]
    Frames = list(set([int(i) for i in Frame]))
    #sns.light_palette("seagreen", as_cmap=True)
    sns.color_palette("Paired")
    #sns.color_palette("coolwarm", as_cmap=True)
    fig, ax = plt.subplots(figsize=(15, 2))
    Chaing_TB[Chaing_TB["Counts"]==0]

    sns.rugplot(data= Chaing_TB[Chaing_TB["Counts"]!=0], x= "Frame", y = 0, hue = "Counts",
                 palette="Paired",  height=1,  legend = False ).set( title=File, xlim=(0,18000))
    ax.set_xticks([0, 30*60, 30*60 *2, 30*60*3, 30*60*4, 30*60*5, 30*60*6, 30*60*7, 30*60*8, 30*60*9, 30*60*10 ])
    ax.set_xticklabels(["0min","1min","2min","3min","4min","5min","6min","7min","8min","9min", "10min"])
    ax.set_yticks([])
    fig.savefig("img/Figure_1D_6F/"+File.split("/")[-1] + "_chain.svg")



for Video in List:
    Chase_TB(Video)