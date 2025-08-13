forv x=1/10 {
	clear all
	tempfile temp_reg`x'
	save    `temp_reg`x'', emptyok
}

clear all
tempfile temp_asi
save    `temp_asi', emptyok

clear all
tempfile temp_asi2
save    `temp_asi2', emptyok
	
**# Figure 0a
/*------------------------------------------------------------------------------
Figure 0a. Exchange rate and purchasing power parity: euro/dollar 
------------------------------------------------------------------------------*/
*For robustness
use "$work_data/main_dataset.dta",clear
keep if inlist(country,"FR","DE")
collapse (mean) xlc* ppp_*, by(year)

gen ER_eur_usd  = xlceux / xlcusx
gen PPP_eur_usd = xlceup / xlcusp
tsset year
tsline ER_eur_usd PPP_eur_usd if inrange(year,1990,2012)


*For Figures
use "$work_data/main_dataset.dta",clear
keep country year xlceup xlceux xlcusp xlcusx xlcyup xlcyux 
// preserve
keep if inlist(country,"FR","DE")
collapse (mean) xlc*, by(year)

gen ER_eur_usd  = xlceux / xlcusx
gen PPP_eur_usd = xlceup / xlcusp
tsset year
tsline ER_eur_usd PPP_eur_usd if inrange(year,1990,2012)


// restore	


**# Figure 0b
/*------------------------------------------------------------------------------
Figure 0b. Exchange rate and purchasing power parity: euro/yuan 
------------------------------------------------------------------------------*/
g ER_usd_yuan  = xlcusx / xlcyux
g PPP_usd_yuan = xlcusp / xlcyup

g ER_eur_yuan=ER_eur_usd*ER_usd_yuan
g PPP_eur_yuan=PPP_eur_usd*PPP_usd_yuan

tsline ER_eur_yuan PPP_eur_yuan if inrange(year,1990,2012)
keep if year>=1990
order year ER_eur_usd PPP_eur_usd ER_eur_yuan PPP_eur_yuan
keep year ER_eur_usd PPP_eur_usd ER_eur_yuan PPP_eur_yuan
export excel using "$output", sheet("DataF0a", modify) cell(B5) keepcellfmt 

**# Figure 0c
/*------------------------------------------------------------------------------
Figure 0c. Exchange rate and purchasing power parity: euro/ruppe 
------------------------------------------------------------------------------*/
*not possible since WID doesnt have data on rupee

**# Figure 0d
/*------------------------------------------------------------------------------
Figure 0d. Exchange rate and purchasing power parity: euro/yen 
------------------------------------------------------------------------------*/
*not possible since WID doesnt have data on yen


**# Figure 1
/*------------------------------------------------------------------------------
Figure 1. Per Capita National Income by World Region 1800-2023
------------------------------------------------------------------------------*/
use "$work_data/coreterritories_dataset.dta",clear
keep country year mnninc ppp_eur npopul 

replace mnninc=mnninc/ppp
replace mnninc= mnninc/npopul
drop ppp npopul
*rename country region1
*merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)
*sort order
*replace region1=shortname if !missing(shortname) & substr(region1,1,1)!="O"
*drop shortname  
*rename region1 country
sort country year

reshape wide mnninc,i(year) j(country) string
rename mnninc* *

order year WO QE XB XL XN XF XR QL XS DE FR	GB	IT	ES	SE	OC	QM	US	CA	AU	NZ	OH	AR	BR	CL	CO	MX	OD	TR	EG	DZ	OE	ZA	OJ	RU	OA	CN	JP	OB	IN	ID	OI

export excel using "$output", sheet("DataF1", modify) cell(B5) keepcellfmt



**# Table 1
//------------------------------------------------------------------------------
//   Table 1. National income by world regions (2024)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear
keep country region1 npopul mnninc_pasty_ppp_eur order

*Compute for world
sum  npopul if country=="WO"
loc mean1=r(mean)
gen double npopul_sh=100*npopul/`mean1' 
sum  mnninc_pasty_ppp_eur if country=="WO"
loc mean2=r(mean)
gen  double mnninc_pasty_ppp_eur_sh=100*mnninc_pasty_ppp_eur/`mean2' 	

*Compute for regions	
collapse (sum) npopul npopul_sh mnninc_pasty_ppp_eur mnninc_pasty_ppp_eur_sh , by(region1 order)

gen double mnninc_pc_pasty_ppp    = mnninc_pasty_ppp_eur/npopul

sum  mnninc_pc_pasty_ppp if region1=="WO"
loc mean3=r(mean)
gen double mnninc_pc_pasty_ppp_sh = 100*mnninc_pc_pasty_ppp/`mean3' 

*Format for Excel
replace npopul=npopul/1000000
replace mnninc_pasty_ppp_eur=mnninc_pasty_ppp_eur/1000000000

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname npopul npopul_sh mnninc_pasty_ppp_eur mnninc_pasty_ppp_eur_sh mnninc_pc_pasty_ppp mnninc_pc_pasty_ppp_sh 
order shortname npopul npopul_sh mnninc_pasty_ppp_eur mnninc_pasty_ppp_eur_sh mnninc_pc_pasty_ppp mnninc_pc_pasty_ppp_sh	

export excel using "$output", sheet("DataT1", modify) cell(B5) keepcellfmt 


**# Table 1 PPPMER
/*------------------------------------------------------------------------------
Table 1 PPP MER. National income by world regions PPPMER (2024)
------------------------------------------------------------------------------*/
use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear

keep country region1 npopul mnninc_pasty_ppp_eur mnninc_mer_eur mnninc_pasty_ppp_usd mnninc_mer_usd order

*Compute for world
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	sum  mnninc_`v' if country=="WO"
	loc mean=r(mean)
	gen  double mnninc_`v'_sh=100*mnninc_`v'/`mean'
	
}

*Compute for regions	
collapse (sum) npopul mnninc_pasty_ppp_eur mnninc_mer_eur mnninc_pasty_ppp_eur_sh mnninc_mer_eur_sh mnninc_pasty_ppp_usd mnninc_mer_usd  mnninc_pasty_ppp_usd_sh mnninc_mer_usd_sh , by(region1 order)

*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mnninc_`v' = mnninc_`v' /1000000000
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname  mnninc_pasty_ppp_eur mnninc_pasty_ppp_eur_sh mnninc_mer_eur mnninc_mer_eur_sh  mnninc_pasty_ppp_usd mnninc_pasty_ppp_usd_sh mnninc_mer_usd mnninc_mer_usd_sh 
order  shortname  mnninc_pasty_ppp_eur mnninc_pasty_ppp_eur_sh mnninc_mer_eur mnninc_mer_eur_sh  mnninc_pasty_ppp_usd mnninc_pasty_ppp_usd_sh mnninc_mer_usd mnninc_mer_usd_sh 

export excel using "$output", sheet("DataT2", modify) cell(B5) keepcellfmt
*export excel using "$output", sheet("DataT1_PPPMER", modify) cell(B5) keepcellfmt


**# Table 1 average PPPMER
//------------------------------------------------------------------------------
//   Table 1. National income by world regions average PPPMER(2024)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear
keep country region1 npopul mnninc_pasty_ppp_eur mnninc_mer_eur mnninc_pasty_ppp_usd mnninc_mer_usd order

*Compute for world
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	sum  mnninc_`v' if country=="WO"
	loc mean=r(mean)
	gen  double mnninc_`v'_sh=100*mnninc_`v'/`mean' 	
}

*Compute for regions	
collapse (sum)  npopul mnninc_pasty_ppp_eur mnninc_mer_eur mnninc_pasty_ppp_eur_sh mnninc_mer_eur_sh mnninc_pasty_ppp_usd mnninc_mer_usd  mnninc_pasty_ppp_usd_sh mnninc_mer_usd_sh, by(region1 order)

foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen double mnninc_pc_`v'    = mnninc_`v'/npopul

	sum  mnninc_pc_`v' if region1=="WO"
	gen double mnninc_pc_`v'_sh = 100*mnninc_pc_`v'/r(mean)
}


