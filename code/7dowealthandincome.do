clear all 

foreach s in _pasty_ppp_eur_cur _mer_eur _pasty_ppp_usd_cur _mer_usd {
	tempfile temp_reg14`s'
	save `temp_reg14`s'', emptyok
}
clear all
gen region1=""
tempfile temp_reg140
save `temp_reg140', emptyok


/*------------------------------------------------------------------------------
Table 13a. Current Account by World Region PPP € (2025)
Table 13b. Current Account by World Region PPP $ (2025)
Table 13c. Current Account by World Region MER € (2025)
Table 13d. Current Account by World Region MER $ (2025)
------------------------------------------------------------------------------*/
*Import 
use "$work_data/coreterritories_dataset.dta",clear
keep if year==$prev_year 
keep country iny*

rename country region1

tempfile price
save `price'


*Import data
use "$work_data/main_dataset.dta",clear
keep if year==$prev_year 

keep if !missing(region5)

keep country year mpinnx* mcomnx* mtbnnx* mtaxnx* mscinx* mncanx* mgdpro* region1 region5 order

sort country year


preserve
	collapse (sum)  mpinnx* mcomnx* mtbnnx* mtaxnx* mscinx* mncanx* mgdpro*, by(year region5)
	drop if missing(region5)
	gen order=9
	rename region5 region1
	tempfile WO_all
	save `WO_all'
restore

*Compute for regions	
collapse (sum)  mpinnx* mcomnx* mtbnnx* mtaxnx* mscinx* mncanx* mgdpro*, by(region1 order)

append using "`WO_all'"

*Format for Excel
foreach x in  mpinnx mcomnx mtbnnx mtaxnx mscinx mncanx {
foreach v in pasty_ppp_eur_cur mer_eur pasty_ppp_usd_cur mer_usd {
	gen shr_`x'_`v' = `x'_`v' /mgdpro_`v'
	replace `x'_`v' = `x'_`v' /1000000000
	}
}

merge 1:1 region1 using "`price'", nogenerate keep(match master)

merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order
keep  shortname  *_pasty_ppp_eur_cur  *_mer_eur *_pasty_ppp_usd_cur *_mer_usd  order
drop mgdpro*



preserve
	keep  shortname  *_pasty_ppp_eur*  
	order shortname mpinnx_pasty_ppp_eur mcomnx_pasty_ppp_eur mtbnnx_pasty_ppp_eur mtaxnx_pasty_ppp_eur mscinx_pasty_ppp_eur mncanx_pasty_ppp_eur shr_mpinnx_pasty_ppp_eur shr_mcomnx_pasty_ppp_eur shr_mtbnnx_pasty_ppp_eur shr_mtaxnx_pasty_ppp_eur shr_mscinx_pasty_ppp_eur shr_mncanx_pasty_ppp_eur 
	

	export excel using "$output", sheet("DataT13a", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname  *_pasty_ppp_usd*  
	order shortname mpinnx_pasty_ppp_usd mcomnx_pasty_ppp_usd mtbnnx_pasty_ppp_usd mtaxnx_pasty_ppp_usd mscinx_pasty_ppp_usd mncanx_pasty_ppp_usd shr_mpinnx_pasty_ppp_usd shr_mcomnx_pasty_ppp_usd shr_mtbnnx_pasty_ppp_usd shr_mtaxnx_pasty_ppp_usd shr_mscinx_pasty_ppp_usd shr_mncanx_pasty_ppp_usd 
	
	export excel using "$output", sheet("DataT13b", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname  *_mer_eur*  
	order shortname  mpinnx_mer_eur mcomnx_mer_eur mtbnnx_mer_eur mtaxnx_mer_eur mscinx_mer_eur mncanx_mer_eur shr_mpinnx_mer_eur shr_mcomnx_mer_eur shr_mtbnnx_mer_eur shr_mtaxnx_mer_eur shr_mscinx_mer_eur shr_mncanx_mer_eur

	export excel using "$output", sheet("DataT13c", modify) cell(B5) keepcellfmt
restore



preserve
	keep  shortname  *_mer_usd* 
	order shortname mpinnx_mer_usd mcomnx_mer_usd mtbnnx_mer_usd mtaxnx_mer_usd mscinx_mer_usd mncanx_mer_usd shr_mpinnx_mer_usd shr_mcomnx_mer_usd shr_mtbnnx_mer_usd shr_mtaxnx_mer_usd shr_mscinx_mer_usd shr_mncanx_mer_usd

	export excel using "$output", sheet("DataT13d", modify) cell(B5) keepcellfmt
restore

/*------------------------------------------------------------------------------
Table 14a. Net foreign Assets PPP € 2025 by World Regions (1980-2025) 
Table 14d. Net foreign Assets MER$  by World Regions (1980-2025) 
Table 14c. Net foreign Assets MER €  by World Regions (1980-2025) 
Table 14d. Net foreign Assets MER$  by World Regions (1980-2025) 
------------------------------------------------------------------------------*/


*Import data
use "$work_data/main_dataset.dta", clear
drop if strpos(country,"WO")

keep country year mnwnxa* mndpro* region1 region5 order

keep country year *_pasty_ppp_eur_cur *_pasty_ppp_usd_cur  *_mer_usd *_mer_eur region1 region5 order
sort country year

preserve
	collapse (sum)  m*, by(year region5)
	drop if missing(region5)
	gen order=9
	rename region5 region1
	tempfile WO_all
	save `WO_all'
restore
*Compute for regions	
collapse (sum)  m*, by(year region1 order)

append using "`WO_all'"


*Format for Excel
foreach x in  mnwnxa {
	foreach v in pasty_ppp_eur_cur mer_eur pasty_ppp_usd_cur mer_usd {
		gen `x'_`v'_sh = `x'_`v' /mndpro_`v'
		replace `x'_`v' = `x'_`v' /1000000000
		

	}
}

drop order mndpro*
reshape wide mnwnxa*, i(year) j(region1) string

keep year *WO *QE *XB *XL *XN *XF *XR *QL *XS


*Compute
foreach s in _pasty_ppp_eur_cur _mer_eur _pasty_ppp_usd_cur _mer_usd {
	foreach region in WO QE XB XL XN XF XR QL XS {
		preserve
			keep year mnwnxa`s'`region' mnwnxa`s'_sh`region'
			sum mnwnxa`s'`region' if year==$prev_year
			loc tf=r(mean)
			sum mnwnxa`s'`region' if year==2020
			loc tp=r(mean)
			sum mnwnxa`s'`region' if year==2000
			loc ts=r(mean)
			sum mnwnxa`s'`region' if year==1980
			loc ti=r(mean)
			sum mnwnxa`s'`region' if year==1800
			loc to=r(mean)
			
			sum mnwnxa`s'_sh`region' if year==$prev_year
			loc tf_s=r(mean)
			sum mnwnxa`s'_sh`region' if year==2020
			loc tp_s=r(mean)
			sum mnwnxa`s'_sh`region' if year==2000
			loc ts_s=r(mean)
			sum mnwnxa`s'_sh`region' if year==1980
			loc ti_s=r(mean)
			sum mnwnxa`s'_sh`region' if year==1800
			loc to_s=r(mean)
			
			gen region1="`region'"
			gen mnwnxa1800`s'=`to'
			gen mnwnxa1980`s'=`ti'
			gen mnwnxa2000`s'=`ts'
			gen mnwnxa2020`s'=`tp'
			gen mnwnxa$prev_year`s' =`tf'
			
			gen mnwnxa_sh1800`s'=`to_s'
			gen mnwnxa_sh1980`s'=`ti_s'
			gen mnwnxa_sh2000`s'=`ts_s'
			gen mnwnxa_sh2020`s'=`tp_s'
			gen mnwnxa_sh$prev_year`s' =`tf_s'
			
			/*
			gen change1800_$prev_year`s' = `tf' - `to'
			gen change1980_2000`s'       = `ts' - `ti'
			gen change2000_2020`s'       = `tp' - `ts'
			gen change2020_$prev_year`s' = `tf' - `tp'
			*/
			keep region mnwnxa1800  mnwnxa1980 mnwnxa2000 mnwnxa2020 mnwnxa$prev_year mnwnxa_sh1800  mnwnxa_sh1980 mnwnxa_sh2000 mnwnxa_sh2020 mnwnxa_sh$prev_year /*change1800_$prev_year change1980_2000 change2000_2020 change2020_$prev_year*/
			duplicates drop

			
			append using "`temp_reg14`s''"
			save "`temp_reg14`s''", replace
		restore
	}
}
*Append in exporting format

use "`temp_reg140'", clear
foreach s in _pasty_ppp_eur_cur _mer_eur _pasty_ppp_usd_cur _mer_usd {
	merge 1:1 region1 using  "`temp_reg14`s''", nogen
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname order)
sort order
drop region1 order 
order shortname


preserve
	keep  shortname *pasty_ppp_eur*
	

	export excel using "$output", sheet("DataT14a", modify) cell(B5) keepcellfmt

restore

preserve
	keep  shortname  **pasty_ppp_usd** 

	export excel using "$output", sheet("DataT14b", modify) cell(B5) keepcellfmt

restore

preserve
	keep  shortname *mer_eur*
	

	export excel using "$output", sheet("DataT14c", modify) cell(B5) keepcellfmt

restore

preserve
	keep  shortname  *mer_usd* 

	export excel using "$output", sheet("DataT14d", modify) cell(B5) keepcellfmt

restore





/*------------------------------------------------------------------------------
Table 15a. National Non-financial Assets by World Region PPP € (2025)
Table 15b. National Non-financial Assets by World Region PPP $ (2025)
Table 15c. National Non-financial Assets by World Region MER € (2025)
Table 15d. National Non-financial Assets by World Region MER $ (2025)
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
drop if country=="WO"

keep country region1  mnwnfa_pasty_ppp_eur mnwnfa_mer_eur mnwnfa_pasty_ppp_usd mnwnfa_mer_usd mnwhou_pasty_ppp_eur mnwhou_mer_eur mnwhou_pasty_ppp_usd mnwhou_mer_usd mnwbus_pasty_ppp_eur mnwbus_mer_eur mnwbus_pasty_ppp_usd mnwbus_mer_usd mgdpro* order

*Compute for world
preserve
	collapse (sum) mnwnfa_pasty_ppp_eur mnwnfa_mer_eur mnwnfa_pasty_ppp_usd mnwnfa_mer_usd mnwhou_pasty_ppp_eur mnwhou_mer_eur mnwhou_pasty_ppp_usd mnwhou_mer_usd mnwbus_pasty_ppp_eur mnwbus_mer_eur mnwbus_pasty_ppp_usd mnwbus_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd
	
	gen region1 ="WO"
	gen order= 9
	
	tempfile  world
	save     `world'
restore


collapse (sum) mnwnfa_pasty_ppp_eur mnwnfa_mer_eur mnwnfa_pasty_ppp_usd mnwnfa_mer_usd mnwhou_pasty_ppp_eur mnwhou_mer_eur mnwhou_pasty_ppp_usd mnwhou_mer_usd mnwbus_pasty_ppp_eur mnwbus_mer_eur mnwbus_pasty_ppp_usd mnwbus_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd, by(region1 order)

append using "`world'"
sort order


foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen  double mnwnfa_`v'_gdpsh=mnwnfa_`v'/mgdpro_`v'
	gen  double mnwhou_`v'_gdpsh=mnwhou_`v'/mgdpro_`v'
	gen  double mnwbus_`v'_gdpsh= mnwbus_`v'/mgdpro_`v'
	drop mgdpro_`v'
	
}


foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	gen aux1 = mnwnfa_`v' if region1=="WO"
	egen mnwnfa_`v'_wo = mode(aux1)
	gen aux2 = mnwhou_`v' if region1=="WO"
	egen mnwhou_`v'_wo = mode(aux2)
	gen aux3 = mnwbus_`v' if region1=="WO"
	egen mnwbus_`v'_wo = mode(aux3)
	gen  double mnwnfa_`v'_sh_con=mnwnfa_`v'/mnwnfa_`v'_wo
	gen  double mnwhou_`v'_sh_con=mnwhou_`v'/mnwhou_`v'_wo
	gen  double mnwbus_`v'_sh_con= mnwbus_`v'/ mnwbus_`v'_wo
	drop *_`v'_wo aux*
	
}



*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mnwnfa_`v' = mnwnfa_`v' /1000000000
	replace mnwhou_`v' = mnwhou_`v' /1000000000
	replace  mnwbus_`v' =  mnwbus_`v' /1000000000
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order



preserve
	keep  shortname *pasty_ppp_eur *pasty_ppp_eur_gdpsh
	order shortname  mnwhou_pasty_ppp_eur mnwbus_pasty_ppp_eur mnwnfa_pasty_ppp_eur  mnwhou_pasty_ppp_eur_gdpsh mnwbus_pasty_ppp_eur_gdpsh mnwnfa_pasty_ppp_eur_gdpsh
	

	export excel using "$output", sheet("DataT15a", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *pasty_ppp_usd *pasty_ppp_usd_gdpsh
	order shortname  mnwhou_pasty_ppp_usd mnwbus_pasty_ppp_usd mnwnfa_pasty_ppp_usd  mnwhou_pasty_ppp_usd_gdpsh mnwbus_pasty_ppp_usd_gdpsh mnwnfa_pasty_ppp_usd_gdpsh


	export excel using "$output", sheet("DataT15b", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *mer_eur *mer_eur_gdpsh
	order shortname mnwhou_mer_eur mnwbus_mer_eur  mnwnfa_mer_eur mnwhou_mer_eur_gdpsh mnwbus_mer_eur_gdpsh mnwnfa_mer_eur_gdpsh

	

	export excel using "$output", sheet("DataT15c", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *mer_usd *mer_usd_gdpsh
	order shortname mnwhou_mer_usd mnwbus_mer_usd mnwnfa_mer_usd  mnwhou_mer_usd_gdpsh mnwbus_mer_usd_gdpsh mnwnfa_mer_usd_gdpsh


	export excel using "$output", sheet("DataT15d", modify) cell(B5) keepcellfmt
restore

/*------------------------------------------------------------------------------
Table 16a. National Capital shares by World Region PPP € (2025)
Table 16b. National Capital shares by World Region PPP $ (2025)
Table 16c. National Capital shares by World Region MER € (2025)
Table 16d. National Capital shares by World Region MER $ (2025)
------------------------------------------------------------------------------*/

*      gsrgo gsrco gmxhn gsrhn
*gvato gvago gvaco gvahn

use "$work_data/main_dataset.dta",clear
keep if year==$prev_year 
drop if country=="WO"

keep country region1  mgsrgo_pasty_ppp_eur  mgsrgo_mer_eur  mgsrgo_pasty_ppp_usd  mgsrgo_mer_usd  mgsrco_pasty_ppp_eur  mgsrco_mer_eur  mgsrco_pasty_ppp_usd  mgsrco_mer_usd  mgmxhn_pasty_ppp_eur  mgmxhn_mer_eur  mgmxhn_pasty_ppp_usd  mgmxhn_mer_usd  mgsrhn_pasty_ppp_eur  mgsrhn_mer_eur  mgsrhn_pasty_ppp_usd  mgsrhn_mer_usd  mgvato_pasty_ppp_eur mgvato_mer_eur mgvato_pasty_ppp_usd mgvato_mer_usd  mgvago_pasty_ppp_eur mgvago_mer_eur mgvago_pasty_ppp_usd mgvago_mer_usd  mgvaco_pasty_ppp_eur mgvaco_mer_eur mgvaco_pasty_ppp_usd mgvaco_mer_usd  mgvahn_pasty_ppp_eur mgvahn_mer_eur mgvahn_pasty_ppp_usd mgvahn_mer_usd mgdpro* order

*Compute for world
preserve
	collapse (sum) mgsrgo_pasty_ppp_eur  mgsrgo_mer_eur  mgsrgo_pasty_ppp_usd  mgsrgo_mer_usd  mgsrco_pasty_ppp_eur  mgsrco_mer_eur  mgsrco_pasty_ppp_usd  mgsrco_mer_usd  mgmxhn_pasty_ppp_eur  mgmxhn_mer_eur  mgmxhn_pasty_ppp_usd  mgmxhn_mer_usd  mgsrhn_pasty_ppp_eur  mgsrhn_mer_eur  mgsrhn_pasty_ppp_usd  mgsrhn_mer_usd  mgvato_pasty_ppp_eur mgvato_mer_eur mgvato_pasty_ppp_usd mgvato_mer_usd  mgvago_pasty_ppp_eur mgvago_mer_eur mgvago_pasty_ppp_usd mgvago_mer_usd  mgvaco_pasty_ppp_eur mgvaco_mer_eur mgvaco_pasty_ppp_usd mgvaco_mer_usd  mgvahn_pasty_ppp_eur mgvahn_mer_eur mgvahn_pasty_ppp_usd mgvahn_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd
	
	gen region1 ="WO"
	gen order= 9
	
	tempfile  world
	save     `world'
restore


collapse (sum) mgsrgo_pasty_ppp_eur  mgsrgo_mer_eur  mgsrgo_pasty_ppp_usd  mgsrgo_mer_usd  mgsrco_pasty_ppp_eur  mgsrco_mer_eur  mgsrco_pasty_ppp_usd  mgsrco_mer_usd  mgmxhn_pasty_ppp_eur  mgmxhn_mer_eur  mgmxhn_pasty_ppp_usd  mgmxhn_mer_usd  mgsrhn_pasty_ppp_eur  mgsrhn_mer_eur  mgsrhn_pasty_ppp_usd  mgsrhn_mer_usd  mgvato_pasty_ppp_eur mgvato_mer_eur mgvato_pasty_ppp_usd mgvato_mer_usd  mgvago_pasty_ppp_eur mgvago_mer_eur mgvago_pasty_ppp_usd mgvago_mer_usd  mgvaco_pasty_ppp_eur mgvaco_mer_eur mgvaco_pasty_ppp_usd mgvaco_mer_usd  mgvahn_pasty_ppp_eur mgvahn_mer_eur mgvahn_pasty_ppp_usd mgvahn_mer_usd mgdpro_pasty_ppp_eur mgdpro_mer_eur mgdpro_pasty_ppp_usd mgdpro_mer_usd, by(region1 order)

append using "`world'"
sort order


foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	* Gvato as a share of GDP
	gen  double mgvato_`v'_gdp=mgvato_`v'/mgdpro_`v'
	*Capital share of the economy (= (gsrco + gsrhn + gsrgo + 0.4*gmxhn) / gvato)
	gen  double k_shr_`v'_gvato = (mgsrco_`v' + mgsrhn_`v' + mgsrgo_`v' + (0.4 * mgmxhn_`v')) / mgvato_`v'
	
	*Capital share in Goverment
	gen  double mgsrgo_`v'_gvago= mgsrgo_`v'/mgvago_`v'
	
	*Capital share in Corporate
	gen  double mgsrco_`v'_gvaco= mgsrco_`v'/mgvaco_`v'
	*Capital share in houshold suprplus
	gen  double mgmxhn_`v'_gvahn= mgmxhn_`v'/mgvahn_`v'
	
	*Capital share in miex income surplus
	gen  double mgsrhn_`v'_gvahn= mgsrhn_`v'/mgvahn_`v'
	
	
}
drop mgdpro* mgvago* mgvaco* mgvahn*



*Format for Excel
foreach v in pasty_ppp_eur mer_eur pasty_ppp_usd mer_usd {
	replace mgvato_`v' = mgvato_`v' /1000000000
	replace mgsrgo_`v' = mgsrgo_`v' /1000000000
	replace mgsrco_`v' = mgsrco_`v' /1000000000
	replace mgmxhn_`v' = mgmxhn_`v' /1000000000
	replace mgsrhn_`v' = mgsrhn_`v' /1000000000
}


merge m:1 region1 using "$work_data/import-region-codes-output.dta", nogen keep(master match) keepusing(shortname)

sort order



preserve
	keep  shortname *pasty_ppp_eur*
	order shortname  mgvato_pasty_ppp_eur mgvato_pasty_ppp_eur_gdp mgsrgo_pasty_ppp_eur mgsrco_pasty_ppp_eur mgmxhn_pasty_ppp_eur mgsrhn_pasty_ppp_eur k_shr_pasty_ppp_eur_gvato mgsrgo_pasty_ppp_eur_gvago mgsrco_pasty_ppp_eur_gvaco mgmxhn_pasty_ppp_eur_gvahn mgsrhn_pasty_ppp_eur_gvahn
	

	export excel using "$output", sheet("DataT16a", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *pasty_ppp_usd*
	order shortname  mgvato_pasty_ppp_usd mgvato_pasty_ppp_usd_gdp mgsrgo_pasty_ppp_usd mgsrco_pasty_ppp_usd mgmxhn_pasty_ppp_usd mgsrhn_pasty_ppp_usd k_shr_pasty_ppp_usd_gvato mgsrgo_pasty_ppp_usd_gvago mgsrco_pasty_ppp_usd_gvaco mgmxhn_pasty_ppp_usd_gvahn mgsrhn_pasty_ppp_usd_gvahn
	


	export excel using "$output", sheet("DataT16b", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *mer_eur*
	order shortname mgvato_mer_eur mgvato_mer_eur_gdp mgsrgo_mer_eur mgsrco_mer_eur mgmxhn_mer_eur mgsrhn_mer_eur k_shr_mer_eur_gvato mgsrgo_mer_eur_gvago mgsrco_mer_eur_gvaco mgmxhn_mer_eur_gvahn mgsrhn_mer_eur_gvahn
	

	

	export excel using "$output", sheet("DataT16c", modify) cell(B5) keepcellfmt
restore

preserve
	keep  shortname *mer_usd*
	order shortname mgvato_mer_usd mgvato_mer_usd_gdp mgsrgo_mer_usd mgsrco_mer_usd mgmxhn_mer_usd mgsrhn_mer_usd k_shr_mer_usd_gvato mgsrgo_mer_usd_gvago mgsrco_mer_usd_gvaco mgmxhn_mer_usd_gvahn mgsrhn_mer_usd_gvahn
	


	export excel using "$output", sheet("DataT16d", modify) cell(B5) keepcellfmt
restore














/*
**# Figure 3a
/*------------------------------------------------------------------------------
Figure 3a. Net Foreign Wealth as % National Income (MER) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mnwnxa_mer_usd mnninc_mer_usd, by(year )
	g mnwnxa_mer_ratioWorld=mnwnxa_mer_usd/mnninc_mer_usd
	drop mnwnxa_mer_usd mnninc_mer_usd
	tempfile mnwnxa_mer_ratioWorld
	save `mnwnxa_mer_ratioWorld'
restore 

*Aggregate at the region-year level
collapse (sum) mnwnxa_mer_usd mnninc_mer_usd, by(year region1)

*Format in Figure format
gen mnwnxa_mer_ratio = mnwnxa_mer_usd / mnninc_mer_usd
drop mnwnxa_mer_usd mnninc_mer_usd
reshape wide mnwnxa_mer_ratio , i(year) j(region) string
merge 1:1 year using "`mnwnxa_mer_ratioWorld'"
drop _merge 

tsset year
tsline mnwnxa_mer_ratioQE mnwnxa_mer_ratioXB mnwnxa_mer_ratioXL mnwnxa_mer_ratioXN mnwnxa_mer_ratioXF mnwnxa_mer_ratioXR mnwnxa_mer_ratioQL mnwnxa_mer_ratioXS mnwnxa_mer_ratioWorld

*Export 
export excel using "$output", sheet("DataF3", modify) cell(A4) keepcellfmt






**# Figure 3b 
/*------------------------------------------------------------------------------
Figure 3b. Net Foreign Wealth as % National Income (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta",clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mnwnxa_mer_usd mnninc_mer_usd, by(year )
	gen mnwnxa_mer_ratioWorld=mnwnxa_mer_usd/mnninc_mer_usd
	drop mnwnxa_mer_usd mnninc_mer_usd
	tempfile  mnwnxa_mer_ratioWorld
	save     `mnwnxa_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"

keep if _merge==3
drop _merge

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mnwnxa_mer_usd mnninc_mer_usd, by(year countryname)

*Format in Figure format
gen mnwnxa_mer_ratio=mnwnxa_mer_usd/mnninc_mer_usd
drop mnwnxa_mer_usd mnninc_mer_usd
reshape wide mnwnxa_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mnwnxa_mer_ratioWorld'", nogen


ren mnwnxa_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)', title("Net foreign wealth as % national income (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: A significant portion of the country's wealth comes from foreign investments (difference between" "a country's foreign assets and its foreign liabilities).") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF3_large", modify) cell(A4) keepcellfmt




**# Figure 4a
/*------------------------------------------------------------------------------
Figure 4a. Net Foreign Wealth as % National Income (PPP) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd , by(year)
	g mnwnxa_ppp_ratioWorld = mnwnxa_pasty_ppp_usd / mnninc_pasty_ppp_usd
	drop mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd
	
	tempfile mnwnxa_ppp_ratioWorld
	save    `mnwnxa_ppp_ratioWorld'
restore 

*Aggregate at the region-year level
collapse (sum) mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd, by(year region1)

*Format in Figure format
g mnwnxa_pasty_ppp_ratio = mnwnxa_pasty_ppp_usd/mnninc_pasty_ppp_usd
drop mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd
reshape wide mnwnxa_pasty_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mnwnxa_ppp_ratioWorld'"
drop _merge 


tsset year
ren mnwnxa_pasty_ppp_ratio* *
tsline QE QL XB XF XL XN XR XS mnwnxa_ppp_ratioWorld

*Export 
export excel using "$output", sheet("DataF4", modify) cell(A4) keepcellfmt






**# Figure 4b
/*------------------------------------------------------------------------------
Figure 4b. Net Foreign Wealth as % National Income (PPP) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd, by(year )
	g mnwnxa_ppp_ratioWorld=mnwnxa_pasty_ppp_usd/mnninc_pasty_ppp_usd
	drop mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd
	
	tempfile mnwnxa_ppp_ratioWorld
	save `mnwnxa_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd, by(year countryname)

*Format in Figure format
g mnwnxa_ppp_ratio=mnwnxa_pasty_ppp_usd/mnninc_pasty_ppp_usd
drop mnwnxa_pasty_ppp_usd mnninc_pasty_ppp_usd
reshape wide mnwnxa_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mnwnxa_ppp_ratioWorld'"
drop _merge 


ren mnwnxa_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}


tsset year
ds year, not
tsline `r(varlist)', title("Net foreign wealth as % national income (PPP)" "by country 1970-$pastyear" "in current USD") note("Positive value: A significant portion of the country's wealth comes from foreign investments (difference between" "a country's foreign assets and its foreign liabilities).") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF4_large", modify) cell(A4) keepcellfmt





**# Figure 5a 
/*------------------------------------------------------------------------------
Figure 5a. Net Foreign Income as % Net Domestic Product (MER) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data 
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mnnfin_mer_usd, by(year )
	g mnnfin_mer_ratioWorld=mnnfin_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mnnfin_mer_usd
	tempfile mnnfin_mer_ratioWorld
	save `mnnfin_mer_ratioWorld.dta'
restore 

*Aggregate at the region-year level
collapse (sum) mndpro_mer_usd mnnfin_mer_usd, by(year region1)

*Format in Figure format
g mnnfin_mer_ratio=mnnfin_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mnnfin_mer_usd
reshape wide mnnfin_mer_ratio , i(year) j(region1) string
merge 1:1 year using "`mnnfin_mer_ratioWorld.dta'"
drop _merge 
rename mnnfin_mer_ratio* *

tsset year
ds year, not
tsline `r(varlist)', title("Net Foreign Income as % Net Domestic Product (MER)" "by country 1970-$pastyear" "in current USD") yline(0,lcolor(gray)) xla(1970(2)$pastyear,angle(90) labsize(small)) ///
lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))

*Export 
export excel using "$output", sheet("DataF5", modify) cell(A4) keepcellfmt





**# Figure 5b
/*------------------------------------------------------------------------------
Figure 5b. Net Foreign Income as % Net Domestic Product (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/

*Import data (start here)
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mnnfin_mer_usd, by(year )
	g mnnfin_mer_ratioWorld=mnnfin_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mnnfin_mer_usd
	
	tempfile mnnfin_mer_ratioWorld
	save `mnnfin_mer_ratioWorld'
restore 

merge m:1 country using  "$work_data/largest.dta"
keep if _merge==3
drop _merge

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mndpro_mer_usd mnnfin_mer_usd, by(year countryname)

*Format in Figure format
g mnnfin_mer_ratio=mnnfin_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mnnfin_mer_usd
reshape wide mnnfin_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mnnfin_mer_ratioWorld'"
drop _merge 



ren mnnfin_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not
tsline `r(varlist)', title("Net foreign income as % net domestic product (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: The country earns more from abroad than foreigners earn within it.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF5_large", modify) cell(A4) keepcellfmt




**# Figures 5c and 5e 
/*------------------------------------------------------------------------------
Figure 5c. Net Foreign Capital Income as % Net Domestic Product (MER) by World Region 1970-$pastyear

Figure 5e. Net Foreign Labor Income as % Net Domestic Product (MER) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/
foreach var in mpinnx mcomnx{


*Use the WID
	use "$work_data/main_dataset.dta", clear
	g `var'_mer_usd=(inyixx*`var')/xlceup
	keep if year>=1970
	drop if country=="WO"
	preserve
		*Aggregate at the national-year level
		collapse (sum) mndpro_mer_usd `var'_mer_usd, by(year )
		g `var'_mer_ratioWorld=`var'_mer_usd/mndpro_mer_usd
		drop mndpro_mer_usd `var'_mer_usd
		tempfile `var'_mer_ratioWorld
		save ``var'_mer_ratioWorld'
	restore 
	*Aggregate at the region-year level
	collapse (sum) mndpro_mer_usd `var'_mer_usd, by(year region1)
	*Format in Figure format
	g `var'_mer_ratio=`var'_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd `var'_mer_usd
	reshape wide `var'_mer_ratio , i(year) j(region1) string
	merge 1:1 year using "``var'_mer_ratioWorld'"
	drop _merge 
	rename `var'_mer_ratio* *
	
	tsset year
	ds year, not
	tsline `r(varlist)', title("`var' as % Net Domestic Product (MER)"  "by country 1970-$pastyear" "in current USD") yline(0,lcolor(gray)) xla(1970(2)$pastyear,angle(90) labsize(small)) ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
	export excel using "$output", sheet("DataF5_`var'", modify) cell(A4) keepcellfmt
}




**# Figure 5d
/*------------------------------------------------------------------------------
Figure 5d. Net Foreign Capital Income as % Net Domestic Product (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/

use "$work_data/main_dataset.dta", clear
g mpinnx_mer_usd=(inyixx*mpinnx)/xlcusx
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mpinnx_mer_usd, by(year )
	g mpinnx_mer_ratioWorld=mpinnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mpinnx_mer_usd
	tempfile mpinnx_mer_ratioWorld
	save `mpinnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mndpro_mer_usd mpinnx_mer_usd, by(year countryname)

*Format in Figure format
g mpinnx_mer_ratio=mpinnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mpinnx_mer_usd
reshape wide mpinnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mpinnx_mer_ratioWorld'"
drop _merge 


ren mpinnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}

tsset year
ds year, not
tsline `r(varlist)', title("Net foreign capital income as % net domestic product (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: The country earns more from abroad than foreigners earn within it.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 


*Export 
export excel using "$output", sheet("DataF5_large_mpinnx", modify) cell(A4) keepcellfmt

	
**# Figure 5f
/*------------------------------------------------------------------------------
Figure 5f. Net Foreign Labor Income as % Net Domestic Product (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/	

use "$work_data/main_dataset.dta", clear
gen mcomnx_mer_usd=(inyixx*mcomnx)/xlcusx
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mcomnx_mer_usd, by(year )
	g mcomnx_mer_ratioWorld=mcomnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mcomnx_mer_usd
	tempfile mcomnx_mer_ratioWorld
	save `mcomnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mndpro_mer_usd mcomnx_mer_usd, by(year countryname)

*Format in Figure format
g mcomnx_mer_ratio=mcomnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mcomnx_mer_usd
reshape wide mcomnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mcomnx_mer_ratioWorld'"
drop _merge 


ren mcomnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not 
tsline `r(varlist)',  title("Net foreign capital income as % net domestic product (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: The country earns more from abroad than foreigners earn within it.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF5_large_mcomnx", modify) cell(A4) keepcellfmt
	
	
	

**# Figures 5g 
/*------------------------------------------------------------------------------
Figure 5g. Net Foreign Taxes and Subsidies as % Net Domestic Product (MER) by World Region 1970-$pastyear

------------------------------------------------------------------------------*/

foreach var in mtaxnx {
*Use the RAW data shared by Gaston if the WID is not updated

*Use the WID if it is updated (start here)
	use "$work_data/main_dataset.dta", clear
	gen `var'_mer_usd=(inyixx*`var')/xlcusx
	keep if year>=1970
	drop if country=="WO"
	preserve
		*Aggregate at the national-year level
		collapse (sum) mndpro_mer_usd `var'_mer_usd, by(year)
		gen `var'_mer_ratioWorld=`var'_mer_usd/mndpro_mer_usd
		drop mndpro_mer_usd `var'_mer_usd
		
		tempfile `var'_mer_ratioWorld
		save ``var'_mer_ratioWorld'
	restore 
	
	*Aggregate at the region-year level
	collapse (sum) mndpro_mer_usd `var'_mer_usd, by(year region1)
	*Format in Figure format
	gen `var'_mer_ratio=`var'_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd `var'_mer_usd
	reshape wide `var'_mer_ratio , i(year) j(region1) string
	merge 1:1 year using "``var'_mer_ratioWorld'"
	
	drop _merge 
	
	tsset year
	ds year, not 
	tsline `r(varlist)', title("`var' as % net domestic product (MER)" "by country 1970-$pastyear" "in current USD") yline(0,lcolor(gray)) xla(1970(2)$pastyear,angle(90) labsize(small)) ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	export excel using "$output", sheet("DataF5_`var'", modify) cell(A4) keepcellfmt
}


	
	
	

**# Figure 5h
/*------------------------------------------------------------------------------
Figure 5h. Net Foreign Taxes and Subsidies as % Net Domestic Product (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/	


use "$work_data/main_dataset.dta", clear
gen mtaxnx_mer_usd=(inyixx*mtaxnx)/xlcusx
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_mer_usd mtaxnx_mer_usd, by(year )
	g mtaxnx_mer_ratioWorld=mtaxnx_mer_usd/mndpro_mer_usd
	drop mndpro_mer_usd mtaxnx_mer_usd
	tempfile mtaxnx_mer_ratioWorld
	save `mtaxnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mndpro_mer_usd mtaxnx_mer_usd, by(year countryname)

*Format in Figure format
g mtaxnx_mer_ratio=mtaxnx_mer_usd/mndpro_mer_usd
drop mndpro_mer_usd mtaxnx_mer_usd
reshape wide mtaxnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mtaxnx_mer_ratioWorld'"
drop _merge 


ren mtaxnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
	 
tsset year
ds year, not 
tsline `r(varlist)', title("Net foreign taxes and subsidies as % net domestic product (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: The country earns more from abroad than foreigners earn within it.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF5_large_mtaxnx", modify) cell(A4) keepcellfmt	
	

	


	




**# Figure 6a
/*------------------------------------------------------------------------------
Figure 6a. Net Foreign Income as % Net Domestic Product (PPP) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta", clear

keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd, by(year )
	g mnnfin_ppp_ratioWorld=mnnfin_pasty_ppp_usd/mndpro_pasty_ppp_usd
	drop mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd
	tempfile mnnfin_ppp_ratioWorld
	save `mnnfin_ppp_ratioWorld'
restore 

*Aggregate at the region-year level
collapse (sum) mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd, by(year region1)

*Format in Figure format
g mnnfin_ppp_ratio=mnnfin_pasty_ppp_usd/mndpro_pasty_ppp_usd
drop mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd
reshape wide mnnfin_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mnnfin_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not 
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF6", modify) cell(A4) keepcellfmt






**# Figure 6b
/*------------------------------------------------------------------------------
Figure 6b. Net Foreign Income as % Net Domestic Product (PPP) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

preserve
	*Aggregate at the national-year level
	collapse (sum) mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd, by(year )
	g mnnfin_ppp_ratioWorld=mnnfin_pasty_ppp_usd/mndpro_pasty_ppp_usd
	drop mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd
	tempfile mnnfin_ppp_ratioWorld
	save `mnnfin_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region-year level
collapse (sum) mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd, by(year countryname)

*Format in Figure format
g mnnfin_ppp_ratio=mnnfin_pasty_ppp_usd/mndpro_pasty_ppp_usd
drop mndpro_pasty_ppp_usd mnnfin_pasty_ppp_usd
reshape wide mnnfin_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mnnfin_ppp_ratioWorld'"
drop _merge 
cap erase mnnfin_ppp_ratioWorld.dta

ren mnnfin_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not 
tsline `r(varlist)', title("Net foreign income as % net domestic product (PPP)" "by country 1970-$pastyear" "in current USD") note("Positive value: The country earns more from abroad than foreigners earn within it.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*Export 
export excel using "$output", sheet("DataF6_large", modify) cell(A4) keepcellfmt






**# Table 13
/*------------------------------------------------------------------------------
Table 13. Per Capita National Income and Trade Balance ($pastyear)
------------------------------------------------------------------------------*/

*Import data
use "$work_data/main_dataset.dta", clear
keep if year==$pastyear
drop if country=="WO"
drop mnninc_mer_usd  mnninc_pasty_ppp_usd
*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx {
	gen `var'_ppp=`var'/ppp_eur
	gen `var'_mer=`var'/xlcusx
	gen `var'_ppp_pc=`var'_ppp/npopul
	gen `var'_mer_pc=`var'_mer/npopul
}



 *Sort from lowest to highest per capita national income (PPP)
 sort mnninc_ppp_pc
 
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
	collapse (sum) npopul  mnninc_ppp mnninc_mer mtbnnx_ppp mtbnnx_mer mtbxrx_ppp mtbxrx_mer mtbmpx_ppp mtbmpx_mer   	
	sum npopul
	loc npopul=r(mean)
	foreach var in mnninc {
		sum `var'_ppp
		loc mnninc_ppp=r(mean)
		loc `var'_ppp_pc= `mnninc_ppp'/`npopul'
		sum `var'_mer
		loc mnninc_mer=r(mean)
		loc `var'_mer_pc=`mnninc_mer'/`npopul'
	}
	foreach var in mtbnnx mtbxrx mtbmpx {
		sum `var'_ppp
		loc `var'_ppp_ratio=r(mean)/`mnninc_ppp'
		sum `var'_mer
		loc `var'_mer_ratio= r(mean)/`mnninc_mer'
	}
	loc mnninc_pc_ratio=`mnninc_mer_pc'/`mnninc_ppp_pc'
	
	sum mnninc_mer 
	loc mnninc_mer=r(mean)
	sum mnninc_ppp
	loc mnninc_ppp=r(mean)
	
	loc mnninc_ratio=`mnninc_mer'/`mnninc_ppp'
restore

 *Compute per percentile
 collapse (sum) npopul mnninc_ppp mnninc_mer mtbnnx_ppp mtbnnx_mer mtbxrx_ppp mtbxrx_mer mtbmpx_ppp mtbmpx_mer, by(percentile)
 
foreach var in mnninc {
	gen `var'_ppp_pc=`var'_ppp/npopul
	gen `var'_mer_pc= `var'_mer/npopul
}

foreach var in mtbnnx mtbxrx mtbmpx{
	gen `var'_ppp_ratio=`var'_ppp/mnninc_ppp
	gen `var'_mer_ratio= `var'_mer/mnninc_mer
}
gen mnninc_pc_ratio=mnninc_mer_pc/mnninc_ppp_pc
gen mnninc_ratio=mnninc_mer/mnninc_ppp
 
*Include World 
set obs `=_N+1'
replace percentile="World" if percentile==""
foreach var in mnninc {
	replace `var'_ppp_pc	=``var'_ppp_pc' 	if percentile=="World" & `var'_ppp_pc==.
	replace `var'_mer_pc	=``var'_mer_pc' 	if percentile=="World" & `var'_mer_pc==.		
}
foreach var in mtbnnx mtbxrx mtbmpx{
	replace `var'_ppp_ratio	=``var'_ppp_ratio' 	if percentile=="World" & `var'_ppp_ratio==.
	replace `var'_mer_ratio	=``var'_mer_ratio' 	if percentile=="World" & `var'_mer_ratio==.
}
replace mnninc_pc_ratio		=`mnninc_pc_ratio' 	if percentile=="World" & mnninc_pc_ratio==.
replace mnninc_ratio		=`mnninc_ratio' 	if percentile=="World" & mnninc_ratio==.	
	
*Format for exporting	
order percentile mnninc_ppp_pc mtbxrx_ppp_ratio mtbmpx_ppp_ratio mtbnnx_ppp_ratio mnninc_mer_pc mnninc_ratio mtbxrx_mer_ratio mtbmpx_mer_ratio mtbnnx_mer_ratio
drop npopul mnninc_ppp mnninc_mer mtbnnx_ppp mtbnnx_mer mtbxrx_ppp mtbxrx_mer mtbmpx_ppp mtbmpx_mer 


*Export to excel
export excel using "$output", sheet("DataT13", modify) cell(A4) keepcellfmt





**# Figure 7a
/*------------------------------------------------------------------------------
Figure 7a. Net Trade Balance as % National Income (MER) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/
*Import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx {
	g `var'_mer=(inyixx*`var')/xlcusx
}

preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year )
	gen  mtbnnx_mer_ratioWorld=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	tempfile mtbnnx_mer_ratioWorld
	save `mtbnnx_mer_ratioWorld'
restore 

*Aggregate at the region-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year region1)

*Format in Figure format
g mtbnnx_mer_ratio=mtbnnx_mer/mnninc_mer
drop mtbnnx_mer mnninc_mer
reshape wide mtbnnx_mer_ratio , i(year) j(region1) string
merge 1:1 year using "`mtbnnx_mer_ratioWorld'"
drop _merge 


tsset year
ds year, not 
tsline `r(varlist)'

*Export 
export excel using "$output", sheet("DataF7", modify) cell(A4) keepcellfmt





**# Figures 7b and 7c 
/*------------------------------------------------------------------------------
Figure 7b. Net Trade Balance (Goods) as % National Income (MER) by World Region 1970-$pastyear

Figure 7c. Net Trade Balance (Services) as % National Income (MER) by World Region 1970-$pastyear
------------------------------------------------------------------------------*/

* Import data
use "$work_data/main_dataset.dta", clear

*Generate relevant variables
foreach var in mtbxrx mtbmpx mtbnnx   	mtgxrx mtgmpx mtgnnx  	mtsxrx mtsmpx mtsnnx mnninc{
	g `var'_mer=((inyixx*`var')/xlcusx)/1000
}


replace region1="World" if country=="WO"
// use main_dataset.dta,clear
keep if year>=1970
drop if country=="WO"



preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year )
	g tb_mer_ratioWorld=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	tempfile tb_mer_ratioWorld
	save `tb_mer_ratioWorld'
restore 

preserve
	*Aggregate at the region-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year region1)


	*Format in Figure format
	g tb_mer_ratio=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	reshape wide tb_mer_ratio , i(year) j(region1) string
	merge 1:1 year using `tb_mer_ratioWorld'
	drop _merge 


	tsset year
	ren tb_mer_ratio* *
	 foreach var of varlist _all {
		label var `var' ""
	}
	tsset year
	ds year, not 
	tsline `r(varlist)', title("Trade Balance (G&S)" "% of National Income (MER)")  ///
	lcolor(red ebblue green gold magenta orange sienna purple black) legend(row(2))
restore


*****Goods

preserve
	*Aggregate at the national-year level
	collapse (sum) mtgnnx_mer mnninc_mer, by(year )
	g tb_mer_ratioWorld=mtgnnx_mer/mnninc_mer
	drop mtgnnx_mer mnninc_mer
	tempfile tb_mer_ratioWorld
	save `tb_mer_ratioWorld'
restore 



preserve
	*Aggregate at the region-year level
	collapse (sum) mtgnnx_mer mnninc_mer, by(year region1)

	*Format in Figure format
	g tb_mer_ratio=mtgnnx_mer/mnninc_mer
	drop mtgnnx_mer mnninc_mer
	reshape wide tb_mer_ratio , i(year) j(region1) string
	merge 1:1 year using `tb_mer_ratioWorld'
	drop _merge 


	tsset year
	ren tb_mer_ratio* *
	 foreach var of varlist _all {
		label var `var' ""
	}

	tsset year
	ds year, not 
	tsline `r(varlist)', title("Trade Balance (G)" "% of National Income (MER)")  ///
	lcolor(red ebblue green gold magenta orange sienna purple black) legend(row(2))

	keep year QL QE XL XN XB XR XF XS World
	order year QL QE XL XN XB XR XF XS World
	*Export 
	export excel using "$output", sheet("DataF7b", modify) cell(A4) keepcellfmt
restore


*****Services

preserve
	*Aggregate at the national-year level
	collapse (sum) mtsnnx_mer mnninc_mer, by(year )
	g tb_mer_ratioWorld=mtsnnx_mer/mnninc_mer
	drop mtsnnx_mer mnninc_mer
	tempfile tb_mer_ratioWorld
	save `tb_mer_ratioWorld'
restore 



preserve
*Aggregate at the region-year level
	collapse (sum) mtsnnx_mer mnninc_mer, by(year region1)

	*Format in Figure format
	g tb_mer_ratio=mtsnnx_mer/mnninc_mer
	drop mtsnnx_mer mnninc_mer
	reshape wide tb_mer_ratio , i(year) j(region1) string
	merge 1:1 year using "`tb_mer_ratioWorld'"
	drop _merge 
	

	tsset year
	ren tb_mer_ratio* *
	 foreach var of varlist _all {
		label var `var' ""
	}
	tsset year
	ds year, not 
	tsline `r(varlist)', title("Trade Balance (S)" "% of National Income (MER)")  ///
	lcolor(red ebblue green gold magenta orange sienna purple black) legend(row(2))
	
	keep year QL QE XL XN XB XR XF XS World
	order year QL QE XL XN XB XR XF XS World
	*Export 
	export excel using "$output", sheet("DataF7c", modify) cell(A4) keepcellfmt
restore








**# Figure 7d
/*------------------------------------------------------------------------------
Figure 7d. Net Trade Balance as % World Income (MER) by World region1 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
 drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	gen `var'_mer=(inyixx*`var')/xlcusx
}


preserve
	*Aggregate at the national-year level
	drop if country=="WO"
	collapse (sum)  mnninc_mer mtbnnx_mer, by(year )
	ren mnninc_mer mnninc_mer_world
	ren mtbnnx_mer mtbnnx_mer_world
	tempfile mnninc_mer_World
	save `mnninc_mer_World'
restore 

*Aggregate at the region1-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year region1)

merge m:1 year using "`mnninc_mer_World'"
keep if _merge==3
drop _merge

gen mtbnnx_mer_world_ratio=mtbnnx_mer/mnninc_mer_world
gen  mtbnnx_mer_world_ratio_world=mtbnnx_mer_world/mnninc_mer_world

drop mtbnnx_mer mnninc_mer mnninc_mer_world mtbnnx_mer_world
*Format in Figure format
reshape wide mtbnnx_mer_world_ratio mtbnnx_mer_world_ratio_world, i(year) j(region1) string


ren mtbnnx_mer_world_ratio* *
keep year QL QE XL XN XB XR XF XS _worldQE // Any _world works here
ren _world* World

tsset year
ds year, not 
tsline `r(varlist)'
order year QL QE XL XN XB XR XF XS World
*export 
export excel using "$output", sheet("DataF7d", modify) cell(A4) keepcellfmt









**# Figure 7e
/*------------------------------------------------------------------------------
Figure 7e. Net Trade Balance as % National Income (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	g `var'_mer=(inyixx*`var')/xlcusx
}

preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year )
	g mtbnnx_mer_ratioWorld=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	tempfile mtbnnx_mer_ratioWorld
	save `mtbnnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year countryname)

*Format in Figure format
g mtbnnx_mer_ratio=mtbnnx_mer/mnninc_mer
drop mtbnnx_mer mnninc_mer
reshape wide mtbnnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mtbnnx_mer_ratioWorld'"
drop _merge 


ren mtbnnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not 
tsline `r(varlist)',   title("Net trade balance as % national income (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the size of the economy.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*export 
export excel using "$output", sheet("DataF7_large", modify) cell(A4) keepcellfmt





**# Figure 7f
/*------------------------------------------------------------------------------
Figure 7f. Net Trade Balance (Goods) as % National Income (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/


*import data
use "$work_data/main_dataset.dta", clear

*Generate relevant variables
foreach var in mtbxrx mtbmpx mtbnnx mtgxrx mtgmpx mtgnnx  mtsxrx mtsmpx mtsnnx mnninc{
	gen `var'_mer=((inyixx*`var')/xlcusx)/1000
}


*Goods
*g mtbnnx_mer=mtgnnx_mer
*g mnninc_mer=mnninc_mer
		
preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year )
	g mtbnnx_mer_ratioWorld=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	tempfile mtbnnx_mer_ratioWorld
	save `mtbnnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year countryname)

*Format in Figure format
g mtbnnx_mer_ratio=mtbnnx_mer/mnninc_mer
drop mtbnnx_mer mnninc_mer
reshape wide mtbnnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mtbnnx_mer_ratioWorld'"
drop _merge 


ren mtbnnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
keep if inrange(year,1970,$pastyear)

tsset year
ds year, not 
tsline `r(varlist)',  title("Net trade balance as % national income (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the size of the economy.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*export 
export excel using "$output", sheet("DataF7b_large", modify) cell(A4) keepcellfmt




**# Figure 7g
/*------------------------------------------------------------------------------
Figure 7g. Net Trade Balance (Services) as % National Income (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/

*import data
use "$work_data/main_dataset.dta", clear


*Generate relevant variables
foreach var in mtbxrx mtbmpx mtbnnx mtgxrx mtgmpx mtgnnx mtsxrx mtsmpx mtsnnx mnninc {
	gen `var'_mer=((inyixx*`var')/xlcusx)/1000
}

// *Goods & services
// g mtbnnx_mer=mmtbnnxnnx_mer
// g mnninc_mer=mnninc_mer
		

*Services
*g mtbnnx_mer=mtsnnx_mer
*g mnninc_mer=mnninc_mer
		

preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_mer mnninc_mer, by(year )
	g mtbnnx_mer_ratioWorld=mtbnnx_mer/mnninc_mer
	drop mtbnnx_mer mnninc_mer
	tempfile mtbnnx_mer_ratioWorld
	save `mtbnnx_mer_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year countryname)

*Format in Figure format
g mtbnnx_mer_ratio=mtbnnx_mer/mnninc_mer
drop mtbnnx_mer mnninc_mer
reshape wide mtbnnx_mer_ratio , i(year) j(countryname) string
merge 1:1 year using "`mtbnnx_mer_ratioWorld'"
drop _merge 


ren mtbnnx_mer_ratio* *

foreach var of varlist _all {
	label var `var' ""
}

keep if inrange(year,1970,$pastyear)

tsset year
ds year, not 
tsline `r(varlist)', title("Net trade balance as % national income (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the size of the economy.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*export 
export excel using "$output", sheet("DataF7c_large", modify) cell(A4) keepcellfmt





**# Figure 7h
/*------------------------------------------------------------------------------
Figure 7h. Net Trade Balance as % World Income (MER) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	g `var'_mer=(inyixx*`var')/xlcusx
}


preserve
	*Aggregate at the national-year level
	collapse (sum)  mnninc_mer mtbnnx_mer, by(year )
	ren mnninc_mer mnninc_mer_world
	ren mtbnnx_mer mtbnnx_mer_world
	tempfile  mnninc_mer_World
	save `mnninc_mer_World'
restore 

merge m:1 country using  "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_mer mnninc_mer, by(year countryname)

merge m:1 year using "`mnninc_mer_World'"
keep if _merge==3
drop _merge

g mtbnnx_mer_world_ratio=mtbnnx_mer/mnninc_mer_world
g mtbnnx_mer_world_ratio_world=mtbnnx_mer_world/mnninc_mer_world

drop mtbnnx_mer mnninc_mer mnninc_mer_world

*Format in Figure format
replace countryname="UK" if countryname=="United_Kingdom"
reshape wide mtbnnx_mer_world_ratio, i(year) j(countryname) string

ren mtbnnx_mer_world_ratio* *
ren (_world UK) (World United_Kingdom)

foreach var of varlist _all {
	label var `var' ""
}
 drop mtbnnx_mer_world
tsset year
ds year, not 
tsline `r(varlist)', title("Net trade balance as % world national income (MER)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the world economic output.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) 

*export 
export excel using "$output", sheet("DataF7b_large", modify) cell(A4) keepcellfmt













**# Figure 8a
/*------------------------------------------------------------------------------
Figure 8a. Net Trade Balance as % National Income (PPP) by World region1 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	g `var'_ppp=(inyixx*`var')/ppp_usd
}

preserve
*Aggregate at the national-year level
	collapse (sum) mtbnnx_ppp mnninc_ppp, by(year )
	g mtbnnx_ppp_ratioWorld=mtbnnx_ppp/mnninc_ppp
	drop mtbnnx_ppp mnninc_ppp
	tempfile mtbnnx_ppp_ratioWorld
	save `mtbnnx_ppp_ratioWorld'
restore 

*Aggregate at the region1-year level
collapse (sum) mtbnnx_ppp mnninc_ppp, by(year region1)

*Format in Figure format
g mtbnnx_ppp_ratio=mtbnnx_ppp/mnninc_ppp
drop mtbnnx_ppp mnninc_ppp
reshape wide mtbnnx_ppp_ratio , i(year) j(region1) string
merge 1:1 year using "`mtbnnx_ppp_ratioWorld'"
drop _merge 


tsset year
ds year, not 
tsline `r(varlist)'

*export 
export excel using "$output", sheet("DataF8", modify) cell(A4) keepcellfmt




**# Figure 8b
/*------------------------------------------------------------------------------
Figure 8b. Net Trade Balance as % World Income (PPP) by World region1 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
 drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	gen `var'_ppp=(inyixx*`var')/ppp_usd
}


preserve
	*Aggregate at the national-year level
	drop if country=="WO"
	collapse (sum)  mnninc_ppp mtbnnx_ppp, by(year )
	ren mnninc_ppp mnninc_ppp_world
	ren mtbnnx_ppp mtbnnx_ppp_world
	tempfile mnninc_ppp_World
	save `mnninc_ppp_World'
restore 

*Aggregate at the region1-year level
collapse (sum) mtbnnx_ppp mnninc_ppp, by(year region1)

merge m:1 year using "`mnninc_ppp_World'"
keep if _merge==3
drop _merge

gen mtbnnx_ppp_world_ratio=mtbnnx_ppp/mnninc_ppp_world
gen mtbnnx_ppp_world_ratio_world=mtbnnx_ppp_world/mnninc_ppp_world

drop mtbnnx_ppp mnninc_ppp mnninc_ppp_world mtbnnx_ppp_world
*Format in Figure format
reshape wide mtbnnx_ppp_world_ratio mtbnnx_ppp_world_ratio_world, i(year) j(region1) string


ren mtbnnx_ppp_world_ratio* *
keep year QL QE XL XN XB XR XF XS _worldQL
ren _worldQL World

tsset year
tsline  QL QE XL XN XB XR XF XS World
order year QL QE XL XN XB XR XF XS World

*export 
export excel using "$output", sheet("DataF8b", modify) cell(A4) keepcellfmt





**# Figure 8c
/*------------------------------------------------------------------------------
Figure 8c. Net Trade Balance as % National Income (PPP) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	g `var'_ppp=(inyixx*`var')/ppp_usd
}

preserve
	*Aggregate at the national-year level
	collapse (sum) mtbnnx_ppp mnninc_ppp, by(year )
	g mtbnnx_ppp_ratioWorld=mtbnnx_ppp/mnninc_ppp
	drop mtbnnx_ppp mnninc_ppp
	tempfile mtbnnx_ppp_ratioWorld
	save `mtbnnx_ppp_ratioWorld'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_ppp mnninc_ppp, by(year countryname)

*Format in Figure format
g mtbnnx_ppp_ratio=mtbnnx_ppp/mnninc_ppp
drop mtbnnx_ppp mnninc_ppp
reshape wide mtbnnx_ppp_ratio , i(year) j(countryname) string
merge 1:1 year using "`mtbnnx_ppp_ratioWorld'"
drop _merge 


ren mtbnnx_ppp_ratio* *

foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not 
tsline `r(varlist)', title("Net trade balance as % national income (PPP)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the size of the economy.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) 

*export 
export excel using "$output", sheet("DataF8_large", modify) cell(A4) keepcellfmt




**# Figure 8d
/*------------------------------------------------------------------------------
Figure 8d. Net Trade Balance as % World Income (PPP) for the Largest Economies 1970-$pastyear
------------------------------------------------------------------------------*/
*import data
use "$work_data/main_dataset.dta", clear
keep if year>=1970
drop if country=="WO"

*Generate relevant variables
foreach var in mnninc mtbnnx mtbxrx mtbmpx{
	gen `var'_ppp=(inyixx*`var')/ppp_usd
}


preserve
	*Aggregate at the national-year level
	collapse (sum)  mnninc_ppp mtbnnx_ppp, by(year )
	ren mnninc_ppp mnninc_ppp_world
	ren mtbnnx_ppp mtbnnx_ppp_world
	tempfile mnninc_ppp_World
	save `mnninc_ppp_World'
restore 

merge m:1 country using "$work_data/largest.dta"
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)

*Aggregate at the region1-year level
collapse (sum) mtbnnx_ppp mnninc_ppp, by(year countryname)

merge m:1 year using "`mnninc_ppp_World'"
keep if _merge==3
drop _merge

g mtbnnx_ppp_world_ratio=mtbnnx_ppp/mnninc_ppp_world
g mtbnnx_ppp_world_ratio_world=mtbnnx_ppp_world/mnninc_ppp_world

drop mtbnnx_ppp mnninc_ppp mnninc_ppp_world mtbnnx_ppp_world
*Format in Figure format
replace countryname="UK" if countryname=="United_Kingdom"
reshape wide mtbnnx_ppp_world_ratio , i(year) j(countryname) string


ren mtbnnx_ppp_world_ratio* *
ren (_world UK ) (World United_Kingdom) 


foreach var of varlist _all {
	label var `var' ""
}
 
tsset year
ds year, not 
tsline `r(varlist)', title("Net trade balance as % world national income (PPP)" "by country 1970-$pastyear" "in current USD") note("Positive value: Trade surplus, meaning exports exceed imports. The larger the absolute value " "of the percentage, the more significant the trade imbalance is relative to the world economic output.") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(2)) lcolor(green red  blue cyan magenta gold orange purple brown pink ) 

*export 
export excel using "$output", sheet("DataF8b_large", modify) cell(A4) keepcellfmt

