clear all
tempfile temp_reg
save    `temp_reg', emptyok

clear all
tempfile data_year
save    `data_year', emptyok

**# Table 5
/*------------------------------------------------------------------------------
Table 5. Country Size by World Regions ($pastyear)
------------------------------------------------------------------------------*/
/*
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear

*Format
replace npopul=npopul/1000000 // in millions
drop if country=="WO"
 
*Generate relevant variables per region 
foreach region in QE XB XL XN XF XR QL XS {
	preserve	 
		 sum npopul if region1=="`region'"
			 loc total_countries=r(N)
			 loc avg_pop=r(mean)
		 sum npopul if region1=="`region'" & inrange(npopul,0,.1) 	
			 loc total_countries_100k=r(N)
		 sum npopul if region1=="`region'" & inrange(npopul,.1,1) 	
			 loc total_countries_1m=r(N)	 
		 sum npopul if region1=="`region'" & inrange(npopul,1,10) 	
			 loc total_countries_10m=r(N)	 	 
		 sum npopul if region1=="`region'" & inrange(npopul,10,50) 	
			 loc total_countries_50m=r(N)	 	 	 
		 sum npopul if region1=="`region'" & inrange(npopul,50,100) 	
			 loc total_countries_100m=r(N)	 	 	 	 
		 sum npopul if region1=="`region'" & inrange(npopul,100,500) 	
			 loc total_countries_500m=r(N)	 	 	 	 	 
		 sum npopul if region1=="`region'" & npopul>=500 	
			 loc total_countries_1b=r(N)	 	 	 	 	 	 

		g col0="`region'"
		g col1=`total_countries'
		g col2=`avg_pop'
		g col3=`total_countries_100k'
		g col4=`total_countries_1m'
		g col5=`total_countries_10m'
		g col6=`total_countries_50m'
		g col7=`total_countries_100m'
		g col8=`total_countries_500m'
		g col9=`total_countries_1b'
		
		keep col*
		duplicates drop
		append using "`temp_reg'"
		save "`temp_reg'", replace
	restore
}

*Generate relevant variables at the World level
sum npopul 
	loc total_countries=r(N)
	loc avg_pop=r(mean)
sum npopul if  inrange(npopul,0,.1) 	
	loc total_countries_100k=r(N)
sum npopul if  inrange(npopul,.1,1) 	
	loc total_countries_1m=r(N)	 
sum npopul if  inrange(npopul,1,10) 	
	loc total_countries_10m=r(N)	 	 
sum npopul if  inrange(npopul,10,50) 	
	loc total_countries_50m=r(N)	 	 	 
sum npopul if  inrange(npopul,50,100) 	
	loc total_countries_100m=r(N)	 	 	 	 
sum npopul if  inrange(npopul,100,500) 	
	loc total_countries_500m=r(N)	 	 	 	 	 
sum npopul if  npopul>=500 	
	loc total_countries_1b=r(N)	 
		 
gen col0="WO"
gen col1=`total_countries'
gen col2=`avg_pop'
gen col3=`total_countries_100k'
gen col4=`total_countries_1m'
gen col5=`total_countries_10m'
gen col6=`total_countries_50m'
gen col7=`total_countries_100m'
gen col8=`total_countries_500m'
gen col9=`total_countries_1b'		
	
keep col*
duplicates drop
tempfile temp_WO
save "`temp_WO'", replace	

*Append in format for exporting	
use "`temp_reg'", clear
append using "`temp_WO'"

rename col0 region1
merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname
rename shortname col0

// *Export	
export excel using "$output", sheet("DataT5", modify) cell(A5) keepcellfmt
*/
	
				
				
				

		
**# Table 6
/*------------------------------------------------------------------------------
Table 6. Per Capita National Income by Country Size ($pastyear)
------------------------------------------------------------------------------*/
/*
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear

*Format
drop if country=="WO"

gen  countries=1

 *Compute for World 
preserve
	collapse (sum) countries npopul mnninc_pasty_ppp_eur 
	sum countries
		loc countries=r(mean)
	sum npopul
		loc npopul=r(mean)
	sum mnninc_pasty_ppp_eur
		loc mnninc_pasty_ppp_eur=r(mean)
	g mnninc = mnninc_pasty_ppp_eur/npopul
	sum mnninc
		loc mnninc=r(mean)
restore

*Compute per category of country size
collapse (sum) countries npopul mnninc_pasty_ppp_eur  ,by(classif)
 
 *Include World 
set obs `=_N+1'
replace classif="World" if classif==""
replace countries=`countries' if classif=="World" & countries==.
replace npopul=`npopul' if classif=="World" & npopul==.
replace mnninc_pasty_ppp_eur=`mnninc_pasty_ppp_eur' if classif=="World" & mnninc_pasty_ppp_eur==.

*Generate relevant variables	
gen mnninc=mnninc_pasty_ppp_eur/npopul
replace npopul=npopul/1000000
gen sh_countries=100*countries/`countries'
gen sh_npopul=100*npopul/(`npopul'/1000000)	
sum mnninc if classif=="World"
gen sh_mnninc=100*mnninc/r(mean)

*Format for exporting		
drop mnninc_pasty_ppp_eur
format mnninc %20.0f
order classif countries sh_countries npopul sh_npopul mnninc sh_mnninc
g order =1 if 		classif=="0-100k"  
	replace order=2 if 	classif=="100k-1m" 
	replace order=3 if 	classif=="1m-10m"  
	replace order=4 if 	classif=="10m-50m"  
	replace order=5 if 	classif=="50m-100m"  
	replace order=6 if 	classif=="100m-500m" 
	replace order=7 if 	classif=="over 500m" 
	replace order=8 if 	classif=="World"
sort order
drop order

*Export
export excel using "$output", sheet("DataT6", modify) cell(B5) keepcellfmt			
*/
		
		
		

