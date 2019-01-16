ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\résultats.pdf";

/* TP Analyse en Composantes Principales */

/* 2) Création d'une table SAS */

LIBNAME TP "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Data";
DATA TP.crime;
INFILE "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Data\crime.dat";
LENGTH netats $14;
INPUT netats $ meurtre viol volmainarmee agression voleffraction volalatire effracoderoute;
RUN;
/* On crée une bibliothèque permanente "TP". Ensuite on importe le fichier crime.dat. 
On crée la table à partir de ce fichier, on indique l'identifiant (netats) et les 7 variables. On indique aussi le format (numérique ou caractère)*/

options linesize = 80 pagesize = 60 nodate;
title "Table de données SAS";
footnote "TP : étude du fichier crime.dat";
proc print data = TP.crime;
run;
/* On peut visualiser le tableau avec la procédure "print" (ci-dessus) ou simplement en double-cliquant dans l'explorateur des tables */


/* 3) Descriptions élémentaires */

/* 3.1) Traitement univariés (tris à plat) */

proc means data = TP.crime;
run;
/* Pour toutes les variables quantitatives affiche : moyenne, écart-type, valeur minimale, valeur maximale, et nombre d'observations. */

proc means data = TP.crime median mean clm Maxdec=2;
run;
/* Grâce aux options ajoutées, la commande affiche seulement : la médiane, la moyenne et les intervalles de confiance pour la moyenne 
On a mis maxdec = 2 pour avoir au maximum 2 chiffres après la virgule. */
 
proc gchart data = TP.crime;
vbar meurtre--effracoderoute;
run;
/* Histogramme en barre verticales de toutes les variables quantitatives */

proc gchart data = TP.crime;
vbar meurtre--effracoderoute / subgroup = netats;
run;
/* Pour chaque tranche de valeur on a maintenant l'état qui y contribue (mais pas proportionnellement) */


/* 3.2)  Traitements bivariés (tris croisés) */

/* a. Formule du coefficient de Pearson (coeff de corrélation linéaire) : r(x,y) = cov(x,y) / s(x)s(y) */

/* b. Le coefficient de corrélation mesure l'intensité de la liaison entre deux variables.
Géométriquement, c'est le cosinus de l'angle entre les deux vecteurs centrés des variables. */

/* c. Le coefficient de corrélation varie entre -1 et 1. Lorsque r(x,y)=1, les variables sont totalement corrélées linéairement positivement 
(quand la valeur de l'une augmente, la valeur de l'autre augmente de la même façon)
Lorsque r(x,y)=-1, c'est l'inverse les variables sont totalement corrélées linéairement négativement 
Lorsque r(x,y)=0, les variables ne sont pas du tout corrélées linéairement (mais elles peuvent cependant être corrélées)*/

proc corr data = TP.crime;
var meurtre--effracoderoute;
run;
/* Les coefficients de corrélation sont tous positifs et quasiment toujours significativement > 0. Autrement dit, presque toutes les variables sont liées entre elles deux à deux.
Les variables les plus corrélées sont "vol à la tire" et "vol par effraction". */

proc gplot data = TP.crime;
symbol1 v = square;
plot voleffraction*volalatire = 1;
run;
proc gplot data = TP.crime;
symbol1 v = square interpol = r;
plot voleffraction*volalatire = 1;
run;
/*Nuage de points et droite de régression linéaire de "vol par effraction" par en fonction de "vol à la tire"*/ 


/* 4) ACP */

options mautosource sasautos = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\1 - ACP\TP ACP\Macros";
proc options option = sasautos;
run;
/* Le chemin d'accès aux macros a été spécifié. 
On va alors pouvoir effectuer l'ACP en utilisant la macro %acp présente dans le dossier en question. */

%acp(TP.crime,netats,meurtre--effracoderoute, q=4);

/* 	1er tableau : statistiques elementaires : moyenne, écart type et effectif de toutes les variables quantitatives.
	2nd tableau : matrice de corrélation de toutes les variables deux à deux.
	3eme tableau : les valeurs propres associées à la matrice de corrélation, ainsi que la part de variance expliquée par chacunes des nouvelles variables synthétiques (on a 7 valeurs propres car 8 variables)
Ici la première variable synthétique explique 59% de la variance. Les 2 premières variables expliquent 76%.
	4eme tableau : les coordonnées des individus dans le nouvel espace et leur coscarré (l'Alabama est très bien représenté dans le 2eme axe).
	5eme 6eme et 7eme tableau : Les vecteurs propres, les coordonnées des variables et la corrélation entre les variables originales et les axes créés. */

/* 7. 	Pourquoi effectuer une ACP ?
		Rechercher des liaisons entre les variables. Quelles variables apportent des informations identiques et lesquels en apporte des différentes ?
		Faire un bilan des "ressemblances" des individus par rapports aux variables

		On a effectué une ACP normée. C'est à dire que les variances de toutes les variables ont été normalisées à 1.
		Ainsi, s'il y a une variable avec des valeurs très importantes et une autre avec des valeurs très faibles,
		un même changement pour les deux variables aura une variation relative bien plus importante pour la seconde que pour la première.
		(regarder le tableau des écart-type, comparer vol à la tire et meurtre. quand on normalise la variance : 1 meurtre en + est plus grave qu'un vol à la tire en +)*/

/* 8. L'inertie du nuage associee aux 7 variables initiales réduites est égale à 7 puisqu'on est en en ACP normée */

%gacpsx

%gacpbx

/* 	9.a) Coordonnées de North Dakota sur le premier axe factoriel = (-4.00)

	9.b) Contribution de North Dakota au premier axe factoriel = 7.79.	Il contribue beaucoup à la construction du premier axe !
			- Calcul de la contribution d'un individu = coordonnées² de l'individu sur l'axe / coordonnées² de tous les individu sur l'axe     

	9.c) Qualité de représentation de North Dakota sur le premier plan factoriel = 0.97+0.01 = 0.98
			- Calcul de la representation d'un individu = cos² entre vecteur(origine,individu) et vecteur(origine,projeté de l'individu)
*/

/* L'inertie représente la dispersion. Si on était en dimension 1, on parlerait de variance. Puisqu'on est en dimension 7, on parle d'inertie. Mais l'idée est la même. */

%gacpvx(x=1,y=2,nc=6,coeff=1);
run;

/*Cercle de corrélation des variables. "meurtre" et "effraction du code de la route" sont les variables les moins corrélées*/ 

%gacpix(x=1,y=2,nc=6,coeff=1);
run;

/* 	Le premier axe contient les états où il y a le plus de : vol avec effraction (0.89), viol (0.88), vol à main armée (0.81) et agressions (0.80) ex: Nevada, Californie
	Le second axe est caractérisé par des états où il y a le moins de meurtre (-0.70) 	ex : Rhodes Island et Hawaii*/


ods pdf close;