*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mnninc_`v'=mnninc_`v'/1000000000
}

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname mnninc_pc_pasty_ppp_eur mnninc_pc_pasty_ppp_eur_sh mnninc_pc_mer_eur mnninc_pc_mer_eur_sh mnninc_pc_pasty_ppp_usd mnninc_pc_pasty_ppp_usd_sh mnninc_pc_mer_usd mnninc_pc_mer_usd_sh
order shortname mnninc_pc_pasty_ppp_eur mnninc_pc_pasty_ppp_eur_sh mnninc_pc_mer_eur mnninc_pc_mer_eur_sh mnninc_pc_pasty_ppp_usd mnninc_pc_pasty_ppp_usd_sh mnninc_pc_mer_usd mnninc_pc_mer_usd_sh

*export excel using "$output", sheet("DataT1_averagePPPMER", modify) cell(B5) keepcellfmt 
export excel using "$output", sheet("DataT2a", modify) cell(B5) keepcellfmt 
**# Table 1 GDP PPPMER
/*------------------------------------------------------------------------------
Table 1 PPP MER. Gross Domestic Product by world regions PPPMER (2024)
------------------------------------------------------------------------------*/
use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear

keep country region1 npopul mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd order

*Compute for world
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	sum  mgdpro_`v' if country=="WO"
	loc mean=r(mean)
	gen  double mgdpro_`v'_sh=100*mgdpro_`v'/`mean'
	
}

*Compute for regions	
collapse (sum) npopul mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_eur_sh mgdpro_mer_eur_sh mgdpro_pasty_ppp_usd mgdpro_mer_usd  mgdpro_pasty_ppp_usd_sh mgdpro_mer_usd_sh , by(region1 order)

*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mgdpro_`v' = mgdpro_`v' /1000000000
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname  mgdpro_pasty_ppp_eur mgdpro_pasty_ppp_eur_sh mgdpro_mer_eur mgdpro_mer_eur_sh  mgdpro_pasty_ppp_usd mgdpro_pasty_ppp_usd_sh mgdpro_mer_usd mgdpro_mer_usd_sh 
order  shortname  mgdpro_pasty_ppp_eur mgdpro_pasty_ppp_eur_sh mgdpro_mer_eur mgdpro_mer_eur_sh  mgdpro_pasty_ppp_usd mgdpro_pasty_ppp_usd_sh mgdpro_mer_usd mgdpro_mer_usd_sh 

*export excel using "$output", sheet("DataT1_GDPPPPMER", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT3", modify) cell(B5) keepcellfmt
**# Table 1 GDP average PPPMER
//------------------------------------------------------------------------------
//   Table 1. Gross Domestic Product by world regions average PPPMER(2024)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear
keep country region1 npopul mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd order

*Compute for world
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	sum  mgdpro_`v' if country=="WO"
	loc mean=r(mean)
	gen  double mgdpro_`v'_sh=100*mgdpro_`v'/`mean' 	
}

*Compute for regions	
collapse (sum)  npopul mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_eur_sh mgdpro_mer_eur_sh mgdpro_pasty_ppp_usd mgdpro_mer_usd  mgdpro_pasty_ppp_usd_sh mgdpro_mer_usd_sh, by(region1 order)

foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen double mgdpro_pc_`v'    = mgdpro_`v'/npopul

	sum  mgdpro_pc_`v' if region1=="WO"
	gen double mgdpro_pc_`v'_sh = 100*mgdpro_pc_`v'/r(mean)
}


