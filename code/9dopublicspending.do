
**# Table 14
/*------------------------------------------------------------------------------
Table 14. Per Capita National Income and Public spending (PPP $pastyear €)
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

*Generate relevant variables
foreach var in mgroni mrevgo mretgo mntrgr mexpgo meduge mheage mehsgo msopge mopsgo mpsugo minpgo mssugo {
	gen `var'_ppp_pc=`var'_ppp/npopul
}


*Sort from lowest to highest per capita national income (PPP)
sort mgroni_ppp_pc
 
*Classify according to per capita net national income
egen seq=seq()
gen percentile=""
replace percentile="0%-10%" if inrange(seq,1,22)
replace percentile="10%-20%" if inrange(seq,23,44)
replace percentile="20%-30%" if inrange(seq,45,66)
replace percentile="30%-40%" if inrange(seq,67,87)
replace percentile="40%-50%" if inrange(seq,88,108) 
replace percentile="50%-60%" if inrange(seq,109,129)
replace percentile="60%-70%" if inrange(seq,130,150)
replace percentile="70%-80%" if inrange(seq,151,172)
replace percentile="80%-90%" if inrange(seq,173,194)
replace percentile="90%-100%" if inrange(seq,195,216) 
 
 
 *Compute for World 
preserve
	collapse (sum) npopul  mgroni_ppp mrevgo_ppp mretgo_ppp mntrgr_ppp mexpgo_ppp mehsgo_ppp msopge_ppp mopsgo_ppp mpsugo_ppp minpgo_ppp mssugo_ppp
	sum npopul
	loc npopul=r(mean)
	foreach var in mgroni {
		sum `var'_ppp
		loc mgroni_ppp=r(mean)
		loc `var'_ppp_pc= `mgroni_ppp'/`npopul'
	}
	foreach var in mrevgo mretgo mntrgr mexpgo mehsgo  msopge mopsgo mpsugo minpgo mssugo{
		sum `var'_ppp
		loc `var'_ppp_ratio=r(mean)/`mgroni_ppp'
	}
restore

 *Compute per percentile
 collapse (sum) npopul mgroni_ppp mrevgo_ppp mretgo_ppp mntrgr_ppp mexpgo_ppp mehsgo_ppp msopge_ppp mopsgo_ppp mpsugo_ppp  minpgo_ppp mssugo_ppp,by(percentile)
 
foreach var in mgroni {
	g `var'_ppp_pc=`var'_ppp/npopul
}

foreach var in mrevgo mretgo mntrgr mexpgo mehsgo  msopge mopsgo mpsugo minpgo mssugo{
	g `var'_ppp_ratio=`var'_ppp/mgroni_ppp	
}
 
*Include World 
set obs `=_N+1'
	replace percentile="World" if percentile==""
	foreach var in mgroni {
		replace `var'_ppp_pc=``var'_ppp_pc' if percentile=="World" & `var'_ppp_pc==.
	}
	foreach var in mrevgo mretgo mntrgr mexpgo mehsgo  msopge mopsgo mpsugo minpgo mssugo{
		replace `var'_ppp_ratio=``var'_ppp_ratio' if percentile=="World" & `var'_ppp_ratio==.
	}
	
*Format for exporting	
order percentile mgroni_ppp_pc 
drop npopul mgroni_ppp mrevgo_ppp mretgo_ppp mntrgr_ppp mexpgo_ppp mehsgo_ppp msopge_ppp mopsgo_ppp mpsugo_ppp minpgo_ppp mssugo_ppp


*Export to excel
export excel using "$output", sheet("DataT14", modify) cell(A4) keepcellfmt




**# Figure 9a
/*------------------------------------------------------------------------------
Public Revenue as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mrevgo_ppp mgroni_ppp, by(year )
	gen mrevgo_ppp_ratioWorld=mrevgo_ppp/mgroni_ppp
	drop mrevgo_ppp mgroni_ppp
	
	tempfile mrevgo_ppp_ratioWorld
	save `mrevgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mrevgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mrevgo_ppp_ratio=mrevgo_ppp/mgroni_ppp
drop mrevgo_ppp mgroni_ppp
reshape wide mrevgo_ppp_ratio, i(year) j(region1) string
merge 1:1 year using `mrevgo_ppp_ratioWorld'
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF9", modify) cell(A4) keepcellfmt



**# Figure 10a
/*------------------------------------------------------------------------------
Figure 10a. Tax Revenue as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mretgo_ppp mgroni_ppp, by(year )
	g mretgo_ppp_ratioWorld= mretgo_ppp/mgroni_ppp
	drop mretgo_ppp mgroni_ppp

	tempfile mretgo_ppp_ratioWorld
	save `mretgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mretgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mretgo_ppp_ratio= mretgo_ppp/mgroni_ppp
drop mretgo_ppp mgroni_ppp
reshape wide mretgo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mretgo_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF10", modify) cell(A4) keepcellfmt


**# Figure 11a
/*------------------------------------------------------------------------------
Figure 11a. Non-tax Revenue as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mntrgr_ppp mgroni_ppp, by(year )
	gen mntrgr_ppp_ratioWorld = mntrgr_ppp/mgroni_ppp
	drop mntrgr_ppp mgroni_ppp
	tempfile mntrgr_ppp_ratioWorld
	save `mntrgr_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mntrgr_ppp mgroni_ppp, by(year region1)

*Format in Figure format
gen mntrgr_ppp_ratio = mntrgr_ppp/mgroni_ppp
drop mntrgr_ppp mgroni_ppp
reshape wide mntrgr_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mntrgr_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF11", modify) cell(A4) keepcellfmt




**# Figure 12a
/*------------------------------------------------------------------------------
Figure 12a. Public spending as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mexpgo_ppp mgroni_ppp, by(year )
	g mexpgo_ppp_ratioWorld= mexpgo_ppp/mgroni_ppp
	drop mexpgo_ppp mgroni_ppp
	tempfile mexpgo_ppp_ratioWorld
	save `mexpgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mexpgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mexpgo_ppp_ratio= mexpgo_ppp/mgroni_ppp
drop mexpgo_ppp mgroni_ppp
reshape wide mexpgo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mexpgo_ppp_ratioWorld'"
drop _merge 
cap erase mexpgo_ppp_ratioWorld.dta

tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF12", modify) cell(A4) keepcellfmt



**# Figure 13a
/*------------------------------------------------------------------------------
Figure 13a. Public spending in Education and Health as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mehsgo_ppp mgroni_ppp, by(year )
	g mehsgo_ppp_ratioWorld=mehsgo_ppp/mgroni_ppp
	drop mehsgo_ppp mgroni_ppp
	tempfile mehsgo_ppp_ratioWorld
	save `mehsgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mehsgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mehsgo_ppp_ratio=mehsgo_ppp/mgroni_ppp
drop mehsgo_ppp mgroni_ppp
reshape wide mehsgo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mehsgo_ppp_ratioWorld'"
drop _merge 
cap erase mehsgo_ppp_ratioWorld.dta

tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF13", modify) cell(A4) keepcellfmt




**# Figure 13c
/*------------------------------------------------------------------------------
Figure 13c. Public spending in Health as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mheage_ppp mgroni_ppp, by(year )
	g mheage_ppp_ratioWorld=mheage_ppp/mgroni_ppp
	drop mheage_ppp mgroni_ppp
	tempfile mheage_ppp_ratioWorld
	save `mheage_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mheage_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mheage_ppp_ratio=mheage_ppp/mgroni_ppp
drop mheage_ppp mgroni_ppp
reshape wide mheage_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mheage_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF13_b", modify) cell(A4) keepcellfmt



**# Figure 13e
/*------------------------------------------------------------------------------
Figure 13e. Public spending in Education as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) meduge_ppp mgroni_ppp, by(year )
	g meduge_ppp_ratioWorld=meduge_ppp/mgroni_ppp
	drop meduge_ppp mgroni_ppp
	tempfile meduge_ppp_ratioWorld
	save `meduge_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum)meduge_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g meduge_ppp_ratio=meduge_ppp/mgroni_ppp
drop meduge_ppp mgroni_ppp
reshape wide meduge_ppp_ratio , i(year) j(region1) string
merge 1:1 year using `meduge_ppp_ratioWorld'
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF13_c", modify) cell(A4) keepcellfmt


**# Figure 14a
/*------------------------------------------------------------------------------
Figure 14a. Public spending in Social Protection as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) msopge_ppp mgroni_ppp, by(year )
	g msopge_ppp_ratioWorld=msopge_ppp/mgroni_ppp
	drop msopge_ppp mgroni_ppp
	
	tempfile msopge_ppp_ratioWorld
	save `msopge_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) msopge_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g msopge_ppp_ratio=msopge_ppp/mgroni_ppp
drop msopge_ppp mgroni_ppp
reshape wide msopge_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`msopge_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF14", modify) cell(A4) keepcellfmt



**# Figure 15a
/*------------------------------------------------------------------------------
Figure 15a. Other Public spending as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mopsgo_ppp mgroni_ppp, by(year )
	g mopsgo_ppp_ratioWorld=mopsgo_ppp/mgroni_ppp
	drop mopsgo_ppp mgroni_ppp
	tempfile mopsgo_ppp_ratioWorld
	save `mopsgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mopsgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mopsgo_ppp_ratio=mopsgo_ppp/mgroni_ppp
drop mopsgo_ppp mgroni_ppp
reshape wide mopsgo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mopsgo_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF15", modify) cell(A4) keepcellfmt




**# Figure 16a
/*------------------------------------------------------------------------------
Figure 16a. Primary Surplus as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
*Aggregate at the national-year level
collapse (sum) mpsugo_ppp mgroni_ppp, by(year )
g mpsugo_ppp_ratioWorld=mpsugo_ppp/mgroni_ppp
drop mpsugo_ppp mgroni_ppp
tempfile mpsugo_ppp_ratioWorld
save `mpsugo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mpsugo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g mpsugo_ppp_ratio=mpsugo_ppp/mgroni_ppp
drop mpsugo_ppp mgroni_ppp
reshape wide mpsugo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mpsugo_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF16", modify) cell(A4) keepcellfmt




**# Figure 17a
/*------------------------------------------------------------------------------
Figure 17a. Interest Payments as % Gross National Income (PPP) by World region1 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) minpgo_ppp mgroni_ppp, by(year )
	g minpgo_ppp_ratioWorld=minpgo_ppp/mgroni_ppp
	drop minpgo_ppp mgroni_ppp
	tempfile minpgo_ppp_ratioWorld
	save `minpgo_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) minpgo_ppp mgroni_ppp, by(year region1)

*Format in Figure format
g minpgo_ppp_ratio=minpgo_ppp/mgroni_ppp
drop minpgo_ppp mgroni_ppp
reshape wide minpgo_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`minpgo_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF17", modify) cell(A4) keepcellfmt











**# Figure 9b
/*------------------------------------------------------------------------------
Figure 9b. Public Revenue as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"



preserve
	*Aggregate at the national-year level
	collapse (sum) mrevgo_ppp mgroni_ppp, by(year )
	g mrevgo_ppp_ratioWorld=mrevgo_ppp/mgroni_ppp
	drop mrevgo_ppp mgroni_ppp
	tempfile mrevgo_ppp_ratioWorld
	save `mrevgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mrevgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mrevgo_ppp_ratio=mrevgo_ppp/mgroni_ppp
drop mrevgo_ppp mgroni_ppp
reshape wide mrevgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mrevgo_ppp_ratioWorld'", nogen


ren mrevgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public revenue as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  Income collected by governments through taxes, fees, fines, and other sources as relative to" "the country's economic output.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) 

*Export 
export excel using "$output", sheet("DataF9_large", modify) cell(A4) keepcellfmt



**# Figure 10b
/*------------------------------------------------------------------------------
Figure 10b. Tax Revenue as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mretgo_ppp mgroni_ppp, by(year )
	gen mretgo_ppp_ratioWorld=mretgo_ppp/mgroni_ppp
	drop mretgo_ppp mgroni_ppp
	tempfile mretgo_ppp_ratioWorld
	save `mretgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mretgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mretgo_ppp_ratio=mretgo_ppp/mgroni_ppp
drop mretgo_ppp mgroni_ppp
reshape wide mretgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mretgo_ppp_ratioWorld'", nogen



ren mretgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Tax revenue as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  Government's fiscal capacity and tax burden as relative to the country's economic" " output." "Countries with tax revenue below 15% of GDP are often considered to have insufficient fiscal capacity.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.15).6)

*Export 
export excel using "$output", sheet("DataF10_large", modify) cell(A4) keepcellfmt


**# Figure 11b
/*------------------------------------------------------------------------------
Figure 11b. Non-tax Revenue as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mntrgr_ppp mgroni_ppp, by(year )
	gen mntrgr_ppp_ratioWorld=mntrgr_ppp/mgroni_ppp
	drop mntrgr_ppp mgroni_ppp
	tempfile mntrgr_ppp_ratioWorld
	save `mntrgr_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mntrgr_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mntrgr_ppp_ratio=mntrgr_ppp/mgroni_ppp
drop mntrgr_ppp mgroni_ppp
reshape wide mntrgr_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mntrgr_ppp_ratioWorld'"
drop _merge 
cap erase mntrgr_ppp_ratioWorld.dta

ren mntrgr_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Non-tax revenue as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  Revenues from natural resources, fees, fines, and other government income that does not" "come from taxation as relative to the country's economic output." "Countries that rely heavily on non-tax revenue, particularly from natural resources, may experience" "a political resource curse.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.05).25)

*Export 
export excel using "$output", sheet("DataF11_large", modify) cell(A4) keepcellfmt




**# Figure 12b
/*------------------------------------------------------------------------------
Figure 12b. Public spending as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mexpgo_ppp mgroni_ppp, by(year )
	g mexpgo_ppp_ratioWorld= mexpgo_ppp/mgroni_ppp
	drop mexpgo_ppp mgroni_ppp
	
	tempfile mexpgo_ppp_ratioWorld
	save `mexpgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mexpgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mexpgo_ppp_ratio= mexpgo_ppp/mgroni_ppp
drop mexpgo_ppp mgroni_ppp
reshape wide mexpgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mexpgo_ppp_ratioWorld'"
drop _merge 
cap erase mexpgo_ppp_ratioWorld.dta

ren mexpgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public spending as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  Economic influence of the government as relative to the country's economic output." "Lower percentages imply a more limited government role and possibly greater reliance on the private sector.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) 

*Export 
export excel using "$output", sheet("DataF12_large", modify) cell(A4) keepcellfmt



**# Figure 13b
/*------------------------------------------------------------------------------
Figure 13b. Public spending in education and health as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mehsgo_ppp mgroni_ppp, by(year )
	g mehsgo_ppp_ratioWorld=mehsgo_ppp/mgroni_ppp
	drop mehsgo_ppp mgroni_ppp
	tempfile mehsgo_ppp_ratioWorld
	save `mehsgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mehsgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mehsgo_ppp_ratio=mehsgo_ppp/mgroni_ppp
drop mehsgo_ppp mgroni_ppp
reshape wide mehsgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mehsgo_ppp_ratioWorld'"
drop _merge 


ren mehsgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public spending in education and health as " "% national income (PPP) by country 1980-$pastyear") note("Interpretation:  Public spending on education typically ranges from 2-6% of GDP, while health spending ranges" "from 1-8% of GDP." "Low-income countries typically msopgeend 3-4% on education and 1-2% on health, middle-income countries 4-5%" "and 3-4%, and high-income countries 5-6% and 6-8% of GDP, respectively.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) 

*Export 
export excel using "$output", sheet("DataF13_large", modify) cell(A4) keepcellfmt


**# Figure 13d
/*------------------------------------------------------------------------------
Figure 13d. Public spending in Health as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"



preserve
*Aggregate at the national-year level
	collapse (sum) mheage_ppp mgroni_ppp, by(year )
	g mheage_ppp_ratioWorld=mheage_ppp/mgroni_ppp
	drop mheage_ppp mgroni_ppp
	tempfile mheage_ppp_ratioWorld
	save `mheage_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mheage_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mheage_ppp_ratio=mheage_ppp/mgroni_ppp
drop mheage_ppp mgroni_ppp
reshape wide mheage_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mheage_ppp_ratioWorld'"
drop _merge 
cap erase mheage_ppp_ratioWorld.dta

ren mheage_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public spending in health as " "% national income (PPP) by country 1980-$pastyear") note("Interpretation:  Public spending on health spending typically ranges from 1-8% of GDP." "Low-income countries typically msopgeend 1-2% on health, middle-income countries 3-4%, and high-income" "countries 6-8% of GDP, respectively.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.02).14)

*Export 
export excel using "$output", sheet("DataF13_large_health", modify) cell(A4) keepcellfmt


**# Figure 13f
/*------------------------------------------------------------------------------
Figure 13f. Public spending in Education as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) meduge_ppp mgroni_ppp, by(year )
	g meduge_ppp_ratioWorld= meduge_ppp/mgroni_ppp
	drop meduge_ppp mgroni_ppp
	
	tempfile meduge_ppp_ratioWorld
	save `meduge_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) meduge_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g meduge_ppp_ratio= meduge_ppp/mgroni_ppp
drop meduge_ppp mgroni_ppp
reshape wide meduge_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`meduge_ppp_ratioWorld'"
drop _merge 


ren meduge_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public spending in education as " "% national income (PPP) by country 1980-$pastyear") note("Interpretation:  Public spending on education spending typically ranges from 2-6% of GDP." "Low-income countries typically msopgeend 3-4% on health, middle-income countries 4-5%, and high-income" "countries 5-6% of GDP, respectively.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.02).14)

*Export 
export excel using "$output", sheet("DataF13_large_education", modify) cell(A4) keepcellfmt


**# Figure 14b
/*------------------------------------------------------------------------------
Figure 14b. Public spending in Social Protecion as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) msopge_ppp mgroni_ppp, by(year )
	g msopge_ppp_ratioWorld=msopge_ppp/mgroni_ppp
	drop msopge_ppp mgroni_ppp
	tempfile msopge_ppp_ratioWorld
	save `msopge_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) msopge_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g msopge_ppp_ratio=msopge_ppp/mgroni_ppp
drop msopge_ppp mgroni_ppp
reshape wide msopge_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using  "`msopge_ppp_ratioWorld'"
drop _merge 
cap erase msopge_ppp_ratioWorld.dta

ren msopge_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Public spending in social protection as " "% national income (PPP) by country 1980-$pastyear") note("Interpretation:  Indicator of a country's commitment to social welfare programs." "High-income nations typically msopgeend over 15% of GDP, while low-income countries often msopgeend below 5%.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.05).35)

*Export 
export excel using "$output", sheet("DataF14_large", modify) cell(A4) keepcellfmt



**# Figure 15b
/*------------------------------------------------------------------------------
Figure 15b. Other Public spending as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"



preserve
	*Aggregate at the national-year level
	collapse (sum) mopsgo_ppp mgroni_ppp, by(year )
	g mopsgo_ppp_ratioWorld=mopsgo_ppp/mgroni_ppp
	drop mopsgo_ppp mgroni_ppp
	tempfile mopsgo_ppp_ratioWorld
	save `mopsgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mopsgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mopsgo_ppp_ratio=mopsgo_ppp/mgroni_ppp
drop mopsgo_ppp mgroni_ppp
reshape wide mopsgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mopsgo_ppp_ratioWorld'"
drop _merge 
cap erase mopsgo_ppp_ratioWorld.dta

ren mopsgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Other public spending as " "% national income (PPP) by country 1980-$pastyear") note("Interpretation:  Government expenditures on public services, economic affairs, public safety, environmental" "protection, housing, and cultural activities. Support for societal infrastructure and community well-being." "A simgronificant portion of the Soviet budget was allocated to military spending, which reportedly reached between" "10% to 27% of GDP during this period.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.05).4)

*Export 
export excel using "$output", sheet("DataF15_large", modify) cell(A4) keepcellfmt




**# Figure 16b
/*------------------------------------------------------------------------------
Figure 16b. Primary Surplus as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"


preserve
	*Aggregate at the national-year level
	collapse (sum) mpsugo_ppp mgroni_ppp, by(year )
	g mpsugo_ppp_ratioWorld=mpsugo_ppp/mgroni_ppp
	drop mpsugo_ppp mgroni_ppp
	tempfile mpsugo_ppp_ratioWorld
	save `mpsugo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mpsugo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g mpsugo_ppp_ratio=mpsugo_ppp/mgroni_ppp
drop mpsugo_ppp mgroni_ppp
reshape wide mpsugo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mpsugo_ppp_ratioWorld'"
drop _merge 


ren mpsugo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Primary surplus as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  A primary surplus indicates that a government is generating more revenue than it is spending" "on its core activities. Primary deficit could lead to increased borrowing and potential long-term fiscal challenges." "High-income countries typically have primary surpluses greater than 4.5% of GDP, middle-income countries" "range from 1-3% of GDP, while low-income countries often face primary deficits with surpluses below 1% of GDP.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(-.25(.05).2) yline(0)

*Export 
export excel using "$output", sheet("DataF16_large", modify) cell(A4) keepcellfmt




**# Figure 17b
/*---------------------- --------------------------------------------------------
Figure 17b. Interest Payments as % Gross National Income for the Largest Economies 1980-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1980
drop if country=="WO"



preserve
	*Aggregate at the national-year level
	collapse (sum) minpgo_ppp mgroni_ppp, by(year )
	g minpgo_ppp_ratioWorld=minpgo_ppp/mgroni_ppp
	drop minpgo_ppp mgroni_ppp
	tempfile minpgo_ppp_ratioWorld
	save `minpgo_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) minpgo_ppp mgroni_ppp, by(year countryname)

*Format in Figure format
g minpgo_ppp_ratio=minpgo_ppp/mgroni_ppp
drop minpgo_ppp mgroni_ppp
reshape wide minpgo_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`minpgo_ppp_ratioWorld'"
drop _merge 


ren minpgo_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)' , title("Interest payments as % national income (PPP)" "by country 1980-$pastyear") note("Interpretation:  Financial burden of government debt relative to its total income, influencing fiscal sustainability" "and economic health." "Low-income countries typically msopgeend over 10% of revenues on interest payments, and high-income countries" "usually less than 2% of GDP.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) yla(0(.02).14) yline(0)

*Export 
export excel using "$output", sheet("DataF17_large", modify) cell(A4) keepcellfmt










