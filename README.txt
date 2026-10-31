Package documentation adapted for stats.camp.

Overview
The code in this replication package constructs the analysis file from four data sources Integrated
Postsecondary Education Data System (IPEDS), 2024; Office of Postsecondary Education (OPE), 2024;
FairTest, 2020 and Bennett, 2021 using the supplied analysis scripts. Five main files run all the code to generate the data for the
three tables in the paper. The replicator should expect the code to run for less than 1 hour.

Data Availability and Provenance Statements
The data that support the findings of this study are openly available from the Integrated
Postsecondary Education Data System through the custom data files (https://nces.ed.gov/ipeds/use-
the-data), the Office of Postsecondary Education through the program data
(https://www.ed.gov/ope-program-data) and FairTest (https://fairtest.org/). We collected data on
the consumer price index from the Federal Reserve Bank of Minneapolis
(https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price- index-
1913-).
Statement about Rights
I certify that the author of the manuscript has legitimate access to and permission to use the data used in
this manuscript including the use within this replication package.
Summary of Availability
All data are publicly available.
Details on each Data Source
 Data Source           Data Files                                 Location                Citation
 “Integrated           applic_fees.csv                            data/ipeds_data         IPEDS (2024)
 Postsecondary         avg_amt_inst_aid_first_full.csv
 Education Data        avg_loan_first_full.csv
 System”               black_enroll.csv
                       cohort_grad_6yrs.csv
                       exp_acad_serv.csv
                       first_full_time_enrolled.csv
                       first_full_time_min_enroll.csv
                       full_time_enrolled.csv
                       hisp_enroll.csv
                       inst_char.csv
                       min_new_hire.csv
                       nat_amer_enroll.csv
                       num_apply.csv
                       num_first_full_inst_aid.csv
                       num_grad_6yrs.csv
                       num_loan_first_full.csv
                       pellgrants_ipeds.csv
                       perc_first_full_inst_aid.csv
                       pub_tuit.csv
                       retention-rates.csv
                       school_county.csv
                       school_selectivity.xlsx
                       selectivity.csv

                           total_enroll.csv
                           total_rev.csv

“Office of                 pell-inst-1999.xls                       data/pell_grant         OPE (2024)
Postsecondary              pell-inst-2000.xls
Education”                 pell-inst-2001.xls
                           pell-inst-2002.xls
                           pell-inst-2003.xls
                           pell-inst-2004.xls
                           pell-inst-2005.xls
                           pell-inst-2006.xls
                           pell-inst-2007.xls
FairTest (2020) and        test_optional_timeline.dta               data/                   FairTest(2020)
Bennett (2021)                                                                              and
                                                                                            Bennett(2021)
Federal Reserve Bank       cpi.dta                                  data/                   FRBM(2024)
of Minneapolis

Dataset list
Data files                                                              Source             Notes
data/dta_out/ipeds                                                      IPEDS              Cleaned IPEDS
                                                                                           data separated by
                                                                                           variable
data/dta_out/pellgrants                                                 OPE                Cleaned OPE data
                                                                                           combined across
                                                                                           years
data/dta_out/clean_school_nonbalanced_final_evertreat.dta               All Listed         Combined data
                                                                                           used as input for
                                                                                           all tables

Computational requirements
Software Requirements
 •       stats.camp for the .do analysis files
           –    csdid
           –    missings
           –    estout

 Memory, Runtime, Storage Requirements
 Summary

     •     Approximate time needed to reproduce the analyses on a standard (2025) desktop machine: Less than 10
           minutes

     •     Approximate storage space needed: Less than 2 GB

      •     The code was las run on a MacOS laptop version 15.3.2


Description of programs/code
There are five .do files in the do/ folder that will clean all datasets and run the analysis to produce all of
the output in the paper.
  •       master-do-aeapp-2025-1057.do will run all .do files.
  •       setup.do will install all dependencies locally and should be run once.

  •       ipeds_cleaning.do will clean and reformat all referenced IPEDS data.
  •       pellgrant_cleaning.do will clean and reformat all referenced OPE data.
  •       combine_clean_data.do will combine all data sources to create the analysis sample.
  •       aeapp-2025-1057-analysis.do will generate all tables in the main body of the article.


Instructions to Replicators
  •       Open the repository in stats.camp and use the repository root as the working directory.
  •       Run do/aeapp-2025-1057-analysis.do to use the deposited cleaned analysis panel.
          The repository README describes dependency support and full-pipeline limitations.
  •       Download the data files referenced above. Each should be stored in the prepared
          subdirectories of data/, in the format that you download them in.
  •       The master do-file runs all preparation and analysis steps in sequence.
          Use a separate writable copy when rebuilding data or replacing reference outputs.

Details
The master sets paths from the repository root. The analysis can also run on its
own in stats.camp and uses the deposited cleaned panel when the rebuilt panel is
absent. Influence-function files are written to data/rif. See README.md for the
local path adaptations and the deposited-data inconsistencies.

List of tables and programs
The provided code reproduces all tables in the paper.


  Figure/Table # Program                                      Line Number                  Output file
  Table 1        aeapp-2025-1057-analysis.do                  43                           table1.csv

  Table 2                 aeapp-2025-1057-analysis.do         67                           table2.csv

  Table 3                 aeapp-2025-1057-analysis.do         90                           table3.csv

References
Bennett, Christopher. 2021. “Untested Admissions: Examining Changes in Application
Behaviors and Student Demographics Under Test-Optional Policies.” American Educational
Research Journal 59(1): 180-216.
FairTest. 2020. “Test-Optional Growth Chronology 2005-2020.”
Federal Reserve Bank of Minneapolis (FRBM). 2025. “Consumer Price Index, 1913-”. Retrieved
from https://www.minneapolisfed.org/about-us/monetary-policy/inflation-
calculator/consumer- price-index-1913-.
U.S. Department of Education, National Center for Education Statistics, Integrated
Postsecondary Education Data System (IPEDS). 2024. Retrieved from
https://nces.ed.gov/ipeds/use-the-data.
U.S. Department of Education, Office of Postsecondary Education (OPE). 2024. Retrieved
from https://www.ed.gov/ope-program-data.
