import numpy as np
import trajectorytools as tt
import matplotlib.pyplot as plt
import json, os

os.system("mkdir img/trejactory/")

def Plot(File, Video, Tail):
    F = open(File + Video + "_.json", 'r').read()
    Dict = json.loads(F)
    trajectories = np.array([[Dict[i][ii]['body'][:2] for ii in np.sort([ii for ii in Dict['12'].keys()])] for i in Dict.keys()])
    tr = tt.Trajectories.from_positions(trajectories)

    fig, ax_trajectories = plt.subplots(figsize=(5,5))
    frame_range = range(30*30) 

    for i in range(tr.number_of_individuals):
        ax_trajectories.plot(tr.s[frame_range,i,0], tr.s[frame_range,i,1])
        ax_trajectories.set_aspect('equal','box')
        ax_trajectories.set_title('Trajectories',fontsize=24)
        ax_trajectories.set_xlabel('X (BL)',fontsize=24)
        ax_trajectories.set_ylabel('Y (BL)',fontsize=24)
        ax_trajectories.set_aspect(.5)

    fig.savefig("img/trejactory/" + Video+"_" + Tail +".svg")


Video_l = ["20220116-promE-v330035-298d-C0379_Trim-2.mp4",
          "20210622_promE-GFP_C0074_Trim.mp4",
          "20220123C0394_Trim.mp4"]

for Video in Video_l:
    Plot('data/csv/', Video, "YoloFly")







def Plot(File, Video, Tail):
    trajectories_file_path = File + Video 
    trajectories_dict = np.load(trajectories_file_path, allow_pickle=True).item()
    trajectories = trajectories_dict['trajectories']
    tr = tt.Trajectories.from_positions(trajectories)

    fig, ax_trajectories = plt.subplots(figsize=(5,5))
    frame_range = range(30*30) 

    for i in range(tr.number_of_individuals):
        ax_trajectories.plot(tr.s[frame_range,i,0], tr.s[frame_range,i,1])
        ax_trajectories.set_aspect('equal','box')
        ax_trajectories.set_title('Trajectories',fontsize=24)
        ax_trajectories.set_xlabel('X (BL)',fontsize=24)
        ax_trajectories.set_ylabel('Y (BL)',fontsize=24)
        #ax_trajectories.set_aspect(.5)

    fig.savefig("img/trejactory/" + Video+"_" + Tail +".svg")


Video_l = ["20220123C0394.npy",
           "C0074.npy",
           "C0379.npy"]

for Video in Video_l:
    Plot('data/idtracker/', Video, "idtracker")




# Scripts for video plots. For running jobs below, you need to get corresponded videos for each trajectory files.