**# Table 7
/*------------------------------------------------------------------------------
Table 7. Per Capita National Income and Country Size ($pastyear)
------------------------------------------------------------------------------*/
/*
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear

*Format
drop if country=="WO"


 *Sort from lowest to highest per capita net national income (PPP)
gen mnninc_pasty_ppp_eur_pc=mnninc_pasty_ppp_eur/npopul
sort mnninc_pasty_ppp_eur_pc
 
 *Classify according to per capita net national income
 egen seq=seq()
 g percentile=""
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
 
 *For Figure 2: top 10% countries
 preserve 
	 keep if percentile=="90%-100%"
	 keep country percentile
	 g top=1
	 tempfile top10
	save `top10',replace
 restore
 
 *Save temporary file with sample
gen  countries=1
tempfile  temp
save     `temp'
 
 *Generate First 2 columns
use "`temp'",clear
gen avg_pop=npopul
gen mnninc_ppp_2=mnninc_pasty_ppp_eur

 *Compute for World 
preserve
	collapse (sum) countries npopul mnninc_pasty_ppp_eur (mean) mnninc_ppp_2  avg_pop
	sum countries
		loc countries=r(mean)
	sum npopul
		loc npopul=r(mean)
	sum avg_pop
		loc avg_pop=r(mean)
	sum mnninc_pasty_ppp_eur
		loc mnninc_pasty_ppp_eur=r(mean)
	sum mnninc_ppp_2
		loc mnninc_ppp_2=r(mean)	
restore

* Compute per percentile
format avg_pop %20.0f
collapse (sum) countries npopul mnninc_pasty_ppp_eur (mean) avg_pop ,by(percentile)
 
*Include World 
set obs `=_N+1'
replace percentile="World" 		if percentile==""
replace countries=`countries' 	if percentile=="World" & countries==.
replace npopul=`npopul' 		if percentile=="World" & npopul==.
replace avg_pop=`avg_pop' 		if percentile=="World" & avg_pop==.
replace mnninc_pasty_ppp_eur = `mnninc_pasty_ppp_eur' if percentile=="World" & mnninc_pasty_ppp_eur ==.
	
*Format for exporting	
gen mnninc_ppp=mnninc_pasty_ppp_eur/npopul
replace npopul=npopul/1000000
replace avg_pop=avg_pop/1000000

drop countries npopul mnninc_pasty_ppp_eur
order percentile mnninc avg_pop

tempfile temp_percentiles
save "`temp_percentiles'",replace
 
 *Generate columns for different sizes of countries
use "`temp'",clear
collapse (sum) countries ,by(classif percentile)
gen		order=1 if 	classif=="0-100k"  
replace order=2 if 	classif=="100k-1m" 
replace order=3 if 	classif=="1m-10m"  
replace order=4 if 	classif=="10m-50m"  
replace order=5 if 	classif=="50m-100m"  
replace order=6 if 	classif=="100m-500m" 
replace order=7 if 	classif=="over 500m" 
sort order
drop classif
reshape wide countries, i(percentile) j(order) 

tempfile   temp_countries_per_size
save `temp_countries_per_size', replace	

*Merge
use "`temp_percentiles'",clear
merge 1:1 percentile using "`temp_countries_per_size'"


*Export
export excel using "$output", sheet("DataT7", modify) cell(B5) keepcellfmt
*/
		
		
**# Figure 2
/*------------------------------------------------------------------------------
Per Capita National Income and Country Size 1970-$pastyear 
($pastyear PPP €)
------------------------------------------------------------------------------*/
/*
**Part 1: Select small countries
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1970
drop if country=="WO"

*Select only small countries	
keep if inlist(classif,"0-100k", "100k-1m", "1m-10m")


*Compute total
gen countries=1
collapse (sum) countries ,by(order_pop year) 
	 
*Format for exporting	 
reshape wide countries , i(year) j(order_pop) 
ren countries1 c_0_100k
ren countries2 c_100k_1m
ren countries3 c_1m_10m

*Save Part 1
tempfile  total_small_countries
save     `total_small_countries'


**Part 2: Compute total countries
*Import data
use  "$work_data/main_dataset.dta",clear
keep if year>=1970
drop if country=="WO"
	
*Compute total	
g countries=1
collapse (sum) countries ,by(year) 

*Save Part 2
tempfile  total_countries
save     `total_countries'


**Part 3: Compute shares
*Import data
use  "$work_data/main_dataset.dta",clear
keep if year>=1970
drop if country=="WO"


*Select only small countries	
keep if inlist(classif,"0-100k", "100k-1m", "1m-10m")
	
*Merge with top 10 countries according to per national net national income
merge m:1 country using "`top10'" //need to run Table 7 before

*Select only small countries and top 10 countries	
keep if inlist(classif,"0-100k", "100k-1m", "1m-10m") & top==1

*Compute total	
g countries=1
collapse (sum) countries ,by(order_pop year) 
	
*Format for exporting	
reshape wide countries , i(year) j(order_pop) 
ren countries1 c_0_100k_top10
ren countries2 c_100k_1m_top10
ren countries3 c_1m_10m_top10

*Merge with Parts 1 and 2
merge 1:1 year using "`total_small_countries'"
drop _merge
merge 1:1 year using "`total_countries'"
drop _merge
g top10_countries=22 //Based on instructions

*Compute relevant variables
g sh_c_0_100k=c_0_100k/countries
g sh_c_100k_1m=c_100k_1m/countries
g sh_c_1m_10m=c_1m_10m/countries
g sh_c_0_100k_top10=c_0_100k_top10/top10_countries
g sh_c_100k_1m_top10=c_100k_1m_top10/top10_countries
g sh_c_1m_10m_top10=c_1m_10m_top10/top10_countries
tsset year
tsline sh_c_0_100k sh_c_100k_1m sh_c_1m_10m

// *Export 
export excel using "$output", sheet("DataF2", modify) cell(A4) keepcellfmt
*/

		
		
		


