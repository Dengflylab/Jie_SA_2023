import os
import pandas as pd
from collections import namedtuple
import seaborn as sns
import matplotlib.pyplot as plt
import operator
import numpy as np

os.system('mkdir img/Figure_1F')

List = [i for i in os.listdir("data/csv") if "o_head" in i and ".mp4.csv" in i]

Wells_dic =  {
              '20210818no_head_Elav-fru-IR-V330035_male-VS-Wild-type_male_C0217_Trim.mp4.csv':
                  {
                    "Well_1":[366, 830, 315, 789]
                  },
              "20210803_no_head_promE-fru-IR-V330035-VS-Wild-typeC0171_Trim.mp4.csv":
                  {"Well_1" : [493, 940, 140, 591]},
              '20211007-No_head_w1118_female___fru-IRV330035_2C0266_Trim.mp4.csv':
                  {
                    "Well_2": [900, 1410, 67, 550]
                  },
               '20210804_no_head_Wild-type-male-VS-promE-fru-IR-V330035_male_C0178_Trim.mp4.csv':
                  {
                    "Well_2": [1100, 1700, 200, 800]
                  }   
    
         }
Frame_dic =  {
              '20210818no_head_Elav-fru-IR-V330035_male-VS-Wild-type_male_C0217_Trim.mp4.csv':
                  [3*30*60, 4.5*30*60],
              "20210803_no_head_promE-fru-IR-V330035-VS-Wild-typeC0171_Trim.mp4.csv":
                  [2.5*30*60, 4*30*60],
              '20211007-No_head_w1118_female___fru-IRV330035_2C0266_Trim.mp4.csv':
                  [2.5*30*60, 4*30*60],
               '20210804_no_head_Wild-type-male-VS-promE-fru-IR-V330035_male_C0178_Trim.mp4.csv':
                  [35 * 30,125*30]  
    
         }

Rectangle = namedtuple('Rectangle', 'xmin ymin xmax ymax')
MATCH_result = None
def area(a, b):  # returns None if rectangles don't intersect
    dx = min(a.xmax, b.xmax) - max(a.xmin, b.xmin)
    dy = min(a.ymax, b.ymax) - max(a.ymin, b.ymin)
    if (dx>=0) and (dy>=0):
        return dx*dy


for File in Wells_dic.keys():
    File = 'data/csv/' + File
    F= open(File, 'r').read().split("\n")
    TB = pd.DataFrame([i.split(" ") for i in F])

    Fram_total = [int(i) for i in TB[0] if i != ""][-1]

    Wells = Wells_dic[File.split("/")[-1]]

    for Well_ID in Wells.keys(): 
        Bind_TB = pd.DataFrame()
        fig, ax = plt.subplots(figsize=(8, 8))
        for Frame in  range(int(Frame_dic[File.split("/")[-1]][0]),
                            int(Frame_dic[File.split("/")[-1]][1])):
            TMP = TB[TB[0]==str(Frame)]
            TMP.loc[:,0] = [float(i) for i in TMP[0]]
            TMP.loc[:,1] = [float(i) for i in TMP[1]]
            TMP.loc[:,2] = [float(i) for i in TMP[2]]
            TMP.loc[:,3] = [float(i) for i in TMP[3]]
            TMP.loc[:,4] = [float(i) for i in TMP[4]]
            TMP.loc[:,5] = [float(i) for i in TMP[5]]
            # Pix to relative pos
            TMP2 = TMP[TMP[2]>Wells[Well_ID][0]/1920]
            TMP2 = TMP2[TMP2[2]<Wells[Well_ID][1]/1920]
            TMP2 = TMP2[TMP2[3]>Wells[Well_ID][2]/1080]
            TMP2 = TMP2[TMP2[3]<Wells[Well_ID][3]/1080]
            # Cal the overlap arear
            Result= {}
            Head_list = TMP2[TMP2[1]==1]
            Body_list = TMP2[TMP2[1]==0]
            for i in Head_list.index:
                head_tmp = TMP[TMP.index==i].iloc[:,2:6].to_numpy()[0]
                for ii in Body_list.index:
                    fly_body = TMP[TMP.index==ii].iloc[:,2:6].to_numpy()[0]
                    fly_loc = Rectangle(fly_body[0] - fly_body[2]/2, fly_body[1] - fly_body[3]/2,  fly_body[0] + fly_body[2]/2, fly_body[1] + fly_body[3]/2)
                    head_loc = Rectangle(head_tmp[0]-head_tmp[2]/2, head_tmp[1]-head_tmp[3]/2, head_tmp[0]+head_tmp[2]/2, head_tmp[1]+head_tmp[3]/2)
                    R = area(fly_loc, head_loc)
                    if R !=None:
                        R = R/(head_tmp[2]*head_tmp[3])
                        Result.update({str(i)+"←"+ str(ii):R})
            # Resort the list 
            Result = dict( sorted(Result.items(), key=operator.itemgetter(1),reverse=True))

            # Clear the list 
            Bind = [i for i in Result.keys()]
            Head_list = [i.split("←")[0] for i in Result.keys()]
            Final = []
            ## collect the unique head
            for i in range(len(Bind)):
                ID = Bind[i].split("←")[0]
                if len([i for i in Head_list if i ==ID])==1:
                    Final +=[Bind[i]]
            ## collect the shared head by sorted areas
            for i in Result.keys():
                if i.split("←")[0]+ "←" not in " ".join(Final):
                    Final+= [i]
            fig_l = 0.3
            #y_start = (Wells["Well_1"][1] - Wells["Well_1"][3])/1080
            #x_start = (Wells["Well_1"][0] - Wells["Well_1"][2])/1920
            #sns.scatterplot(x=2, y=3,
            #                color ="steelblue",
            #                alpha = .7,
                            #data=AA[AA[1]==4]).set(ylim=(0,360), xlim=(0,480))
            #                data=TMP2)#.set(ylim=(y_start, y_start- fig_l), xlim=(x_start, x_start+ fig_l))
            # make the plot
            for h_b in Final:
                Head = TMP[TMP.index==int(h_b.split("←")[0])].iloc[:,2:].to_numpy()[0] 
                Body = TMP[TMP.index==int(h_b.split("←")[1])].iloc[:,2:].to_numpy()[0] 
                df = pd.DataFrame.from_dict({'x' : [Body[0], Head[0]],
                                             'y' : [Body[1], Head[1]]})
                x = df['x'].values
                y = df['y'].values

                u = np.diff(x)
                v = np.diff(y)
                pos_x = x[:-1] + u/2
                pos_y = y[:-1] + v/2
                norm = np.sqrt(u**2+v**2) 
                #ax.plot(x,y, marker="o")
                color = "grey"
                if 3 in TMP2[1].to_list():
                    color = "steelblue"
                if 4 in TMP2[1].to_list():
                    color = "salmon"
                if 5 in TMP2[1].to_list():
                    color = "yellow"
                Bind_TB =  pd.concat([Bind_TB, pd.DataFrame([Frame, Head[0], Head[1], Body[0],  Body[1], color]).T], axis=0)
                ax.quiver(pos_x, pos_y, u/norm, v/norm, angles="xy", zorder=10, pivot="mid",
                               alpha=.3, scale= 9,
                                 linewidths = np.linspace(0, 0, 0),
                                 color = color)
        fig.savefig("img/Figure_1F/"+File.split("/")[-1]+"_"+Well_ID+"_1.5min.png")
        Bind_TB.to_csv("img/Figure_1F/"+File.split("/")[-1]+"_"+Well_ID+"_1.5min.csv")