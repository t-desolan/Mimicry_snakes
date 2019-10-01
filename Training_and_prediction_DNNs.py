import numpy as np
import tensorflow as tf
import random
import keras
from keras.preprocessing import image
from keras import backend as K
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Activation, Input
from keras.layers import Conv2D, MaxPooling2D, GlobalAveragePooling2D
from keras.models import Model
from keras import optimizers
import time
import matplotlib
import keras.applications
import pickle
from keras import metrics
import pandas as pd
from pandas import ExcelWriter
from keras.layers import Conv2D, MaxPooling2D, GlobalAveragePooling2D, Activation, Average, Dropout


###############################################################################################################
###############################################################################################################
###############################################################################################################
################## TRAINING OF THE DNNs ON VENOMOUS SNAKES IMAGES 


### Definition of the path for the venomous snakes images
training_path = '/home/sdd1/de_solan/training_poubelle/'

## Definition of the variables
batch_size = 8
num_classes = 36
model_input = Input(shape=(299,299,3))

#definition of the metric: top3 accuracy
def top3(y_true, y_pred):
    return metrics.top_k_categorical_accuracy(y_true, y_pred, k=3)


#####  Data augmentation
datagen = ImageDataGenerator(
	rotation_range=180,
	rescale=1./255,
	zoom_range=0.2,
	channel_shift_range=0.2,
	horizontal_flip=True,
	vertical_flip=True,
	validation_split=0.1)

#####  Images generators for the training set
train_images = datagen.flow_from_directory(
	training_path,
	color_mode="rgb",
	target_size=(299, 299),
	batch_size=batch_size,
	subset="training",
	class_mode='categorical')

#####  Images generators for the validation set
val_images = datagen.flow_from_directory(
	training_path,
	color_mode="rgb",
	target_size=(299, 299),
	batch_size=batch_size,
	subset="validation",
	class_mode='categorical')



#################### FIRST MODEL #################################################

#DOWNLOAD of Xception model
model = keras.applications.xception.Xception(include_top=False, weights='imagenet', input_tensor=model_input)
for layer in model.layers:
  layer.name = layer.name + str("_1")

#modification of Xception
x = model.output
x = GlobalAveragePooling2D()(x)
x = Dense(2048, activation='relu')(x)
x = Dropout (0.7)(x)
x = Dense(256, activation='relu')(x)
x = Dropout (0.7)(x)
predictions = Dense(num_classes, activation='softmax')(x)
xception1 = Model(inputs=model.input, outputs=predictions)

#definition of the optimizer
sgd2 = optimizers.SGD(lr=0.001,  momentum=0.9, decay=0.00001, nesterov=True)

#model compilation
xception1.compile(optimizer=sgd2, loss='categorical_crossentropy', metrics=['accuracy', top3])

#model training
History = xception1.fit_generator(train_images, 
	epochs=50,
	validation_data=val_images)
	
#writing of the training history
df1 = pd.DataFrame.from_records(History.history)
writer = ExcelWriter('feature_1.xlsx')
df1.to_csv('/home/data/Resultat_de_solan_avec_poubelle/history_xception_SGD_.csv', sep=';', index_label='epochs')



#################### SECOND MODEL  #################################################
#DOWNLOAD of Xception model
model = keras.applications.xception.Xception(include_top=False, weights='imagenet', input_tensor=model_input)
for layer in model.layers:
  layer.name = layer.name + str("_2")

#modification of Xception
x = model.output
x = GlobalAveragePooling2D()(x)
x = Dense(2048, activation='relu')(x)
x = Dropout (0.7)(x)
x = Dense(256, activation='relu')(x)
x = Dropout (0.7)(x)
predictions = Dense(num_classes, activation='softmax')(x)
xception2 = Model(inputs=model.input, outputs=predictions)

#definition of the optimizer
adagrad=keras.optimizers.Adagrad(lr=0.0005, epsilon=None, decay=0.0)

#model compilation
xception2.compile(optimizer=adagrad, loss='categorical_crossentropy', metrics=['accuracy', top3])

#model training
History = xception2.fit_generator(train_images, 
	epochs=125,
	validation_data=val_images)

