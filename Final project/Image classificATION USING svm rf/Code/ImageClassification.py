#{'cars': 0, 'cats': 1, 'dogs': 2, 'person': 3, 'planes': 4}
from tkinter import *
import tkinter
from tkinter import filedialog
import numpy as np
from tkinter.filedialog import askopenfilename
import pandas as pd 
from tkinter import simpledialog
from tkinter import messagebox
import cv2
from sklearn import svm
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

main = tkinter.Tk()
main.title("Image Classification Using SVM & Randon Forest") 
main.geometry("600x500")

global filename
global X, Y
global model
global X_train, X_test, y_train, y_test
global pca
    

def upload(): 
    global filename
    filename = filedialog.askopenfilename(initialdir="testimages")
    messagebox.showinfo("File Information", "image file loaded")
    

def generateModel():
    global pca
    global X, Y
    global model
    global X_train, X_test, y_train, y_test
    X = np.load("model/X.txt.npy")
    Y = np.load("model/Y.txt.npy")
    X = np.reshape(X, (X.shape[0],(X.shape[1]*X.shape[2])))

    pca = PCA(n_components = 200)
    X = pca.fit_transform(X)
    print(X.shape)

    X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.2)
    cls = svm.SVC()
    cls.fit(X, Y)
    predict = cls.predict(X_test)
    acc = accuracy_score(y_test,predict)*100

    cls = RandomForestClassifier()
    cls.fit(X, Y)
    predict = cls.predict(X_test)
    acc1 = accuracy_score(y_test,predict)*100
    model = cls
    
    messagebox.showinfo("SVM & Random Forest Accuracy", "SVM Accuracy : "+str(acc)+"\nRandom Forest Accuracy : "+str(acc1))

    bars = ('SVM Accuracy','Random Forest Accuracy')
    y_pos = np.arange(len(bars))
    plt.bar(y_pos, [acc,acc1])
    plt.xticks(y_pos, bars)
    plt.show()
    plt.title('SVM & Random Forest Accuracy Performance Graph')
    plt.show()
    

def classify():
    img = cv2.imread(filename,0)
    img = cv2.resize(img, (64,64))
    img = img.astype('float32')
    img = img/255
    temp = []
    temp.append(img)
    temp = np.asarray(temp)
    temp = np.reshape(temp, (temp.shape[0],(temp.shape[1]*temp.shape[2])))
    img = pca.transform(temp)
    predict = model.predict(img)
    msg = ""
    if predict == 0:
        msg = "Image Contains Car"
    if predict == 1:
        msg = "Image Contains Cat"
    if predict == 2:
        msg = "Image Contains Dog"
    if predict == 3:
        msg = "Image Contains Person"
    if predict == 4:
        msg = "Image Contains Plane"
    imagedisplay = cv2.imread(filename)
    output = cv2.resize(imagedisplay,(600,600))
    cv2.putText(output, msg, (10, 25),  cv2.FONT_HERSHEY_SIMPLEX,0.7, (0, 255, 0), 2)
    cv2.imshow("Predicted Image Result", output)
    cv2.waitKey(0)


def exit():
    global main
    main.destroy()
    
font = ('times', 16, 'bold')
title = Label(main, text='Image Classification Using SVM & Random Forest Algorithm', justify=LEFT)
title.config(bg='lavender blush', fg='DarkOrchid1')  
title.config(font=font)           
title.config(height=3, width=120)       
title.place(x=100,y=5)
title.pack()

font1 = ('times', 14, 'bold')
model = Button(main, text="Generate SVM & Random Forest Train & Test Model", command=generateModel)
model.place(x=100,y=100)
model.config(font=font1)  

uploadimage = Button(main, text="Upload Test Image", command=upload)
uploadimage.place(x=100,y=150)
uploadimage.config(font=font1) 

classifyimage = Button(main, text="Classify Picture In Image", command=classify)
classifyimage.place(x=100,y=200)
classifyimage.config(font=font1) 

exitapp = Button(main, text="Exit", command=exit)
exitapp.place(x=100,y=250)
exitapp.config(font=font1) 

main.config(bg='light coral')
main.mainloop()
