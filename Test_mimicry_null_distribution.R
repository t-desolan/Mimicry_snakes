library('lmtest')
library(vegan)
library(ggplot2)


###############################################################################################################
############     LOADING AND TRANSFORMATION OF THE RESEMBLANCE MATRIX

#### list with the name of the venomous species
liste_venimeux="(Atractaspis engaddensis|Bitis arietans|Cerastes cerastes|Cerastes gasperettii|Cerastes vipera|Daboia mauritanica|Daboia palaestinae|Echis carinatus|Echis coloratus|Echis pyramidum|Gloydius halys|Macrovipera lebetina|Montivipera albizona|Montivipera bornmuelleri|Montivipera bulgardaghica|Montivipera raddei|Montivipera wagneri|Montivipera xanthina|Naja haje|Naja nubiae|Pseudocerates fieldi|Vipera ammodytes|Vipera anatolica|Vipera aspis|Vipera berus|Vipera darevskii|Vipera dinniki|Vipera eriwanensis|Vipera graeca|Vipera kaznakovi|Vipera latastei|Vipera monticola|Vipera renardi|Vipera seoanei|Vipera ursinii|Walterinnesia aegyptia|Walterinnesia morgan)"

#### list with the name of the non-venomous species
liste_nn_venimeux="(Boaedon fuliginosus|Letheobia episcopa|Letheobia simonii|Myriopholis algeriensis|Myriopholis cairi|Myriopholis macrorhyncha|Xerotyphlops vermicularis|Coronella austriaca|Coronella girondica|Dasypeltis bazi|Dasypeltis sahelensis|Dolichophis caspius|Dolichophis jugularis|Dolichophis schmidti|Eirenis aurolineatus|Eirenis barani|Eirenis collaris|Eirenis coronella|Eirenis coronelloides|Eirenis decemlineatus|Eirenis eiselti|Eirenis levantinus|Eirenis lineomaculatus|Eirenis modestus|Eirenis nigrofascitus|Eirenis occidentalis|Eirenis punctatolineatus|Eirenis rothi|Eirenis thospitis|Elaphe dione|Elaphe quatuorlineata|Elaphe sauromates|Eryx colubrinus|Eryx jaculus|Eryx jayakari|Eryx miliaris|Hemorrhois algirus|Hemorrhois hippocrepis|Hemorrhois nummifer|Hemorrhois ravergieri|Hierophis cypriensis|Hierophis gemonensis|Hierophis viridiflavus|Lytorhynchus diadema|Macroprotodon abubakeri|Macroprotodon brevis|Macroprotodon cucullatus|Macroprotodon mauritanicus|Malpolon insignitus|Malpolon monspessulanus|Micrelaps muelleri|Muhtarophis barani|Natrix astreptophora|Natrix helvetica|Natrix maura|Natrix natrix|Natrix tessellata|Platyceps chesneii|Platyceps collaris|Platyceps elegantissimus|Platyceps florulentus|Platyceps najadum|Platyceps rhodorachis|Platyceps rogersi|Platyceps tessellatus|Platyceps sinai|Psammophis aegyptius|Psammophis schokari|Psammophis sibilans|Rhagerhis moilensis|Rhynchocalamus dayanae|Rhynchocalamus melanocephalus|Rhynchocalamus satunini|Spalerosophis diadema|Spalerosophis dolichospilus|Telescopus dhara|Telescopus fallax|Telescopus hoogstralii|Telescopus nigriceps|Telescopus obtusus|Telescopus tessellatus|Telescopus tripolitanus|Zamenis hohenackeri|Zamenis lineatus|Zamenis longissimus|Zamenis persicus|Rhinechis scalaris|Zamenis situla)"

#### Loading the mean prediction made by the 15 averaged DNNs prediction for the non-venomous snakes images
prediction <- read.csv("D:/professional_data_max100Gb/Mimetisme_chez_les_serpents/Neural_network/Transfer_learning/pred/avec_poubelle/prediction_xception_ok", sep=";")
prediction <- prediction[,-2]

### aggregation by species
prediction<-aggregate(prediction[, 2:37], list(prediction$nom_espece), mean)
names<-prediction[,c(1)]
prediction<-prediction[,-c(1)]

### rank transformation 
prediction<- as.data.frame(t(apply(-prediction[,1:36], 1,rank, ties.method="min")))
prediction<-cbind(names,prediction)
names<-as.data.frame(prediction[,1]);colnames(names)="names"
rownames(prediction)<-prediction[,1]
prediction<-prediction[,-1]

# removal of all the non-venomous species first attributed to the "foreign species"class
prediction<-prediction[-which(prediction$Foreign==1),]
prediction<-prediction[,-20]

#transformation 1/rank
prediction<- as.data.frame(t(apply(prediction[,1:35], 1,rank, ties.method="min")))
prediction[] <- apply(prediction,c(1,2), function(x) 1/x)
prediction<-as.data.frame(prediction[grepl(liste_nn_venimeux, rownames(prediction)),]) 
names<-as.data.frame(rownames(prediction))



###############################################################################################################
############     LOADING OF THE SYMPATRY MATRIX

sympatrie <- read.csv("C:/Users/de-solan/Desktop/Sympatry_matrix.csv", sep=";")
sympatrie<-sympatrie[sympatrie$X %in% rownames(prediction),]
sympatrie<-sympatrie[,-1]




############################################################################################################################
###########   CREATION OF THE NULL DISTRIBUTION AND DETECTION OF THE POTENTIALLY MIMETIC SPECIES###########################
############################################################################################################################

# WEIGHTING the resemblance matrix with the sympatry matrix
mat_pred_symp<-prediction*sympatrie  


####### Creation of the null distribution by randomly permutation the venomous species (columns) in the sympatry matrix
scores_rand<-names
for(i in 1:50000){
  prediction_rand=prediction
  sympatrie_rand=sympatrie
  sympatrie_rand<-sympatrie_rand[,sample(ncol(sympatrie_rand))] # marche aussi avec t(apply(sympatrie_rand, 1, function(d) sample(d, ncol(sympatrie_rand))))
  prediction_rand<-prediction_rand*sympatrie_rand
  scores_rand<-cbind(scores_rand,apply(prediction_rand,1,sum))
  colnames(scores_rand)[i+1]<-'score'}


####### obtention of the total score (i.e. the sum of the weighted resemblance scores for each non-venomous species)
score_ok<-cbind(names,apply(mat_pred_symp,1,sum)) ; colnames(score_ok)=c('names','scores')


#### testing the total scores against the null distribution
test<-c()
data_c<-c()
visu<-data.frame(score=1:27,quantile_95=0)
rownames(visu)<-rownames(prediction)
for(i in 1:nrow(scores_rand)){
  data_a = as.numeric(c(scores_rand[i, 2:50001]))
  data_b = c(score_ok[i, 2])
  data_c = ifelse (data_b<data_a, 1,0)
  visu$score[i] = data_b
  visu$quantile_95[i] = quantile(data_a, 0.95)
  test[i] = sum(data_c)/50000
  if (data_b>quantile(data_a, 0.95) )
  { print(score_ok[i,1]) } }


#Fisher's method
score=-2*sum(log(test))
1-pchisq(score,54)