*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mgdpro_`v'=mgdpro_`v'/1000000000
}

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname mgdpro_pc_pasty_ppp_eur mgdpro_pc_pasty_ppp_eur_sh mgdpro_pc_mer_eur mgdpro_pc_mer_eur_sh mgdpro_pc_pasty_ppp_usd mgdpro_pc_pasty_ppp_usd_sh mgdpro_pc_mer_usd mgdpro_pc_mer_usd_sh
order shortname mgdpro_pc_pasty_ppp_eur mgdpro_pc_pasty_ppp_eur_sh mgdpro_pc_mer_eur mgdpro_pc_mer_eur_sh mgdpro_pc_pasty_ppp_usd mgdpro_pc_pasty_ppp_usd_sh mgdpro_pc_mer_usd mgdpro_pc_mer_usd_sh

*export excel using "$output", sheet("DataT1_GDPaveragePPPMER", modify) cell(B5) keepcellfmt 
export excel using "$output", sheet("DataT3a", modify) cell(B5) keepcellfmt 



**# Table 1b
//------------------------------------------------------------------------------
// Table 1b. National Income by World Region (2021): New PPP (ICP 2021) vs Old PPP (ICP 2017)
//------------------------------------------------------------------------------
import excel using "$root/raw-data/ppp_comparison__1.xlsx",clear firstrow
ren iso country
drop year
ren ppp_new ppp2021_icp2021_usd
ren ppp_old ppp2021_icp2017_usd
drop ratio
merge 1:m country using "$work_data/main_dataset.dta"

keep if year==2021
*ppp_usd = ppp2021_icp2021_usd
br year country  ppp_eur ppp_usd ppp_eur ppp_usd ppp2021_icp2021_usd ppp2021_icp2017_usd
gen mnninc_ppp_2021_usd_icp2021=(mnninc/ppp2021_icp2021_usd)
gen mnninc_ppp_2021_usd_icp2017=mnninc/ppp2021_icp2017_usd
keep country region1 npopul mnninc_ppp_2021_usd_icp2021 mnninc_ppp_2021_usd_icp2017 order

// drop if countr=="SS"
drop if country=="WO"
*Compute for world
preserve
	collapse (sum) mnninc_ppp_2021_usd_icp2021 mnninc_ppp_2021_usd_icp2017 npopul
	gen region1="WO"
	gen mnninc_ppp_2021_usd_icp2021_pc=mnninc_ppp_2021_usd_icp2021/npopul
	gen mnninc_ppp_2021_usd_icp2017_pc=mnninc_ppp_2021_usd_icp2017/npopul
	keep region mnninc_ppp_2021_usd_icp2021_pc mnninc_ppp_2021_usd_icp2017_pc
	tempfile world_2021_ICP
	save `world_2021_ICP'
restore

collapse (sum) mnninc_ppp_2021_usd_icp2021 mnninc_ppp_2021_usd_icp2017 npopul, by(region order)
sort order
drop if region1=="WO"
gen mnninc_ppp_2021_usd_icp2021_pc=mnninc_ppp_2021_usd_icp2021/npopul
gen mnninc_ppp_2021_usd_icp2017_pc=mnninc_ppp_2021_usd_icp2017/npopul
keep region mnninc_ppp_2021_usd_icp2021_pc mnninc_ppp_2021_usd_icp2017_pc
append using  "`world_2021_ICP'"


sum  mnninc_ppp_2021_usd_icp2021 if region1=="WO"
loc mean=r(mean)
gen double mnninc_ppp_2021_usd_icp2021_sh=100*mnninc_ppp_2021_usd_icp2021/`mean'
	
sum  mnninc_ppp_2021_usd_icp2017 if region1=="WO"
loc mean=r(mean)
gen double mnninc_ppp_2021_usd_icp2017_sh=100*mnninc_ppp_2021_usd_icp2017/`mean'	

gen double ratio_2021_2017=mnninc_ppp_2021_usd_icp2021_pc   /   mnninc_ppp_2021_usd_icp2017_pc	

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order

order 	shortname mnninc_ppp_2021_usd_icp2021_pc mnninc_ppp_2021_usd_icp2021_sh mnninc_ppp_2021_usd_icp2017_pc  mnninc_ppp_2021_usd_icp2017_sh ratio_2021_2017


*export excel using "$output", sheet("DataT1b", modify) cell(B5) keepcellfmt 
export excel using "$output", sheet("DataT4", modify) cell(B5) keepcellfmt 


