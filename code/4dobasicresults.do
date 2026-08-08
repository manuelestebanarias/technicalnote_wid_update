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
	

/*------------------------------------------------------------------------------
Figure 0a. Exchange Rate and Purchasing Power Parity: Euro/Dollar
------------------------------------------------------------------------------*/
*For robustness
use "$work_data/main_dataset.dta",clear
keep if inlist(country,"FR","DE")
collapse (mean) xlc* ppp_*, by(year)

gen MER_eur_usd  = xlceux / xlcusx
gen PPP_eur_usd = xlceup / xlcusp
tsset year
tsline MER_eur_usd PPP_eur_usd if inrange(year,1990,2012)


*For Figures
use "$work_data/main_dataset.dta",clear
keep country year xlceup xlceux xlcusp xlcusx xlcyup xlcyux 
// preserve
keep if inlist(country,"FR","DE")
collapse (mean) xlc*, by(year)

gen MER_eur_usd  = xlceux / xlcusx
gen PPP_eur_usd = xlceup / xlcusp
tsset year
tsline MER_eur_usd PPP_eur_usd if inrange(year,1990,2012)






/*------------------------------------------------------------------------------
Figure 0b. Exchange Rate and Purchasing Power Parity: Euro/Yuan
------------------------------------------------------------------------------*/
g MER_usd_yuan  = xlcusx / xlcyux
g PPP_usd_yuan = xlcusp / xlcyup

g MER_eur_yuan=MER_eur_usd*MER_usd_yuan
g PPP_eur_yuan=PPP_eur_usd*PPP_usd_yuan

tsline MER_eur_yuan PPP_eur_yuan if inrange(year,1990,$prev_year)
keep if year>=1990
order year MER_eur_usd PPP_eur_usd MER_eur_yuan PPP_eur_yuan
keep year MER_eur_usd PPP_eur_usd MER_eur_yuan PPP_eur_yuan
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



/*------------------------------------------------------------------------------
Figure 1. Per Capita National Income by World Region 1800-2023
------------------------------------------------------------------------------*/
use  "$work_data/coreterritories_dataset.dta", clear
keep country year mnninc_pasty_ppp_eur npopul 

rename mnninc_pasty_ppp_eur mnninc
replace mnninc= mnninc/npopul
drop  npopul


sort country year

reshape wide mnninc,i(year) j(country) string
rename mnninc* *

order year WO QE XB XL XN XF XR QL XS DE DK	ES	FR	GB	IT	NL	NO	SE	OC	QM	US	CA	AU	NZ	OH	AR	BR	CL	CO	MX	OD	AE	DZ	EG	IR	MA	SA	TR	OE	CD	CI	ET	KE	ML	NE	NG	RW	SD	ZA	OJ	RU	OA	CN	JP	KR	TW	OB	BD	IN	ID	MM	PK	PH	TH	VN	OI

export excel using "$output", sheet("DataF1", modify) cell(B5) keepcellfmt



/*------------------------------------------------------------------------------
Table 1. Gross domestic product by World Region USD-EUR (2025)
------------------------------------------------------------------------------*/
use  "$work_data/main_dataset.dta",clear
keep if year==$prev_year 

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
export excel using "$output", sheet("DataT1", modify) cell(B5) keepcellfmt


//------------------------------------------------------------------------------
//Table 1a. Per capita gross domestic product by World Region USD-EUR (2025)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
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
export excel using "$output", sheet("DataT1a", modify) cell(B5) keepcellfmt 



/*------------------------------------------------------------------------------
Table 2. Consumption of Fixed Capial by World Region USD-EUR (2025)
------------------------------------------------------------------------------*/


use "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
drop if country=="WO"

keep country region1 mconfc_pasty_ppp_eur mconfc_mer_eur mconfc_pasty_ppp_usd mconfc_mer_usd mgdpro* order

*Compute for world
preserve
	collapse (sum) mconfc_pasty_ppp_eur mconfc_mer_eur mconfc_pasty_ppp_usd mconfc_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd
	
	gen region1 ="WO"
	gen order= 9
	
	tempfile  world
	save     `world'
restore


collapse (sum) mconfc_pasty_ppp_eur mconfc_mer_eur mconfc_pasty_ppp_usd mconfc_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd, by(region1 order)

append using "`world'"
sort order


foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen  double mconfc_`v'_gdpsh=mconfc_`v'/mgdpro_`v'
	drop mgdpro_`v'
	
}


foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen aux = mconfc_`v' if region1=="WO"
	egen mconfc_`v'_wo = mode(aux)
	gen  double mconfc_`v'_sh_con=mconfc_`v'/mconfc_`v'_wo
	drop mconfc_`v'_wo aux
	
}



*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mconfc_`v' = mconfc_`v' /1000000000
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname  mconfc_pasty_ppp_eur mconfc_pasty_ppp_eur_gdpsh  mconfc_pasty_ppp_eur_sh mconfc_mer_eur mconfc_mer_eur_gdpsh  mconfc_mer_eur_sh  mconfc_pasty_ppp_usd mconfc_pasty_ppp_usd_sh mconfc_pasty_ppp_usd_gdpsh mconfc_mer_usd mconfc_mer_usd_gdpsh mconfc_mer_usd_sh 
order  shortname  mconfc_pasty_ppp_eur mconfc_pasty_ppp_eur_gdpsh  mconfc_pasty_ppp_eur_sh mconfc_mer_eur mconfc_mer_eur_gdpsh  mconfc_mer_eur_sh  mconfc_pasty_ppp_usd mconfc_pasty_ppp_usd_sh mconfc_pasty_ppp_usd_gdpsh mconfc_mer_usd mconfc_mer_usd_gdpsh mconfc_mer_usd_sh 

*export excel using "$output", sheet("DataT1_GDPPPPMER", modify) cell(B5) keepcellfmt
export excel using "$output", sheet("DataT2", modify) cell(B5) keepcellfmt

/*------------------------------------------------------------------------------
Table 3. National Income by World Region USD-EUR (2025)
------------------------------------------------------------------------------*/
use  "$work_data/main_dataset.dta",clear
keep if year==$prev_year 

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

export excel using "$output", sheet("DataT3", modify) cell(B5) keepcellfmt
*export excel using "$output", sheet("DataT1_PPPMER", modify) cell(B5) keepcellfmt




//------------------------------------------------------------------------------
//   Table 4. Per Capita National Income by World Region (2025)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
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

export excel using "$output", sheet("DataT4", modify) cell(B5) keepcellfmt 







//------------------------------------------------------------------------------
//   Table 4a. Per capita national Income by World Region USD-EUR (2025)
//------------------------------------------------------------------------------
use  "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
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
export excel using "$output", sheet("DataT4a", modify) cell(B5) keepcellfmt 




//------------------------------------------------------------------------------
// Table 3c. National Income by World Region (2021): New PPP (ICP 2021) vs Old PPP (ICP 2011)
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
*br year country  ppp_eur ppp_usd ppp_eur ppp_usd ppp2021_icp2021_usd ppp2021_icp2017_usd
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
export excel using "$output", sheet("DataT3c", modify) cell(B5) keepcellfmt 



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


keep if year==$prev_year
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
*keep if year==$prev_year
*keep country year xlceup mnninc
*keep if inlist(country, "AD", "AT", "BE", "CY", "DE", "EE", "ES", "FI", "FR") | ///
		inlist(country, "GR", "HR", "IE", "IT", "KS", "LT", "LU", "LV", "MC") | ///
		inlist(country, "ME", "MT", "NL", "PT", "SI", "SK", "SM")
*egen totalincome=total(mnninc)
*gen double weight=mnninc/totalincome

*merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)


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



