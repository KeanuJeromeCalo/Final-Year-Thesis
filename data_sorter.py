#!/usr/bin/env python
# coding: utf-8

# In[2]:


import json
import os
import shutil
  
# Opening JSON file
f = open(r'C:\Users\User\Desktop\welds\data\test\test.json')
  
# returns JSON object as 
# a dictionary

labels = json.load(f)
for i in labels:
    print(i)
def path_exists(folder, filename,i):
    path = folder+"\\"+filename
    if os.path.exists(path):
        os.rename(path,path+"_"+str(i))
        i+=1
                


# In[37]:


src_path = r'C:\Users\User\Desktop\welds\data\test'
i=1
for dirname, _, filenames in os.walk(src_path):
    for filename in filenames: #run through every image in folder
        #print("170815-133921-Al 2mm/frame_00080.png" == "170815-133921-Al 2mm/frame_00080.png")
        print((os.path.join(dirname, filename))[38:].replace("\\","/"))
        
        for name in labels: #compare image to every label in json
            if ((os.path.join(dirname, filename))[38:]).replace("\\","/") == name:
                #print(os.path.join(dirname, filename))
                #print(labels[name])
                
                if labels[name] == 0:
                    #move file to "good weld"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\good_weld'
                    #path_exists(dst_path,filename,i)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)
                    print(src_path," moved to ",dst_path)
                elif labels[name] == 1:
                    #move file to "burn through"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\burn_through'
                    #path_exists(dst_path,filename)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)
                    print(src_path," moved to ",dst_path)
                elif labels[name] == 2:
                    #move file to "contamination"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\contamination'
                    #path_exists(dst_path,filename,i)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)                      
                    print(src_path," moved to ",dst_path)
                elif labels[name] == 3:
                    #move file to "lack of fusion"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\lack_of_fusion'
                    #path_exists(dst_path,filename,i)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)
                    print(src_path," moved to ",dst_path)
                elif labels[name] == 4:
                    #move file to "misalignment"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\misalignment'
                    #path_exists(dst_path,filename,i)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)
                    print(src_path," moved to ",dst_path)
                elif labels[name] == 5:
                    #move file to "lack of penetration"
                    src_path = (os.path.join(dirname, filename))
                    dst_path = r'C:\Users\User\Desktop\welds\classifications\lack_of_penetration'
                    #path_exists(dst_path,filename,i)
                    newFileName = dst_path+"\\"+filename[:filename.index(".")]+"_"+str(i)+".png"
                    path = str(dst_path+"\\"+filename)
                    if os.path.exists(path):
                        
                        os.rename(path,newFileName)
                        i+=1
                        
                    shutil.move(src_path, dst_path)
                    print(src_path," moved to ",dst_path)
                


# In[16]:


src_path = r'C:\Users\User\Desktop\Welding Data\tut'
#src_path = 'F:\welds'
for dirname, _, filenames in os.walk(src_path):
    for filename in filenames: #run through every image in folder
        if filename == "frame_00322.png":
            print(os.path.join(dirname, filename))
            src_path = (os.path.join(dirname, filename))
            dst_path = r'C:\Users\User\Desktop\Welding Data\Welding Defects\Arc Crater'
            shutil.move(src_path, dst_path)
        


# In[30]:


src_path = r'C:\Users\User\Desktop\welds\classifications'
for dirname, _, filenames in os.walk(src_path):
    for filename in filenames: #run through every image in folder
        if filename[-1:] != "g":
            #print(filename[filename.index("g")+1:]," ",filename)
            newFileName = dirname+"\\"+filename[:filename.index(".")]+filename[filename.index("g")+1:]+".png"
            os.rename(os.path.join(dirname, filename),newFileName)
            print(newFileName)  


# In[64]:


src_path = r'C:\Users\User\Desktop\Welding Data\tut'
for filename in os.listdir(src_path):
    #if filename.endswith(".png"): 
    if filename == "frame_00322.png":
        src_path = (os.path.join(dirname, filename))
        dst_path = r'C:\Users\User\Desktop\Welding Data\Welding Defects\Arc Crater'
        shutil.move(src_path, dst_path)
        print(filename+" moved")
        


# In[ ]:


if labels[name] == 0:
    #move file to "good weld"
    src_path = string(os.path.join(dirname, filename))
    dst_path = r'C:\Users\User\Desktop\welds\classifications\good_weld'
    shutil.move(src_path, dst_path)
    print(src_path," moved to ",dst_path)

