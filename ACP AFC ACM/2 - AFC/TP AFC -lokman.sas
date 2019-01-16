ods pdf file = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data\resultats.pdf";

libname tpafc "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data";

data tpafc.bacs76;
infile "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Data\bacs76.dat";
input regions $ A B C D E F G H index;

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
run;

proc print data = tpafc.bacs76 LABEL;
run;

/* 1- 	Un tableau de contingence est tout simplement un tableau dans lequel on situe un effectif selon deux crit�res (un en lignes et un en colonnes)
		Ces donn�es sont bien sous la forme de tableau de contingence avec les r�gions en ligne et les series de bac en colonne. 
		Cependant il manque les totaux afin d'avoir un tableau de contingence. Par exemple, le nombre total pour chaque ligne et celui pour chaque colonne. */

/* 2- 	Une AFC permet d'�tudier les corr�lations qui existent entre deux variables qualitatives. 
		Ici, on voudra �tudier les correspondances qui existent entre la s�rie du baccalaur�at poursuivi et la r�gion du lyc�en */


proc corresp data = tpafc.bacs76 observed CP RP out = resul dim = 3 ;
var A B C D E F G H;
id regions;
run;

/* 3- Les options choisies sont :
- "observed" qui affiche le tableau analys�, dans ces cas, le tableau de contingence
- "CP" affiche le tableau des profils-colonnes (column)
- "RP", affiche les profils-lignes (row)
- "out = resul", cr�e la table qui a permi d'effectuer l'AFC dans la biblioth�que work
- "dim = 3", le nombre d'axes qui devra �tre utilis�. Par d�fault, dim = 2. Par cette AFC, on demande 3 axes 
Dans la proc�dure corresp, les lignes du tableau � analyser correspondent aux observations de la table sas en entr�e (id regions)
et les colonnes aux variables sp�cifi�es dans l'instruction VAR. On ommet la variable index car on en veut pas */

/* 4- 	21563 : sum(B) : est le total des �tudiants qui ont pass� le Bac en s�rie Economie et Social (G�n�ral) en 1976
		43115 : sum(ILDF) : est le total de tous les �tudiants qui ont pass� leur bac dans la r�gion Ile de France en 1976 */

/* 5- Inertie totale = distance du Khi-deux / le nombre total d'individus.
Le degr� de libert� 147 = (nombre de colonne moins un) * (nombre de ligne moins 1)
La distance du Khi-deux = 4350 > 1.96. On rejette donc l'ind�pendance du Khi-deux. Il y a donc bien une corr�lation entre la s�rie de BAC choisie et la r�gion du lyc�en.
p-valeur = P_H0(D�>d�) = P(khi�_[(r-1)(s-1)]>d�)

Le tableau "Inertia and Chi-Square Decomposition" donne la part de l'inertie totale expliqu�e par chaque axe.
Le premier axe explique 56% de l'inertie totale, le second 24%, le troisi�me 8%. Ainsi, en retenant trois axes, 88% de l'inertie totale est expliqu�e. 
Dans le cadre d'une AFC, il y a au plus min(r-1, s-1) valeurs propres non nulles donc.
Dans le cadre de cet exercice, il y a au plus 7 valeurs propres non nulles, d'o� les 7 axes factoriels */

/* 6- Le profil ligne de la r�gion Ile de France indique la part de lyc�ens parisiens ayant suivi chacune des s�ries.
Par exemple, 22% des bacheliers de la r�gion Ile de France �taient en s�rie Philosophie, 13% en Eco. 
Le profil colonne du bac s�rie A indique la part de bacheliers de cette s�rie venant de chaque r�gion. Par exemple, 21% 
des bacheliers de la s�rie Philosphie venait d'Ile de France, 2% de Champagne. 

Dans le tableau des profils lignes, la valeur au croisement (Corse, Philosophie) indique que 44% des bacheliers Corses �taient en s�rie Philosophie,
Dans le tableau des profils colonnes, ce m�me croisement indique que 0,7% des bacheliers de la s�rie Philosophie �taient Corses. */

/* 7- Le tableau "Coordonn�es des lignes" correspond aux coordonn�es de chaque r�gion dans le plan factoriel. */

/* 8- Dans le tableau "Statistiques descriptives pour les points des colonnes" la qualit� de repr�sentation d'une modalit� dans le 
plan factoriel est donn�. Celle-ci est �gale � la somme des cosinus carr� sur le nombre d'axes du plan retenu. 
Ainsi, on peut distinguer quelles sont les r�gions bien repr�sent�es mais aussi celles mal repr�sent�es dans le plan factoriel.
Le Centre et la Basse-Normandie (BNORD) sont les r�gions les plus mal repr�sent�es sur le plan. 
*/

options mautosource sasautos = "C:\Users\Lokman\Desktop\M1 MASS COMPLET\_STATISTIQUE EXPLORATOIRE MULTIVARIE\ACP AFC ACM\2 - AFC\TP AFC\Macros";
proc options option = sasautos;
run;

%gafcx(ident = regions, x = 1, y = 2, nc = 4);
run;

/* Cette macro permet de faire des repr�sentations graphiques. L'identificateur est pr�cis� par "iden =" , 
le nombre maximum de caract�re � pr�senter sur le graphique est donn� par "nc = 4", le nom des axes est donn� par "x/y = " */

%gafcx(ident = regions, x = 1, y = 3, nc = 8);
run;



ods pdf close;
