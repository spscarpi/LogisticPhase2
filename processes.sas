
*libname statement;
libname log "C:\Users\bjsul\Documents\GitHub\MSA\Fall_1_Team_Work\LogisticPhase2";

*create new factor levels for missing values;
data work.insurance_t;
	set log.insurance_t_bin;
	if cc = . then cc = 2;
	if ccpurc = . then ccpurc = 5;
	if inv = . then inv = 2;
	if hmown = . then hmown = 2;
run;

*cross-freq tables for all variables with INS;
proc freq data = work.insurance_t;
	tables ins*(_all_);
run;

*collapse bins on variables with seperation concerns;
data work.insurance_t;
	set work.insurance_t;
	if cashbk = 2 then cashbk = 1;
	if mmcred = 5 then mmcred = 3;
run;

*cross freq table for INS, cashbk and mmcred;
proc freq data = work.insurance_t;
	tables ins*(cashbk mmcred);
run;

*check correleation of mmbal_bin and mm;
proc corr data = work.insurance_t;
	var mmbal_bin mm;
run;

*get all var names;
ods trace on;
proc contents data = work.insurance_t short;
	ods output variablesshort = varnames;
run;
ods trace off;

/*
data work.test;
	set work.varnames;
	variablesmin = substr(variables, find(variables, "INS"), 3);
	call symputx("varns", variables);
run;
*/

*logistic regression on all vars.;
%let allvars = ACCTAGE_Bin AGE_Bin ATM ATMAMT_Bin BRANCH CASHBK CC CCBAL_Bin CCPURC CD CDBAL_Bin CHECKS_Bin CRSCORE_Bin DDA DDABAL_Bin DEPAMT_Bin DIRDEP HMOWN HMVAL_Bin ILS ILSBAL_Bin INAREA INCOME_Bin INV INVBAL_Bin IRA IRABAL_Bin LOC LOCBAL_Bin LORES_Bin MM MMBAL_Bin MMCRED MOVED MTG MTGBAL_Bin NSF NSFAMT_Bin PHONE_Bin POSAMT_Bin POS_Bin RES SAV SAVBAL_Bin SDB TELLER_Bin;
proc logistic data = work.insurance_t;
	class _all_;
	model ins = &allvars
		/ selection = backward slstay = 0.002 clodds = pl clparm=pl;
	ods output clparmpl = work.oddsratios;
	ods output modelanova = work.type3main;
run;

%let maineffects = ATMAMT_Bin BRANCH CC CDBal_Bin Checks_bin DDA DDABAL_BIN ILS INV IRA MM NSF SAVBAL_BIN TELLER_BIN;

*export p-values for main effects only model;
proc sort data = work.type3main out=work.type3mainsort;
	by probchisq;
run;

proc export data=work.type3mainsort
	outfile="C:\Users\bjsul\Documents\GitHub\MSA\Fall_1_Team_Work\LogisticPhase2\p-vaules_maineffects.csv" replace;
run;

*interactions effects model;
%let interactions = ATMAMT_Bin|BRANCH|CC|CDBal_Bin|Checks_bin|DDA|DDABAL_BIN|ILS|INV|IRA|MM|NSF|SAVBAL_BIN|TELLER_BIN;
ods trace on;
proc logistic data = work.insurance_t;
	class _all_;
	model ins = &maineffects &interactions @2
		/ selection = forward slentry = 0.002 clodds=pl clparm=pl;
	ods output parameterestimates = work.oddsratiosint;
	ods output modelANOVA = work.Type3;
run;
ods trace off;


*sort by p-vaule and export odds ratios for main effects + interaction effects;
proc sort data=oddsratiosint out=oddsratiosintsort;
	by probchisq;
run;

proc export data=oddsratiosintsort
	outfile="C:\Users\bjsul\Documents\GitHub\MSA\Fall_1_Team_Work\LogisticPhase2\oddsratiosint.csv" replace;
run;

*sort type3 by p-value then export for main effects + interaction effects;
proc sort data = type3 out=type3sort;
	by probchisq;
run;

proc export data=type3sort
	outfile="C:\Users\bjsul\Documents\GitHub\MSA\Fall_1_Team_Work\LogisticPhase2\type3effects-interactions.csv" replace;
run;	

*hard coded interaction variables;
data work.insurance_t;
	set work.insurance_t;
	ddairaint = dda*ira;
	mmddabalbinint = mm*ddabal_bin;
	ddabalbinsavbalbinint = DDABAL_Bin*SAVBAL_Bin;
run;

*two way frequency table for interaction effects;
proc freq data = work.insurance_t;
	tables ins*(ddairaint mmddabalbinint ddabalbinsavbalbinint);
run;


quit;