**# Figures 2b and 2c

/*------------------------------------------------------------------------------
Figure 2b Per Capita National Income by Country Size 1970-$pastyear
(% of world average) -$pastyear PPP €-

Figure 2c Per Capita National Income by Country Size 1970-$pastyear
(% of world average) -$pastyear PPP €- log scale
------------------------------------------------------------------------------*/
/*

use  "$work_data/main_dataset.dta",clear
keep if year==$pastyear
keep country   classif
tempfile classif_$pastyear
save `classif_$pastyear' 

forv year=1970/$pastyear{

	use "$work_data/main_dataset.dta",clear
	keep if year==`year'
	drop classif

	merge 1:1 country using "`classif_$pastyear'"
	keep if _merge==3
	drop _merge


	*Format
	drop if country=="WO"

	merge 1:1 country using "$work_data/ppp.dta"
	keep if _merge==3
	drop _merge


	gen countries=1

	 *Compute for World 
	preserve
		collapse (sum) countries npopul mnninc_pasty_ppp_eur
		sum countries
			loc countries=r(mean)
		sum npopul
			loc npopul=r(mean)
		sum mnninc_pasty_ppp_eur
			loc mnninc_pasty_ppp_eur=r(mean)
		gen mnninc=mnninc_pasty_ppp_eur/npopul
		sum mnninc
		loc mnninc=r(mean)
	restore

	 *Compute per category of country size
	 collapse (sum) countries npopul mnninc_pasty_ppp_eur ,by(classif)
	 
	 *Include World 
	set obs `=_N+1'
	replace classif="World" if classif==""
	replace countries=`countries' if classif=="World" & countries==.
	replace npopul=`npopul' if classif=="World" & npopul==.
	replace mnninc_pasty_ppp_eur=`mnninc_pasty_ppp_eur' if classif=="World" & mnninc_pasty_ppp_eur==.

	*Generate relevant variables	
	gen mnninc=mnninc_pasty_ppp_eur/npopul
	replace npopul=npopul/1000000
	gen sh_countries=100*countries/`countries'
	gen sh_npopul=100*npopul/(`npopul'/1000000)	
	sum mnninc if classif=="World"
	gen sh_mnninc=100*mnninc/r(mean)

	*Format for exporting		
	drop mnninc_pasty_ppp_eur
	format mnninc %20.0f
	order classif countries sh_countries npopul sh_npopul mnninc sh_mnninc
	gen     order=1 if 	classif=="0-100k"  
	replace order=2 if 	classif=="100k-1m" 
	replace order=3 if 	classif=="1m-10m"  
	replace order=4 if 	classif=="10m-50m"  
	replace order=5 if 	classif=="50m-100m"  
	replace order=6 if 	classif=="100m-500m" 
	replace order=7 if 	classif=="over 500m" 
	replace order=8 if 	classif=="World"
	sort order
	drop order

	keep classif sh_mnninc
	gen  year=`year'
	drop if classif=="World"
	loc s classif 
	replace `s' = subinstr(`s', "-", "_", .)
	replace `s' = subinstr(`s', " ", "_", .)
	reshape wide sh_mnninc, i(year) j(classif) string
	
	append using "`data_year'"
	save "`data_year'",replace
}

use "`data_year'",clear


sort year 

tsset year
tsline sh_mnninc0_100k sh_mnninc100k_1m sh_mnninc100m_500m sh_mnninc10m_50m sh_mnninc1m_10m sh_mnninc50m_100m sh_mnnincover_500m, xline(1979 2005 2014)
drop year
*Export
export excel using "$output", sheet("DataF2_b", modify) cell(B4) keepcellfmt			
*/						
		
		
		
		
**# Figures 2d-2g 
/*------------------------------------------------------------------------------
Equivalent to Figure 2b Per Capita National Income by Country Size 1970-$pastyear
(% of world average) -$pastyear PPP €-
for regions EURO, LATA, NAOC, and SSA
------------------------------------------------------------------------------*/
/*
use "$work_data/main_dataset.dta",clear
keep if year>=1970
drop classif
merge m:1 country using "`classif_$pastyear'"
keep if _merge==3
drop _merge


*Format
drop mnninc
g mnninc=mnninc_pasty_ppp_eur/npopul

preserve
collapse (mean ) mnninc ,by(year)
ren mnninc mnninc_world
save mnninc_world.dta,replace
restore
merge m:1 year using mnninc_world.dta
keep if _merge==3
drop _merge
g sh_mnninc=100*mnninc/mnninc_world
keep if classif=="0-100k" 



keep country npopul mnninc_pasty_ppp_eur year sh_mnninc
tab country


drop mnninc_pasty_ppp_eur npopul mnninc
reshape wide sh_mnninc, i(year) j(country) string

tsset year
tsline sh_mnnincAD sh_mnnincAG sh_mnnincAI  sh_mnnincBM sh_mnnincBQ sh_mnnincDM  sh_mnnincGG sh_mnnincGI sh_mnnincGL sh_mnnincIM  sh_mnnincKN sh_mnnincKY sh_mnnincLI sh_mnnincMC sh_mnnincMH sh_mnnincMS sh_mnnincNR sh_mnnincPW sh_mnnincSM  sh_mnnincSX sh_mnnincTC  sh_mnnincTV  sh_mnnincVG 

*Europe
label var sh_mnnincAD Andorra
label var sh_mnnincGG Guernsey
label var sh_mnnincGI Gibraltar
label var sh_mnnincGL Greenland
label var sh_mnnincIM IsleOfMan
label var sh_mnnincLI Liechtenstein
label var sh_mnnincMC Monaco
label var sh_mnnincSM 	SanMarino


*LATAM
label var sh_mnnincAG AntiguaAndBarbuda 
label var sh_mnnincAI Anguilla
label var sh_mnnincBQ Bonaire
label var sh_mnnincDM Dominica
label var sh_mnnincKN 	SaintKittsAndNevis
label var sh_mnnincKY 	CaymanIslands
label var sh_mnnincSX SintMaarten
label var sh_mnnincTC TurksAndCaicosIslandsGrenadines
label var sh_mnnincVG BritishVirginIslands 

*NAOC
label var sh_mnnincBM Bermuda
label var sh_mnnincMH MarshallIslands
label var sh_mnnincNR Nauru
label var sh_mnnincPW Palau
label var sh_mnnincTV Tuvalu

*SSA
label var sh_mnnincMS Mauritania



tsline sh_mnnincAD sh_mnnincAG sh_mnnincAI  sh_mnnincBM sh_mnnincBQ sh_mnnincDM  sh_mnnincGG sh_mnnincGI sh_mnnincGL sh_mnnincIM sh_mnnincKN sh_mnnincKY sh_mnnincLI sh_mnnincMC sh_mnnincMH sh_mnnincMS sh_mnnincNR sh_mnnincPW  sh_mnnincSM  sh_mnnincSX sh_mnnincTC sh_mnnincTV  sh_mnnincVG 

tsline sh_mnnincMS , title("Per Capita National Income in Sub Saharan Africa 1970-$pastyear" "(% of world average) -PPP- ") note("Note: Countries with populations between 0 and 100k in $pastyear.") legend(row(1)) 

tsline  sh_mnnincBM    sh_mnnincMH   sh_mnnincNR   sh_mnnincPW   sh_mnnincTV    , title("Per Capita National Income in" "North America and Oceania 1970-$pastyear" "(% of world average) -PPP- ") note("Note: Countries with populations between 0 and 100k in $pastyear.") lpattern(dash) legend(row(2))


tsline  sh_mnnincAD   sh_mnnincGG sh_mnnincGI sh_mnnincGL sh_mnnincIM  sh_mnnincLI sh_mnnincMC sh_mnnincSM 	, title("Per Capita National Income in" "Europe 1970-$pastyear" "(% of world average) -PPP- ") note("Note: Countries with populations between 0 and 100k in $pastyear.") lpattern(dash dash dash) legend(row(2))



tsline  sh_mnnincAG   sh_mnnincAI  sh_mnnincBQ   sh_mnnincDM   sh_mnnincKN   sh_mnnincKY   sh_mnnincSX   sh_mnnincTC    sh_mnnincVG , title("Per Capita National Income in" "Latin America and the Caribean 1970-$pastyear" "(% of world average) -PPP- ") note("Note: Countries with populations between 0 and 100k in $pastyear.") lpattern(dash dash dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(row(4))

tsline  sh_mnnincBM  sh_mnnincKY  , title("Per Capita National Income" "(% of world average) -PPP- ") note("Note: Countries with populations between 0 and 100k in $pastyear.")


*Europe
rename sh_mnnincAD Andorra
rename sh_mnnincGG Guernsey
rename sh_mnnincGI Gibraltar
rename sh_mnnincGL Greenland
rename sh_mnnincIM IsleOfMan
rename sh_mnnincLI Liechtenstein
rename sh_mnnincMC Monaco
rename sh_mnnincSM 	SanMarino


*LATAM
rename sh_mnnincAG AntiguaAndBarbuda 
rename sh_mnnincAI Anguilla
rename sh_mnnincBQ Bonaire
rename sh_mnnincDM Dominica
rename sh_mnnincKN 	SaintKittsAndNevis
rename sh_mnnincKY 	CaymanIslands
rename sh_mnnincSX SintMaarten
rename sh_mnnincTC TurksAndCaicosIslands
rename sh_mnnincVG BritishVirginIslands 

*NAOC
rename sh_mnnincBM Bermuda
rename sh_mnnincMH MarshallIslands
rename sh_mnnincNR Nauru
rename sh_mnnincPW Palau
rename sh_mnnincTV Tuvalu

*SSA
rename sh_mnnincMS Mauritania

*drop year
*Export
export excel using  "$output", sheet("DataF2_b_region", modify) cell(A4) keepcellfmt	
*/
		
		
		
		


