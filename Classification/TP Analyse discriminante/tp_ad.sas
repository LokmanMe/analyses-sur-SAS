ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\résultats.pdf";

libname tp_ad "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\Data";

/* I. Approche descriptive */

data tp_ad.kehr70fl_t;
infile "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\Data\kehr70fl_r.txt" dlm=';' firstobs=2;
input county $ region $ having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

proc contents data=tp_ad.kehr70fl_t;
run;

/* Nairobi a été exclue de l'analyse parce qu'il est à la fois région et county.*/

proc print data=tp_ad.kehr70fl_t;
TITLE "TP : Analyse discriminante";
FOOTNOTE "";
run;

proc candisc data=tp_ad.kehr70fl_t out=tp_ad.sortie outstat=stat;
class region;
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

/* 
Tableau 1 : On a nos 7 classes a priori : les régions. 
Le poids d'une classe est égal au nombre d'individu de cette classe. 

On cherche une combinaison linéaire des variables d'équipement qui séparerait 
les régions, ce qui revient à maximiser la dispersion entre les classes sur la dispersion totale.

Tableau 2 : Test de l'hypothèse H0: "les centres de gravité de toutes les classes sont confondus"
Toutes les statistiques mènent à un rejet de l'hypothèse nulle avec une probabilité très forte : au moins deux centres de gravité sont différents.

Tableau 3 : regroupe les axes factoriels qui découlent de la procédure. 
Correlation canonique au carré : inertie inter-classes / inertie totale. 
Plus cette valeur sera importante, plus l'axe en question discriminera correctement.
La deuxième partie du tableau regroupe des valeurs propres issues de la diagonalisation de la matrice variances intra-classes.

Tableau 4 : Ce sont les corrélations entre les variables et les axes 
Le premier axe est le plus corrélé avec la variable avoir un canapé.
Dans ce tableau, les régions sont absentes.


/* Représentation graphique des individus sur le plan factoriel discriminant */

proc plot data=tp_ad.sortie;
plot can2*can1=region;
run;

proc sgplot data=tp_ad.sortie;
scatter x=can1 y=can2 / datalabel=region;
run;

/* Représentation des régions sur le premier et deuxième axe.
Sur l'axe 1, on constate que les différentes régions ne sont pas bien discriminées. En effet, il semble que la variance intra soit relativement importante par rapport à l'inter. 
On a bien fait de prendre 2 axes*/

/* Représentation graphique des variables sur le plan factoriel discriminant */

proc corr out=doncor data=tp_ad.sortie noprint;
var can1-can2;
with having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

data correl;
set doncor;
where _type_='CORR';
run;

proc sgplot data=correl;
scatter X=can1 Y=can2 / datalabel=_NAME_;
title 'Analyse Discriminante : représentation des variables dans le plan factoriel';
run;

/* L'axe 1 est principalement défini par les variables sur la droite. Donc, si on revient sur les individus, la région Est, qui était correctement représenté, sont des counties qui sont
sous-représentés dans ces variables. L'axe 1 est un axe corrélé positivement à des équipements. Puisque la région Est est sur la gauche de l'axe 1, c'est une région où les counties sont
sous-équipés quant à ces variables. */

/* II. Approche décisionnelle */

/* Deux méthodes d'affectations des individus aux classes :
-méthode géométrique : on affecte l'individu au groupe dont sa distance est la plus petite, i.e. l'individu est affecté au groupe auquel il est le plus proche 
-méthode probabiliste : l'individu sera affecté au groupe pour laquelle la probabilité sera la plus forte. Dans ce cas, chaque individu aura donc 6 probabilité (une pour chaque groupe). 
*/

proc discrim data=tp_ad.kehr70fl_t outstat=stat out=tp_ad.sortie2 method=normal pool=yes bcov wcov list crossvalidate canonical;
class region;
priors prop; 
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

/* PROC CANDISC avec de nouvelles tables : statistiques (moyennes, écarts-types, corrélations),  
Option canonical pour avoir les nouvelles variables synthétiques. 
Option Method=normal spécifie si la distribution doit être estimée par une une densité de gaussienne,
Option Pool=yes : les distances sont calculées en utilisant la matrice de variance covariance inter-classes. 
Wcov spécifie que les covariances intraclasses doivent être spécifiées pour chaque classe 
List permet de faire apparaître dans quel groupe chaque individu a été affecté. 
Crossvalidate spécifie que les individus sont classifiés en utilisant une fonction de classification qui ne prend pas en compte l'observation. 
*/





ods pdf close;