'''

import cv2
from matplotlib import colors

Palette = ["#B03D3B", "#B86C3D", "#BF8040", "#ACC144", "#78C144", "#47C291", "#478BC2", "#4760C2", "#574BC3", "#834BC3", "#C34BAB", "#C14465", "#DEB59C", "#D7DF9F", "#A7DF9F", "#9FDFD9", "#A3B3E0", "#D0A3E0", "#E2A7CD", "#361712", "#1A3913", "#132B39", "#2D1339", "#391330"]

V_list = {"C0074.npy": '/mnt/Ken_lap/Vlog/upload/promE-GFP/20210622_promE-GFP_C0074_Trim.mp4',
    "C0379.npy": '/mnt/Ken_lap/Vlog/upload/promE-fru-IR-v330035/20220116-promE-v330035-298d-C0379_Trim-2.mp4',
    "20220123C0394.npy": '/mnt/Ken_lap/Vlog/upload/elav-GS-fru-IR-V330035/20220123C0394_Trim.mp4'}


def Video_output(Video, V_loc):
    trajectories_file_path = 'data/idtracker/' + Video 
    trajectories_dict = np.load(trajectories_file_path, allow_pickle=True).item()
    trajectories = trajectories_dict['trajectories']
    tr = tt.Trajectories.from_positions(trajectories)

    Num = 0
    cap=cv2.VideoCapture(V_loc)
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    out = cv2.VideoWriter("img/trejactory/" + Video + "_30.avi", fourcc, 30.0, (1920,1080))

    List = []
    while Num <= 900:
        ret,frame=cap.read()
        List += [trajectories[Num]]
        List = List[-100:]
        for Trace in List:
            for id in range(len(Trace)):
                XY = np.array(Trace[id]  , dtype = int)
                C = np.array(colors.to_rgba(Palette[id]))[:-1] * 225
                cv2.putText(frame, "." ,(XY[0], XY[1]), cv2.FONT_HERSHEY_COMPLEX, 1, C, 2)

        Trace = List[-1]
        for id in range(len(Trace)):
            XY = np.array(Trace[id]  , dtype = int)
            C = np.array(colors.to_rgba(Palette[id]))[:-1] * 225
            cv2.putText(frame, str(id) ,(XY[0], XY[1]), cv2.FONT_HERSHEY_COMPLEX, 1, C, 2)

        cv2.imshow("video",frame)
        Num +=1 
        out.write(frame)
        if cv2.waitKey(30)&0xFF==ord('q'):
            cv2.destroyAllWindows()
            out.write(frame)
            break
    cv2.destroyAllWindows()
    out.write(frame)



for Video in V_list.keys():
    Video_output(Video, V_list[Video])










import numpy as np
import trajectorytools as tt
import matplotlib.pyplot as plt
import json


F = open("data/csv/20220116-promE-v330035-298d-C0379_Trim-2.mp4_.json", 'r').read()
Dict = json.loads(F)
trajectories = np.array([[Dict[i][ii]['body'][:2] for ii in np.sort([ii for ii in Dict['12'].keys()])] for i in Dict.keys()])
tr = tt.Trajectories.from_positions(trajectories)

fig, ax_trajectories = plt.subplots(figsize=(5,5))
frame_range = range(30*30) 

for i in range(tr.number_of_individuals):
    ax_trajectories.plot(tr.s[frame_range,i,0], tr.s[frame_range,i,1])
    ax_trajectories.set_aspect('equal','box')
    ax_trajectories.set_title('Trajectories',fontsize=24)
    ax_trajectories.set_xlabel('X (BL)',fontsize=24)
    ax_trajectories.set_ylabel('Y (BL)',fontsize=24)
    ax_trajectories.set_aspect(.5)


fig.savefig("20220123C0394_Trim_30.png")


import cv2
from matplotlib import colors

Palette = ["#B03D3B", "#B86C3D", "#BF8040", "#ACC144", "#78C144", "#47C291", "#478BC2", "#4760C2", "#574BC3", "#834BC3", "#C34BAB", "#C14465", "#DEB59C", "#D7DF9F", "#A7DF9F", "#9FDFD9", "#A3B3E0", "#D0A3E0", "#E2A7CD", "#361712", "#1A3913", "#132B39", "#2D1339", "#391330"]
V_list = {"20210622_promE-GFP_C0074_Trim.mp4": '/mnt/Ken_lap/Vlog/upload/promE-GFP/20210622_promE-GFP_C0074_Trim.mp4',
    "20220116-promE-v330035-298d-C0379_Trim-2.mp4": '/mnt/Ken_lap/Vlog/upload/promE-fru-IR-v330035/20220116-promE-v330035-298d-C0379_Trim-2.mp4',
    "20220123C0394_Trim.mp4": '/mnt/Ken_lap/Vlog/upload/elav-GS-fru-IR-V330035/20220123C0394_Trim.mp4'}


def Video_output(Video, V_loc):
  loc = [i for i in os.listdir("data/csv") if Video in i and "json" in i][0]
  F = open("data/csv/" + loc , 'r').read()
  Dict = json.loads(F)
  trajectories = np.array([[Dict[i][ii]['body'][:2] for ii in np.sort([ii for ii in Dict['12'].keys()])] for i in Dict.keys()])
  tr = tt.Trajectories.from_positions(trajectories)

  Num = 0
  cap=cv2.VideoCapture(V_loc)
  fourcc = cv2.VideoWriter_fourcc(*'XVID')
  out = cv2.VideoWriter("img/trejactory/" + Video + "_30.avi", fourcc, 30.0, (1920,1080))
  
  List = []
  while Num <= 900:
    ret,frame=cap.read()
    List += [trajectories[Num]]
    List = List[-100:]
    for Trace in List:
      for id in range(len(Trace)):
        XY = np.array(Trace[id]  * (1920, 1080), dtype = int)
        C = np.array(colors.to_rgba(Palette[id]))[:-1] * 225
        cv2.putText(frame, "." ,(XY[0], XY[1]), cv2.FONT_HERSHEY_COMPLEX, 1, C, 2)

    Trace = List[-1]
    for id in range(len(Trace)):
      XY = np.array(Trace[id]  * (1920, 1080), dtype = int)
      C = np.array(colors.to_rgba(Palette[id]))[:-1] * 225
      cv2.putText(frame, str(id) ,(XY[0], XY[1]), cv2.FONT_HERSHEY_COMPLEX, 1, C, 2)

    cv2.imshow("video",frame)
    Num +=1 
    out.write(frame)
    if cv2.waitKey(30)&0xFF==ord('q'):
        cv2.destroyAllWindows()
        out.write(frame)
        break
  cv2.destroyAllWindows()
  out.write(frame)



for Video in V_list.keys():
    Video_output(Video, V_list[Video])

'''