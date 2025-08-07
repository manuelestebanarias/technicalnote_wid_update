//------------------------------------------------------------------------------
//    Main
//------------------------------------------------------------------------------

// 1. Set up globals
do "~/Documents/GitHub/technicalnote_wid_update/code/1dodirectory.do"

* Generate worok_datafolder
capture mkdir "$root/work-data"


// 2. Import country codes and regions
do "$code/2importcountrycodes.do"



// 3. Download and assemble data
do "$code/3domaindataset.do" 

// 4. Generate appendinx
do "$code/10doappendix.do" 

// 5. Generate Core results
* Tables, figures and data 1-4,0
do "$code/4dobasicresults.do" 
* Tables, figures and data 5-8
do "$code/5docountrysize.do" 
* Tables, figures and data 8-12
do "$code/6dorichest.do" 

// 6. Generate extended results
* Tables, figures and data 3-8 large
*do "$code/7dowealthandincome.do" 
* Tables, figures and data 5 large and rem
*do "$code/8netremittances.do" 
* Tables, figures and data 8-17
*do "$code/9dopublicspending.do" 

// 7. Run checks 
*do "$code/checks.do"
