
#######################################################################################
## Filename:                f_ae_count.R
## Program Developer:       Orla Doyle

## Project/Trial code:  AA1234/AA1234    
## Description:  

## Program history: 
#######################################################################################


####  ENV VARs

DOMINO_RUN_ID <- Sys.getenv("DOMINO_RUN_ID")


# paths
data_path <- "/mnt/imported/data/SDTMBLIND/"
output_path <- "/mnt/artifacts/report/saf/"
hash_path <- "/mnt/code/.hashes/"

# filenames
pgm_stem <- "t_ae_"
status <- "_qc"

####  TFL GENERATION

# libraries
library(dplyr)
library(stringr)
library(haven)

# read data
ae <- haven::read_sas(file.path(data_path, "ae.sas7bdat"))


# severity ----------------------------------------------------------------

# count the number of patients by AE severity (AESEV variable)
output_tag <- "severity"
count_severity_by_patient <- ae %>%
  dplyr::group_by(AESEV) %>%
  dplyr::summarise(count_sev = n_distinct(AETERM))

raw_artifact <- paste0(output_path, pgm_stem, output_tag, status, ".csv")
write.csv(count_severity_by_patient,
          raw_artifact)

# get checksum of csv file
cs_raw <- system(paste0("sha512sum ", raw_artifact, " | cut -d \" \" -f 1"), 
                 intern=TRUE)
write(cs_raw,
      paste0(hash_path, pgm_stem, output_tag, status, '.txt'))

#### end of file
sessionInfo()
