%macro acp(dataset, ident, listev, red=,q=3,poids=);
%* Acp de dataset ;
%*          ident : variable contenant les identificateurs;
%*                  des individus;
%*        listev : liste des variables (numeriques);
%*     par defaut : reduites sinon red=cov;
%*              q : nombre de composantes retenues;
%*          poids : variable de ponderation;
%*          pvar  : nombre de variables ;
%* options  edition;
%global pvar;
options linesize=80 pagesize=66 nonumber nodate;
title "A.c.p. des donnees de &dataset";
footnote;

data donnees (keep=ident poids &listev);
set &dataset nobs=nn;
retain spoids 0;
%if %length(&poids) ne 0 %then %str(poids = &poids;);
                         %else %str(poids=1;);
spoids=spoids+poids;
ident=&ident;
if _n_=nn then call symput('spoids',spoids);
run;

proc princomp data=donnees noprint
              outstat=eltpr out=compr
              vardef=weight &red;
 weight poids;
 var &listev;
run;

%* nettoyage des resultats;
data tlambda (drop=_type_)
     tvectp (drop=_type_)
     sigma (drop=_type_)
     statel;
set eltpr;
select (_type_);
when ('EIGENVAL') do;
         _name_ = 'lambda';
         output tlambda;
         end;
when ('CORR','COV')  output sigma;
when ('SCORE')       output tvectp;
otherwise output statel;
end;
run;

proc print data=statel noobs round;
title3 'Statistiques elementaires';
run;
title;
proc print data=sigma noobs round;
title2 'Matrice des covariances ou des correlations';
run;

data lambda (keep=k lambda pctvar cumpct);
set tlambda (drop= _name_) ;
array l{*} _numeric_;
tr=sum(of l{*});
cumpct=0;
do k=1 to dim(l);
lambda=l{k};
pctvar=l{k}/tr;
cumpct=pctvar + cumpct;
output;
end;
run;
data lambda ;
set lambda nobs=pvar;
call symput('pvar',compress(pvar));
run;
proc print noobs round;
title2 'Valeurs propres, variances expliquees';
var k lambda pctvar cumpct;
run;

%* matrice des vecteurs propres;
proc transpose data=tvectp out=vectp prefix=v;
run;

%* vecteur contenant les ecarts types;
data sigma (keep=sig);
set sigma;
array covcor{*} _numeric_;
sig=sqrt(covcor{_n_});
run;

%* Calculs concernant les individus;
%* ================================;
%* Calculs  des contributions et cos carres;
data coorindq;
if _n_ = 1 then set tlambda;
set compr (drop= &listev) nobs=nind;
array c{*}  prin1-prin&pvar;
array cosca{&q};
array cont{&q};
array l{*} &listev;
poids=poids/&spoids;
disto=uss(of c{*});
do j = 1 to &q;
       cosca{j}=c{j}*c{j}/disto;
       cont{j}=100*poids*c{j}*c{j}/l{j};
end;
contg=100*poids*disto/(sum(of l{*}));
keep ident poids prin1-prin&q contg cont1-cont&q cosca1-cosca&q ;
run;

proc print noobs round;
title2 'Coordonnees des individus contributions et cosinus carres';
var ident poids prin1-prin&q contg cont1-cont&q cosca1-cosca&q ;
run;


%* calcul des coordonnees des variables;
%* ====================================;

proc print data=vectp noobs round;
title2 'Vecteurs propres';
run;

data coordvar (drop=i lambda);
set tvectp;
set lambda (keep=lambda);
array coord{*} &listev;
do i = 1 to dim(coord);
     coord{i}=coord{i}*sqrt(lambda);
end;
run;

proc transpose out=coordvar prefix=v;
var _numeric_;
run;

proc print noobs round;
title2 'Coordonnees des variables (isométrique colonnes)';
run;

%* calcul des correlations variables x facteurs;

data covarfac (drop=i sig);
set  coordvar;
set sigma;
array coord{*} _numeric_;
do i = 1 to dim(coord);
     coord{i}=coord{i}/sig;
end;
run;

proc print noobs round;
title2 'Correlations  variables x facteurs';
var _name_ _numeric_;
run;
%mend;
