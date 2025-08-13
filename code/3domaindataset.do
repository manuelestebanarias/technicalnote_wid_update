//----------------------------------------------------------------------------//
//               3.  Main dataset cleanning ad preparing
//----------------------------------------------------------------------------//

clear all
tempfile var_tab
save    `var_tab ', emptyok


* Import PPP series for pastyear
wid, ind(xlceup xlcusp /*xlcyup*/ xlceux xlcusx /*xlcyux*/) ag(999) pop(i) year( $pastyear ) clear
drop percentile age pop year
reshape wide value, i(country) j(variable) string
rename valuexlceup999i ppp_eur //PPP EUR
rename valuexlcusp999i ppp_usd //PPP USD
*rename valuexlcyup999i ppp_cny //PPP USD
rename valuexlceux999i exc_eur //PPP EUR
rename valuexlcusx999i exc_usd //PPP USD
*rename valuexlcyux999i ppp_cny //PPP USD

save "$work_data/ppp.dta", replace

global variables "npopul anninc mnninc mnnfin xlceux xlcusx xlcyux mndpro mnwnxa mpinnx mcomnx  mtaxnx mscinx inyixx mnwnxa mpinnx mcomnx mtaxnx mscinx mgdpro mnnfin mtbnnx  mtbxrx mtbmpx mrevgo mretgo mexpgo mntrgr mheage meduge msopge mpsugo minpgo xlceup xlcusp xlcyup mtgnnx mtgxrx mtgmpx mtsnnx mtsxrx mtsmpx mscrnx msconx mscgnx"

*Import data series from 1970 to 2023 
foreach v in  $variables{
	di "Downloading `v'"
	wid, ind(`v') age(999) pop(i)  clear
	*keep if year>=1970
	append using `var_tab'
	
	save `var_tab', replace
}

u "`var_tab'", clear 

assert percentile=="p0p100"
drop percentile age pop
replace variable = substr(variable,1,6)
duplicates drop
reshape wide value, i(country year) j(variable) string
rename value* *

*Calculate missing variables
gen double mgroni = mgdpro + mnnfin	// gross national income
gen double mehsgo = mheage + meduge 	//Public spending in education and health
gen double mopsgo = mexpgo- (mheage + meduge) -msopge	//Other public spending
gen double mssugo = mpsugo - minpgo //secondary surplus
gen double mndinc = mnninc + mscinx // Net disposable income

* Bring PPP pastyear
merge m:1 country using "$work_data/ppp.dta", nogen keep(master match)
 
*save "$work_data/raw_data.dta", replace
*use "$work_data/raw_data.dta", clear
//--------------REMOVE THIS IN 2026 --------------------------------------------
gen marked=0
replace marked=1 if inlist(substr(country,1,2),"OA", "OB", "OC", "OD", "OE", "OH", "OI", "OJ", "OK") | ///
					inlist(substr(country,1,2), "OL","QE", "QF", "QL", "QM", "QP") | ///
					inlist(substr(country,1,2), "XB", "XF", "XL", "XN", "XR", "XS","WO")
					
drop  if missing(substr(country,3,1)) & marked==1 // Note: this is only necessary because between July and August of 2025, the WO corresponded to  PPPUSD, WO-PPP correspond to PPPUSD and the WO-MER correspond to MERUSD

replace country = substr(country,1,2) if !inlist(country,"CN-RU","CN-UR") & !strpos(country,"-PPP")
drop marked
//-------------------------------------------------------------------------

*generate double mnninc999i_excusd = mnninc999i/excusd			= mnninc
*generate double mnninc999i_nomusx = (mnninc999i*inyixx)/xlcusx	= mnninc_mer_usd

foreach v in mndpro mnnfin mgdpro mnwnxa mscinx mnninc mscrnx mscgnx msconx { // mscrnx msconx mscgnx {
	*Convert to current USD
	gen `v'_mer_usd		= (inyixx*`v')/xlcusx
	gen `v'_mer_eur		= (inyixx*`v')/xlceux
	gen `v'_mer_usd_cur	= (inyixx*`v')/exc_usd 
	gen `v'_mer_eur_cur	= (inyixx*`v')/exc_eur
	*Convert to constant USD 2024
	gen `v'_mer_usd_con	= (`v')/exc_usd 
	gen `v'_mer_eur_con	= (`v')/exc_eur 
	
}

foreach v in mndpro mnnfin mgdpro mnwnxa mscinx mnninc mscrnx mscgnx msconx { // mscrnx msconx mscgnx {
	*Convert to current USD 2024
	gen `v'_pasty_ppp_usd_cur = (inyixx*`v')/ppp_usd 
	gen `v'_pasty_ppp_eur_cur = (inyixx*`v')/ppp_eur 
	gen `v'_ppp_usd_cur = (inyixx*`v')/xlceup 
	gen `v'_ppp_eur_cur = (inyixx*`v')/xlceup  
	*Convert to constant USD 2024
	gen `v'_pasty_ppp_usd = `v'/ppp_usd 
	gen `v'_pasty_ppp_eur = `v'/ppp_eur  
	*Convert to constant USD 2024
	gen `v'_ppp_usd = `v'/xlcusp
	gen `v'_ppp_eur = `v'/xlceup  
}                                             
/*
foreach v in mgroni mrevgo mretgo mntrgr mexpgo meduge mheage mehsgo  msopge mopsgo mpsugo minpgo mssugo { 
	gen `v'_ppp=`v'/ppp_eur 
}
*/

*Calculate price indexes
generate  inyusx =  mnninc_mer_usd/mnninc_mer_usd_con
generate  inyeux =  mnninc_mer_eur/mnninc_mer_eur_con
generate  inyusp =  mnninc_ppp_usd_cur/mnninc_pasty_ppp_usd
generate  inyeup =  mnninc_ppp_eur_cur/mnninc_pasty_ppp_eur

*

*Generate Region variable
merge m:1 country using "$work_data/import-core-country-codes-output.dta", nogen keepusing(corecountry region* shortname)

rename shortname countryname
replace countryname="Russia" if countryname=="Russian_Federation"
replace region1="WO" if country=="WO"

*Classify according to total population
gen classif=""
 	 replace classif = "0-100k" 	if  inrange(npopul, 0,        100000) 	
	 replace classif = "100k-1m" 	if  inrange(npopul, 100000,   1000000) 	
	 replace classif = "1m-10m" 	if  inrange(npopul, 1000000,  10000000) 	
	 replace classif = "10m-50m" 	if  inrange(npopul, 10000000, 50000000) 	
	 replace classif = "50m-100m" 	if  inrange(npopul, 50000000, 100000000) 	
	 replace classif = "100m-500m" 	if  inrange(npopul, 100000000,500000000) 	
	 replace classif = "over 500m" 	if  npopul >= 500000000 	
	 tab country if mnninc==.
	 
*Convert to PPP 2023
*gen mnninc_pasty_ppp_eur = mnninc/ppp_eur
*gen mnninc_mer_eur = mnninc/xlceux

*Format 	
gen      order = 1 		if region1=="QL"
replace  order = 2 		if region1=="QE"
replace  order = 3 		if region1=="XL"
replace  order = 4 		if region1=="XN"
replace  order = 5 		if region1=="XB"
replace  order = 6 		if region1=="XR"
replace  order = 7 		if region1=="XS"
replace  order = 8 		if region1=="XF"
replace  order = 9 		if region1=="WO"
	
gen     order_pop = 1 	if classif=="0-100k"  
replace order_pop = 2 	if classif=="100k-1m" 
replace order_pop = 3 	if classif=="1m-10m"  
replace order_pop = 4 	if classif=="10m-50m"  
replace order_pop = 5 	if classif=="50m-100m"  
replace order_pop = 6 	if classif=="100m-500m" 
replace order_pop = 7 	if classif=="over 500m" 	

preserve
	keep if (corecountry==1 & missing(region2)) | inlist(country,"WO","QE", "XB", "XL", "XN", "XF", "XR", "QL", "XS") | (substr(country,1,1)=="O" & country!="OM") | country=="QM"

	drop if strpos(country,"-PPP") | strpos(country,"-MER")
	drop corecountry
	
	replace region2 = country if missing(region2) & ((substr(country,1,1)=="O" & country!="OM") | country=="QM")
	
	replace region1 = "XR" if country == "OA"
	replace region1 = "QL" if country == "OB"
	replace region1 = "QE" if country == "OC"
	replace region1 = "XL" if country == "OD"
	replace region1 = "XN" if country == "OE"
	replace region1 = "XB" if country == "OH"
	replace region1 = "XS" if country == "OI"
	replace region1 = "XF" if country == "OJ"
	replace region1 = "XB" if country == "OK"
	replace region1 = "XB" if country == "OL"
	replace region2 = "OH" if country == "OK"
	replace region2 = "OH" if country == "OL"
	replace region1 = "QE" if country == "QM"
	
	merge m:1 region2 using "$work_data/import-region-codes-output.dta", nogen keepusing(shortname) keep(master match)
	replace countryname=shortname if missing(countryname) & !missing(shortname)
	drop shortname
	
	save  "$work_data/coreterritories_dataset.dta",replace
restore 
/*
preserve
	keep if strpos(country,"-PPP")
	drop corecountry
	replace country=substr(country,1,2)
	replace region2 = country if missing(region2) & ((substr(country,1,1)=="O" & country!="OM") | country=="QM")
	
	replace region1 = "XR" if country == "OA"
	replace region1 = "QL" if country == "OB"
	replace region1 = "QE" if country == "OC"
	replace region1 = "XL" if country == "OD"
	replace region1 = "XN" if country == "OE"
	replace region1 = "XB" if country == "OH"
	replace region1 = "XS" if country == "OI"
	replace region1 = "XF" if country == "OJ"
	replace region1 = "XB" if country == "OK"
	replace region1 = "XB" if country == "OL"
	replace region2 = "OH" if country == "OK"
	replace region2 = "OH" if country == "OL"
	replace region1 = "QE" if country == "QM"
	
	merge m:1 region2 using "$work_data/import-region-codes-output.dta", nogen keepusing(shortname) keep(master match)
	replace countryname=shortname if missing(countryname) & !missing(shortname)
	drop shortname
	
	save  "$work_data/regionsppp_dataset.dta",replace
restore 
*/

keep if (corecountry==1 | country=="WO")
drop corecountry
save  "$work_data/main_dataset.dta",replace
 