/*------------------------------------------------------------------------------
Table 5a. Per Capita National Income Growth PPP 2025  € by World Regions (1800-2025) 
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear

keep country region1 region5 mnninc_pasty_ppp_eur npopul year

collapse (sum) mnninc_pasty_ppp_eur npopul, by(region1 year)


gen double  mnninc_pc_pasty_ppp = mnninc_pasty_ppp_eur/npopul
drop mnninc_pasty_ppp_eur npopul

reshape wide mnninc_pc_pasty_ppp, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_pasty_ppp`region'
		sum mnninc_pc_pasty_ppp`region' if year==$prev_year
		loc tf=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==2020
		loc tp=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==2000
		loc ts=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1800
		loc to=r(mean)
		

		gen region1="`region'"
		gen mnninc_pc_pasty_ppp1800=`to'
		gen mnninc_pc_pasty_ppp1980=`ti'
		gen mnninc_pc_pasty_ppp2000=`ts'
		gen mnninc_pc_pasty_ppp2020=`tp'
		gen mnninc_pc_pasty_ppp$prev_year =`tf'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region mnninc_pc_pasty_ppp1800  mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp2000 mnninc_pc_pasty_ppp2020 mnninc_pc_pasty_ppp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg1'"
		save `temp_reg1', replace
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
Table 5b. Per Capita National Income Growth PPP 2025  $  by World Regions (1800-2025) 
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$prev_year )
keep country region1 mnninc_pasty_ppp_usd npopul year

collapse (sum) mnninc_pasty_ppp_usd npopul, by(region year)

gen double  mnninc_pc_pasty_ppp=mnninc_pasty_ppp_usd/npopul
drop mnninc_pasty_ppp_usd npopul

reshape wide mnninc_pc_pasty_ppp, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_pasty_ppp`region'
		sum mnninc_pc_pasty_ppp`region' if year==$prev_year
		loc tf=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==2020
		loc tp=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==2000
		loc ts=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_pasty_ppp`region' if year==1800
		loc to=r(mean)
		

		gen region1="`region'"
		gen mnninc_pc_pasty_ppp1800=`to'
		gen mnninc_pc_pasty_ppp1980=`ti'
		gen mnninc_pc_pasty_ppp2000=`ts'
		gen mnninc_pc_pasty_ppp2020=`tp'
		gen mnninc_pc_pasty_ppp$prev_year =`tf'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region mnninc_pc_pasty_ppp1800  mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp2000 mnninc_pc_pasty_ppp2020 mnninc_pc_pasty_ppp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg2'"
		save `temp_reg2', replace
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
Table 5c. Per Capita National Income Growth MER 2025 € by World Regions (1800-2025) 
------------------------------------------------------------------------------*/
use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$prev_year )
keep country region1 mnninc_mer_eur_con npopul year

collapse (sum) mnninc_mer_eur npopul, by(region year)

gen double  mnninc_pc_mer=mnninc_mer_eur/npopul
drop mnninc_mer_eur npopul

reshape wide mnninc_pc_mer, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_mer`region'
		sum mnninc_pc_mer`region' if year==$prev_year
		loc tf=r(mean)
		sum mnninc_pc_mer`region' if year==2020
		loc tp=r(mean)
		sum mnninc_pc_mer`region' if year==2000
		loc ts=r(mean)
		sum mnninc_pc_mer`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_mer`region' if year==1800
		loc to=r(mean)
		

		gen region1="`region'"
		gen mnninc_pc_mer1800=`to'
		gen mnninc_pc_mer1980=`ti'
		gen mnninc_pc_mer2000=`ts'
		gen mnninc_pc_mer2020=`tp'
		gen mnninc_pc_mer$prev_year =`tf'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region mnninc_pc_mer1800  mnninc_pc_mer1980 mnninc_pc_mer2000 mnninc_pc_mer2020 mnninc_pc_mer$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg3'"
		save `temp_reg3', replace
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
Table 5d. Per Capita National Income Growth MER 2025 $  by World Regions (1800-2025) 
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
*keep if inrange(year, 1979,$prev_year )
keep country region1 mnninc_mer_usd_con npopul year

collapse (sum) mnninc_mer_usd npopul, by(region year)

gen double  mnninc_pc_mer=mnninc_mer_usd/npopul
drop mnninc_mer_usd npopul

reshape wide mnninc_pc_mer, i(year) j(region1) string

*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year mnninc_pc_mer`region'
		sum mnninc_pc_mer`region' if year==$prev_year
		loc tf=r(mean)
		sum mnninc_pc_mer`region' if year==2020
		loc tp=r(mean)
		sum mnninc_pc_mer`region' if year==2000
		loc ts=r(mean)
		sum mnninc_pc_mer`region' if year==1980
		loc ti=r(mean)
		sum mnninc_pc_mer`region' if year==1800
		loc to=r(mean)
		

		gen region1="`region'"
		gen mnninc_pc_mer1800=`to'
		gen mnninc_pc_mer1980=`ti'
		gen mnninc_pc_mer2000=`ts'
		gen mnninc_pc_mer2020=`tp'
		gen mnninc_pc_mer$prev_year =`tf'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region mnninc_pc_mer1800  mnninc_pc_mer1980 mnninc_pc_mer2000 mnninc_pc_mer2020 mnninc_pc_mer$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg4'"
		save `temp_reg4', replace
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


