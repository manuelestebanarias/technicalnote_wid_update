


**# Table 9
/*------------------------------------------------------------------------------
Table 9. Bottom 10 Poorest Countries ($pastyear)
------------------------------------------------------------------------------*/
**Part 1 (all Countries)
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp 	= mnnfin / ppp_eur
gen mnwnxa_pasty_ppp 	= mnwnxa / ppp_eur
gen mndpro_pasty_ppp 	= mndpro / ppp_eur
gen mnninc_mer	 			= mnninc / xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio	= ppp_eur/ xlceux
gen mnnfin_ratio			= mnnfin_pasty_ppp / mndpro_pasty_ppp
gen mnwnxa_ratio			= mnwnxa_pasty_ppp / mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur / npopul
sort mnninc_pasty_ppp_eur_pc
egen seq=seq()
gen percentile=""
replace percentile="0%-10%" 	if inrange(seq,1,22)
replace percentile="10%-20%" 	if inrange(seq,23,44)
replace percentile="20%-30%" 	if inrange(seq,45,66)
replace percentile="30%-40%" 	if inrange(seq,67,87)
replace percentile="40%-50%" 	if inrange(seq,88,108) 
replace percentile="50%-60%" 	if inrange(seq,109,129)
replace percentile="60%-70%" 	if inrange(seq,130,150)
replace percentile="70%-80%" 	if inrange(seq,151,172)
replace percentile="80%-90%" 	if inrange(seq,173,194)
replace percentile="90%-100%" 	if inrange(seq,195,216) 
keep if percentile=="0%-10%" 
sort seq
egen top10=seq()
keep if inrange(top10,1,10)
 

sort top10

*Format for exporting
order country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp mnwnxa_ratio
keep country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp top10 mnwnxa_ratio
foreach var in country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp mnwnxa_ratio{
	ren `var' `var'_all
}

rename country_all country
merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop country 
order shortname
rename shortname country_all

*Save Part 1
tempfile top10_poorest_all
save `top10_poorest_all'



**Part 2 (Only Small Countries)
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp = mnnfin / ppp_eur
gen mnwnxa_pasty_ppp = mnwnxa / ppp_eur
gen mndpro_pasty_ppp = mndpro / ppp_eur
gen mnninc_mer			 = mnninc / xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio= ppp_eur / xlceux
gen mnnfin_ratio		= mnnfin_pasty_ppp / mndpro_pasty_ppp
gen mnwnxa_ratio		= mnwnxa_pasty_ppp / mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur / npopul
sort mnninc_pasty_ppp_eur_pc

 
 egen seq=seq()
 g percentile=""
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
 
 drop if inlist(classif,"0-100k", "100k-1m","1m-10m")
 sort seq
 egen top10=seq()
 keep if inrange(top10,1,10)
 

 
*Format for exporting
order country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp mnwnxa_ratio
keep  country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp top10 mnwnxa_ratio


merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop country 
order shortname
rename shortname country_all

*Merge with Part 1
merge 1:1 top10 using "`top10_poorest_all'"
drop _merge
order top10 country_all mnninc_pasty_ppp_eur_pc_all npopul_all mnnfin_ratio_all mnninc_mer_ppp_all mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp_ratio mnwnxa_ratio_all mnwnxa_ratio
keep top10 country_all mnninc_pasty_ppp_eur_pc_all npopul_all mnnfin_ratio_all mnninc_mer_ppp_all mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp_ratio mnwnxa_ratio_all mnwnxa_ratio


