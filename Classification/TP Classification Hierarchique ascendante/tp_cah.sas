ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Classification Hierarchique ascendante\r�sultats.pdf";

libname tpcah "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\Classification\TP Classification Hierarchique ascendante\Data";
run;

option fmtsearch=(tpcah);
run;

/* R�sum� de la table */

proc contents data = tpcah.kehr70fl_c;
run;

/* Moyenne des variables pour chaque county */

proc print data = tpcah.kehr70fl_c;
title "TP : Classification Ascendante Hi�rarchique des counties, m�thode = ward";
run;



proc cluster data = tpcah.kehr70fl_c method = ward outtree = tree
pseudo rsquare simple standard;
id county;
run;

/* On a la moyenne et l'�cart-type pour chaque variable. 
La variance a �t� normalis�e afin d'�viter de donner � certaines variables
trop d'importance parce que la variance serait plus importante pour cette variable que pour une autre.

Historique des classifications : �tapes r�cusirves de fusion des county afin de constituer une classe.
Les counties les plus proches au sens de ward ont �t� fusionn�s 2 � 2.

La colonne R-carr� repr�sente l'inertie inter-classe divis�e par l'inertie totale 
La colonne R-carr� semi-partiel ce qui est perdu lors de l'agglom�ration de deux classes.
Au fur et � mesure des agglom�rations, on perd de l'inertie inter et on gagne de l'inertie totale. */

/* L'inertie intra-classes est la variance qu'il y a entre les individus d'une m�me classe.
L'inertie inter-classes est la variance qu'il y a entre les classes.
Inertie(totale) = Inertie(intra) + Inertie(inter)
R� = I_inter/I_totale */

/* Un pseudoF �lev� repr�sente une dispersion interclasse forte par rapport � l'inertie intraclasse. 
Pic de pseudoF : la dispersion entre les classes est importante, donc les classes sont bien diff�rentes, et la dispersion au sein des classes est faible,
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

   /* On retient donc 3 classes : pseudoF maximal, le pseudo T� suffisemment faible. 
   Une �tape de plus consisterait � aggr�ger des classes diff�rentes. */

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
title "Distribution des classes au K�nya";
run;
quit;

/* Cr�ation de la carte. La proc�dure associe chaque county � une classe, et colore selon la classe correspondante. */

proc sort data=out;
by cluster;
run;

proc print data=out;
var having_electricity_f having_radio_f having_television_f having_refrigirator_f having_landlinephone_f having_mobilephone_f having_solarpanel_f 
having_table_f having_chair_f having_sofa_f having_bed_f having_cupboard_f having_clock_f having_microwave_f having_dvdplayer_f having_cdplayer_f;
by cluster;
run;

/* Les individus sont d'abord class�s selon la classe � laquelle ils appartiennent puis ils sont affich�s. Les variables sont aussi affich�es. */

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

/* En terme d'�quipements, par rapport � la moyenne nationale pour les diff�rentes variables, la premi�re classe est dans la moyenne, la seconde classe est en dessous, la troisi�me classe est au dessus. */



/* Valeurs tests associ�es : */

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

L'hypoth�se nulle correspond � une situation o� la moyenne de la variable en question n'est pas diff�rente de la moyenne pour tout l'�chantillon. 
La comparaison se fait par rapport � une loi normale centr�e r�duite. A chaque fois que la statistique est sup�rieure �
cette valeur, l'hypoth�se nulle est rejet�e et donc la diff�rence entre la moyenne de la classe et la moyenne de la population est significative.
Plus cette statistique est importante, plus le rejet est important. 
Une statistique importante illustre donc des variables qui sont clairement clivantes. */ 

ods pdf close;
