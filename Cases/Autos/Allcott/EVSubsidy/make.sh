#!/bin/bash

# User-defined inputs
LOGFILE=output/build.log

# Exit on non-zero return values (errors)
set -e

# remove previous output
# rm -rf output

# create empty output directory if it doesn't exist
mkdir -p output

# Remove log file if it exists
rm -f ${LOGFILE}

# Run programs, logging output to file (output/build.log) and screen
{
    # Ensure packages are installed
    # Rscript -e "install.packages(c('kableExtra', 'rmarkdown'), repos='http://cran.rstudio.com/')"

    # Run programs
    # rprogram="code/process_barreca.R"
    # echo "Running R program: $rprogram..." 
    # Rscript "$rprogram"

    # Run programs
    rmd_file="code/sample_solution.Rmd"
    pdf_output="../output/sample_solution.pdf"
    echo "Running Rmarkdown script: $rmd_file..." 
    Rscript -e "rmarkdown::render('$rmd_file', output_file='$pdf_output')" 

} 2>&1 | tee -a "${LOGFILE}"
