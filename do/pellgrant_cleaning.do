***** Cleaning Data for Matching: Part II- Pell Grant Data ****

* Goal: The goal of this do-file is to clean and organize all of the data from the Department 
* of Education. Then create data sets with all of the needed information for the (at least) 4-year 
* schools in IPEDS. There will  be two versions of the completed data set. They will be differentiated 
* by the definition of minority student as indiciated by the number on the end of the saved file.

** Cleaning not automated at all. Need to look year by year to see how each is cleaned.
** Only small differences between the files each year that require manual changes. 

* Data from from 2000-2007 will come from the Department of Education while data from 
* the years 2008 and onwards will come from IPEDS. This is because data for the years
* before 2008 are not available. 

********
* 2000 *
********
import excel using "$pellgrant_data/pell-inst-2000.xls", clear

* Dropping rows that do not conatin any information
drop in 1/5
drop in 2

drop F

* Renaming first row to be variable names
foreach j in A B C D E {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring PELLID, replace
destring Recipients, replace
destring Awards, replace

rename (PELLID Institution State Recipients Awards)(pellid institutionname state num_pell2000 tot_pell_amt2000)

drop if pellid == .


duplicates tag pellid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2000.dta", replace 

********
* 2001 *
********
import excel using "$pellgrant_data/pell-inst-2001.xls", clear

* Dropping rows that do not conatin any information
drop in 1/5
drop in 2

* Renaming first row to be variable names
foreach j in A B C D E {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring PELLID, replace
destring Recipients, replace
destring Awards, replace

rename (PELLID Institution State Recipients Awards)(pellid institutionname state num_pell2001 tot_pell_amt2001)

drop if pellid == .

duplicates tag pellid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2001.dta", replace 

********
* 2002 *
********
import excel using "$pellgrant_data/pell-inst-2002.xls", clear

* Dropping rows that do not conatin any information
drop in 1/5
drop in 2


* Renaming first row to be variable names
foreach j in A B C D E {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring Recipients, replace
destring Awards, replace

rename (OPEID Institution State Recipients Awards)(oepid institutionname state num_pell2002 tot_pell_amt2002)

drop if oepid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2002.dta", replace 

********
* 2003 *
********
import excel using "$pellgrant_data/pell-inst-2003.xls", clear

* Dropping rows and columns that do not conatin any information
drop in 1/5
drop in 2
drop E 

* Renaming first row to be variable names
foreach j in A B C D F {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring PELLID, replace
destring Awards, replace
destring G, replace

rename (OPEID PELLID NAME State G Awards)(oepid pellid institutionname state num_pell2003 tot_pell_amt2003)

drop if oepid == .
drop if pellid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2003.dta", replace 

********
* 2004 *
********
import excel using "$pellgrant_data/pell-inst-2004.xls", clear

* Dropping rows and columns that do not conatin any information
drop in 1/5
drop in 2
drop E 

* Renaming first row to be variable names
foreach j in A B C D F G {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring PELLID, replace
destring Awards, replace
destring Recipients, replace

rename (OPEID PELLID Name State Recipients Awards)(oepid pellid institutionname state num_pell2004 tot_pell_amt2004)

drop if oepid == .
drop if pellid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2004.dta", replace 

********
* 2005 *
********
import excel using "$pellgrant_data/pell-inst-2005.xls", clear

* Dropping rows and columns that do not conatin any information
drop in 1/5
drop in 2
drop E 

* Renaming first row to be variable names
foreach j in A B C D F G {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring PELLID, replace
destring Awards, replace
destring Recipients, replace

rename (OPEID PELLID Name State Recipients Awards)(oepid pellid institutionname state num_pell2005 tot_pell_amt2005)

drop if oepid == .
drop if pellid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2005.dta", replace 
clear

********
* 2006 *
********
import excel using "$pellgrant_data/pell-inst-2006.xls", clear


* Dropping rows and columns that do not conatin any information
drop in 1/5
drop in 2
drop E 

* Renaming first row to be variable names
foreach j in A B C D F G {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring PELLID, replace
destring Awards, replace
destring Recipients, replace

rename (OPEID PELLID Name State Recipients Awards)(oepid pellid institutionname state num_pell2006 tot_pell_amt2006)

drop if oepid == .
drop if pellid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2006.dta", replace 

********
* 2007 *
********
import excel using "$pellgrant_data/pell-inst-2007.xls", clear

* Dropping rows and columns that do not conatin any information
drop in 1/5
drop in 2
drop D F 

* Renaming first row to be variable names
foreach j in A B C E G H {
     local try = strtoname(strtrim(`j'[1]))
     capture rename `j'  `try'
}
drop in 1

destring OPEID, replace
destring PELLID, replace
destring Awards, replace
destring Recips, replace

rename (OPEID PELLID Name State Recips Awards)(oepid pellid institutionname state num_pell2007 tot_pell_amt2007)

drop if oepid == .
drop if pellid == .

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

save "$pellgrant_data/dta/pellgrant_data_2007.dta", replace 


********************
* 2008 and Onwards *
********************
import delimited using "$ipeds_data/pellgrants_ipeds.csv", varnames(1) clear
missings dropvars _all, force

drop *0708*

local k = 2008
foreach i in 0809 0910 1011 1112 1213 1314 1415 1516 1617 1718 1819 {

foreach m in a n t {
ds *`m'sfa`i'*
local j = r(varlist)

rename `j' `m'_pell`k'
}

local k = `k' + 1
}
*

forval i = 2008(1)2018 {

rename n_pell`i' num_pell`i'
rename a_pell`i' avg_pell`i'
rename t_pell`i' tot_pell_amt`i'
}

rename opeidhd2019 oepid 
duplicates tag oepid, gen(dup)
drop if dup > 0 
drop dup

reshape long num_pell avg_pell tot_pell_amt, i(oepid) j(year)
save "$pellgrant_data/dta/pellgrant_data_2008onwards.dta", replace

*******************************
* Combining Data Across Years *
*******************************
use "$pellgrant_data/dta/pellgrant_data_2002.dta", clear
sort oepid
drop if oepid == .
merge 1:1 oepid using "$pellgrant_data/dta/pellgrant_data_2003.dta", nogen
sort pellid
drop if pellid == .
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2001.dta", nogen
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2000.dta", nogen
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2004.dta", nogen
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2005.dta", nogen
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2006.dta", nogen
merge 1:1 pellid using "$pellgrant_data/dta/pellgrant_data_2007.dta", nogen

order oepid pellid institutionname state *2001 *2002 *2003 *2004 *2005 *2006 *2007

duplicates tag oepid, gen(dup)
tab dup
drop if dup > 0
drop dup

reshape long num_pell tot_pell_amt, i(oepid) j(year)

gen avg_pell= tot_pell_amt/num_pell

append using "$pellgrant_data/dta/pellgrant_data_2008onwards.dta"

drop state pellid

sort oepid unitid year
by oepid: replace unitid = unitid[_n-1] if unitid == .

drop if unitid == .

sort unitid year
save "$dta_out/pellgrant/pellgrant_data.dta", replace
