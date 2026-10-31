***** Cleaning Data for Estimation: Part I- IPEDS Data ****

* Goal: The goal of this do-file is to clean and organize all of the data from IPEDS.
* Then create data sets with all of the needed information for the (at least) 4-year schools in IPEDS. 
* There will be two versions of the completed data set. Schools included will be those that serve first-time,
* full-time students, offer at least a Bachelor's degree, are Title IV participating and are located in the US.

// ssc install missings

* I categorize  all students that fall into the following categories as minority: 
* (1) Black or African American
* (2) Hispanic
* (3) Native American/ Alaskan Native

* Pell Grant Data Cleaning is extensive and placed in a different do-file saved as 
* pell_grant_cleaning found in the do-file folder

*********************************************
* Part A: Variable that need no adjustments *
*********************************************

***** Variables of Interest ******
* (1) num apply
* (2) pub_tuit- published in-state tuition and fees in an academic year
* (2) first_full_time_enrolled - All students, Undergraduate, Degree/certificate-seeking, First-time, Full-time
* (3) applic_fees - Application fee for Undergraduates
* (4) full-time-enrolled
* (5) total enrolled

foreach yvar in num_apply pub_tuit first_full_time_enrolled applic_fees full_time_enrolled {
import delimited using "${ipeds_data}/`yvar'.csv", varnames(1) clear

missings dropvars _all, force

forval i = 2001(1)2018 {
ds *`i'*
local j = r(varlist)
rename `j' `yvar'`i'
}
*

reshape long `yvar', i(unitid) j(year)
save "${dta_out}/ipeds/`yvar'.dta", replace
}

import delimited using "$ipeds_data/total_enroll.csv", varnames(1) clear

missings dropvars _all, force

forval i = 2002(1)2019 {
ds *`i'*
local j = r(varlist)
local k = `i' - 1
rename `j' total_enroll`k'
}
*
reshape long total_enroll, i(unitid) j(year)
save "$dta_out/ipeds/total_enroll.dta", replace

* (4) num_first_full_inst_aid- Number of full-time first-time undergraduates receiving institutional grant aid
* (5) perc_first_full_inst_aid- Percent of full-time first-time undergraduates receiving institutional grant aid
* (6) avg_amt_inst_aid_first_full - Average amount of institutional grant aid awarded to full-time first-time undergraduates
* (7) num_loan_first_full - Number of full-time first-time undergraduates awarded student loans
* (8) avg_loan_first_full - Average amount of student loans awrded to full-time, first-time undergraduates

foreach yvar in num_first_full_inst_aid perc_first_full_inst_aid avg_amt_inst_aid_first_full total_rev {
local k = 2001

import delimited using "${ipeds_data}/`yvar'.csv", varnames(1) clear

missings dropvars _all, force

foreach i in 0102 0203 0304 0405 0506 0607 0708 0809 0910 1011 1112 ///
1213 1314 1415 1516 1617 1718 1819 {

ds *`i'*
local j = r(varlist)

rename `j' `yvar'`k'

local k = `k' + 1
}
*

reshape long `yvar', i(unitid) j(year)
save "${dta_out}/ipeds/`yvar'.dta", replace
}
*

import delimited using "$ipeds_data/loan_data.csv", varnames(1) clear
local k = 2001
missings dropvars _all, force

foreach i in 0102 0203 0304 0405 0506 0607 0708 0809 0910 1011 1112 ///
1213 1314 1415 1516 1617 1718 1819 {
foreach m in n p a {
ds *`m'sfa`i'*
local j = r(varlist)

rename `j' `m'loan`k'

}

local k = `k' + 1
}
*

reshape long nloan ploan aloan, i(unitid) j(year)
save "$dta_out/ipeds/loans.dta", replace

******************************************
* Part B: Variable that need adjustments *
******************************************
* Note: Need adjustments because data does not cover all years or need to assign values
* to the relevant cohorts

***** Variables of Interest ******
* (1) ret_rate- Full-time retention rate (subtract 1 to get relevant cohort) only 2003-2019
import delimited using "${ipeds_data}/retention-rates.csv", varnames(1) clear

missings dropvars _all, force

forval i = 2003(1)2020 {
ds *`i'*
local j = r(varlist)
local k = `i' - 1
rename `j' retentionrate`k'
}


keep unitid institutionname *retentionrate*
reshape long retentionrate, i(unitid) j(year)
label var retentionrate "Retention Rate for Cohort Entering in Corresponding Year"
save "$dta_out/ipeds/ret_rate.dta", replace

* (2) num_grad_6yrs- 4-year institutions, Completers within 150% of normal time (subtract by 6 to get relevant cohort)
* (3) cohort_grad_6yrs- 4-year institutions, Adjusted cohort (revised cohort minus exclusions)

import delimited using "$ipeds_data/cohort_grad_6yrs.csv", varnames(1) clear
missings dropvars _all, force

forval i = 2007(1)2022 {
ds *`i'*
local j = r(varlist)
local k = `i' - 6
rename `j' cohort_grad_6yrs`k'
}
*

reshape long cohort_grad_6yrs, i(unitid) j(year)
save "$dta_out/ipeds/cohort_grad_6yrs.dta", replace

*

import delimited using "$ipeds_data/num_grad_6yrs.csv", varnames(1) clear

missings dropvars _all, force

forval i = 2007(1)2022 {
ds *`i'*
local j = r(varlist)
local k = `i' - 6
rename `j' num_grad_6yrs`k'
}
*

reshape long num_grad_6yrs, i(unitid) j(year)
save "$dta_out/ipeds/num_grad_6yrs.dta", replace

*************************
* Part C: Minority Hire *
*************************
***** Variables of interest *****
* (1) min_new_hire - (Minority) New hires, Instruction/research/public service total
foreach yvar in min_new_hire {
import delimited using "$ipeds_data/`yvar'.csv", varnames(1) clear

missings dropvars _all, force

forval i = 2001(1)2018 {
ds *`i'*
local j = r(varlist)
egen `yvar'`i' = rowtotal(`j'), missing
}
*


keep unitid institutionname *`yvar'*

reshape long `yvar', i(unitid) j(year)
save "$dta_out/ipeds/`yvar'.dta", replace
}

***************************************
* Part D: Institution Characteristics *
***************************************

***** Variables of interest *****
* statefips
* religious_aff
* inst_type

import delimited using "$ipeds_data/inst_char.csv", varnames(1) clear

missings dropvars _all, force

rename (fipsfa2001hd relaffilic2001 cntlaffiic2001)(statefips religious_aff inst_type)

save "$dta_out/ipeds/inst_char.dta", replace

***** Variables of interest *****
* selectivity
import delimited using "$ipeds_data/selectivity.csv", varnames(1) clear

missings dropvars _all, force

rename selectv2dvpricesfa2002 selectivity

save "$dta_out/ipeds/selectivity.dta", replace

*******************************
* Part E: School Expenditures *
*******************************

***** Variables of interest *****
* exp_acad_serv- Academic Support: Total Amount

foreach yvar in exp_acad_serv {
local k = 2002

import delimited using "$ipeds_data/`yvar'.csv", varnames(1) clear

missings dropvars _all, force

foreach i in 0203 0304 0405 0506 0607 0708 0809 0910 1011 1112 ///
1213 1314 1415 1516 1617 1718 1819 {
ds *`i'*
local j = r(varlist)
egen `yvar'`k' = rowtotal(`j'), missing

local k = `k' + 1
}
*

keep unitid institutionname exp_*

reshape long `yvar', i(unitid) j(year)

replace  `yvar' = `yvar'/1000000
save "$dta_out/ipeds/`yvar'.dta", replace
}



*********************************
* Race and Enrollment by Gender *
*********************************
*** Black Enrollment: Total, Men and Women ***
import delimited using "$ipeds_data/black_enroll.csv", varnames(1) clear
missings dropvars _all, force

foreach x in bkaat bkaam bkaaw {
ds *`x'*
local j = r(varlist)

local i = 2018
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

foreach x in dvefbkte dvefbkme dvefbkwe  {
ds *`x'*
local j = r(varlist)

local i = 2009
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename dvefbkte* bkaat*
rename dvefbkme* bkaam*
rename dvefbkwe* bkaaw*

foreach x in race03 race04 race18 {
ds *`x'*
local j = r(varlist)

local i = 2007
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename race18* bkaat*
rename race03* bkaam*
rename race04* bkaaw*

reshape long bkaat bkaam bkaaw, i(unitid) j(year)
save "$dta_out/ipeds/black_enroll.dta", replace

*** Hispanic Enrollment: Total, Men and Women ***
import delimited using "$ipeds_data/hisp_enroll.csv", varnames(1) clear
missings dropvars _all, force

foreach x in hispm hispw hispt {
ds *`x'*
local j = r(varlist)

local i = 2018
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

foreach x in dvefhsme dvefhswe dvefhste  {
ds *`x'*
local j = r(varlist)

local i = 2009
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename dvefhsme* hispm*
rename dvefhswe* hispw*
rename dvefhste* hispt*

foreach x in race09 race10 race21 {
ds *`x'*
local j = r(varlist)

local i = 2007
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename race21* hispt*
rename race09* hispm*
rename race10* hispw*

reshape long hispt hispm hispw, i(unitid) j(year)
save "$dta_out/ipeds/hisp_enroll.dta", replace

*** Native American Enrollment: Total, Men and Women ***
import delimited using "$ipeds_data/nat_amer_enroll.csv", varnames(1) clear
missings dropvars _all, force

foreach x in aiant aianm aianw {
ds *`x'*
local j = r(varlist)

local i = 2018
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

foreach x in dvefaime dvefaite dvefaiwe  {
ds *`x'*
local j = r(varlist)

local i = 2009
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename dvefaime* aianm*
rename dvefaiwe* aianw*
rename dvefaite* aiant*

foreach x in race05 race06 race19 {
ds *`x'*
local j = r(varlist)

local i = 2007
foreach var in `j' {
rename `var' `x'`i'

local i = `i' - 1
}
}

rename race05* aianm*
rename race06* aianw*
rename race19* aiant*

reshape long aianm aianw aiant, i(unitid) j(year)
save "$dta_out/ipeds/nat_amer_enroll.dta", replace
