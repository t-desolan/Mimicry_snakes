import random
import keras
import numpy as np #permet de faire appel a numpy en utilisant seulement np
from keras.preprocessing import image
from keras import backend as K
from keras.preprocessing.image import ImageDataGenerator
from keras.layers import Dense, Dropout, Flatten, Activation, Input
from keras.layers import Conv2D, MaxPooling2D, GlobalAveragePooling2D
from keras.models import Model
from keras import optimizers
from keras import metrics
import time
import matplotlib
from pandas import ExcelWriter
import pandas as pd


###### Definition of the path; 
# mim_path contains 20 images of mimetic non venomous species plus the same 20 images with exchanged background
# non_mim_path contains 20 images of non mimetic and non venomous species plus the same 20 images with exchanged background
# vipere_path contains 20 images of venomous species plus the same 20 images with exchanged background
training_path = 'D:/professional_data_max100Gb/Mimetisme chez les serpents/Photos tests/training/'
mim_path = 'D:/professional_data_max100Gb/Mimetisme chez les serpents/Photos tests/echange/couleuvre mim/'
non_mim_path = 'D:/professional_data_max100Gb/Mimetisme chez les serpents/Photos tests/echange/couleuvre non mim/'
vipere_path = 'D:/professional_data_max100Gb/Mimetisme chez les serpents/Photos tests/echange/vipere/'

nb_test_samples = 40

### no data augmentation
datagen = ImageDataGenerator(rescale=1./255)

#definition of the metric: top3 accuracy
def top3(y_true, y_pred):
    return metrics.top_k_categorical_accuracy(y_true, y_pred, k=3) 

######### loading of the averaged network
xception = keras.models.load_model('D:/professional_data_max100Gb/Mimetisme chez les serpents/Neural network/Transfer learning/reseaux entraine/avec poubelle/ensemble_xception_1_model', custom_objects={"top3": top3})



###########################################################
###### data generator used for the formating of DNNs predictions
datagen2 = ImageDataGenerator(
  featurewise_center = True,
  featurewise_std_normalization = True,
  rotation_range=180,
  rescale=1./255,
  shear_range=0.2,
  zoom_range=0.2,
  horizontal_flip=True)

train_images = datagen2.flow_from_directory(
	training_path,
	color_mode="rgb",
	target_size=(299, 299),
	batch_size=32,
	class_mode='categorical')
train_images.reset()



############################################################################################
# image generator for the mimetic species images, without data augmentation
generator2 = datagen.flow_from_directory(
    mim_path,
    color_mode="rgb",
    target_size=(299,299),
    batch_size=1,
    class_mode='categorical',
    shuffle=False)

#prediction for the mimetic species 
features_2 = xception.predict_generator(generator2, steps=nb_test_samples, workers=1)
df3 = pd.DataFrame(features_2)

### back up of the prediction
dico2 = train_images.class_indices
dico2 = {v: k for k, v in dico2.items()}
df3.index = generator2.classes
dico3=generator2.class_indices
dico3 = {v: k for k, v in dico3.items()}
df3.rename(columns=dico2, inplace=True)
df3['nom_espece']=generator2.classes
df3=df3.replace({"nom_espece": dico3})

writer = ExcelWriter('feature_2.xlsx')
df3.to_csv('D:/professional_data_max100Gb/Mimetisme chez les serpents/Neural network/Transfer learning/background/pred/prediction_1_mimetic.csv', sep=';', header=True)

############################################################################################
# image generator for the venomous species images, without data augmentation
generator2 = datagen.flow_from_directory(
    vipere_path,
    color_mode="rgb",
    target_size=(299,299),
    batch_size=1,
    class_mode='categorical',
    shuffle=False)

#prediction for the venomous species 
features_2 = xception.predict_generator(generator2, steps=nb_test_samples, workers=1)
df3 = pd.DataFrame(features_2)

### back up of the prediction
dico2 = train_images.class_indices
dico2 = {v: k for k, v in dico2.items()}
df3.index = generator2.classes
dico3=generator2.class_indices
dico3 = {v: k for k, v in dico3.items()}
df3.rename(columns=dico2, inplace=True)
df3['nom_espece']=generator2.classes
df3=df3.replace({"nom_espece": dico3})

writer = ExcelWriter('feature_2.xlsx')
df3.to_csv('D:/professional_data_max100Gb/Mimetisme chez les serpents/Neural network/Transfer learning/background/pred/prediction_1_vipere.csv', sep=';', header=True)

############################################################################################
# image generator for the non mimetic and non venomous species images, without data augmentation
generator2 = datagen.flow_from_directory(
    non_mim_path,
    color_mode="rgb",
    target_size=(299,299),
    batch_size=1,
    class_mode='categorical',
    shuffle=False)

#prediction for the nonvenomous and non mimetic species 
features_2 = xception.predict_generator(generator2, steps=nb_test_samples, workers=1)
df3 = pd.DataFrame(features_2)

### back up of the prediction
dico2 = train_images.class_indices
dico2 = {v: k for k, v in dico2.items()}
df3.index = generator2.classes
dico3=generator2.class_indices
dico3 = {v: k for k, v in dico3.items()}
df3.rename(columns=dico2, inplace=True)
df3['nom_espece']=generator2.classes
df3=df3.replace({"nom_espece": dico3})

writer = ExcelWriter('feature_2.xlsx')
df3.to_csv('D:/professional_data_max100Gb/Mimetisme chez les serpents/Neural network/Transfer learning/background/pred/prediction_1_non_mim.csv', sep=';', header=True)




