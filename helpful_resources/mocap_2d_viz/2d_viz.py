#!/usr/bin/env python
# coding: utf-8

# In[47]:


import matplotlib.pyplot as plt
import json
import time
#from IPython.display import clear_output
#get_ipython().run_line_magic('matplotlib', 'inline')


# In[48]:


mocap = json.load(open("E:\Desktop\github\VR-Elbow-Inference\mocap_data\80\80_10.json"))


# In[80]:


def getFrame(coord_num, frame_num):
    frame_values = []
    for joint in mocap[str(frame_num)].values():
        frame_values.append(joint.get("coordinate")[coord_num])
    return frame_values


# In[50]:


frame_number = "1"
x = getFrame(0, frame_number)
y = getFrame(1, frame_number)
z = getFrame(2, frame_number)


# In[88]:


frames = {"x": [], "y": [], "z": []}
def prep_frames():
    for i in range(772):
        x = getFrame(0, i)
        y = getFrame(1, i)
        z = getFrame(2, i)
        frames["x"].append(x)
        frames["y"].append(y)
        frames["z"].append(z)
    
def draw_frame(frame_number):
    #clear_output(wait=True)
    plt.axis("equal")
    plt.scatter(frames["x"][frame_number], frames["y"][frame_number], s=1)


# In[89]:


prep_frames()

for i in range(772):
    draw_frame(i)
    plt.pause(0.005)

#plt.show()


# In[ ]:




