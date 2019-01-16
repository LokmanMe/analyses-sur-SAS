LIBNAME DATA "C:\Users\m1103856\Desktop\TPSE\TP AFC";

DATA DATA.bacs76;
INFILE "C:\Users\m1103856\Desktop\TPSE\TP AFC\data\bacs76.dat";
INPUT regions $ A B C D E F G H index;

TITLE "R�partition des bacheliers en France selon leurs r�gions";
FOOTNOTE "TP : �tude du fichier bacs76.dat";

LABEL 
A = "Philosophie-Lettres (G�n�ral)"
B = "Economie et Social (G�n�ral)"
C = "Math�matiques et Science Physique (G�n�ral)"
D = "Math�matiques et Science de la nature"
E = "Math�matiques et Technique"
F = "Technique industrielle"
G = "Technique �conomique"
H = "Technique informatique"
;
PROC PRINT DATA = DATA.bacs76;
RUN;

PROC CONTENTS DATA = DATA.bacs76;
RUN;

/* 	
	1) 	Un tableau de contingence est tout simplement un tableau dans lequel on situe un effectif selon deux crit�res (un en lignes et un en colonnes)
		Ces donn�es sont donc bien sous la forme de tableau de contingence avec pour modalit�s les r�gions en ligne et les series de bac en colonne 

	2) 	Une AFC admet en entr�e un tableau de contingence, et produit en sortie une ou plusieurs cartes ou images de r�partition des valeurs et des variables
		On va donc faire une AFC pour avoir une r�partition des s�ries de BAC et des r�gions pour par exemple savoir s'il y a beaucoup d'�l�ves en Math�matique et Technique dans la r�gion 
		PACA 
*/

ODS PDF FILE = "C:\Users\m1103856\Desktop\TPSE\TP AFC\Resultats.pdf";
PROC corresp DATA = data.bacs76 observed CP RP out=resul dim=3;		
VAR A B C D E F G H;
ID regions;
RUN;
ODS pdf CLOSE;

/*
	3)	On cr�e la table de contingence avec seulement les variables de s�ries de bacs (on ne veut pas r�gions ni index pour l'AFC)

	Description des options choisies :
		- observed cp et rp permet d'afficher les colonnes et les lignes en faisant l'AFC 
		- out=resul : cr�e toutes les donn�es n�cessaires dans la table Result et la met dans la biblioth�que WORK
		- dim=3 : on a dimension 1/dimension 2, dimension 1/dimension 3 et dimension 2/dimension 3 

	4)	A propos de la table de contingence
		� 21563 : sum(B) : est le total des �tudiants qui ont pass� le Bac en s�rie Economie et Social (G�n�ral) en 1976
		� 43115 : sum(ILDF) : est le total de tous les �tudiants qui ont pass� leur bac dans la r�gion Ile de France en 1976

	5) 	A propos de l'inertie et de la d�composition de la distance du Khi-deux
		

*/

