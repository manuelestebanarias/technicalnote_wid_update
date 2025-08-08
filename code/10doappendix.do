

**# Appendix 1
*Import PPP series for 2021
use "$work_data/main_dataset.dta", clear
keep if year==2021
keep country xlceup xlcusp xlceux xlcusx 


rename xlceup ppp_2021_eur //PPP EUR
rename xlcusp ppp_2021_usd //PPP USD
rename xlceux mer_2021_eur //MER EUR
rename xlcusx mer_2021_usd //MER USD

tempfile ppp_mer_2021
save `ppp_mer_2021'

use "$work_data/main_dataset.dta", clear
keep if year==$pastyear
drop if country=="WO"

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)
drop region1 
rename shortname region1


gen mnninc_pasty_ppp_eur_pc = mnninc_pasty_ppp_eur/npopul
gen mnninc_mer_ppp_ratio   = mnninc_mer_eur/mnninc_pasty_ppp_eur

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
	 
gen PPP_to_MER_pasty_EUR=ppp_eur/xlceux
gen PPP_to_MER_pasty_USD=ppp_usd/xlcusx 





merge 1:1 country using "`ppp_mer_2021'"
keep if _merge==3
drop _merge
*erase ppp_mer_2021.dta


gsort -mnninc_pasty_ppp_eur_pc

g PPP_to_MER_2021_EUR=ppp_2021_eur/mer_2021_eur
g PPP_to_MER_2021_USD=ppp_2021_usd/mer_2021_usd	 


g mcomnx_ppp_pasty_usd=(/*nipi**/mcomnx)/ppp_usd 
g mpinnx_ppp_pasty_usd=(/*nipi**/mpinnx)/ppp_usd 



order countryname mnninc_pasty_ppp_eur_pc percentile region1   mnninc_pasty_ppp_eur npopul country mnnfin_pasty_ppp_usd mpinnx_ppp_pasty_usd mcomnx_ppp_pasty_usd mnwnxa_pasty_ppp_usd /// 
mndpro_pasty_ppp_usd mgdpro_pasty_ppp_usd 	PPP_to_MER_pasty_EUR PPP_to_MER_pasty_USD PPP_to_MER_2021_EUR PPP_to_MER_2021_USD	

keep countryname mnninc_pasty_ppp_eur_pc percentile region1   mnninc_pasty_ppp_eur npopul country mnnfin_pasty_ppp_usd mpinnx_ppp_pasty_usd mcomnx_ppp_pasty_usd mnwnxa_pasty_ppp_usd ///
mndpro_pasty_ppp_usd mgdpro_pasty_ppp_usd 	PPP_to_MER_pasty_EUR PPP_to_MER_pasty_USD PPP_to_MER_2021_EUR PPP_to_MER_2021_USD


*Export 
export excel using "$output", sheet("Appendix1", modify) cell(A4) keepcellfmt


