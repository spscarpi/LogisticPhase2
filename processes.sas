
*libname statement;
libname log "C:\Users\bjsul\Documents\NCSU\MSA\Fall\Logistic_Regression\Homework2_LR";

*proc print data = log.insurance_t_bin;
*run;

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

*check correleatino of mmbal_bin and mm;
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

*logistic regression on all vars.  
*ACCTAGE_Bin AGE_Bin ATM ATMAMT_Bin BRANCH CASHBK CC CCBAL_Bin CCPURC CD CDBAL_Bin CHECKS_Bin CRSCORE_Bin DDA DDABAL_Bin DEPAMT_Bin DIRDEP HMOWN HMVAL_Bin ILS ILSBAL_Bin INAREA INCOME_Bin INV INVBAL_Bin IRA IRABAL_Bin LOC LOCBAL_Bin LORES_Bin MM MMBAL_Bin MMCRED MOVED MTG MTGBAL_Bin NSF NSFAMT_Bin PHONE_Bin POSAMT_Bin POS_Bin RES SAV SAVBAL_Bin SDB TELLER_Bin ;
proc logistic data = work.insurance_t;
	class _CHAR_;
	model ins = ACCTAGE_Bin AGE_Bin ATM ATMAMT_Bin BRANCH CASHBK CC CCBAL_Bin CCPURC CD CDBAL_Bin CHECKS_Bin CRSCORE_Bin DDA DDABAL_Bin DEPAMT_Bin DIRDEP HMOWN HMVAL_Bin ILS ILSBAL_Bin INAREA INCOME_Bin INV INVBAL_Bin IRA IRABAL_Bin LOC LOCBAL_Bin LORES_Bin MM MMBAL_Bin MMCRED MOVED MTG MTGBAL_Bin NSF NSFAMT_Bin PHONE_Bin POSAMT_Bin POS_Bin RES SAV SAVBAL_Bin SDB TELLER_Bin
		/ selection = backward slstay = 0.002 clodds = pl clparm=pl;
run;


%let maineffects = SAVBAL_BIN SAV MTGBAL_BIN NSF MM IRA INV ILS DDABAL_BIN DDA ATM ATMAMT_BIN BRANCH CC CDBAL_BIN CHECKS_BIN TELLER_BIN SAVBAL_BIN|SAV|MTGBAL_BIN|NSF|MM|IRA|INV|ILS|DDABAL_BIN|DDA|ATM|ATMAMT_BIN|BRANCH|CC|CDBAL_BIN|CHECKS_BIN|TELLER_BIN;;
ods trace on;
proc logistic data = work.insurance_t;
	class _CHAR_;
	model ins = &maineffects @2
		/ selection = forward slentry = 0.002 clodds=pl clparm=pl include=17;
	ods output clparmpl = work.oddsratios;
run;
ods trace off;

*hard coded interaction variables;
data log.insurance_t_bin;
	set log.insurance_t_bin;
	savbalddabalint = savbal_bin*ddabal_bin;
	savbalddaint = savbal_bin*dda;
	iraddaint = ira*dda;
	savbalchecksint = savbal_bin*checks_bin;
run;

*two way frequency table for interaction effects;
proc freq data = log.insurance_t_bin;
	tables ins*(savbalddabalint savbalddaint iraddaint savbalchecksint);
run;


quit;
