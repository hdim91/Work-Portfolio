libname hire "D:\work\4181\hire_compile";
/*
filename target "D:\work\4181\hire_compile\compile201502.txt" encoding='utf-8';
filename fromzip zip "D:\work\4181\aa10\2015-02\aa10.txt.gz" gzip;
data _null_;
	infile fromzip;
	file target;
	input;
	put _infile_;
run;
*/
filename fromzip zip "D:\work\4181\aa10\aa10.txt.gz" gzip;
data hire.empdata;
	infile fromzip;
	input upchecd $6. inwon_yyyymm $8. inwon_gubun $2.  inwon_quarter $1. wage $8. inwon $7.;
run;
/*
data hire.emp201502;
	infile "D:\work\4181\hire_compile\compile201502.txt" dlm="";
	input upchecd :$6. inwon_yyyymm :$8. inwon_gubun :$2.  inwon_quarter :$1. wage :$8. inwon :$7.;
run;
*/
