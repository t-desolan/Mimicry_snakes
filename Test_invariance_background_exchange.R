##### EFFECT OF BACKGROUND EXCHANGE ON DNNs PREDICTIONS

library(vegan)



############################################################################################################################################################
############ Formating the data


list_modif<-rep(c("no_modification","modified"), times = 20)

#### Loading and formating the prediction made by the 15 averaged DNNs for the venomous species
vipere1<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_1_vipere.csv", sep=";")
vipere2<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_2_vipere.csv", sep=";")
vipere3<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_3_vipere.csv", sep=";")
vipere4<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_4_vipere.csv", sep=";")
vipere5<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_5_vipere.csv", sep=";")
vipere6<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_6_vipere.csv", sep=";")
vipere7<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_7_vipere.csv", sep=";")
vipere8<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_8_vipere.csv", sep=";")
vipere9<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_9_vipere.csv", sep=";")
vipere10<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_10_vipere.csv", sep=";")
vipere11<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_11_vipere.csv", sep=";")
vipere12<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_12_vipere.csv", sep=";")
vipere13<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_13_vipere.csv", sep=";")
vipere14<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_14_vipere.csv", sep=";")
vipere15<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_15_vipere.csv", sep=";")
vipere<-rbind(vipere1,vipere2,vipere3,vipere4,vipere5,vipere6,vipere7,vipere8,vipere9,vipere10,vipere11,vipere12,vipere13,vipere14,vipere15)
vipere<-aggregate(vipere[,2:37], list(vipere[,38]), mean)
vipere[,38]<-rep(c("no_modification","modified"), times = 20)
vipere[,1]<-c("bitare","bitare","bitare","bitare","cercer","cercer","cercer","cercer","dabmau","dabmau","dabmau","dabmau","echpyr","echpyr","echpyr","echpyr","monxan","monxan","monxan","monxan","najhaj","najhaj","najhaj","najhaj","psefie","psefie","psefie","psefie","vipamm","vipamm","vipamm","vipamm","vipber","vipber","vipber","vipber","vipseo","vipseo","vipseo","vipseo")
colnames(vipere)[1]<-c("specie")
colnames(vipere)[38]<-c("modification")

#### Loading the prediction made by the 15 averaged DNNs for the potentially mimetic species
mimetic1<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_1_mimetic.csv", sep=";")
mimetic2<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_2_mimetic.csv", sep=";")
mimetic3<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_3_mimetic.csv", sep=";")
mimetic4<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_4_mimetic.csv", sep=";")
mimetic5<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_5_mimetic.csv", sep=";")
mimetic6<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_6_mimetic.csv", sep=";")
mimetic7<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_7_mimetic.csv", sep=";")
mimetic8<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_8_mimetic.csv", sep=";")
mimetic9<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_9_mimetic.csv", sep=";")
mimetic10<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_10_mimetic.csv", sep=";")
mimetic11<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_11_mimetic.csv", sep=";")
mimetic12<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_12_mimetic.csv", sep=";")
mimetic13<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_13_mimetic.csv", sep=";")
mimetic14<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_14_mimetic.csv", sep=";")
mimetic15<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_15_mimetic.csv", sep=";")
mimetic<-rbind(mimetic1,mimetic2,mimetic3,mimetic4,mimetic5,mimetic6,mimetic7,mimetic8,mimetic9,mimetic10,mimetic11,mimetic12,mimetic13,mimetic14,mimetic15)
mimetic<-aggregate(mimetic[,2:37], list(mimetic[,38]), mean)
mimetic[,38]<-rep(c("no_modification","modified"), times = 20)
mimetic[,1]<-c("coraus","coraus","coraus","coraus","dassah","dassah","dassah","dassah","dassah","dassah","hemnum","hemnum","hemnum","hemnum","hemnum","hemnum","nathel","nathel","nathel","nathel","nathel","nathel","natmau","natmau","natmau","natmau","natmau","natmau","spadia","spadia","spadia","spadia","spadia","spadia","telfal","telfal","telfal","telfal","telfal","telfal")
colnames(mimetic)[1]<-c("specie")
colnames(mimetic)[38]<-c("modification")


