ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\r�sultats.pdf";

libname tp_ad "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\Data";

/* I. Approche descriptive */

data tp_ad.kehr70fl_t;
infile "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Analyse discriminante\Data\kehr70fl_r.txt" dlm=';' firstobs=2;
input county $ region $ having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

proc contents data=tp_ad.kehr70fl_t;
run;

/* Nairobi a �t� exclue de l'analyse parce qu'il est � la fois r�gion et county.*/

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
Tableau 1 : On a nos 7 classes a priori : les r�gions. 
Le poids d'une classe est �gal au nombre d'individu de cette classe. 

On cherche une combinaison lin�aire des variables d'�quipement qui s�parerait 
les r�gions, ce qui revient � maximiser la dispersion entre les classes sur la dispersion totale.

Tableau 2 : Test de l'hypoth�se H0: "les centres de gravit� de toutes les classes sont confondus"
Toutes les statistiques m�nent � un rejet de l'hypoth�se nulle avec une probabilit� tr�s forte : au moins deux centres de gravit� sont diff�rents.

Tableau 3 : regroupe les axes factoriels qui d�coulent de la proc�dure. 
Correlation canonique au carr� : inertie inter-classes / inertie totale. 
Plus cette valeur sera importante, plus l'axe en question discriminera correctement.
La deuxi�me partie du tableau regroupe des valeurs propres issues de la diagonalisation de la matrice variances intra-classes.

Tableau 4 : Ce sont les corr�lations entre les variables et les axes 
Le premier axe est le plus corr�l� avec la variable avoir un canap�.
Dans ce tableau, les r�gions sont absentes.


/* Repr�sentation graphique des individus sur le plan factoriel discriminant */

proc plot data=tp_ad.sortie;
plot can2*can1=region;
run;

proc sgplot data=tp_ad.sortie;
scatter x=can1 y=can2 / datalabel=region;
run;

/* Repr�sentation des r�gions sur le premier et deuxi�me axe.
Sur l'axe 1, on constate que les diff�rentes r�gions ne sont pas bien discrimin�es. En effet, il semble que la variance intra soit relativement importante par rapport � l'inter. 
On a bien fait de prendre 2 axes*/

/* Repr�sentation graphique des variables sur le plan factoriel discriminant */

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
title 'Analyse Discriminante : repr�sentation des variables dans le plan factoriel';
run;

/* L'axe 1 est principalement d�fini par les variables sur la droite. Donc, si on revient sur les individus, la r�gion Est, qui �tait correctement repr�sent�, sont des counties qui sont
sous-repr�sent�s dans ces variables. L'axe 1 est un axe corr�l� positivement � des �quipements. Puisque la r�gion Est est sur la gauche de l'axe 1, c'est une r�gion o� les counties sont
sous-�quip�s quant � ces variables. */

/* II. Approche d�cisionnelle */

/* Deux m�thodes d'affectations des individus aux classes :
-m�thode g�om�trique : on affecte l'individu au groupe dont sa distance est la plus petite, i.e. l'individu est affect� au groupe auquel il est le plus proche 
-m�thode probabiliste : l'individu sera affect� au groupe pour laquelle la probabilit� sera la plus forte. Dans ce cas, chaque individu aura donc 6 probabilit� (une pour chaque groupe). 
*/

proc discrim data=tp_ad.kehr70fl_t outstat=stat out=tp_ad.sortie2 method=normal pool=yes bcov wcov list crossvalidate canonical;
class region;
priors prop; 
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
run;

/* PROC CANDISC avec de nouvelles tables : statistiques (moyennes, �carts-types, corr�lations),  
Option canonical pour avoir les nouvelles variables synth�tiques. 
Option Method=normal sp�cifie si la distribution doit �tre estim�e par une une densit� de gaussienne,
Option Pool=yes : les distances sont calcul�es en utilisant la matrice de variance covariance inter-classes. 
Wcov sp�cifie que les covariances intraclasses doivent �tre sp�cifi�es pour chaque classe 
List permet de faire appara�tre dans quel groupe chaque individu a �t� affect�. 
Crossvalidate sp�cifie que les individus sont classifi�s en utilisant une fonction de classification qui ne prend pas en compte l'observation. 
*/





ods pdf close;
