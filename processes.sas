libname log "C:\Users\bjsul\Documents\NCSU\MSA\Fall\Logistic_Regression\Homework2_LR";

*proc print data = log.insurance_t_bin;
*run;

data work.insurance_t;
	set log.insurance_t_bin;
	if cc = . then cc = 2;
	if ccpurc = . then ccpurc = 5;
	if inv = . then inv = 2;
	if hmown = . then hmown = 2;
run;


proc freq data = work.insurance_t;
	tables ins*(_all_);
run;

data work.insurance_t;
	set work.insurance_t;
	if cashbk = 2 then cashbk = 1;
	if mmcred = 5 then mmcred = 3;
run;

proc freq data = work.insurance_t;
	tables ins*(cashbk mmcred);
run;

proc corr data = work.insurance_t;
	var mmbal_bin mm;
run;

ods trace on;
proc contents data = work.insurance_t short;
	ods output variablesshort = varnames;
run;
ods trace off;

data work.test;
	set work.varnames;
	variablesmin = substr(variables, find(variables, "INS"), 3);
	call symputx("varns", variables);
run;

*ACCTAGE_Bin AGE_Bin ATM ATMAMT_Bin BRANCH CASHBK CC CCBAL_Bin CCPURC CD CDBAL_Bin CHECKS_Bin CRSCORE_Bin DDA DDABAL_Bin DEPAMT_Bin DIRDEP HMOWN HMVAL_Bin ILS ILSBAL_Bin INAREA INCOME_Bin INV INVBAL_Bin IRA IRABAL_Bin LOC LOCBAL_Bin LORES_Bin MM MMBAL_Bin MMCRED MOVED MTG MTGBAL_Bin NSF NSFAMT_Bin PHONE_Bin POSAMT_Bin POS_Bin RES SAV SAVBAL_Bin SDB TELLER_Bin ;
proc logistic data = work.insurance_t;
	class _CHAR_;
	model ins = ACCTAGE_Bin AGE_Bin ATM ATMAMT_Bin BRANCH CASHBK CC CCBAL_Bin CCPURC CD CDBAL_Bin CHECKS_Bin CRSCORE_Bin DDA DDABAL_Bin DEPAMT_Bin DIRDEP HMOWN HMVAL_Bin ILS ILSBAL_Bin INAREA INCOME_Bin INV INVBAL_Bin IRA IRABAL_Bin LOC LOCBAL_Bin LORES_Bin MM MMBAL_Bin MMCRED MOVED MTG MTGBAL_Bin NSF NSFAMT_Bin PHONE_Bin POSAMT_Bin POS_Bin RES SAV SAVBAL_Bin SDB TELLER_Bin
		/ selection = backward slstay = 0.002 clodds = pl clparm=pl;
run;


quit;
