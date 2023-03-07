import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
import cv2, json, os, math
from sklearn.cluster import DBSCAN

os.system('mkdir img/Figure_2B')
Video_1 = "data/fly2/C0401_L.mp4"
Video_2 = "data/fly2/C0401_R.mp4"

# We calculate the first array for the food region
cap=cv2.VideoCapture("data/fly2/masks/C0401_L_mask.png")
ret,frame=cap.read()
frame2 = cv2.cvtColor(frame,cv2.COLOR_RGB2GRAY)
colourArray = frame2 
indicesArray = np.moveaxis(np.indices((len(frame2),len(frame2[0]))), 0, 2)
allArray = np.dstack((indicesArray, frame2)).reshape((-1, 3))
df = pd.DataFrame(allArray, columns=["y", "x", "grey"])
TMP = df[df['grey']!=0]
clustering = DBSCAN(eps=1, min_samples=2).fit(TMP[["y","x"]])
TMP['group']= clustering.labels_
Food_array1 = TMP[TMP['group']==1]

# Now, is the second food area-array
cap=cv2.VideoCapture("data/fly2/masks/C0401_R_mask.png")
ret,frame=cap.read()
frame2 = cv2.cvtColor(frame,cv2.COLOR_RGB2GRAY)
colourArray = frame2 #np.array(img).reshape((1024,1024,1)) # !!!! change the size to value
indicesArray = np.moveaxis(np.indices((len(frame2),len(frame2[0]))), 0, 2)
allArray = np.dstack((indicesArray, frame2)).reshape((-1, 3))
df = pd.DataFrame(allArray, columns=["y", "x", "grey"])
TMP = df[df['grey']!=0]
clustering = DBSCAN(eps=1, min_samples=2).fit(TMP[["y","x"]])
TMP['group']= clustering.labels_
Food_array2 = TMP[TMP['group']==1]


# location of the files
Json_1 = ["data/fly2/csv/" + i for i in os.listdir("data/fly2/csv") if Video_1.split("/")[-1] in i and "json" in i][0]
Json_2 = ["data/fly2/csv/" + i for i in os.listdir("data/fly2/csv") if Video_2.split("/")[-1] in i and "json" in i][0]
# Read the json files with the old way. It may takes a while = = I should save them as npy formate...
Fly_matrix_1 = {}
[Fly_matrix_1.update(json.loads(i)) for i in open(Json_1,'r').read().split(";")[:-1]]
Fly_matrix_2 = {}
[Fly_matrix_2.update(json.loads(i)) for i in open(Json_2,'r').read().split(";")[:-1]]

# Now, I forgot what is this for
Frame = '1000'
X1 = [[int(Fly_matrix_1[i][fly_id]['head'][0]*1920) for i in Fly_matrix_1.keys()] for fly_id in Fly_matrix_1[Frame].keys()]
Y1 = [[int(Fly_matrix_1[i][fly_id]['head'][1]*1080) for i in Fly_matrix_1.keys()] for fly_id in Fly_matrix_1[Frame].keys()]
X2 = [[int(Fly_matrix_2[i][fly_id]['head'][0]*1920) for i in Fly_matrix_2.keys()] for fly_id in Fly_matrix_2[Frame].keys()]
Y2 = [[int(Fly_matrix_2[i][fly_id]['head'][1]*1080) for i in Fly_matrix_2.keys()] for fly_id in Fly_matrix_2[Frame].keys()]

def List_DF(Fly_matrix_2, X, Frame, C_name= "X"):
    TMP = pd.DataFrame(X).T
    TMP.columns = Fly_matrix_2[Frame].keys()
    TMP['frame'] =  Fly_matrix_2.keys()
    TMP = TMP.melt(id_vars='frame')
    TMP.columns = ['Frame','Fly', C_name]
    return TMP

TMP_X = List_DF(Fly_matrix_1, X1, Frame, "X")
TMP_Y = List_DF(Fly_matrix_1, Y1, Frame, "Y")
TB_V1 = pd.concat([TMP_X, TMP_Y['Y']], axis=1)

TMP_X = List_DF(Fly_matrix_2, X2, Frame, "X")
TMP_Y = List_DF(Fly_matrix_2, Y2, Frame, "Y")
TB_V2 = pd.concat([TMP_X, TMP_Y['Y']], axis=1)

TB_V1["X_TF"] = TB_V1['X'].isin(Food_array1['x'])
TB_V1["Y_TF"] = TB_V1['Y'].isin(Food_array1['y'])
TB_V2["X_TF"] = TB_V2['X'].isin(Food_array2['x'])
TB_V2["Y_TF"] = TB_V2['Y'].isin(Food_array2['y'])
AA = ["x".join([str(ii) for ii in i]) for i in TB_V1[['X',"Y"]].to_numpy().tolist()]
BB = ["x".join([str(ii) for ii in i]) for i in Food_array1[['x',"y"]].to_numpy().tolist()]
TB1_plot= TB_V1[np.in1d(AA,list(set(BB)))].dropna()

AA = ["x".join([str(ii) for ii in i]) for i in TB_V2[['X',"Y"]].to_numpy().tolist()]
BB = ["x".join([str(ii) for ii in i]) for i in Food_array2[['x',"y"]].to_numpy().tolist()]
TB2_plot= TB_V2[np.in1d(AA,list(set(BB)))].dropna()




Box_plot = pd.DataFrame([TB1_plot.Fly.value_counts().to_numpy(), TB2_plot.Fly.value_counts().to_numpy()]).T
Box_plot.columns = ["Vdeio1", "Video2"]
Box_plot = Box_plot.melt().dropna()
# save the result
Box_plot.to_csv("data/fly2/Two_video_feed.csv")

fix, axs = plt.subplots(figsize=(3,5))
ax = sns.boxplot(data=Box_plot, x= "variable", y = "value")

ax.set(ylim=[0,10000])
fix.savefig("img/Figure_2B/box.svg")

TB2_plot_m = pd.DataFrame(TB2_plot)
TB2_plot_m.Y = TB2_plot_m.Y+1080
Img_merge = np.zeros([1080*2, 1920, 3], dtype=np.uint8)

cap=cv2.VideoCapture(Video_1)
ret,frame=cap.read()
frame = cv2.cvtColor(frame,cv2.COLOR_RGB2BGR)
Img_merge[:1080,:1920,:]= frame

cap=cv2.VideoCapture(Video_2)
ret,frame=cap.read()
frame = cv2.cvtColor(frame,cv2.COLOR_RGB2BGR)
Img_merge[1080:,:1920,:]= frame

TB_M = pd.concat([TB1_plot,TB2_plot_m])
TB_M.index= range(len(TB_M))

fig, ax= plt.subplots(figsize=(40,40))
plt.imshow(Img_merge)

sns.histplot(data=TB_M, x='X', y= 'Y', bins=15, binwidth=15, pthresh=.03, cmap="coolwarm")
fig.savefig("img/Figure_2B/heatmap.svg")


