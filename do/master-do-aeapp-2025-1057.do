***** Master Do File - Test Optional Project *****

*** Preliminaries ***
clear all 
set more off

* Set Working Directory
* [stats.camp replication] The author's absolute path
* "/Volumes/T7_Shield/Research/RemoveSATACT/AERPandP" is replaced by the
* directory this file is run from, i.e. the repository root. See README.md.
global root "`c(pwd)'"
cd "${root}/data/rif"

* Globals 

global data "${root}/data"
global dofiles "${root}/do"
global dta_out "${root}/data/dta_out"
global tables "${root}/tables"
global ipeds_data "${data}/ipeds_data"
global pellgrant_data "${data}/pell_grant"

*** Create log file
capture log close
log using "${root}/aeapp_2025_1057_BF_03032025.log", replace

* Erase Past Output
capture erase "${tables}/table1.csv"
capture erase "${tables}/table2.csv"
capture erase "${tables}/table3.csv"

*** Install Necessary Packages ****
do "${dofiles}/setup.do" 

**** Step (I): Data Cleaning ****
* IPEDS data
do "${dofiles}/ipeds_cleaning.do" 

* Pell Grant data
do "${dofiles}/pellgrant_cleaning.do" 

* Combine Cleaned Data and Create Sample
do "${dofiles}/combine_clean_data.do" 

**** Step (II): Analysis ****
do "${dofiles}/aeapp-2025-1057-analysis.do" 

*** End
log close
translate "${root}/aeapp_2025_1057_BF_03032025.log" "${root}/aeapp_2025_1057_BF_03032025.pdf", replace
clear