/*------------------------------------------------------------------------------
Table 6. Per Capita National Income Growth PPP 2025  € by  WID core Territories (1980-2025) 
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
			sum mnninc_pc_pasty_ppp`c' if year==$prev_year
			loc tf=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==2020
			loc tp=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==2000
			loc ts=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==1980
			loc ti=r(mean)
			sum mnninc_pc_pasty_ppp`c' if year==1800
			loc to=r(mean)
			
			gen region1="`c'"
			gen mnninc_pc_pasty_ppp1800=`to'
			gen mnninc_pc_pasty_ppp1980=`ti'
			gen mnninc_pc_pasty_ppp2000=`ts'
			gen mnninc_pc_pasty_ppp2020=`tp'
			gen mnninc_pc_pasty_ppp$prev_year =`tf'
			gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
			gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
			gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
			gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
			gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

			keep region1 mnninc_pc_pasty_ppp1800  mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp2000 mnninc_pc_pasty_ppp2020 mnninc_pc_pasty_ppp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
			duplicates drop
			
				
			append using "`temp_`r''"
			save`temp_`r'', replace
		restore
		}

	*Append in exporting format
	use  "`temp_`r''", clear

	ren region1 country
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
	order  regionname countryname mnninc_pc_pasty_ppp1800  mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp2000 mnninc_pc_pasty_ppp2020 mnninc_pc_pasty_ppp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
	keep regionname countryname mnninc_pc_pasty_ppp1800  mnninc_pc_pasty_ppp1980 mnninc_pc_pasty_ppp2000 mnninc_pc_pasty_ppp2020 mnninc_pc_pasty_ppp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year  growth2020_$prev_year order
	
	
	
	append using "`temp_asi'"
	save "`temp_asi'", replace
	*export excel using "$output", sheet("T2_`r'", modify) cell(B5) keepcellfmt 
 }

u "`temp_asi'", clear
gsort order  -mnninc_pc_pasty_ppp$prev_year
drop order
export excel using "$output", sheet("DataT6", modify) cell(B5) keepcellfmt 


**# Table 3
/*------------------------------------------------------------------------------
Table 3. Per Capita National Income by World Regions (1800-2023)
------------------------------------------------------------------------------*/
/*
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
		sum mnninc`region' if year==$prev_year
		loc tf=r(mean)
		sum mnninc`region' if year==2020
		loc tp=r(mean)
		sum mnninc`region' if year==2000
		loc ts=r(mean)
		sum mnninc`region' if year==1980
		loc ti=r(mean)
		sum mnninc`region' if year==1800
		loc to=r(mean)
		
		

		gen region1 		 = "`region'"
		gen mnninc1800 		 = `to'
		gen mnninc1980 		 = `ti'
		gen mnninc2000 	     = `ts'
		gen mnninc2020       = `tp'
		gen mnninc$prev_year = `tf'
		
		loc ratio = `tf'/`to'
		
		gen ratio			      = `ratio'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 mnninc1800  mnninc1980 mnninc2000 mnninc2020 mnninc$prev_year ratio growth1800_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
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
*/

	

/*------------------------------------------------------------------------------
Table 7. Population by World Regions (1800-2025)
------------------------------------------------------------------------------*/

*Import data
use "$work_data/coreterritories_dataset.dta",clear
keep country year npopul
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
replace npopul = npopul/1000000
reshape wide npopul, i(year) j(country) string

