**** Combine IPEDS, DOE and College Board Data ****

***********************************
* Step (1): Bring in All the Data *
***********************************
****************** IPEDS Data ******************
use "$dta_out/ipeds/num_apply.dta", clear
rename num_apply num_app

sort unitid year
merge m:1 unitid using "$dta_out/ipeds/inst_char.dta", nogen
merge m:1 unitid using "$dta_out/ipeds/selectivity.dta", nogen

foreach var in first_full_time_enrolled full_time_enrolled num_grad_6yrs cohort_grad_6yrs ret_rate num_first_full_inst_aid perc_first_full_inst_aid avg_amt_inst_aid_first_full pub_tuit applic_fees exp_acad_serv min_new_hire loans hisp_enroll black_enroll nat_amer_enroll total_enroll {

	merge 1:1 unitid year using "$dta_out/ipeds/`var'.dta", nogen keep(1 3)
}
*

****************** DOE Data ******************
sort unitid year
merge 1:1 unitid year using "$dta_out/pellgrant/pellgrant_data.dta", nogen keep(1 3)

** Generating Variables of Interest
gen grad_rate_6yrs = (num_grad_6yrs/cohort_grad_6yrs)*100
gen fftme = bkaat + aiant + hispt

* Generating Percent Minority Enrollment and Percent Pell Grant Enrollment
gen perc_min = (fftme/first_full_time_enrolled) * 100
gen perc_pell = (num_pell/total_enroll) * 100

* There are some school-year observations where the perc_pell > 100. This makes no sense
* and it isn't an issue of the variables used to indicate total-enrollment. I will simply drop those schools
bysort unitid: egen aux = total(perc_pell > 100 & perc_pell != .)
tab aux
drop if aux > 0
drop aux

sort unitid year
by unitid: gen fte2001 = full_time_enroll if year == 2001
by unitid: replace fte2001 = fte2001[1] if missing(fte2001)

** Creating Logged Variables 
foreach i in num_pell first_full_time_enrolled fftme pub_tuit num_first_full_inst_aid full_time_enrolled {

	gen log_`i' = log(`i')
}
*

* Adjusting Average Institutional Aid and Tuition for inflation (2010 dollars)
sort year
merge m:1 year using "$data/cpi.dta"

, nogen

gen cpi2010 = .
replace cpi2010 = cpi if year == 2010
sort unitid cpi2010 year

replace cpi2010 = cpi2010[_n-1] if cpi2010 == .

foreach var of varlist pub_tuit avg_pell applic_fees exp_acad_serv aloan {

gen `var'_rel2010 = (`var'*cpi)/cpi2010

}
rename pub_tuit_rel2010 pub_tuition_rel2010

gen avg_inst_aid_rel2010 = (avg_amt_inst_aid_first_full*cpi)/cpi2010


** Creating Treatment Variables 
merge m:1 unitid using "${data}/test_op_timeline.dta", keep(1 3) nogen

* Notes: 1 test-optional school did not merge because I did not have IPEDS data for them
drop if aux == "1"
drop aux

* (i) Year from Adoption
gen time_adopt = year - adopt_year 

* (ii) Indicator for Treated Years
gen treated = 0 
replace treated = 1 if time_adopt >= 0 & time_adopt != .

* (iii) Ever-treated indicator
sort unitid
by unitid: egen total_ = total(treated > 0)
gen ever_treat = 0 
replace ever_treat = 1 if total_ > 0
drop total_

* (iv) Post x Treated Indicator
gen post_x_treated = 0
replace post_x_treated = 1 if treated == 1 & time_adopt >= 0

*********************************
* Step (2): Sample Restrictions *
*********************************
drop if statefips == .

sort unitid
by unitid: egen miss_numapp = total(num_app == .)
by unitid: egen miss_minenroll = total(fftme == .) 
by unitid: egen miss_tuit = total(pub_tuit == .)
by unitid: egen miss_enroll = total(first_full_time_enroll == .)

drop if miss_minenroll > 1 
drop if miss_numapp > 1
drop if miss_tuit > 1
drop if miss_enroll > 1
drop miss* 

* Note: Only want to keep "selective" schools
keep if selectivity == 2 | selectivity == 3
keep if inst_type == 1 | inst_type == 3 | inst_type == 4

drop if unitid == .
drop if year > 2018

* Don't want to keep schools with previous test-optional policies
drop if institutionname == "Bowdoin College" | institutionname == "Bates College" | institutionname == "Hampshire College" | institutionname == "College of the Atlantic" | institutionname == "St. John's College" | institutionname == "Sterling College" | institutionname == "Lewis & Clark College" | institutionname == "Wheaton College" | institutionname == "Lafayette College" | institutionname == "Dickinson College" | institutionname == "Hartwick College" | institutionname == "Muhlenberg College" | institutionname == "Mount Holyoke College" | institutionname == "Ursinus College" | institutionname == "Utica College" | institutionname == "Dowling College" | institutionname == "Pitzer College" | unitid == 216278 | unitid == 2125770 | unitid == 189088

* Bard College at Simon's Rock is an Early College
drop if unitid == 167792

