ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Resultats TP ACM.pdf";

LIBNAME TPACM "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Data";

DATA TPACM.chiens;
INFILE "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Data\chiens.dat";
INPUT race $ taille $ poids $ velocite $ intellig $ affect $ agress $ fonction $;
RUN;

PROC PRINT data=TPACM.chiens;
TITLE 'Table de donn�es';
FOOTNOTE 'TP ACM : �tude du fichier chiens.dat';
RUN;

/* Tableau initial : individus * variables qualitatives. */

PROC CONTENTS data=TPACM.chiens;
RUN;

/* Cr�ation d'un tableau de codage condens� */

/*Avec changement des modalit�s dans la table*/
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


/* On a utilis� la premi�re option qui consiste de cr�er un tableau de codage condens�. En effet, il remplace les chiffres par les significations correspondantes */



/* ACM � partir de la table de Burt */

options fmtsearch=(tpacm);

PROC CORRESP DATA=TPACM.chiens2 mca out=resul;
TABLES taille--fonction;
TITLE "ACM � partir de la table de Burt (table chiens2)";
RUN;

/* ACM � partir du tableau disjonctif complet */

PROC CORRESP DATA=tpacm.chiens2 out=resul;
TABLES race,taille--fonction;
SUPPLEMENTARY fonction;
TITLE "ACM � partir du tableau disjonctif complet et la variable fonction en suppl�mentaire";
run;

				/* En utilisant la mise en forme de la solution 2 (table chiens + formats) 

				/* ACM � partir du tableau de Burt             *

				proc corresp data=TPACM.chiens mca out=resul observed;
				tables taille--fonction;
				format taille $taillef. poids $poidsf. velocite $velocitef. intellig $intelligf. affect $affectf. agress $agressf. fonction $fonctionf.;
				title "ACM � partir de la table de Burt (table chiens)";
				run;

				/* ACM � partir du tableau disjonctif complet                *

				proc corresp data=tpacm.chiens out=resul observed;
				tables race,taille--fonction;
				format taille $taillef. poids $poidsf. velocite $velocitef. intellig $intelligf. affect $affectf. agress $agressf. fonction $fonctionf.;
				supplementary fonction;
				title "ACM � partir du tableau disjonctif complet et la variable fonction en suppl�mentaire (table chiens)";
				run;

/* Repr�sentations graphiques */

options mautosource sasautos="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\3 - ACM\TP ACM clean\Macros";
proc options option=sasautos;
run;

%gafcix(ident=_name_,x=1,y=2,nc=10,tp=0.8);
run;

/* ident : identificateur
x et y : les axes
nc : nombre max de caract�res
tp : un facteur de taille de repr�sentation des points */

/* Utilise la table de r�sultats resul, dasn le r�pertoire work, pr�sente gr�ce � la proc�dure
corresp lanc�e pr�c�demment. */

%gafcix0(ident=_name_,x=1,y=2,nc=10,tp=0.8);
run;

/* Dans cette macro, les noms des individus ne sont pas pr�cis�s : ils ne sont repr�sent�s 
que par des points. Ne sont visibles que les modalit�s */

ods pdf close;
