LIBNAME DATA "C:\Users\m1103856\Desktop\TPSE\TP AFC";

DATA DATA.bacs76;
INFILE "C:\Users\m1103856\Desktop\TPSE\TP AFC\data\bacs76.dat";
INPUT regions $ A B C D E F G H index;

TITLE "Répartition des bacheliers en France selon leurs régions";
FOOTNOTE "TP : étude du fichier bacs76.dat";

LABEL 
A = "Philosophie-Lettres (Général)"
B = "Economie et Social (Général)"
C = "Mathématiques et Science Physique (Général)"
D = "Mathématiques et Science de la nature"
E = "Mathématiques et Technique"
F = "Technique industrielle"
G = "Technique économique"
H = "Technique informatique"
;
PROC PRINT DATA = DATA.bacs76;
RUN;

PROC CONTENTS DATA = DATA.bacs76;
RUN;

/* 	
	1) 	Un tableau de contingence est tout simplement un tableau dans lequel on situe un effectif selon deux critères (un en lignes et un en colonnes)
		Ces données sont donc bien sous la forme de tableau de contingence avec pour modalités les régions en ligne et les series de bac en colonne 

	2) 	Une AFC admet en entrée un tableau de contingence, et produit en sortie une ou plusieurs cartes ou images de répartition des valeurs et des variables
		On va donc faire une AFC pour avoir une répartition des séries de BAC et des régions pour par exemple savoir s'il y a beaucoup d'élèves en Mathématique et Technique dans la région 
		PACA 
*/

ODS PDF FILE = "C:\Users\m1103856\Desktop\TPSE\TP AFC\Resultats.pdf";
PROC corresp DATA = data.bacs76 observed CP RP out=resul dim=3;		
VAR A B C D E F G H;
ID regions;
RUN;
ODS pdf CLOSE;

/*
	3)	On crée la table de contingence avec seulement les variables de séries de bacs (on ne veut pas régions ni index pour l'AFC)

	Description des options choisies :
		- observed cp et rp permet d'afficher les colonnes et les lignes en faisant l'AFC 
		- out=resul : crée toutes les données nécessaires dans la table Result et la met dans la bibliothèque WORK
		- dim=3 : on a dimension 1/dimension 2, dimension 1/dimension 3 et dimension 2/dimension 3 

	4)	A propos de la table de contingence
		• 21563 : sum(B) : est le total des étudiants qui ont passé le Bac en série Economie et Social (Général) en 1976
		• 43115 : sum(ILDF) : est le total de tous les étudiants qui ont passé leur bac dans la région Ile de France en 1976

	5) 	A propos de l'inertie et de la décomposition de la distance du Khi-deux
		

*/

