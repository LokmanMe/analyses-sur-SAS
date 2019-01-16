ods pdf file = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data\resultats.pdf";

libname tpafc "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data";

data tpafc.bacs76;
infile "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data\bacs76.dat";
input regions $ A B C D E F G H index;

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
run;

proc print data = tpafc.bacs76 LABEL;
run;

/* 1- 	Un tableau de contingence est tout simplement un tableau dans lequel on situe un effectif selon deux critères (un en lignes et un en colonnes)
		Ces données sont bien sous la forme de tableau de contingence avec les régions en ligne et les series de bac en colonne. 
		Cependant il manque les totaux afin d'avoir un tableau de contingence. Par exemple, le nombre total pour chaque ligne et celui pour chaque colonne. */

/* 2- 	Une AFC permet d'étudier les corrélations qui existent entre deux variables qualitatives. 
		Ici, on voudra étudier les correspondances qui existent entre la série du baccalauréat poursuivi et la région du lycéen */


proc corresp data = tpafc.bacs76 observed CP RP out = resul dim = 3 ;
var A B C D E F G H;
id regions;
run;

/* 3- Les options choisies sont :
- "observed" qui affiche le tableau analysé, dans ces cas, le tableau de contingence
- "CP" affiche le tableau des profils-colonnes (column)
- "RP", affiche les profils-lignes (row)
- "out = resul", crée la table qui a permi d'effectuer l'AFC dans la bibliothèque work
- "dim = 3", le nombre d'axes qui devra être utilisé. Par défault, dim = 2. Par cette AFC, on demande 3 axes 
Dans la procédure corresp, les lignes du tableau à analyser correspondent aux observations de la table sas en entrée (id regions)
et les colonnes aux variables spécifiées dans l'instruction VAR. On ommet la variable index car on en veut pas */

/* 4- 	21563 : sum(B) : est le total des étudiants qui ont passé le Bac en série Economie et Social (Général) en 1976
		43115 : sum(ILDF) : est le total de tous les étudiants qui ont passé leur bac dans la région Ile de France en 1976 */

/* 5- Inertie totale = distance du Khi-deux / le nombre total d'individus.
Le degré de liberté 147 = (nombre de colonne moins un) * (nombre de ligne moins 1)
La distance du Khi-deux = 4350 > 1.96. On rejette donc l'indépendance du Khi-deux. Il y a donc bien une corrélation entre la série de BAC choisie et la région du lycéen.
p-valeur = P_H0(D²>d²) = P(khi²_[(r-1)(s-1)]>d²)

Le tableau "Inertia and Chi-Square Decomposition" donne la part de l'inertie totale expliquée par chaque axe.
Le premier axe explique 56% de l'inertie totale, le second 24%, le troisième 8%. Ainsi, en retenant trois axes, 88% de l'inertie totale est expliquée. 
Dans le cadre d'une AFC, il y a au plus min(r-1, s-1) valeurs propres non nulles donc.
Dans le cadre de cet exercice, il y a au plus 7 valeurs propres non nulles, d'où les 7 axes factoriels */

/* 6- Le profil ligne de la région Ile de France indique la part de lycéens parisiens ayant suivi chacune des séries.
Par exemple, 22% des bacheliers de la région Ile de France étaient en série Philosophie, 13% en Eco. 
Le profil colonne du bac série A indique la part de bacheliers de cette série venant de chaque région. Par exemple, 21% 
des bacheliers de la série Philosphie venait d'Ile de France, 2% de Champagne. 

Dans le tableau des profils lignes, la valeur au croisement (Corse, Philosophie) indique que 44% des bacheliers Corses étaient en série Philosophie,
Dans le tableau des profils colonnes, ce même croisement indique que 0,7% des bacheliers de la série Philosophie étaient Corses. */

/* 7- Le tableau "Coordonnées des lignes" correspond aux coordonnées de chaque région dans le plan factoriel. */

/* 8- Dans le tableau "Statistiques descriptives pour les points des colonnes" la qualité de représentation d'une modalité dans le 
plan factoriel est donné. Celle-ci est égale à la somme des cosinus carré sur le nombre d'axes du plan retenu. 
Ainsi, on peut distinguer quelles sont les régions bien représentées mais aussi celles mal représentées dans le plan factoriel.
Le Centre et la Basse-Normandie (BNORD) sont les régions les plus mal représentées sur le plan. 
*/

options mautosource sasautos = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Macros";
proc options option = sasautos;
run;

%gafcx(ident = regions, x = 1, y = 2, nc = 4);
run;

/* Cette macro permet de faire des représentations graphiques. L'identificateur est précisé par "iden =" , 
le nombre maximum de caractère à présenter sur le graphique est donné par "nc = 4", le nom des axes est donné par "x/y = " */

%gafcx(ident = regions, x = 1, y = 3, nc = 8);
run;



ods pdf close;