*Compute
foreach region in WO QE XB XL XN XF XR QL XS{
	preserve
		keep year npopul`region'
		sum npopul`region' if year==$prev_year
		loc tf=r(mean)
		sum npopul`region' if year==2020
		loc tp=r(mean)
		sum npopul`region' if year==2000
		loc ts=r(mean)
		sum npopul`region' if year==1980
		loc ti=r(mean)
		sum npopul`region' if year==1800
		loc to=r(mean)

		gen region1="`region'"
		gen npopul1800=`to'
		gen npopul1980=`ti'
		gen npopul2000=`ts'
		gen npopul2020=`tp'
		gen npopul$prev_year =`tf'
		
		loc ratio = `tf'/`to'
		
		gen ratio				  = `ratio'
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 npopul1800  npopul1980 npopul2000 npopul2020 npopul$prev_year ratio growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
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
export excel using "$output", sheet("DataT7", modify) cell(B5) keepcellfmt

	

/*------------------------------------------------------------------------------
Table 8a. Price index Growth PPP 2025 € by World Regions (1980-2025) 
------------------------------------------------------------------------------*/
forv x=1/10 {
	clear all
	tempfile temp_reg`x'
	save    `temp_reg`x'', emptyok
}

use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyeup
reshape wide inyeup, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year inyeup`region'
		sum inyeup`region' if year==$prev_year
		loc tf=r(mean)
		sum inyeup`region' if year==2020
		loc tp=r(mean)
		sum inyeup`region' if year==2000
		loc ts=r(mean)
		sum inyeup`region' if year==1980
		loc ti=r(mean)
		sum inyeup`region' if year==1800
		loc to=r(mean)

		gen region1="`region'"
		gen inyeup1800=`to'
		gen inyeup1980=`ti'
		gen inyeup2000=`ts'
		gen inyeup2020=`tp'
		gen inyeup$prev_year =`tf'
		
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 inyeup1800  inyeup1980 inyeup2000 inyeup2020 inyeup$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg7'"
		save `temp_reg7', replace
	restore
}

use "`temp_reg7'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname inyeup1800  inyeup1980 inyeup2000 inyeup2020 inyeup$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year

*Export
export excel using "$output", sheet("DataT8a", modify) cell(B5) keepcellfmt

	

/*------------------------------------------------------------------------------
Table 8b. Price index Growth PPP 2025 $ by World Regions (1980-2025) 
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyusp
reshape wide inyusp, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year inyusp`region'
		sum inyusp`region' if year==$prev_year
		loc tf=r(mean)
		sum inyusp`region' if year==2020
		loc tp=r(mean)
		sum inyusp`region' if year==2000
		loc ts=r(mean)
		sum inyusp`region' if year==1980
		loc ti=r(mean)
		sum inyusp`region' if year==1800
		loc to=r(mean)

		gen region1="`region'"
		gen inyusp1800=`to'
		gen inyusp1980=`ti'
		gen inyusp2000=`ts'
		gen inyusp2020=`tp'
		gen inyusp$prev_year =`tf'
		
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 inyusp1800  inyusp1980 inyusp2000 inyusp2020 inyusp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
				
		append using "`temp_reg8'"
		save `temp_reg8', replace
	restore
}

use "`temp_reg8'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname inyusp1800  inyusp1980 inyusp2000 inyusp2020 inyusp$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year

*Export
export excel using "$output", sheet("DataT8b", modify) cell(B5) keepcellfmt

	

**# Table 5 EUR MER 
/*------------------------------------------------------------------------------
Table 8c. Price index Growth  MER € by World Regions (1980-2025) 
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyeux
reshape wide inyeux, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year inyeux`region'
		sum inyeux`region' if year==$prev_year
		loc tf=r(mean)
		sum inyeux`region' if year==2020
		loc tp=r(mean)
		sum inyeux`region' if year==2000
		loc ts=r(mean)
		sum inyeux`region' if year==1980
		loc ti=r(mean)
		sum inyeux`region' if year==1800
		loc to=r(mean)

		gen region1="`region'"
		gen inyeux1800=`to'
		gen inyeux1980=`ti'
		gen inyeux2000=`ts'
		gen inyeux2020=`tp'
		gen inyeux$prev_year =`tf'
		
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 inyeux1800  inyeux1980 inyeux2000 inyeux2020 inyeux$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		append using "`temp_reg9'"
		save `temp_reg9', replace
	restore
}

use "`temp_reg9'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname inyeux1800  inyeux1980 inyeux2000 inyeux2020 inyeux$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year

*Export
export excel using "$output", sheet("DataT8c", modify) cell(B5) keepcellfmt



/*------------------------------------------------------------------------------
Table 8d. Price index Growth  MER $ by World Regions (1980-2025) 
------------------------------------------------------------------------------*/
	
