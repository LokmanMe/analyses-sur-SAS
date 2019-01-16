ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Resultats TP ACM.pdf";

LIBNAME TPACM "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Data";

DATA TPACM.chiens;
INFILE "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Data\chiens.dat";
INPUT race $ taille $ poids $ velocite $ intellig $ affect $ agress $ fonction $;
RUN;

PROC PRINT data=TPACM.chiens;
TITLE 'Table de données';
FOOTNOTE 'TP ACM : étude du fichier chiens.dat';
RUN;

/* Tableau initial : individus * variables qualitatives. */

PROC CONTENTS data=TPACM.chiens;
RUN;

/* Création d'un tableau de codage condensé */

/*Avec changement des modalités dans la table*/
DATA TPACM.chiens2;
SET TPACM.chiens;
select(taille);
when('1')taille='T-';
when('2')taille='T+';
when('3')taille='T++';
otherwise; end;
select(poids);
when('1')poids='P-';
when('2')poids='P+';
when('3')poids='P++';
otherwise; end;
select(velocite);
when('1')velocite='V-';
when('2')velocite='V+';
when('3')velocite='V++';
otherwise; end;
select(intellig);
when('1')intellig='I-';
when('2')intellig='I+';
when('3')intellig='I++';
otherwise; end;
select(affect);
when('1')affect='Af-';
when('2')affect='Af+';
otherwise; end;
select(agress);
when('1')agress='Ag-';
when('2')agress='Ag+';
otherwise; end;
select(fonction);
when('1')fonction='Com';
when('2')fonction='Cha';
when('3')fonction ='Uti';
otherwise; end;
RUN;

PROC PRINT DATA=TPACM.chiens2;
RUN;

/*
				/* Avec les formats 
				PROC FORMAT library=tpacm;
				value $taillef
				"1"="T-"
				"2"="T+"
				"3"="T++"
				;
				value $poidsf
				"1"="P-"
				"2"="P+"
				"3"="P++"
				;
				value $velocitef
				"1"="V-"
				"2"="V+"
				"3"="V++"
				;
				value $intelligf
				"1"="I-"
				"2"="I+"
				"3"="I++"
				;
				value $affectf
				"1"="Af-"
				"2"="Af+"
				;
				value $agressf
				"1"="Ag-"
				"2"="Ag+"
				;
				value $fonctionf
				"1"="Com"
				"2"="Cha"
				"3"="Uti"
				;
				RUN;	
*/


/* On a utilisé la première option qui consiste de créer un tableau de codage condensé. En effet, il remplace les chiffres par les significations correspondantes */



/* ACM à partir de la table de Burt */

options fmtsearch=(tpacm);

PROC CORRESP DATA=TPACM.chiens2 mca out=resul;
TABLES taille--fonction;
TITLE "ACM à partir de la table de Burt (table chiens2)";
RUN;

/* ACM à partir du tableau disjonctif complet */

PROC CORRESP DATA=tpacm.chiens2 out=resul;
TABLES race,taille--fonction;
SUPPLEMENTARY fonction;
TITLE "ACM à partir du tableau disjonctif complet et la variable fonction en supplémentaire";
run;

				/* En utilisant la mise en forme de la solution 2 (table chiens + formats) 

				/* ACM à partir du tableau de Burt             *

				proc corresp data=TPACM.chiens mca out=resul observed;
				tables taille--fonction;
				format taille $taillef. poids $poidsf. velocite $velocitef. intellig $intelligf. affect $affectf. agress $agressf. fonction $fonctionf.;
				title "ACM à partir de la table de Burt (table chiens)";
				run;

				/* ACM à partir du tableau disjonctif complet                *

				proc corresp data=tpacm.chiens out=resul observed;
				tables race,taille--fonction;
				format taille $taillef. poids $poidsf. velocite $velocitef. intellig $intelligf. affect $affectf. agress $agressf. fonction $fonctionf.;
				supplementary fonction;
				title "ACM à partir du tableau disjonctif complet et la variable fonction en supplémentaire (table chiens)";
				run;

/* Représentations graphiques */

options mautosource sasautos="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Macros";
proc options option=sasautos;
run;

%gafcix(ident=_name_,x=1,y=2,nc=10,tp=0.8);
run;

/* ident : identificateur
x et y : les axes
nc : nombre max de caractères
tp : un facteur de taille de représentation des points */

/* Utilise la table de résultats resul, dasn le répertoire work, présente grâce à la procédure
corresp lancée précédemment. */

%gafcix0(ident=_name_,x=1,y=2,nc=10,tp=0.8);
run;

/* Dans cette macro, les noms des individus ne sont pas précisés : ils ne sont représentés 
que par des points. Ne sont visibles que les modalités */

ods pdf close;
