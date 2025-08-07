**# Figure 5i
/*------------------------------------------------------------------------------
Figure 5i. Net Foreign Transfers as % Net Domestic Product (MER) by World region1 1970-2023
------------------------------------------------------------------------------*/
* Import data 
use "$work_data/main_dataset.dta", clear

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscinx_mer_usd, by(year)
	gen mscinx_mer_ratioWorld=mscinx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscinx_mer_usd
	
	tempfile mscinx_mer_ratioWorld 
	save `mscinx_mer_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscinx_mer_usd, by(year region1)
*Format in Figure format
gen mscinx_mer_ratio = mscinx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscinx_mer_usd
reshape wide mscinx_mer_ratio, i(year) j(region1) string
merge 1:1 year using "`mscinx_mer_ratioWorld'"
drop _merge 


ren mscinx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}   

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("(Net Foreign Aid + Net Remittances +" "Net Other Transfers) % mndpro" "by world region1s") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
export excel using "$output", sheet("DataF5_mscinx", modify) cell(A4) keepcellfmt

		
		
**# Figure 5j
/*------------------------------------------------------------------------------
Figure 5j. Net Foreign Transfers as % Net Domestic Product (MER) for the Largest Economies 1970-2023
------------------------------------------------------------------------------*/
* Import data
use "$work_data/main_dataset.dta", clear

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscinx_mer_usd, by(year )
	g mscinx_mer_ratioWorld=mscinx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscinx_mer_usd
	
	tempfile mscinx_mer_ratioWorld
	save `mscinx_mer_ratioWorld'
restore 
	
	
merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
	replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscinx_mer_usd, by(year countryname)
	
	
*Format in Figure format
g mscinx_mer_ratio=mscinx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscinx_mer_usd
reshape wide mscinx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mscinx_mer_ratioWorld'", nogen


tsset year
ren mscinx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("(Net Foreign Aid + Net Remittances +" "Net Other Transfers) % mndpro" "by world region1s") ///
	lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 
	
export excel using "$output", sheet("DataF5_large_mscinx", modify) cell(A4) keepcellfmt
		
		
		
		
	
 **# Figure 5k
/*------------------------------------------------------------------------------
Figure 5k. Net Remittances as % Net Domestic Product (MER) by World region1 1970-2023
------------------------------------------------------------------------------*/
 *net_remittances (mscrnx)
 /*
 ren foreignaid_debit	scgpx
ren foreignaid_credit	scgrx
ren net_foreignaid		scgnx
ren remittances_debit	scrpx
ren remittances_credit	scrrx
ren net_remittances		scrnx
ren othtrans_debit		scopx
ren othtrans_credit		scorx
ren net_othtrans		sconx
 */
* Import data
use "$work_data/main_dataset.dta", clear


preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscrnx_mer_usd, by(year)
	g mscrnx_mer_ratioWorld=mscrnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscrnx_mer_usd
	
	tempfile mscrnx_mer_ratioWorld
	save 	`mscrnx_mer_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscrnx_mer_usd, by(year region1)
*Format in Figure format
g mscrnx_mer_ratio=mscrnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscrnx_mer_usd
reshape wide mscrnx_mer_ratio , i(year) j(region1) string
merge 1:1 year using "`mscrnx_mer_ratioWorld'"
drop _merge 

tsset year
ren mscrnx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
title("(Net Remittances  % mndpro" "by world region1s") ///
lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
export excel using "$output", sheet("DataF5_rem", modify) cell(A4) keepcellfmt

		
	
	
	
	
**# Figure 5l largest
/*------------------------------------------------------------------------------
Figure 5l. Net Remittances as % Net Domestic Product (MER) for the Largest Economies 1970-2023
------------------------------------------------------------------------------*/