#writing of the training history
df1 = pd.DataFrame.from_records(History.history)
writer = ExcelWriter('feature_1.xlsx')
df1.to_csv('/home/data/Resultat_de_solan_avec_poubelle/history_xception_ADAMGRAD_.csv', sep=';', index_label='epochs')


	

#################### THIRD MODEL #################################################
#DOWNLOAD of Xception model
model = keras.applications.xception.Xception(include_top=False, weights='imagenet', input_tensor=model_input)
for layer in model.layers:
  layer.name = layer.name + str("_3")

#modification of Xception
x = model.output
x = GlobalAveragePooling2D()(x)
x = Dense(2048, activation='relu')(x)
x = Dropout (0.7)(x)
x = Dense(256, activation='relu')(x)
x = Dropout (0.7)(x)
predictions = Dense(num_classes, activation='softmax')(x)
xception3 = Model(inputs=model.input, outputs=predictions)

#definition of the optimizer
nadam=keras.optimizers.Nadam(lr=0.00003, beta_1=0.9, beta_2=0.999, epsilon=None, schedule_decay=0.004)

#model compilation
xception3.compile(optimizer=nadam, loss='categorical_crossentropy', metrics=['accuracy', top3])

#model training
History = xception3.fit_generator(train_images, 
	epochs=45,
	validation_data=val_images)
	
#writing of the training history
df1 = pd.DataFrame.from_records(History.history)
writer = ExcelWriter('feature_1.xlsx')
df1.to_csv('/home/data/Resultat_de_solan_avec_poubelle/history_xception_NADAM_.csv', sep=';', index_label='epochs')


###################################################################################
###### averaged network 
ensembled_models = [xception1,xception2,xception3]

def ensemble(models,model_input):
    outputs = [model.outputs[0] for model in models]
    y = Average()(outputs)
    model = Model(model_input,y,name='ensemble')
    return model


ensemble_model = ensemble(ensembled_models,model_input)

# Back up
ensemble_model.save('/home/data/Resultat_de_solan_avec_poubelle/ensemble_xception__model')

# compilation of the ensemble network
ensemble_model.compile(optimizer=sgd2, loss='categorical_crossentropy', metrics=['accuracy', top3])

#Measurement of the averaged network accuracy
ensemble_accuracy_1 = ensemble_model.evaluate_generator(val_images, steps=len(val_images))
df2 = pd.DataFrame(ensemble_accuracy_1)
writer = ExcelWriter('feature_1.xlsx')
df2.to_csv('/home/data/Resultat_de_solan_avec_poubelle/accuracy_ensemble_.csv', sep=';')




###############################################################################################################
###############################################################################################################
###############################################################################################################
################## PREDICTION OF THE DNNs FOR THE NON VENOMOUS SNAKES IMAGES

# Definition of the path for the non-venomous snakes images
testing_path = '/home/sdd1/de_solan/test'
nb_test_samples = 1206

### no data aumentation
datagen = ImageDataGenerator(rescale=1./255)

#image generator
generator2 = datagen.flow_from_directory(
    testing_path,
    color_mode="rgb",
    target_size= (299,299),
    batch_size=1,
    class_mode='categorical',
    shuffle=False)

#definition of the metric: top3 accuracy
def top3(y_true, y_pred):
    return metrics.top_k_categorical_accuracy(y_true, y_pred, k=3) 

###############   PREDICTION
features_2 = ensemble_model.predict_generator(generator2, steps=nb_test_samples, workers=1)



########### Back up of the predictions ######################

df3 = pd.DataFrame(features_2)

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
	target_size=(299,299),
	batch_size=batch_size,
	class_mode='categorical')
train_images.reset()

dico2 = train_images.class_indices
dico2 = {v: k for k, v in dico2.items()}
df3.index = generator2.classes
dico3=generator2.class_indices
dico3 = {v: k for k, v in dico3.items()}
df3.rename(columns=dico2, inplace=True)
df3['nom_espece']=generator2.classes
df3=df3.replace({"nom_espece": dico3})

writer = ExcelWriter('feature_2.xlsx')
df3.to_csv('/home/data/Resultat_de_solan_avec_poubelle/features_ensemble_xception_.csv', sep=';', header=True)