**# Table 1b Euro
/*------------------------------------------------------------------------------
Table 1b. National Income by World Region (2021): New PPP (ICP 2021) vs Old PPP (ICP 2017)
------------------------------------------------------------------------------*/
/*
use "$root/raw-data/PPPEUR_2023_ICP207.dta",clear
tab widcode
ren iso country
sort country

merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(corecountry)
keep if (corecountry==1 | country=="WO")
duplicates report country
drop year
ren value ppp2023_icp2017_eur

keep country  ppp2023_icp2017_eur
merge 1:m country  using "$work_data/main_dataset.dta"
tab country if _merge==2


keep if year==$pastyear
*ppp_usd = ppp2021_icp2021_usd
br year country   ppp_eur  ppp2023_icp2017_eur 
ren ppp_eur ppp2023_icp2021_eur
gen mnninc_ppp_icp2021=(mnninc/ppp2023_icp2021_eur)
gen mnninc_ppp_icp2017=mnninc/ppp2023_icp2017_eur 

*Save for table 1c
keep country region1 npopul mnninc_ppp_icp2021 mnninc_ppp_icp2017 order ppp2023_icp2017_eur ppp2023_icp2021_eur
save "$work_data\mnninc_pppicp_2017_2021.dta", replace

keep country region1 npopul mnninc_ppp_icp2021 mnninc_ppp_icp2017 order

// drop if countr=="SS"
drop if country=="WO"

*Compute for world
preserve
	collapse (sum) mnninc_ppp_icp2021 mnninc_ppp_icp2017 npopul
	gen region1="WO"
	gen mnninc_ppp_icp2021_pc=mnninc_ppp_icp2021 /npopul
	gen mnninc_ppp_icp2017_pc=mnninc_ppp_icp2017/npopul
	keep region mnninc_ppp_icp2021_pc mnninc_ppp_icp2017_pc
	save "$work_data\temp_world_2021_ICP.dta", replace
restore

collapse (sum) mnninc_ppp_icp2021 mnninc_ppp_icp2017 npopul, by(region order)
sort order
drop if region=="World"
gen mnninc_ppp_icp2021_pc=mnninc_ppp_icp2021 /npopul
gen mnninc_ppp_icp2017_pc=mnninc_ppp_icp2017/npopul
keep region mnninc_ppp_icp2021_pc mnninc_ppp_icp2017_pc
append using  "$work_data\temp_world_2021_ICP.dta"
cap erase "$work_data\temp_world_2021_ICP.dta"

sum  mnninc_ppp_icp2021_pc if region1=="WO"
loc mean=r(mean)
gen double mnninc_ppp_icp2021_pc_sh=100*mnninc_ppp_icp2021_pc/`mean'
	
sum  mnninc_ppp_icp2017_pc if region1=="WO"
loc mean=r(mean)
gen double mnninc_ppp_icp2017_pc_sh=100*mnninc_ppp_icp2017_pc/`mean'	

gen double ratio_2021_2017=mnninc_ppp_icp2021_pc   /   mnninc_ppp_icp2017_pc	

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order 	shortname mnninc_ppp_icp2021_pc mnninc_ppp_icp2021_pc_sh mnninc_ppp_icp2017_pc  mnninc_ppp_icp2017_pc_sh ratio_2021_2017

export excel using "$output", sheet("DataT1b2", modify) cell(B5) keepcellfmt 
*/

**# Table 1c Euro
/*------------------------------------------------------------------------------
Table 1c. National-Income-Weighted Average Euro Price Index (2023)
------------------------------------------------------------------------------*/
*import excel using "$root\raw-data\weights_pppeuros.xlsx",clear firstrow
*ren iso country


*use "$work_data/main_dataset.dta", clear
*keep if year==$pastyear
*keep country year xlceup mnninc
*keep if inlist(country, "AD", "AT", "BE", "CY", "DE", "EE", "ES", "FI", "FR") | ///
		inlist(country, "GR", "HR", "IE", "IT", "KS", "LT", "LU", "LV", "MC") | ///
		inlist(country, "ME", "MT", "NL", "PT", "SI", "SK", "SM")
*egen totalincome=total(mnninc)
*gen double weight=mnninc/totalincome

*merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
**# Bookmark #5

*keep if _merge==3 | country=="KS"
*replace countryname="Kosovo" if country=="KS" //*KS;Kosovo;Kosovo;Europe;Eastern Europe	
*keep countryname year weight country 
*order countryname year weight
*merge 1:1 country using "$work_data\mnninc_pppicp_2017_2021.dta"
*keep if _merge==3
*order countryname year weight mnninc_ppp_icp2021 mnninc_ppp_icp2017  ppp2023_icp2021_eur ppp2023_icp2017_eur 
*keep countryname year weight mnninc_ppp_icp2021 mnninc_ppp_icp2017 ppp2023_icp2021_eur ppp2023_icp2017_eur 
*foreach var in 2021 2017{
*		replace mnninc_ppp_icp`var'=mnninc_ppp_icp`var'/1000000000
*}

*export excel using "$output", sheet("T1c", modify) cell(B5) keepcellfmt 


**# Table 2 PPPEUR
/*------------------------------------------------------------------------------
Table 2. Per capita national income growth by world regions (1980-2023)
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$pastyear )
keep country region1 mnninc_pasty_ppp_eur npopul year

collapse (sum) mnninc_pasty_ppp_eur npopul, by(region year)

gen double  mnninc_pc_pasty_ppp=mnninc_pasty_ppp_eur/npopul
drop mnninc_pasty_ppp_eur npopul

reshape wide mnninc_pc_pasty_ppp, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_pasty_ppp`region'
		sum mnninc_pc_pasty_ppp`region' if year==$pastyear
		loc tf=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(mnninc_pc_pasty_ppp`region'/L.mnninc_pc_pasty_ppp`region'-1)
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen mnninc_pc_pasty_ppp1800=`to'
		gen mnninc_pc_pasty_ppp1980=`ti'
		gen mnninc_pc_pasty_ppp$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region mnninc_pc_pasty_ppp1800 mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg1'"
		save`temp_reg1', replace
	restore
}

use "`temp_reg1'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
*export excel using "$output", sheet("DataT2", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT5a", modify) cell(B5) keepcellfmt

**# Table 2 USDPPP
/*------------------------------------------------------------------------------
Table 2. Per capita national income growth by world regions (1980-2023) USD PPP
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$pastyear )
keep country region1 mnninc_pasty_ppp_usd npopul year

collapse (sum) mnninc_pasty_ppp_usd npopul, by(region year)

gen double  mnninc_pc_pasty_ppp=mnninc_pasty_ppp_usd/npopul
drop mnninc_pasty_ppp_usd npopul

reshape wide mnninc_pc_pasty_ppp, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_pasty_ppp`region'
		sum mnninc_pc_pasty_ppp`region' if year==$pastyear
		loc tf=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(mnninc_pc_pasty_ppp`region'/L.mnninc_pc_pasty_ppp`region'-1)
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen mnninc_pc_pasty_ppp1800=`to'
		gen mnninc_pc_pasty_ppp1980=`ti'
		gen mnninc_pc_pasty_ppp$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region mnninc_pc_pasty_ppp1800 mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg2'"
		save`temp_reg2', replace
	restore
}

use "`temp_reg2'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
*export excel using "$output", sheet("DataT2_USDPPP", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT5b", modify) cell(B5) keepcellfmt


**# Table 2 EURMER
/*------------------------------------------------------------------------------
Table 2. Per capita national income growth by world regions (1980-2023) EUR MER
------------------------------------------------------------------------------*/
use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$pastyear )
keep country region1 mnninc_mer_eur_con npopul year

