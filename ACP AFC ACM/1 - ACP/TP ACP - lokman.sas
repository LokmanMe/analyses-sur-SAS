ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\r�sultats.pdf";

/* TP Analyse en Composantes Principales */

/* 2) Cr�ation d'une table SAS */

LIBNAME TP "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Data";
DATA TP.crime;
INFILE "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Data\crime.dat";
LENGTH netats $14;
INPUT netats $ meurtre viol volmainarmee agression voleffraction volalatire effracoderoute;
RUN;
/* On cr�e une biblioth�que permanente "TP". Ensuite on importe le fichier crime.dat. 
On cr�e la table � partir de ce fichier, on indique l'identifiant (netats) et les 7 variables. On indique aussi le format (num�rique ou caract�re)*/

options linesize = 80 pagesize = 60 nodate;
title "Table de donn�es SAS";
footnote "TP : �tude du fichier crime.dat";
proc print data = TP.crime;
run;
/* On peut visualiser le tableau avec la proc�dure "print" (ci-dessus) ou simplement en double-cliquant dans l'explorateur des tables */


/* 3) Descriptions �l�mentaires */

/* 3.1) Traitement univari�s (tris � plat) */

proc means data = TP.crime;
run;
/* Pour toutes les variables quantitatives affiche : moyenne, �cart-type, valeur minimale, valeur maximale, et nombre d'observations. */

proc means data = TP.crime median mean clm Maxdec=2;
run;
/* Gr�ce aux options ajout�es, la commande affiche seulement : la m�diane, la moyenne et les intervalles de confiance pour la moyenne 
On a mis maxdec = 2 pour avoir au maximum 2 chiffres apr�s la virgule. */
 
proc gchart data = TP.crime;
vbar meurtre--effracoderoute;
run;
/* Histogramme en barre verticales de toutes les variables quantitatives */

proc gchart data = TP.crime;
vbar meurtre--effracoderoute / subgroup = netats;
run;
/* Pour chaque tranche de valeur on a maintenant l'�tat qui y contribue (mais pas proportionnellement) */


/* 3.2)  Traitements bivari�s (tris crois�s) */

/* a. Formule du coefficient de Pearson (coeff de corr�lation lin�aire) : r(x,y) = cov(x,y) / s(x)s(y) */

/* b. Le coefficient de corr�lation mesure l'intensit� de la liaison entre deux variables.
G�om�triquement, c'est le cosinus de l'angle entre les deux vecteurs centr�s des variables. */

/* c. Le coefficient de corr�lation varie entre -1 et 1. Lorsque r(x,y)=1, les variables sont totalement corr�l�es lin�airement positivement 
(quand la valeur de l'une augmente, la valeur de l'autre augmente de la m�me fa�on)
Lorsque r(x,y)=-1, c'est l'inverse les variables sont totalement corr�l�es lin�airement n�gativement 
Lorsque r(x,y)=0, les variables ne sont pas du tout corr�l�es lin�airement (mais elles peuvent cependant �tre corr�l�es)*/

proc corr data = TP.crime;
var meurtre--effracoderoute;
run;
/* Les coefficients de corr�lation sont tous positifs et quasiment toujours significativement > 0. Autrement dit, presque toutes les variables sont li�es entre elles deux � deux.
Les variables les plus corr�l�es sont "vol � la tire" et "vol par effraction". */

proc gplot data = TP.crime;
symbol1 v = square;
plot voleffraction*volalatire = 1;
run;
proc gplot data = TP.crime;
symbol1 v = square interpol = r;
plot voleffraction*volalatire = 1;
run;
/*Nuage de points et droite de r�gression lin�aire de "vol par effraction" par en fonction de "vol � la tire"*/ 


/* 4) ACP */

options mautosource sasautos = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Macros";
proc options option = sasautos;
run;
/* Le chemin d'acc�s aux macros a �t� sp�cifi�. 
On va alors pouvoir effectuer l'ACP en utilisant la macro %acp pr�sente dans le dossier en question. */

%acp(TP.crime,netats,meurtre--effracoderoute, q=4);

/* 	1er tableau : statistiques elementaires : moyenne, �cart type et effectif de toutes les variables quantitatives.
	2nd tableau : matrice de corr�lation de toutes les variables deux � deux.
	3eme tableau : les valeurs propres associ�es � la matrice de corr�lation, ainsi que la part de variance expliqu�e par chacunes des nouvelles variables synth�tiques (on a 7 valeurs propres car 8 variables)
Ici la premi�re variable synth�tique explique 59% de la variance. Les 2 premi�res variables expliquent 76%.
	4eme tableau : les coordonn�es des individus dans le nouvel espace et leur coscarr� (l'Alabama est tr�s bien repr�sent� dans le 2eme axe).
	5eme 6eme et 7eme tableau : Les vecteurs propres, les coordonn�es des variables et la corr�lation entre les variables originales et les axes cr��s. */

/* 7. 	Pourquoi effectuer une ACP ?
		Rechercher des liaisons entre les variables. Quelles variables apportent des informations identiques et lesquels en apporte des diff�rentes ?
		Faire un bilan des "ressemblances" des individus par rapports aux variables

		On a effectu� une ACP norm�e. C'est � dire que les variances de toutes les variables ont �t� normalis�es � 1.
		Ainsi, s'il y a une variable avec des valeurs tr�s importantes et une autre avec des valeurs tr�s faibles,
		un m�me changement pour les deux variables aura une variation relative bien plus importante pour la seconde que pour la premi�re.
		(regarder le tableau des �cart-type, comparer vol � la tire et meurtre. quand on normalise la variance : 1 meurtre en + est plus grave qu'un vol � la tire en +)*/

/* 8. L'inertie du nuage associee aux 7 variables initiales r�duites est �gale � 7 puisqu'on est en en ACP norm�e */

%gacpsx

%gacpbx

/* 	9.a) Coordonn�es de North Dakota sur le premier axe factoriel = (-4.00)

	9.b) Contribution de North Dakota au premier axe factoriel = 7.79.	Il contribue beaucoup � la construction du premier axe !
			- Calcul de la contribution d'un individu = coordonn�es� de l'individu sur l'axe / coordonn�es� de tous les individu sur l'axe     

	9.c) Qualit� de repr�sentation de North Dakota sur le premier plan factoriel = 0.97+0.01 = 0.98
			- Calcul de la representation d'un individu = cos� entre vecteur(origine,individu) et vecteur(origine,projet� de l'individu)
*/

/* L'inertie repr�sente la dispersion. Si on �tait en dimension 1, on parlerait de variance. Puisqu'on est en dimension 7, on parle d'inertie. Mais l'id�e est la m�me. */

%gacpvx(x=1,y=2,nc=6,coeff=1);
run;

/*Cercle de corr�lation des variables. "meurtre" et "effraction du code de la route" sont les variables les moins corr�l�es*/ 

%gacpix(x=1,y=2,nc=6,coeff=1);
run;

/* 	Le premier axe contient les �tats o� il y a le plus de : vol avec effraction (0.89), viol (0.88), vol � main arm�e (0.81) et agressions (0.80) ex: Nevada, Californie
	Le second axe est caract�ris� par des �tats o� il y a le moins de meurtre (-0.70) 	ex : Rhodes Island et Hawaii*/


ods pdf close;