use "$work_data/coreterritories_dataset.dta",clear
keep if inlist(country, "WO", "QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS")
keep country year inyusx
reshape wide inyusx, i(year) j(country) string


*Compute
foreach region in QE XB XL XN XF XR QL XS WO {
	preserve
		keep year inyusx`region'
		sum inyusx`region' if year==$prev_year
		loc tf=r(mean)
		sum inyusx`region' if year==2020
		loc tp=r(mean)
		sum inyusx`region' if year==2000
		loc ts=r(mean)
		sum inyusx`region' if year==1980
		loc ti=r(mean)
		sum inyusx`region' if year==1800
		loc to=r(mean)

		gen region1="`region'"
		gen inyusx1800=`to'
		gen inyusx1980=`ti'
		gen inyusx2000=`ts'
		gen inyusx2020=`tp'
		gen inyusx$prev_year =`tf'
		
		gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
		gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
		gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
		gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
		gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

		keep region1 inyusx1800  inyusx1980 inyusx2000 inyusx2020 inyusx$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
		duplicates drop
		
		append using "`temp_reg10'"
		save `temp_reg10', replace
	restore
}

use "`temp_reg10'", clear

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname inyusx1800  inyusx1980 inyusx2000 inyusx2020 inyusx$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year

*Export
export excel using "$output", sheet("DataT8d", modify) cell(B5) keepcellfmt




/*------------------------------------------------------------------------------
Table 9. Price index Growth  €  by Core countries (1980-2025) 
------------------------------------------------------------------------------*/

use "$work_data/coreterritories_dataset.dta", clear
levelsof region1, local(regiones)

foreach r of local regiones {
	clear all
	
	tempfile temp_`r'
	save    `temp_`r'', emptyok
	
	use "$work_data/coreterritories_dataset.dta", clear
	
	keep if (region1=="`r'")
	keep country region1 inyeup year
	levelsof country, local(countries)
		
	reshape wide inyeup, i(year) j(country) string
		
	*Compute
	foreach c of local countries {
		preserve
			keep year inyeup`c'
			sum inyeup`c' if year==$prev_year
			loc tf=r(mean)
			sum inyeup`region' if year==2020
			loc tp=r(mean)
			sum inyeup`c' if year==2000
			loc ts=r(mean)
			sum inyeup`c' if year==1980
			loc ti=r(mean)
			sum inyeup`c' if year==1800
			loc to=r(mean)

			gen country="`c'"
			gen inyeup1800=`to'
			gen inyeup1980=`ti'
			gen inyeup2000=`ts'
			gen inyeup2020=`tp'
			gen inyeup$prev_year =`tf'
			
			gen growth1800_$prev_year = 100*((`tf'/`to')^(1/($prev_year - 1800)) - 1)
			gen growth1980_$prev_year = 100*((`tf'/`ti')^(1/($prev_year - 1980)) - 1)
			gen growth1980_2000       = 100*((`ts'/`ti')^(1/(2000-1980))         - 1)
			gen growth2000_$prev_year = 100*((`tf'/`ts')^(1/($prev_year - 2000)) - 1)
			gen growth2020_$prev_year = 100*((`tf'/`tp')^(1/($prev_year - 2020)) - 1)

			keep country inyeup1800  inyeup1980 inyeup2000 inyeup2020 inyeup$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
			duplicates drop
		
			append using "`temp_`r''"
			save`temp_`r'', replace
		restore
		}
	*Append in exporting format
	use  "`temp_`r''", clear

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
	order regionname countryname inyeup1800  inyeup1980 inyeup2000 inyeup2020 inyeup$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year growth2020_$prev_year
	keep  regionname countryname inyeup1800  inyeup1980 inyeup2000 inyeup2020 inyeup$prev_year growth1800_$prev_year growth1980_$prev_year growth1980_2000 growth2000_$prev_year  growth2020_$prev_year order
	
	append using "`temp_asi2'"
	save "`temp_asi2'", replace
	*export excel using "$output", sheet("T2_`r'", modify) cell(B5) keepcellfmt 
 }

u "`temp_asi2'", clear
gsort order  - inyeup$prev_year
drop order
export excel using "$output", sheet("DataT9", modify) cell(B5) keepcellfmt 