*Export to excel
*export excel using "$output", sheet("DataT9", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT11", modify) cell(B5) keepcellfmt





**# Table 10 
/*------------------------------------------------------------------------------
Table 10. Top 10 Largest Economies ($pastyear)
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp = mnnfin /ppp_eur
gen mndpro_pasty_ppp = mndpro /ppp_eur
gen mnninc_mer=mnninc/xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio = ppp_eur/xlceux
gen mnnfin_ratio		 = mnnfin_pasty_ppp / mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur / npopul
 
gsort -mnninc_mer
egen rank_mer=seq()
 
*Select top 10 countries according to total net national income (ppp)
gsort -mnninc_pasty_ppp_eur
egen seq=seq()
sort seq
egen top10=seq()
keep if inrange(top10,1,10)
 
preserve
	keep country 
	save "$work_data/largest.dta", replace
restore
 
sort top10

*Format for exporting
order country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer mnninc_mer_ppp_ratio
replace mnninc_pasty_ppp_eur=mnninc_pasty_ppp_eur/1000000000
replace mnninc_mer=mnninc_mer/1000000000
replace npopul=npopul/1000000

gen mnnfin_mer_ratio=mnnfin_mer_usd/mndpro_mer_usd
gen mnwnxa_mer_ratio=mnwnxa_mer_usd/mnninc_mer_usd

*Export to excel
keep country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer rank_mer mnninc_mer_ppp_ratio mnnfin_mer_ratio mnwnxa_mer_ratio
order country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer rank_mer mnninc_mer_ppp_ratio mnnfin_mer_ratio mnwnxa_mer_ratio

merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop country 
order shortname
rename shortname country
 sort mnninc_pasty_ppp_eur

*export excel using "$output", sheet("DataT10", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT12", modify) cell(B5) keepcellfmt



**# Table 11 
/*------------------------------------------------------------------------------
Table 11. Bottom 10 smallest economies, excluding countries with population <10m ($pastyear)
------------------------------------------------------------------------------*/
/*
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp = mnnfin / ppp_eur
gen mndpro_pasty_ppp = mndpro / ppp_eur
gen mnninc_mer		 = mnninc / xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio = ppp_eur/xlceux
gen mnnfin_ratio		 = mnnfin_pasty_ppp / mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc=mnninc_pasty_ppp_eur/npopul
 


 
*Select top 10 countries according to total net national income (ppp)
drop if npopul<10000000
sort mnninc_pasty_ppp_eur
egen seq=seq()
sort seq
egen top10=seq()
keep if inrange(top10,1,10)
 
sort mnninc_mer
egen rank_mer=seq()
sort top10

*Format for exporting
order country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer mnninc_mer_ppp_ratio
replace mnninc_pasty_ppp_eur = mnninc_pasty_ppp_eur/1000000000
replace mnninc_mer			 = mnninc_mer/1000000000
replace npopul				 = npopul/1000000

gen mnnfin_mer_ratio = mnnfin_mer_usd/mndpro_mer_usd
gen mnwnxa_mer_ratio = mnwnxa_mer_usd/mnninc_mer_usd

*Export to excel
keep country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer rank_mer mnninc_mer_ppp_ratio mnnfin_mer_ratio mnwnxa_mer_ratio
order country mnninc_pasty_ppp_eur npopul mnninc_pasty_ppp_eur_pc mnninc_mer rank_mer mnninc_mer_ppp_ratio mnnfin_mer_ratio mnwnxa_mer_ratio

merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop country 
order shortname
rename shortname country

export excel using "$output", sheet("DataT11", modify) cell(A4) keepcellfmt

*/


**# Tables 12a and 12b
/*------------------------------------------------------------------------------
Table 12a. Per Capita Net Domestic Product and Foreign Income (PPP $pastyear €)

Table 12b. Per Capita Net Domestic Product and Foreign Income ($pastyear, MER €)
------------------------------------------------------------------------------*/
/*
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mndpro_ppp_pc = (mndpro / ppp_eur)/npopul
foreach var in mndpro  mnnfin mnwnxa mpinnx mcomnx mscinx mtaxnx{
gen `var'_ppp=(`var'/ppp_eur)
gen `var'_mer=(`var'/xlceux)	
}




*Sort from lowest to highest per capita net domestic product PPP
sort mndpro_ppp_pc
 
*Classify according to per capita net national income
egen seq=seq()
gen percentile=""
replace percentile="0%-10%"   if inrange(seq,1,22)
replace percentile="10%-20%"  if inrange(seq,23,44)
replace percentile="20%-30%"  if inrange(seq,45,66)
replace percentile="30%-40%"  if inrange(seq,67,87)
replace percentile="40%-50%"  if inrange(seq,88,108) 
replace percentile="50%-60%"  if inrange(seq,109,129)
replace percentile="60%-70%"  if inrange(seq,130,150)
replace percentile="70%-80%"  if inrange(seq,151,172)
replace percentile="80%-90%"  if inrange(seq,173,194)
replace percentile="90%-100%" if inrange(seq,195,216) 


*Save temporary file with sample
tempfile  temp
save     `temp'
 
*Generate First 2 columns
use "`temp'",clear
 
 *Compute for World 
preserve
	collapse (sum) npopul  mndpro_ppp mnnfin_ppp mnwnxa_ppp	mpinnx_ppp mcomnx_ppp mtaxnx_ppp mscinx_ppp	mndpro_mer mnnfin_mer mnwnxa_mer mpinnx_mer mcomnx_mer mtaxnx_mer mscinx_mer  	/*mndpro _ppp_usd mndpro _mer_usd */
	sum npopul
	loc npopul=r(mean)
	sum mndpro_ppp
	loc mndpro_ppp=r(mean)
	loc mndpro_ppp_pc=`mndpro_ppp'/`npopul'
	loc mnnfin_ppp_ratio=mnnfin_ppp/mndpro_ppp
	loc mnwnxa_ppp_ratio=mnwnxa_ppp/mndpro_ppp	
	loc mpinnx_ppp_ratio=mpinnx_ppp/mndpro_ppp
	loc mcomnx_ppp_ratio=mcomnx_ppp/mndpro_ppp	
	loc mscinx_ppp_ratio=mscinx_ppp/mndpro_ppp
	loc mtaxnx_ppp_ratio=mtaxnx_ppp/mndpro_ppp
	
	sum mndpro_mer
	loc mndpro_mer=r(mean)
	loc mndpro_mer_pc=`mndpro_mer'/`npopul'	

	loc mnnfin_mer_ratio=mnnfin_mer/mndpro_mer
	loc mnwnxa_mer_ratio=mnwnxa_mer/mndpro_mer
	loc mpinnx_mer_ratio=mpinnx_mer/mndpro_mer
	loc mcomnx_mer_ratio=mcomnx_mer/mndpro_mer	
	loc mscinx_mer_ratio=mscinx_mer/mndpro_mer
	loc mtaxnx_mer_ratio=mtaxnx_mer/mndpro_mer
	
	loc mndpro_mer_ppp_pc_ratio= `mndpro_mer_pc'/`mndpro_ppp_pc'	
	
restore

 *Compute per percentile
collapse (sum) npopul  mndpro_ppp mnnfin_ppp mnwnxa_ppp mpinnx_ppp mcomnx_ppp mtaxnx_ppp mscinx_ppp mndpro_mer mnnfin_mer mnwnxa_mer mpinnx_mer mcomnx_mer mtaxnx_mer mscinx_mer, by(percentile) 		/*mndpro_ppp_usd mndpro_mer_usd */
 
gen mndpro_ppp_pc	 = mndpro_ppp/npopul
gen mnnfin_ppp_ratio = mnnfin_ppp/mndpro_ppp
gen mnwnxa_ppp_ratio = mnwnxa_ppp/mndpro_ppp
gen mpinnx_ppp_ratio = mpinnx_ppp/mndpro_ppp
gen mcomnx_ppp_ratio = mcomnx_ppp/mndpro_ppp
gen mscinx_ppp_ratio = mscinx_ppp/mndpro_ppp
gen mtaxnx_ppp_ratio = mtaxnx_ppp/mndpro_ppp

gen mndpro_mer_pc=mndpro_mer/npopul

gen mnnfin_mer_ratio = mnnfin_mer/mndpro_mer
gen mnwnxa_mer_ratio = mnwnxa_mer/mndpro_mer
gen mpinnx_mer_ratio = mpinnx_mer/mndpro_mer
gen mcomnx_mer_ratio = mcomnx_mer/mndpro_mer
gen mscinx_mer_ratio = mscinx_mer/mndpro_mer
gen mtaxnx_mer_ratio = mtaxnx_mer/mndpro_mer

gen mndpro_mer_ppp_pc_ratio=mndpro_mer_pc/mndpro_ppp_pc 

// g mndpro _mer_ppp_ratio_usd=mndpro _mer_usd/mndpro _ppp_usd
 
*Include World 
set obs `=_N+1'
replace percentile       = "World" if percentile==""
replace mndpro_ppp_pc    = `mndpro_ppp_pc'   if percentile=="World" & mndpro_ppp_pc==.
replace mnnfin_ppp_ratio = `mnnfin_ppp_ratio' if percentile=="World" & mnnfin_ppp_ratio==.
replace mnwnxa_ppp_ratio = `mnwnxa_ppp_ratio' if percentile=="World" & mnwnxa_ppp_ratio==.	
replace mpinnx_ppp_ratio = `mpinnx_ppp_ratio' if percentile=="World" & mpinnx_ppp_ratio==.	
replace mcomnx_ppp_ratio = `mcomnx_ppp_ratio' if percentile=="World" & mcomnx_ppp_ratio==.	
replace mtaxnx_ppp_ratio = `mtaxnx_ppp_ratio' if percentile=="World" & mtaxnx_ppp_ratio==.
replace mscinx_ppp_ratio = `mscinx_ppp_ratio' if percentile=="World" & mscinx_ppp_ratio==.	
	
replace mndpro_mer_pc           = `mndpro_mer_pc' if percentile=="World" & mndpro_mer_pc==.
replace mndpro_mer_ppp_pc_ratio = `mndpro_mer_ppp_pc_ratio' if percentile=="World" & mndpro_mer_ppp_pc_ratio==.
replace mnnfin_mer_ratio=`mnnfin_mer_ratio' if percentile=="World" & mnnfin_mer_ratio==.
replace mnwnxa_mer_ratio=`mnwnxa_mer_ratio' if percentile=="World" & mnwnxa_mer_ratio==.	
replace mpinnx_mer_ratio=`mpinnx_mer_ratio' if percentile=="World" & mpinnx_mer_ratio==.	
replace mcomnx_mer_ratio=`mcomnx_mer_ratio' if percentile=="World" & mcomnx_mer_ratio==.	
replace mtaxnx_mer_ratio=`mtaxnx_mer_ratio' if percentile=="World" & mtaxnx_mer_ratio==.
replace mscinx_mer_ratio=`mscinx_mer_ratio' if percentile=="World" & mscinx_mer_ratio==.
	
replace mndpro_mer_ppp_pc_ratio=`mndpro_mer_ppp_pc_ratio' if percentile=="World" & mndpro_mer_ppp_pc_ratio==.

	
*Format for exporting	
order percentile mndpro_ppp_pc mnnfin_ppp_ratio mnwnxa_ppp_ratio mpinnx_ppp_ratio mcomnx_ppp_ratio mtaxnx_ppp_ratio mscinx_ppp_ratio mndpro_mer_pc mndpro_mer_ppp_pc_ratio /*mndpro _mer_ppp_ratio_usd*/ mnnfin_mer_ratio mnwnxa_mer_ratio mpinnx_mer_ratio mcomnx_mer_ratio mtaxnx_mer_ratio mscinx_mer_ratio
drop npopul mndpro_ppp mnnfin_ppp mnwnxa_ppp mndpro_mer mnnfin_mer mnwnxa_mer mpinnx_mer mcomnx_mer mtaxnx_mer mscinx_mer mpinnx_ppp mcomnx_ppp mtaxnx_ppp mscinx_ppp /*mndpro _mer_ppp_pc_ratio*/


*Export to excel
export excel using "$output", sheet("DataT12", modify) cell(A4) keepcellfmt

*/