#### Loading the prediction made by the 15 averaged DNNs for the non-venomous species
non_mim1<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_1_non_mim.csv", sep=";")
non_mim2<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_2_non_mim.csv", sep=";")
non_mim3<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_3_non_mim.csv", sep=";")
non_mim4<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_4_non_mim.csv", sep=";")
non_mim5<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_5_non_mim.csv", sep=";")
non_mim6<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_6_non_mim.csv", sep=";")
non_mim7<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_7_non_mim.csv", sep=";")
non_mim8<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_8_non_mim.csv", sep=";")
non_mim9<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_9_non_mim.csv", sep=";")
non_mim10<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_10_non_mim.csv", sep=";")
non_mim11<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_11_non_mim.csv", sep=";")
non_mim12<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_12_non_mim.csv", sep=";")
non_mim13<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_13_non_mim.csv", sep=";")
non_mim14<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_14_non_mim.csv", sep=";")
non_mim15<-read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/background/pred/prediction_15_non_mim.csv", sep=";")
non_mim<-rbind(non_mim1,non_mim2,non_mim3,non_mim4,non_mim5,non_mim6,non_mim7,non_mim8,non_mim9,non_mim10,non_mim11,non_mim12,non_mim13,non_mim14,non_mim15)
non_mim<-aggregate(non_mim[,2:37], list(non_mim[,38]), mean)
non_mim[,38]<-rep(c("no_modification","modified"), times = 20)
non_mim[,1]<-c("corgir","corgir","corgir","corgir","eirbar","eirbar","eirbar","eirbar","eirnir","eirnir","eirnir","eirnir","eladio","eladio","eladio","eladio","eryjac","eryjac","eryjac","eryjac","hievir","hievir","hievir","hievir","letsim","letsim","letsim","letsim","mutbar","mutbar","mutbar","mutbar","platflo","platflo","platflo","platflo","teltri","teltri","teltri","teltri")
colnames(non_mim)[1]<-c("specie")
colnames(non_mim)[38]<-c("modification")


#### Gathering all the predictions
total<-rbind(vipere,mimetic,non_mim)
total[,39]<-c(rep("venomous", times = 40),rep("mimetic", times = 40),rep("non_mimetic", times = 40))
colnames(total)[39]<-"type"



################################################################################################################################################
############ TEST OF THE EFFECT OF BACKGROUND EXCHANGE


##### Test on all the species
dependent<-as.matrix(total[,2:37])
#1/rank transformation
dependent<-t(apply(-dependent, 1,rank, ties.method="min"))
dependent<-1/dependent
#Multivariate Analysis of Variance
adonis(dependent~total$specie+total$modification)
#test for Multivariate homogeneity of variance
permutest(betadisper(dist(dependent),total$modification))

   
##### Test on the non-venomous and potentially mimetic species
dependent<-as.matrix(mimetic[,2:37])
dependent<-t(apply(-dependent, 1,rank, ties.method="min"))
dependent<-1/dependent
adonis(dependent~mimetic$specie+mimetic$modification, stata=mimetic$specie)
permutest(betadisper(dist(dependent),mimetic$modification))


##### Test on the non-venomous and non-mimetic species
dependent<-as.matrix(non_mim[,2:37])
dependent<-t(apply(-dependent, 1,rank, ties.method="min"))
dependent<-1/dependent
adonis(dependent~non_mim$specie+non_mim$modification, stata=non_mim$specie)
permutest(betadisper(dist(dependent),non_mim$modification))

##### Test on the venomous species
dependent<-as.matrix(vipere[,2:37])
dependent<-t(apply(-dependent, 1,rank, ties.method="min"))
dependent<-1/dependent
adonis(dependent~vipere$specie+vipere$modification, stata=vipere$specie)
permutest(betadisper(dist(dependent),vipere$modification))





