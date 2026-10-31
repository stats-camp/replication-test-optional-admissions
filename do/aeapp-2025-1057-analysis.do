*** AEA:P&P-2025-1057 Analysis

* Preliminaries
estimates clear

* [stats.camp replication] Run on its own rather than from the master, the
* folders are set from the working directory, the repository root.
if "${root}" == "" {
	global root "`c(pwd)'"
	global data "${root}/data"
	global dta_out "${root}/data/dta_out"
	global tables "${root}/tables"
}

cd "${root}/data/rif"

* Load in Final Data Set
* [stats.camp replication] Without the preparation pipeline's output, use the
* deposited panel (`_apr2022`).
capture use "$dta_out/clean_school_nonbalanced_final_evertreat.dta", clear
if _rc use "$dta_out/clean_school_nonbalanced_final_evertreat_apr2022.dta", clear
replace adopt_year = 0 if adopt_year == .

* Generating Baseline Controls
foreach var in perc_min pub_tuition_rel2010 perc_pell gr6 {
	bys unitid: gen b_`var' = `var' if year == 2001
	bys unitid: egen minb_`var' = min(b_`var')
	bys unitid: replace b_`var' = minb_`var' if missing(b_`var')
	drop minb_`var'
}


* Table 1: Effects of Test-Optional Policies on Enrollment and Academic Performance
foreach var of varlist perc_min perc_pell ret_rate gr6 {
cd "${root}/data/rif"

* CS Estimation - Covariates 
qui csdid `var' fte2001 b_perc_min b_pub_tuition_rel2010 b_perc_pell b_gr6, method(dripw) ivar(unitid) time(year) gvar(adopt_year) saverif(rif_`var') replace

preserve
use "$data/rif/rif_`var'", clear
csdid_stats simple, wboot estore(`var')
restore

count if `var' != .
estadd scalar n1 = round(r(N), 1)

qui sum `var' if time_adopt == -1, d 
estadd scalar n2 = round(r(mean),0.01)

}


** Main Table 
esttab perc_min perc_pell ret_rate gr6 using "${tables}/table1.csv", noobs mtitle("FTFT BAH" "Pell Grant Recipients" "Retention Rate" "Six-Year Graduation Rate") cells(b(star fmt(2)) se(par fmt(2))) starlevels(* 0.1 ** 0.05 *** 0.01) replace

* Table 2: Effects of Test-Optional Policies on Financial Aid
foreach var of varlist perc_first_full_inst_aid aiar2010 ploan alr2010 {
cd "${root}/data/rif"

* CS Estimation - Covariates 
qui csdid `var' fte2001 b_perc_min b_pub_tuition_rel2010 b_perc_pell b_gr6, method(dripw) ivar(unitid) time(year) gvar(adopt_year) saverif(rif_`var') replace

preserve
use "$data/rif/rif_`var'", clear
csdid_stats simple, wboot estore(`var')
restore

count if `var' != .
estadd scalar n1 = round(r(N), 1)

qui sum `var' if time_adopt == -1, d 
estadd scalar n2 = round(r(mean),0.01)

}


** Main Table 
esttab perc_first_full_inst_aid aiar2010 ploan alr2010 using "${tables}/table2.csv", noobs mtitle("Share FTFT Receiving Inst. Aid" "Avg. Amount FTFT Inst. Aid" "Share FTFT Taking a Loan" "Avg. Amount FTFT Taking a Loan") cells(b(star fmt(2)) se(par fmt(2))) starlevels(* 0.1 ** 0.05 *** 0.01) replace

* Table 3: Other Possible Policy Interventions
foreach var of varlist afr2010 easr2010 min_new_hire {
cd "${root}/data/rif"

* CS Estimation - Covariates 
qui csdid `var' fte2001 b_perc_min b_pub_tuition_rel2010 b_perc_pell b_gr6, method(dripw) ivar(unitid) time(year) gvar(adopt_year) saverif(rif_`var') replace

preserve
use "$data/rif/rif_`var'", clear
csdid_stats simple, wboot estore(`var')
restore

count if `var' != .
estadd scalar n1 = round(r(N), 1)

qui sum `var' if time_adopt == -1, d 
estadd scalar n2 = round(r(mean),0.01)

}

** Main Table 
esttab afr2010 easr2010 min_new_hire using "${tables}/table3.csv", noobs mtitle("Application Fees" "Academic Services Exp." "# of BAH New Hires") cells(b(star fmt(2)) se(par fmt(2))) starlevels(* 0.1 ** 0.05 *** 0.01) replace