collapse (sum) mnninc_mer_eur npopul, by(region year)

gen double  mnninc_pc_mer=mnninc_mer_eur/npopul
drop mnninc_mer_eur npopul

reshape wide mnninc_pc_mer, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_mer`region'
		sum mnninc_pc_mer`region' if year==$pastyear
		loc tf=r(mean)
		sum mnninc_pc_mer`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_mer`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(mnninc_pc_mer`region'/L.mnninc_pc_mer`region'-1)
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen mnninc_pc_mer1800=`to'
		gen mnninc_pc_mer1980=`ti'
		gen mnninc_pc_mer$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region mnninc_pc_mer1800 mnninc_pc_mer1980 mnninc_pc_mer$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg3'"
		save`temp_reg3', replace
	restore
}

use "`temp_reg3'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
*export excel using "$output", sheet("DataT2_EURMER", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT5c", modify) cell(B5) keepcellfmt

**# Table 2 USDMER
/*------------------------------------------------------------------------------
Table 2. Per capita national income growth by world regions (1980-2023) EUR MER
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$pastyear )
keep country region1 mnninc_mer_usd_con npopul year

collapse (sum) mnninc_mer_usd npopul, by(region year)

gen double  mnninc_pc_mer=mnninc_mer_usd/npopul
drop mnninc_mer_usd npopul

reshape wide mnninc_pc_mer, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_mer`region'
		sum mnninc_pc_mer`region' if year==$pastyear
		loc tf=r(mean)
		sum mnninc_pc_mer`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_mer`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(mnninc_pc_mer`region'/L.mnninc_pc_mer`region'-1)
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen mnninc_pc_mer1800=`to'
		gen mnninc_pc_mer1980=`ti'
		gen mnninc_pc_mer$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region mnninc_pc_mer1800 mnninc_pc_mer1980 mnninc_pc_mer$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg4'"
		save`temp_reg4', replace
	restore
}

use "`temp_reg4'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
*export excel using "$output", sheet("DataT2_USDMER", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT5d", modify) cell(B5) keepcellfmt

**# Table 2 Continents
/*------------------------------------------------------------------------------
Table 2. Per capita national income growth for Regions (1980-2023)
------------------------------------------------------------------------------*/

use "$work_data/coreterritories_dataset.dta", clear
levelsof region1, local(regiones)

foreach r of local regiones {
	clear all
	
	tempfile temp_`r'
	save    `temp_`r'', emptyok
	
	use "$work_data/coreterritories_dataset.dta", clear
	
	keep if (region1=="`r'")
	keep country region1 mnninc_pasty_ppp_eur npopul year
	gen double  mnninc_pc_pasty_ppp=mnninc_pasty_ppp_eur/npopul
	drop mnninc_pasty_ppp_eur npopul region
	levelsof country, local(countries)
		
	reshape wide mnninc_pc_pasty_ppp, i(year) j(country) string
		
	*Compute
	foreach c of local countries {
		preserve
			keep year mnninc_pc_pasty_ppp`c'
			sum mnninc_pc_pasty_ppp`c' if year==$pastyear
			loc tf=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==1980
			loc ti=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==1800
			loc to=r(mean)

			tsset year
			g annual_growth=100*(mnninc_pc_pasty_ppp`c'/L.mnninc_pc_pasty_ppp`c'-1)

			sum annual_growth if inrange(year,1800,$pastyear )
			loc growth1800_$pastyear =r(mean)
			sum annual_growth if inrange(year,1980,$pastyear )
			loc growth1980_$pastyear =r(mean)
			sum annual_growth if inrange(year,1980,2000)
			loc growth1980_2000=r(mean)
			sum annual_growth if inrange(year,2000,$pastyear )
			loc growth2000_$pastyear =r(mean)
			sum annual_growth if inrange(year,2019,$pastyear )
			loc growth2019_$pastyear =r(mean)

				
			gen region="`c'"
			gen mnninc_pc_pasty_ppppc1800=`to'
			gen mnninc_pc_pasty_ppppc1980=`ti'
			gen mnninc_pc_pasty_ppppc$pastyear =`tf'
			gen growth1800_$pastyear = `growth1800_$pastyear'
			gen growth1980_$pastyear =`growth1980_$pastyear'
			gen growth1980_2000=`growth1980_2000'
			gen growth2000_$pastyear =`growth2000_$pastyear'
			gen growth2019_$pastyear =`growth2019_$pastyear '
	
			keep region mnninc_pc_pasty_ppppc1800 mnninc_pc_pasty_ppppc1980 mnninc_pc_pasty_ppppc$pastyear  growth1800_$pastyear growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear
			duplicates drop
				
			append using "`temp_`r''"
			save`temp_`r'', replace
		restore
		}
	*Append in exporting format
	use  "`temp_`r''", clear

	ren region country
	merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname region1)
	
	replace region1="XR" if missing(region1) & country=="OA"
	replace region1="QL" if missing(region1) & country=="OB"
	replace region1="QE" if missing(region1) & country=="OC"
	replace region1="XL" if missing(region1) & country=="OD"
	replace region1="XN" if missing(region1) & country=="OE"
	replace region1="XB" if missing(region1) & country=="OH"
	replace region1="XS" if missing(region1) & country=="OI"
	replace region1="XF" if missing(region1) & country=="OJ"
	replace region1="XB" if missing(region1) & country=="OK"
	replace region1="XB" if missing(region1) & country=="OL"
	replace region1="QE" if missing(region1) & country=="QM"
	replace region1="WO" if missing(region1) & country=="WO"
	
	replace shortname="Other Russia & Central Asia"	 	if missing(shortname) & country=="OA"
	replace shortname="Other East Asia" 				if missing(shortname) & country=="OB"
	replace shortname="Other Western Europe" 			if missing(shortname) & country=="OC"
	replace shortname="Other Latin America" 			if missing(shortname) & country=="OD"
	replace shortname="Other MENA" 						if missing(shortname) & country=="OE"
	replace shortname="Other North America & Oceania" 	if missing(shortname) & country=="OH"
	replace shortname="Other South & South-East Asia" 	if missing(shortname) & country=="OI"
	replace shortname="Other Sub-Saharan Africa" 		if missing(shortname) & country=="OJ"
	replace shortname="Other North America" 			if missing(shortname) & country=="OK"
	replace shortname="Other Oceania" 					if missing(shortname) & country=="OL"
	replace shortname="Eastern Europe" 					if missing(shortname) & country=="QM"
	replace shortname="World" 							if missing(shortname) & country=="WO"
	rename shortname countryname
	
	merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(match master) keepusing(shortname order)
	rename shortname regionname
	order  regionname countryname mnninc_pc_pasty_ppppc1800 mnninc_pc_pasty_ppppc1980 mnninc_pc_pasty_ppppc$pastyear growth1800_$pastyear growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear
	keep regionname countryname mnninc_pc_pasty_ppppc1800 mnninc_pc_pasty_ppppc1980 mnninc_pc_pasty_ppppc$pastyear  growth1800_$pastyear  growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear  order
	
	
	
	append using "`temp_asi'"
	save "`temp_asi'", replace
	*export excel using "$output", sheet("T2_`r'", modify) cell(B5) keepcellfmt 
 }

u "`temp_asi'", clear
gsort order  -mnninc_pc_pasty_ppppc$pastyear
drop order
export excel using "$output", sheet("DataT6", modify) cell(B5) keepcellfmt 


**# Table 3
/*------------------------------------------------------------------------------
Table 3. Per Capita National Income by World Regions (1800-2023)
------------------------------------------------------------------------------*/

*Import data
use "$work_data/coreterritories_dataset.dta",clear
keep country year mnninc ppp_eur npopul 

replace mnninc=mnninc/ppp
replace mnninc= mnninc/npopul
drop ppp npopul
sort country year

reshape wide mnninc,i(year) j(country) string

keep year *WO *QE *XB *XL *XN *XF *XR *QL *XS


*Compute
foreach region in WO QE XB XL XN XF XR QL XS {
	preserve
		keep year mnninc`region'
		sum mnninc`region' if year==$pastyear
		loc mnninc$pastyear = r(mean)
		sum mnninc`region' if year==1800
		loc mnninc1800 		= r(mean)
		
		loc ratio=`mnninc$pastyear'/`mnninc1800'
		
		tsset year
		gen annual_growth=100*(mnninc`region'/L.mnninc`region'-1)

		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1800,1910)
		loc growth1800_1910 	 =r(mean)
		sum annual_growth if inrange(year,1910,$pastyear )
		loc growth1910_$pastyear =r(mean)
		sum annual_growth if inrange(year,1910,1950)
		loc growth1910_1950 	 =r(mean)
		sum annual_growth if inrange(year,1950,1990)
		loc growth1950_1990 	 =r(mean)
		sum annual_growth if inrange(year,1990,$pastyear )
		loc growth1990_$pastyear =r(mean)	
		
		gen region1="`region'"
		gen mnnincpc1980 			= `mnninc1800'
		gen mnnincpc$pastyear 		= `mnninc$pastyear'
		gen ratio					= `ratio'
		gen growth1800_$pastyear 	= `growth1800_$pastyear'
		gen growth1800_1910		 	= `growth1800_1910'
		gen growth1910_$pastyear 	= `growth1910_$pastyear'
		gen growth1910_1950			= `growth1910_1950'
		gen growth1950_1990			= `growth1950_1990'
		gen growth1990_$pastyear 	= `growth1990_$pastyear'
		keep region mnnincpc1980 mnnincpc$pastyear ratio growth1800_$pastyear growth1800_1910 growth1910_$pastyear growth1910_1950 growth1950_1990 growth1990_$pastyear 
		duplicates drop
		
		append using "`temp_reg5'"
		save "`temp_reg5'", replace
	restore
}

*Append in exporting format
use "`temp_reg5'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname


// *Export
*export excel using "$output", sheet("DataT3", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT7", modify) cell(B5) keepcellfmt


	
**# Table 4
/*------------------------------------------------------------------------------
Table 4. Population by World Regions (1800-2023)
------------------------------------------------------------------------------*/

*Import data
use "$work_data/coreterritories_dataset.dta",clear
keep country year npopul
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
reshape wide npopul, i(year) j(country) string

*Compute
foreach region in WO QE XB XL XN XF XR QL XS{
	preserve
		keep year npopul`region'
		sum npopul`region' if year==$pastyear
		loc npopul$pastyear =r(mean)
		sum npopul`region' if year==1800
		loc npopul1800=r(mean)
		
		loc ratio=`npopul$pastyear'/`npopul1800'
		
		tsset year
		g annual_growth=100*(npopul`region'/L.npopul`region'-1)

		sum annual_growth if inrange(year,1800,$pastyear)
		loc growth1800_$pastyear=r(mean)
		sum annual_growth if inrange(year,1800,1910)
		loc growth1800_1910=r(mean)
		sum annual_growth if inrange(year,1910,$pastyear)
		loc growth1910_$pastyear =r(mean)
		sum annual_growth if inrange(year,1910,1950)
		loc growth1910_1950=r(mean)
		sum annual_growth if inrange(year,1950,1990)
		loc growth1950_1990=r(mean)
		sum annual_growth if inrange(year,1990,$pastyear)
		loc growth1990_$pastyear =r(mean)	

		g region1="`region'"
		g npopulpc1980=`npopul1800'/1000000
		g npopulpc$pastyear =`npopul$pastyear'/1000000
		g ratio=`ratio'
		g growth1800_$pastyear =`growth1800_$pastyear'
		g growth1800_1910=`growth1800_1910'
		g growth1910_$pastyear =`growth1910_$pastyear'
		g growth1910_1950=`growth1910_1950'
		g growth1950_1990=`growth1950_1990'
		g growth1990_$pastyear =`growth1990_$pastyear'
		keep region npopulpc1980 npopulpc$pastyear ratio growth1800_$pastyear growth1800_1910 growth1910_$pastyear growth1910_1950 growth1950_1990 growth1990_$pastyear
		duplicates drop
		
		append using "`temp_reg6'"
		save "`temp_reg6'", replace
	restore
}

*Append in exporting format
use "`temp_reg6'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
*export excel using "$output", sheet("DataT4", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT8", modify) cell(B5) keepcellfmt

	
**# Table 5 EUR PPP 
/*------------------------------------------------------------------------------
Table 5. Price index growth by world regions (1980-2023) EUR PPP
------------------------------------------------------------------------------*/

use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyeup
reshape wide inyeup, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		
		sum inyeup`region' if year==$pastyear
		loc tf=r(mean)
		sum inyeup`region' if year==1980
		loc ti=r(mean)
		sum inyeup`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(inyeup`region'/L.inyeup`region'-1)
		/*
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		*/
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen inyeup1800=`to'
		gen inyeup1980=`ti'
		gen inyeup$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region inyeup1800 inyeup1980 inyeup$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg7'"
		save`temp_reg7', replace
	restore
}

use "`temp_reg7'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
export excel using "$output", sheet("DataT9a", modify) cell(B5) keepcellfmt

	
**# Table 5 USD PPP 
/*------------------------------------------------------------------------------
Table 5. Price index growth by world regions (1980-2023) USD PPP
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyusp
reshape wide inyusp, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		
		sum inyusp`region' if year==$pastyear
		loc tf=r(mean)
		sum inyusp`region' if year==1980
		loc ti=r(mean)
		sum inyusp`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(inyusp`region'/L.inyusp`region'-1)
		/*
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		*/
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen inyusp1800=`to'
		gen inyusp1980=`ti'
		gen inyusp$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region inyusp1800 inyusp1980 inyusp$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg8'"
		save`temp_reg8', replace
	restore
}

use "`temp_reg8'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
export excel using "$output", sheet("DataT9b", modify) cell(B5) keepcellfmt

	

**# Table 5 EUR MER 
/*------------------------------------------------------------------------------
Table 5. Price index growth by world regions (1980-2023) EUR MER
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyeux
reshape wide inyeux, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		
		sum inyeux`region' if year==$pastyear
		loc tf=r(mean)
		sum inyeux`region' if year==1980
		loc ti=r(mean)
		sum inyeux`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(inyeux`region'/L.inyeux`region'-1)
		/*
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		*/
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen inyeux1800=`to'
		gen inyeux1980=`ti'
		gen inyeux$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region inyeux1800 inyeux1980 inyeux$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg9'"
		save`temp_reg9', replace
	restore
}

use "`temp_reg9'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
export excel using "$output", sheet("DataT9c", modify) cell(B5) keepcellfmt


**# Table 5 USD MER 
/*------------------------------------------------------------------------------
Table 5. Price index growth by world regions (1980-2023) USD MER
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyusx
reshape wide inyusx, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		
		sum inyusx`region' if year==$pastyear
		loc tf=r(mean)
		sum inyusx`region' if year==1980
		loc ti=r(mean)
		sum inyusx`region' if year==1800
		loc to=r(mean)
		
		tsset year
		g annual_growth=100*(inyusx`region'/L.inyusx`region'-1)
		/*
		forv x=2020/$pastyear{
			sum annual_growth if year==`x'
		}
		*/
		
		sum annual_growth if inrange(year,1800,$pastyear )
		loc growth1800_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,$pastyear )
		loc growth1980_$pastyear =r(mean)
		sum annual_growth if inrange(year,1980,2000)
		loc growth1980_2000=r(mean)
		sum annual_growth if inrange(year,2000,$pastyear )
		loc growth2000_$pastyear =r(mean)
		sum annual_growth if inrange(year,2019,$pastyear )
		loc growth2019_$pastyear =r(mean)

		gen region1="`region'"
		gen inyusx1800=`to'
		gen inyusx1980=`ti'
		gen inyusx$pastyear =`tf'
		gen growth1800_$pastyear =`growth1800_$pastyear '
		gen growth1980_$pastyear =`growth1980_$pastyear '
		gen growth1980_2000      =`growth1980_2000'
		gen growth2000_$pastyear =`growth2000_$pastyear '
		gen growth2019_$pastyear =`growth2019_$pastyear '

		keep region inyusx1800 inyusx1980 inyusx$pastyear  growth1800_$pastyear growth1980_$pastyear  growth1980_2000 growth2000_$pastyear  growth2019_$pastyear  
		duplicates drop
		
		append using "`temp_reg10'"
		save`temp_reg10', replace
	restore
}

use "`temp_reg10'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname

*Export
export excel using "$output", sheet("DataT9d", modify) cell(B5) keepcellfmt



**# Table 5 Continents
/*------------------------------------------------------------------------------
Table 5. Price index growth by world regions (1980-2023) USD MER
------------------------------------------------------------------------------*/

use "$work_data/coreterritories_dataset.dta", clear
levelsof region1, local(regiones)

foreach r of local regiones {
	clear all
	
	tempfile temp_`r'
	save    `temp_`r'', emptyok
	
	use "$work_data/coreterritories_dataset.dta", clear
	
	keep if (region1=="`r'")
	keep country region1 inyusx year
	levelsof country, local(countries)
		
	reshape wide inyusx, i(year) j(country) string
		
	*Compute
	foreach c of local countries {
		preserve
			keep year inyusx`c'
			sum inyusx`c' if year==$pastyear
			loc tf=r(mean)
			sum inyusx`c' if year==1980
			loc ti=r(mean)
			sum inyusx`c' if year==1800
			loc to=r(mean)

			tsset year
			g annual_growth=100*(inyusx`c'/L.inyusx`c'-1)

			sum annual_growth if inrange(year,1800,$pastyear )
			loc growth1800_$pastyear =r(mean)
			sum annual_growth if inrange(year,1980,$pastyear )
			loc growth1980_$pastyear =r(mean)
			sum annual_growth if inrange(year,1980,2000)
			loc growth1980_2000=r(mean)
			sum annual_growth if inrange(year,2000,$pastyear )
			loc growth2000_$pastyear =r(mean)
			sum annual_growth if inrange(year,2019,$pastyear )
			loc growth2019_$pastyear =r(mean)
				
			gen region="`c'"
			gen inyusx1800=`to'
			gen inyusx1980=`ti'
			gen inyusx$pastyear =`tf'
			gen growth1800_$pastyear = `growth1800_$pastyear'
			gen growth1980_$pastyear =`growth1980_$pastyear'
			gen growth1980_2000=`growth1980_2000'
			gen growth2000_$pastyear =`growth2000_$pastyear'
			gen growth2019_$pastyear =`growth2019_$pastyear '
			
			keep region inyusx1800 inyusx1980 inyusx$pastyear  growth1800_$pastyear growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear
			duplicates drop
				
			append using "`temp_`r''"
			save`temp_`r'', replace
		restore
		}
	*Append in exporting format
	use  "`temp_`r''", clear

	ren region country
	merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname region1)
	
	replace region1="XR" if missing(region1) & country=="OA"
	replace region1="QL" if missing(region1) & country=="OB"
	replace region1="QE" if missing(region1) & country=="OC"
	replace region1="XL" if missing(region1) & country=="OD"
	replace region1="XN" if missing(region1) & country=="OE"
	replace region1="XB" if missing(region1) & country=="OH"
	replace region1="XS" if missing(region1) & country=="OI"
	replace region1="XF" if missing(region1) & country=="OJ"
	replace region1="XB" if missing(region1) & country=="OK"
	replace region1="XB" if missing(region1) & country=="OL"
	replace region1="QE" if missing(region1) & country=="QM"
	replace region1="WO" if missing(region1) & country=="WO"
	
	replace shortname="Other Russia & Central Asia"	 	if missing(shortname) & country=="OA"
	replace shortname="Other East Asia" 				if missing(shortname) & country=="OB"
	replace shortname="Other Western Europe" 			if missing(shortname) & country=="OC"
	replace shortname="Other Latin America" 			if missing(shortname) & country=="OD"
	replace shortname="Other MENA" 						if missing(shortname) & country=="OE"
	replace shortname="Other North America & Oceania" 	if missing(shortname) & country=="OH"
	replace shortname="Other South & South-East Asia" 	if missing(shortname) & country=="OI"
	replace shortname="Other Sub-Saharan Africa" 		if missing(shortname) & country=="OJ"
	replace shortname="Other North America" 			if missing(shortname) & country=="OK"
	replace shortname="Other Oceania" 					if missing(shortname) & country=="OL"
	replace shortname="Eastern Europe" 					if missing(shortname) & country=="QM"
	replace shortname="World" 							if missing(shortname) & country=="WO"
	rename shortname countryname
	
	merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(match master) keepusing(shortname order)
	rename shortname regionname
	order  regionname countryname inyusx1800 inyusx1980 inyusx$pastyear growth1800_$pastyear growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear
	keep regionname countryname inyusx1800 inyusx1980 inyusx$pastyear  growth1800_$pastyear  growth1980_$pastyear growth1980_2000 growth2000_$pastyear growth2019_$pastyear order
	
	
	
	append using "`temp_asi2'"
	save "`temp_asi2'", replace
	*export excel using "$output", sheet("T2_`r'", modify) cell(B5) keepcellfmt 
 }

u "`temp_asi2'", clear
gsort order  -inyusx$pastyear
drop order
export excel using "$output", sheet("DataT10", modify) cell(B5) keepcellfmt 