* Import data
use "$work_data/main_dataset.dta", clear

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscrnx_mer_usd, by(year )
	g mscrnx_mer_ratioWorld=mscrnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscrnx_mer_usd
	
	tempfile mscrnx_mer_ratioWorld
	save `mscrnx_mer_ratioWorld'
restore 
	
	
merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
	replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscrnx_mer_usd, by(year countryname)
	
	
*Format in Figure format
g mscrnx_mer_ratio=mscrnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscrnx_mer_usd
reshape wide mscrnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mscrnx_mer_ratioWorld'"
drop _merge 
cap erase mscrnx_mer_ratioWorld.dta
tsset year
ren mscrnx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances % mndpro" "by world region1s") ///
	lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 
	
export excel using "$output", sheet("DataF5_large_rem", modify) cell(A4) keepcellfmt
			
	
 
	
	
	
 **# Figure 5m
/*------------------------------------------------------------------------------
Figure 5m. Net Public Foreign Transfers as % Net Domestic Product (MER) by World region1 1970-2023
------------------------------------------------------------------------------*/ 
* Import data
use "$work_data/main_dataset.dta", clear

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscgnx_mer_usd, by(year )
	g mscgnx_mer_ratioWorld=mscgnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscgnx_mer_usd
	
	tempfile mscgnx_mer_ratioWorld
	save `mscgnx_mer_ratioWorld'
restore 
 	
*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscgnx_mer_usd, by(year region1)
*Format in Figure format
gen mscgnx_mer_ratio=mscgnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscgnx_mer_usd
reshape wide mscgnx_mer_ratio , i(year) j(region1) string
merge 1:1 year using "`mscgnx_mer_ratioWorld'", nogen
	
tsset year
ren mscgnx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Aid % mndpro" "by world region1s") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
export excel using "$output", sheet("DataF5_mscgnx", modify) cell(A4) keepcellfmt

		
		
**# Figure 5n largest
/*------------------------------------------------------------------------------
Figure 5n. Net Public Foreign Transfers as % Net Domestic Product (MER) for the Largest Economies 1970-2023
------------------------------------------------------------------------------*/ 
* Import data
use "$work_data/main_dataset.dta", clear


preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mscgnx_mer_usd, by(year )
	g mscgnx_mer_ratioWorld=mscgnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mscgnx_mer_usd
	tempfile mscgnx_mer_ratioWorld
	save `mscgnx_mer_ratioWorld'
restore 
	
	
merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
	replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd mscgnx_mer_usd, by(year countryname)

	
*Format in Figure format
g mscgnx_mer_ratio=mscgnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mscgnx_mer_usd
reshape wide mscgnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mscgnx_mer_ratioWorld'"
drop _merge 

tsset year
ren mscgnx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Aid % mndpro" "by world region1s") ///
	lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 
	
export excel using "$output", sheet("DataF5_large_mscgnx", modify) cell(A4) keepcellfmt
			
		
		
**# Figure 5o
/*------------------------------------------------------------------------------
Figure 5o. Net Other Foreign Transfers as % Net Domestic Product (MER) by World region1 1970-2023
------------------------------------------------------------------------------*/ 
* Import data
use "$work_data/main_dataset.dta", clear


preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd msconx_mer_usd, by(year )
	g msconx_mer_ratioWorld=msconx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd msconx_mer_usd
	save msconx_mer_ratioWorld.dta,replace
restore 

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd msconx_mer_usd, by(year region1)
*Format in Figure format
g msconx_mer_ratio=msconx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd msconx_mer_usd
reshape wide msconx_mer_ratio , i(year) j(region1) string
merge 1:1 year using msconx_mer_ratioWorld.dta
drop _merge 

tsset year
ren msconx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Other Transfers % mndpro" "by world region1s") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
export excel using "$output", sheet("DataF5_msconx", modify) cell(A4) keepcellfmt
		
		
		
		
		
**# Figure 5p largest
/*------------------------------------------------------------------------------
Figure 5p. Net Other Foreign Transfers as % Net Domestic Product (MER) for the Largest Economies 1970-2023
------------------------------------------------------------------------------*/
* Import data
use "$work_data/main_dataset.dta", clear

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd msconx_mer_usd, by(year )
	gen msconx_mer_ratioWorld=msconx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd msconx_mer_usd
	
	tempfile msconx_mer_ratioWorld
	save `msconx_mer_ratioWorld'
restore 
	
merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
	replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mndpro_mer_usd msconx_mer_usd, by(year countryname)
	
	
*Format in Figure format
gen  msconx_mer_ratio=msconx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd msconx_mer_usd
reshape wide msconx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`msconx_mer_ratioWorld'"
drop _merge 

tsset year
ren msconx_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)' if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Aid % mndpro" "by world region1s") ///
	lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 
	
export excel using "$output", sheet("DataF5_large_msconx", modify) cell(A4) keepcellfmt		
	