**# Tables 8a and 8b
/*------------------------------------------------------------------------------
Table 8a. Top 10 Richest Countries ($pastyear)

Table 8b. Top 10 Richest Countries ($pastyear), excluding countries with population below 10
------------------------------------------------------------------------------*/
**Part 1: All Countries
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp = mnnfin / ppp_eur
gen mnwnxa_pasty_ppp = mnwnxa / ppp_eur
gen mndpro_pasty_ppp = mndpro / ppp_eur
gen mnninc_mer		 = mnninc/xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio = ppp_eur / xlceux
gen mnnfin_ratio=mnnfin_pasty_ppp / mndpro_pasty_ppp
gen mnwnxa_ratio=mnwnxa_pasty_ppp / mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur /npopul
sort mnninc_pasty_ppp_eur_pc
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
keep if percentile=="90%-100%" 
gsort -seq
egen top10=seq()
keep if inrange(top10,1,10)
 

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
tempfile top10_richest_all
save `top10_richest_all'



**Part 2 (Only Small Countries)
*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$pastyear
drop if country=="WO"

gen mnnfin_pasty_ppp = mnnfin/ppp_eur
gen mnwnxa_pasty_ppp = mnwnxa/ppp_eur
gen mndpro_pasty_ppp = mndpro/ppp_eur
gen mnninc_mer=mnninc/xlceux

*Gnerate ratio Ratio between MER and PPP Per Capita National Income
gen mnninc_mer_ppp_ratio=ppp_eur/xlceux
gen mnnfin_ratio=mnnfin_pasty_ppp /mndpro_pasty_ppp
gen mnwnxa_ratio=mnwnxa_pasty_ppp /mndpro_pasty_ppp

*Select top 10 countries according to per capita net national income  (PPP)
gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur /npopul
sort mnninc_pasty_ppp_eur_pc
gen countries=1

 
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

drop if inlist(classif,"0-100k", "100k-1m","1m-10m")
gsort -seq
egen top10=seq()
keep if inrange(top10,1,10)
 
sort top10

*Format for exporting
order country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp mnwnxa_ratio
keep country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp top10 mnwnxa_ratio


merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop country 
order shortname
rename shortname country

*Merge with Part 1
merge 1:1 top10 using "`top10_richest_all'"
drop _merge
order top10 country_all mnninc_pasty_ppp_eur_pc_all npopul_all mnnfin_ratio_all mnninc_mer_ppp_all country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp_ratio mnwnxa_ratio_all mnwnxa_ratio
keep  top10 country_all mnninc_pasty_ppp_eur_pc_all npopul_all mnnfin_ratio_all mnninc_mer_ppp_all country mnninc_pasty_ppp_eur_pc npopul mnnfin_ratio mnninc_mer_ppp_ratio mnwnxa_ratio_all mnwnxa_ratio
sort top10

*Export to excel
*export excel using "$output", sheet("DataT8", modify) cell(B5) keepcellfmt		
export excel using "$output", sheet("DataT11", modify) cell(B5) keepcellfmt		