****************************************
* Step (3): Variable labels and values *
****************************************
foreach var of varlist religious_aff inst_type selectivity statefips {

preserve
import delim using "$data/ipeds_data/varlabels/`var'_varlabel.csv", varn(1) clear

drop variablename 
gen variablename = "`var'"

// define the labels
qui count
local n `r(N)'

forvalues i = 1/`n' {
    la def `var' `=value[`i']' "`=valuelabel[`i']'", replace
}
*

// save value labels in a temporary do-file with the -label- command
tempfile vlbl
label save using `vlbl', replace

restore

do `vlbl'

// assign value labels to variables
la val `var' `var'

}
*

label var unitid "IPEDS idenitication Variable"
label var year "Academic Year"
label var statefips "State-level FIPS Code"
label var institutionname "Institution Name"
label var num_app "Applications Total"
label var religious_aff "Religious Affiliation"
label var inst_type "Institutional control or affiliation"
label var selectivity "2002 Selectivity Measure"
label var fftme "(Minority) Full-time students, Undergraduate, Degree/certificate-seeking, First-time"
label var full_time_enrolled "All students, Undergraduate, Degree/certificate-seeking total, full-time"
label var num_grad_6yrs "4-year institutions, Completers within 150% of normal time"
label var cohort_grad_6yrs "4-year institutions, Adjusted cohort (revised cohort minus exclusions)"

rename retentionrate ret_rate
label var ret_rate "Full-time retention rate"
label var num_first_full_inst_aid "Number of full-time first-time undergraduates receiving institutional grant aid"
label var perc_first_full_inst_aid "Percent of full-time first-time undergraduates receiving institutional grant aid"
label var avg_amt_inst_aid_first_full "Average amount of institutional grant aid awarded to full-time first-time undergraduates"
label var pub_tuit "Published in-state tuition and fees"
label var first_full_time_enrolled "All students, Undergraduate, Degree/certificate-seeking, First-time, Full-time"
label var num_pell "Number of undergraduate students awarded Pell grants"
label var tot_pell_amt "Total amount of Pell grant aid awarded to undergraduate students"
label var avg_pell "Average amount Pell grant aid awarded to undergraduate students"
label var adopt_year "Year School Adopted a Test-Optional Policy"
label var time_adopt "Number of years since school adopted test-optional policy"
label var treated "Indicator that = 1 in years school have test-optional policy in place"
label var ever_treat "Indicator if school ever adopts a test-optional policy"
label var grad_rate_6yrs "6-year Graduation rate - bachelor's degree within 150% of normal time"
label var exp_acad_serv "Academic Support: Total Amount"
label var applic_fees "Application fee for Undergraduates"
label var bkaat "Full-Time, First-Time Black Total Enrollment"
label var bkaam "Full-Time, First-Time Black Men Enrollment"
label var bkaaw "Full-Time, First-Time Black Women Enrollment"
label var hispt "Full-Time, First-Time Hispanic Total Enrollment"
label var hispw "Full-Time, First-Time Hispanic Women Enrollment"
label var hispm "Full-Time, First-Time Hispanic Men Enrollment"
label var aiant "Full-Time, First-Time American Indian/Native Alaskan Total Enrollment"
label var aianm "Full-Time, First-Time American Indian/Native Alaskan Men Enrollment"
label var aianw "Full-Time, First-Time American Indian/Native Alaskan Women Enrollment"
label var min_new_hire "New Black, Hispanic, and  Native American Faculty and Staff Hired"
label var perc_min "Percent FTFT Enrollment - BNH"
label var perc_pell "Percent of Students Receiving a Pell Grant"
label var fte2001 "Full-Time Enrollment in 2001"
label var log_num_pell "Log(# of Students Receiving a Pell Grant)"
label var log_fftme "Log(FTFT Enrollment - BNH)"
label var log_num_first_full_inst_aid "Log(# of FTFT Receiving Inst. Aid)"
label var pub_tuition_rel2010 "Published in-state tuition and fees in 2010 $"
label var exp_acad_serv_rel2010 "Academic Support: Total Amount in 2010 $"
label var applic_fees_rel2010 "Application fee for Undergraduates in 2010 $"
label var avg_pell_rel2010 "Average amount Pell grant aid awarded to undergraduate students in 2010 $"
label var avg_inst_aid_rel2010 "Average amount of institutional grant aid awarded to FTFT in 2010 $"
label var min_new_hire "New Black, Hispanic, and  Native American Faculty and Staff Hired"

label var nloan "Number of full-time first-time undergraduates awarded student loans"
label var aloan "Average amount of student loan aid received"
label var ploan "% of full-time first-time undergraduates awarded student loans"
label var total_enroll "Total # of Students Enrolled"
label var oepid "OEPID Number"
label var grad_rate_6yrs "6-year Graduation rate - bachelor's degree within 150% of normal time"
label var log_first_full_time_enrolled "Log(FTFT Enrollment)"
label var log_pub_tuit "Log(Published In-State Tuition)"
label var cpi "CPI in given Year"
label var cpi2010 "CPI in 2010"
label var applic_fees_rel2010 "Application fee for Undergraduates in 2010 $"
label var aloan_rel2010 "Average amount of student loan aid received in 2010 $"
label var post_x_treated "Post x Treated Indicator"

sort unitid year
order unitid year statefips institutionname religious_aff inst_type selectivity adopt_year-ever_treat

* Have to shorten variable names
rename first_full_time_enrolled ffte
rename log_first_full_time_enrolled lffte

rename log_fftme lfftme

rename num_first_full_inst_aid nffia
rename log_num_first_full_inst_aid lnffia

rename full_time_enrolled fte
rename log_full_time_enrolled lfte

rename grad_rate_6yr gr6

rename avg_inst_aid_rel2010 aiar2010

rename nloan nlff
rename aloan_rel2010 alr2010
rename avg_pell_rel2010 apr2010

rename applic_fees_rel2010 afr2010
rename exp_acad_serv_rel2010 easr2010

* Dropping Art and Music Schools
drop if strpos(institutionname, "Art") > 0
drop if strpos(institutionname, "Music") > 0
drop if unitid == 192110

drop if ever_treat == 1 & (adopt_year > 2014 | adopt_year < 2005)
save "${dta_out}/clean_school_nonbalanced_final_evertreat.dta", replace

