%macro gafcx(ident=_name_,x=1,y=2,nc=4);

%*    Graphique des individus;
%*    x : numero axe horizontal;
%*    y : numero axe vertical;
%*   nc : nombre max de caracteres;

data anno;
 retain  xsys ysys '2';
 set resul;
 style='swiss';
 y= dim&y;
 x= dim&x;
 text=substr(&ident,1,&nc);
 size=0.8;
 label y = "Axe &y"
       x = "Axe &x";
keep x y text xsys ysys size;
run;

proc gplot data=anno;
 title;
 axis1  length=10cm; /* attention taille */
 axis2  length=8cm;
 symbol1 v=none; 
 plot y*x=1 / annotate=anno frame  href=0 vref=0
  haxis=axis1 vaxis=axis2 ;
run;
goptions reset=all;
quit;
%mend;