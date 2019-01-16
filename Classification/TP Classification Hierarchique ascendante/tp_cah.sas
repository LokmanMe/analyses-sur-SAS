ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Classification Hierarchique ascendante\résultats.pdf";

libname tpcah "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Classification Hierarchique ascendante\Data";
run;

option fmtsearch=(tpcah);
run;

/* Résumé de la table */

proc contents data = tpcah.kehr70fl_c;
run;

/* Moyenne des variables pour chaque county */

proc print data = tpcah.kehr70fl_c;
title "TP : Classification Ascendante Hiérarchique des counties, méthode = ward";
run;



proc cluster data = tpcah.kehr70fl_c method = ward outtree = tree
pseudo rsquare simple standard;
id county;
run;

/* On a la moyenne et l'écart-type pour chaque variable. 
La variance a été normalisée afin d'éviter de donner à certaines variables
trop d'importance parce que la variance serait plus importante pour cette variable que pour une autre.

Historique des classifications : étapes récusirves de fusion des county afin de constituer une classe.
Les counties les plus proches au sens de ward ont été fusionnés 2 à 2.

La colonne R-carré représente l'inertie inter-classe divisée par l'inertie totale 
La colonne R-carré semi-partiel ce qui est perdu lors de l'agglomération de deux classes.
Au fur et à mesure des agglomérations, on perd de l'inertie inter et on gagne de l'inertie totale. */

/* L'inertie intra-classes est la variance qu'il y a entre les individus d'une même classe.
L'inertie inter-classes est la variance qu'il y a entre les classes.
Inertie(totale) = Inertie(intra) + Inertie(inter)
R² = I_inter/I_totale */

/* Un pseudoF élevé représente une dispersion interclasse forte par rapport à l'inertie intraclasse. 
Pic de pseudoF : la dispersion entre les classes est importante, donc les classes sont bien différentes, et la dispersion au sein des classes est faible,
donc les individus de la classe sont proches. En effet :
PseudoF = [I_inter / (nbr_classe - 1)] / [I_intra / (n - nbr_classe)] */

/*****Graphiques *********/
proc sort data=tree;
  by _ncl_;
run;
     /****sprsq *****/
data sprsq;
 set tree;
 by _ncl_;
if first._ncl_;
keep _ncl_ _sprsq_;
run;
proc gplot data=sprsq;
where _ncl_ <10 and  _ncl_ ne 1;
plot _sprsq_*_ncl_;
symbol i=join;
run;
quit;



  /**** pseudo f et pseudo t ****/
data FT2;
   set tree ;
   by _ncl_;
   if first._ncl_;
   if _psf_=. and _pst2_=. then delete;
   keep _ncl_ _psf_  _pst2_;
   legend1 across=2 cborder=red
   position = (top right inside ) mode = protect
   label=none
    value= (h= 0.5 tick=1 "F" tick=2 "T2");

   axis1 label = none;
   symbol1 c=green i=join l=1;
   symbol2 c=red i=join l=2 ;

   proc gplot data= FT2 ;
    where _ncl_ < 10 and _ncl_ ne 1;
    plot (_psf_ _pst2_)*_ncl_/overlay legend=legend1
          vaxis=axis1;

   run;
   quit;

   /* On retient donc 3 classes : pseudoF maximal, le pseudo T² suffisemment faible. 
   Une étape de plus consisterait à aggréger des classes différentes. */

   proc tree data=tree nclusters=3 out=out;
   copy having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f 
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
id county;
run;

/* Dendogramme */

proc mapimport out=carto_kenya datafile="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Classification Hierarchique ascendante\Data\Kenya_admin_2014_WGS84.shp";
run;

proc gmap data=out map=carto_kenya;
id county;
choro cluster / discrete WOUTLINE=1 levels=3;
title "Distribution des classes au Kénya";
run;
quit;

/* Création de la carte. La procédure associe chaque county à une classe, et colore selon la classe correspondante. */

proc sort data=out;
by cluster;
run;

proc print data=out;
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f 
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
by cluster;
run;

/* Les individus sont d'abord classés selon la classe à laquelle ils appartiennent puis ils sont affichés. Les variables sont aussi affichées. */

proc tabulate data=out;
class cluster;
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f 
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
table(having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f 
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f), 
(cluster all)*mean;
label cluster='Classes';
keylabel mean='Moyenne';
run;

/* En terme d'équipements, par rapport à la moyenne nationale pour les différentes variables, la première classe est dans la moyenne, la seconde classe est en dessous, la troisième classe est au dessus. */



/* Valeurs tests associées : */

%macro valeurtest(vble) ;

title "";
PROC SQL;
CREATE TABLE meanbyclus AS
SELECT DISTINCT mean(&vble) as byclus_m&vble, cluster, 1 as indic, count(*) as nl
FROM out
GROUP BY cluster
;


CREATE TABLE meantot AS
SELECT DISTINCT mean(&vble) as m&vble, var(&vble) as var&vble, 1 as indic, count(*) as n
FROM out
;

create table pourvaleurtest as
select data1.cluster, data1.byclus_m&vble,  data2.m&vble, data2.var&vble, data1.nl, data2.n
from meanbyclus as data1 FULL JOIN meantot as data2
on data1.indic=data2.indic;

create table &vble as
select cluster as cluster,((byclus_m&vble-m&vble)/sqrt(((n-nl)/nl)*(var&vble/(n-1)))) as &vble
from pourvaleurtest
order by cluster
;
QUIT;
%mend valeurtest;

%LET selvar=having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f  having_mobilephone_f having_solarpanel_f having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;  


%valeurtest(%scan(&selvar,1,' '));
%valeurtest(%scan(&selvar,2,' '));
%valeurtest(%scan(&selvar,3,' '));
%valeurtest(%scan(&selvar,4,' '));
%valeurtest(%scan(&selvar,5,' '));
%valeurtest(%scan(&selvar,6,' '));
%valeurtest(%scan(&selvar,7,' '));
%valeurtest(%scan(&selvar,8,' '));
%valeurtest(%scan(&selvar,9,' '));
%valeurtest(%scan(&selvar,10,' '));
%valeurtest(%scan(&selvar,11,' '));
%valeurtest(%scan(&selvar,12,' '));
%valeurtest(%scan(&selvar,13,' '));
%valeurtest(%scan(&selvar,14,' '));
%valeurtest(%scan(&selvar,15,' '));
%valeurtest(%scan(&selvar,16,' '));




data vt;
merge &selvar;
by cluster;
run;

Title "Valeurs tests";
proc tabulate data=vt noseps format =8.2;
class cluster ;
var &selvar;
table(&selvar),
mean="valeur test"*(cluster)
/rts=7 condense;
label cluster='Classes';
/*keylabel mean='moyenne';*/
run;

/* 
Z 99% = 2.57
Z 95% = 1.96

L'hypothèse nulle correspond à une situation où la moyenne de la variable en question n'est pas différente de la moyenne pour tout l'échantillon. 
La comparaison se fait par rapport à une loi normale centrée réduite. A chaque fois que la statistique est supérieure à
cette valeur, l'hypothèse nulle est rejetée et donc la différence entre la moyenne de la classe et la moyenne de la population est significative.
Plus cette statistique est importante, plus le rejet est important. 
Une statistique importante illustre donc des variables qui sont clairement clivantes. */ 

ods pdf close;
