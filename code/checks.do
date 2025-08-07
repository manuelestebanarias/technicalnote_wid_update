

*Erase all temporary files
local datafiles: dir "$root\outputs\checks\nfts" files ".*png"
foreach datafile of local datafiles {
        rm `datafile'
}



 
 **# net foreign taxes and subsidies NDP

wid,  ind(mtaxnx inyixx xlcusx mndpro) ag(999) pop(i) clear
keep if year>=1990
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region




	
	
	
	
 preserve
keep if region =="EASA"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
		replace `s' = subinstr(`s', "'", "", .)
		replace `s' = subinstr(`s', "´", "", .)		
		replace `s' = subinstr(`s', "`", "", .)				
replace countryname="CAF" if countryname=="Central_African_Republic" 	
replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
replace countryname="Cote_dIvoire" if country=="CI" 	
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline  China Hong_Kong Japan Korea Macao Mongolia North_Korea Taiwan  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "EASA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
 graph export "$root\outputs\checks\\nfts\\easa1_nfts.png",replace
 
 restore





 preserve
keep if region =="SSAF"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
		replace `s' = subinstr(`s', "'", "", .)
		replace `s' = subinstr(`s', "´", "", .)		
		replace `s' = subinstr(`s', "`", "", .)				
replace countryname="CAF" if countryname=="Central_African_Republic" 	
replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
replace countryname="Cote_dIvoire" if country=="CI" 	
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Angola Benin Botswana Burkina_Faso Burundi CAF Cabo_Verde Cameroon Chad Comoros  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSAF 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\ssaf1_nfts.png",replace

  tsline   Congo Cote_dIvoire DR_Congo Djibouti Equatorial_Guinea Eritrea Ethiopia Gabon  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSAF 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssaf2_nfts.png",replace


    tsline   Gambia Ghana Guinea GuineaBissau Kenya Lesotho  Liberia Madagascar Malawi Mali , title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSAF 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssaf3_nfts.png",replace
	
	    tsline   Mauritania Mauritius Mozambique Namibia Niger Nigeria Rwanda SaoTomePrincipe Senegal Seychelles , title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSAF 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
		  graph export "$root\outputs\checks\\nfts\\ssaf4_nfts.png",replace
		
		    tsline   Sierra_Leone Somalia South_Africa South_Sudan Sudan Swaziland Tanzania Togo Uganda Zambia Zimbabwe, title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSAF 5") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
			  graph export "$root\outputs\checks\\nfts\\ssaf5_nfts.png",replace
 
 restore



 preserve
keep if region =="MENA"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Syria" if countryname=="Syrian_Arab_Republic" 	
replace countryname="UAE" if countryname=="United_Arab_Emirates" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Algeria Bahrain Egypt Iran Iraq Israel Jordan Kuwait Lebanon Libya  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "MENA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\mena1_nfts.png",replace

  tsline   Morocco Oman Palestine Qatar Saudi_Arabia Syria Tunisia Turkey UAE Yemen , title("Net Foreign Taxes and Subsides % Net Domestic Product" "MENA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
    graph export "$root\outputs\checks\\nfts\\mena2_nfts.png",replace
 
 restore



 preserve
keep if region =="LATA"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="AntiguaBarb" if countryname=="Antigua_and_Barbuda" 	
replace countryname="StKittsNevis" if countryname=="Saint_Kitts_and_Nevis" 	
replace countryname="StVincentGren" if countryname=="Saint_Vincent_and_the_Grenadines" 	
replace countryname="SintMaarten" if countryname=="Sint_Maarten_(Dutch_part)" 	
replace countryname="TriniTobago" if countryname=="Trinidad_and_Tobago" 
replace countryname="TurksCaicos" if countryname=="Turks_and_Caicos_Islands" 
replace countryname="BrVirginIslands" if countryname=="Virgin_Islands,_British" 

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Anguilla AntiguaBarb Argentina Aruba Bahamas Barbados Belize Bolivia Bonaire BrVirginIslands   , title("Net Foreign Taxes and Subsides % Net Domestic Product" "LATA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\lata1_nfts.png",replace

  tsline  Brazil Cayman_Islands Chile Colombia Costa_Rica Cuba Curacao Dominica Dominican_Republic Ecuador Venezuela , title("Net Foreign Taxes and Subsides % Net Domestic Product" "LATA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\lata2_nfts.png",replace
 
    tsline  El_Salvador Grenada Guatemala Guyana Haiti Honduras Jamaica Mexico Montserrat Nicaragua Uruguay , title("Net Foreign Taxes and Subsides % Net Domestic Product" "LATA 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
	graph export "$root\outputs\checks\\nfts\\lata3_nfts.png",replace
	
	  tsline  Panama Paraguay Peru Puerto_Rico Saint_Lucia SintMaarten StKittsNevis StVincentGren Suriname TriniTobago TurksCaicos  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "LATA 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
	  graph export "$root\outputs\checks\\nfts\\lata4_nfts.png",replace
 
 restore



  preserve
keep if region =="NAOC"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Australia Bermuda Canada Fiji French_Polynesia Greenland Kiribati Marshall_Islands Micronesia Nauru  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "NAOC 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
 graph export "$root\outputs\checks\\nfts\\naoc1_nfts.png",replace

  tsline  New_Caledonia New_Zealand Palau Papua_New_Guinea Samoa Solomon_Islands Tonga Tuvalu USA Vanuatu , title("Net Foreign Taxes and Subsides % Net Domestic Product" "NAOC 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\naoc2_nfts.png",replace
 
 restore


  preserve
keep if region =="EURO"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Albania Andorra Austria Belgium Bosnia Bulgaria Croatia Cyprus Czech_Republic Denmark  , title("Net Foreign Taxes and Subsides % Net Domestic Product" "EURO 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\euro1_nfts.png",replace

  tsline Estonia Finland France Germany Gibraltar Greece Hungary Iceland Ireland Isle_of_Man , title("Net Foreign Taxes and Subsides % Net Domestic Product" "EURO 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
    graph export "$root\outputs\checks\\nfts\\euro2_nfts.png",replace
 
   tsline Italy Latvia Liechtenstein Lithuania Luxembourg Malta Moldova Monaco Montenegro Netherlands , title("Net Foreign Taxes and Subsides % Net Domestic Product" "EURO 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)   xla(1990(5)2025)
     graph export "$root\outputs\checks\\nfts\\euro3_nfts.png",replace
  
     tsline North_Macedonia Norway Poland Portugal Romania San_Marino Serbia Slovakia Slovenia Spain Sweden Switzerland United_Kingdom, title("Net Foreign Taxes and Subsides % Net Domestic Product" "EURO 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)    xla(1990(5)2025)
	   graph export "$root\outputs\checks\\nfts\\euro4_nfts.png",replace

 restore


preserve
keep if region =="SSEA"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
replace countryname="TimorLeste" if countryname=="Timor-Leste" 	

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Afghanistan Bangladesh Bhutan Brunei Cambodia India Indonesia Lao_PDR Malaysia Maldives , title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSEA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssea1_nfts.png",replace

tsline Myanmar Nepal Pakistan Philippines Singapore Sri_Lanka Thailand TimorLeste Viet_Nam, title("Net Foreign Taxes and Subsides % Net Domestic Product" "SSEA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\ssea2_nfts.png",replace
 restore




 preserve
keep if region =="RUCA"
drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
replace countryname="TimorLeste" if countryname=="Timor-Leste" 	

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Armenia Azerbaijan Belarus Georgia Kazakhstan Kyrgyzstan Russian_Federation Tajikistan Turkmenistan Ukraine Uzbekistan , title("Net Foreign Taxes and Subsides % Net Domestic Product" "RUCA") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ruca1_nfts.png",replace


 restore



 

drop age pop percentile region
reshape wide value, i(country year) j(variable) string
ren value* *
ren *999i *

g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region
drop if region==""
g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g ndp_mer_usd=(inyixx*mndpro)/xlcusx

	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nfts_mer_usd, by(year )
	g nfts_mer_ratioWorld=nfts_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfts_mer_usd
	save nfts_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nfts_mer_usd, by(year region)
	*Format in Figure format
	g nfts_mer_ratio=nfts_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfts_mer_usd
	reshape wide nfts_mer_ratio , i(year) j(region) string
	merge 1:1 year using nfts_mer_ratioWorld.dta
	drop _merge 
	cap erase nfts_mer_ratioWorld.dta
	tsset year
	ren nfts_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World,yline(0,lcolor(gray)) xla(1990(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Taxes and Subsides % Net Domestic Product" "by world regions") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
graph export "$root\outputs\checks\\nfts\\regions_nfts.png",replace

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
//  **# net foreign taxes and subsidies GDP
//
// wid,  ind(mtaxnx inyixx xlcusx mgdpro) ag(999) pop(i) clear
// keep if year>=1990
// g region2=""
// foreach c of global EURO {
// 	replace region2="EURO" if country=="`c'"
// 	}
// foreach c of global NAOC {
// 	replace region2="NAOC" if country=="`c'"
// 	}
// foreach c of global LATA {
// 	replace region2="LATA" if country=="`c'"
// 	}
// foreach c of global MENA {
// 	replace region2="MENA" if country=="`c'"
// 	}
// foreach c of global SSAF {
// 	replace region2="SSAF" if country=="`c'"
// 	}
// foreach c of global RUCA {
// 	replace region2="RUCA" if country=="`c'"
// 	}
// foreach c of global EASA {
// 	replace region2="EASA" if country=="`c'"
// 	}	
// foreach c of global SSEA {
// 	replace region2="SSEA" if country=="`c'"
// 	}		
// ren region2 region
//
//
//
//  preserve
// keep if region =="EASA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// 		replace `s' = subinstr(`s', "'", "", .)
// 		replace `s' = subinstr(`s', "´", "", .)		
// 		replace `s' = subinstr(`s', "`", "", .)				
// replace countryname="CAF" if countryname=="Central_African_Republic" 	
// replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
// replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
// replace countryname="Cote_dIvoire" if country=="CI" 	
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
//
//
//  tsline  China Hong_Kong Japan Korea Macao Mongolia North_Korea Taiwan  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "EASA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//  graph export "$root\outputs\checks\\nfts\\easa1_nfts_gdp_gdp.png",replace
//  
//  restore
//
//
//
//  preserve
// keep if region =="SSAF"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// 		replace `s' = subinstr(`s', "'", "", .)
// 		replace `s' = subinstr(`s', "´", "", .)		
// 		replace `s' = subinstr(`s', "`", "", .)				
// replace countryname="CAF" if countryname=="Central_African_Republic" 	
// replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
// replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
// replace countryname="Cote_dIvoire" if country=="CI" 	
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
// 
//
//  tsline Angola Benin Botswana Burkina_Faso Burundi CAF Cabo_Verde Cameroon Chad Comoros  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSAF 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//   graph export "$root\outputs\checks\\nfts\\ssaf1_nfts_gdp.png",replace
// 
//   tsline   Congo Cote_dIvoire DR_Congo Djibouti Equatorial_Guinea Eritrea Ethiopia Gabon  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSAF 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\ssaf2_nfts_gdp.png",replace
// 
// 
//     tsline   Gambia Ghana Guinea GuineaBissau Kenya Lesotho  Liberia Madagascar Malawi Mali , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSAF 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\ssaf3_nfts_gdp.png",replace
//	
// 	    tsline   Mauritania Mauritius Mozambique Namibia Niger Nigeria Rwanda SaoTomePrincipe Senegal Seychelles , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSAF 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
// 		  graph export "$root\outputs\checks\\nfts\\ssaf4_nfts_gdp.png",replace
//		
// 		    tsline   Sierra_Leone Somalia South_Africa South_Sudan Sudan Swaziland Tanzania Togo Uganda Zambia Zimbabwe, title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSAF 5") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
// 			  graph export "$root\outputs\checks\\nfts\\ssaf5_nfts_gdp.png",replace
//  
//  restore
//
//
//
//  preserve
// keep if region =="MENA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="Syria" if countryname=="Syrian_Arab_Republic" 	
// replace countryname="UAE" if countryname=="United_Arab_Emirates" 	
//
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
// 
//
//  tsline Algeria Bahrain Egypt Iran Iraq Israel Jordan Kuwait Lebanon Libya  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "MENA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\mena1_nfts_gdp.png",replace
// 
//   tsline   Morocco Oman Palestine Qatar Saudi_Arabia Syria Tunisia Turkey UAE Yemen , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "MENA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//     graph export "$root\outputs\checks\\nfts\\mena2_nfts_gdp.png",replace
//  
//  restore
//
//
//
//  preserve
// keep if region =="LATA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="AntiguaBarb" if countryname=="Antigua_and_Barbuda" 	
// replace countryname="StKittsNevis" if countryname=="Saint_Kitts_and_Nevis" 	
// replace countryname="StVincentGren" if countryname=="Saint_Vincent_and_the_Grenadines" 	
// replace countryname="SintMaarten" if countryname=="Sint_Maarten_(Dutch_part)" 	
// replace countryname="TriniTobago" if countryname=="Trinidad_and_Tobago" 
// replace countryname="TurksCaicos" if countryname=="Turks_and_Caicos_Islands" 
// replace countryname="BrVirginIslands" if countryname=="Virgin_Islands,_British" 
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
// 
// 
//  tsline Anguilla AntiguaBarb Argentina Aruba Bahamas Barbados Belize Bolivia Bonaire BrVirginIslands   , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "LATA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\lata1_nfts_gdp.png",replace
// 
//   tsline  Brazil Cayman_Islands Chile Colombia Costa_Rica Cuba Curacao Dominica Dominican_Republic Ecuador Venezuela , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "LATA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//   graph export "$root\outputs\checks\\nfts\\lata2_nfts_gdp.png",replace
//  
//     tsline  El_Salvador Grenada Guatemala Guyana Haiti Honduras Jamaica Mexico Montserrat Nicaragua Uruguay , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "LATA 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
// 	graph export "$root\outputs\checks\\nfts\\lata3_nfts_gdp.png",replace
//	
// 	  tsline  Panama Paraguay Peru Puerto_Rico Saint_Lucia SintMaarten StKittsNevis StVincentGren Suriname TriniTobago TurksCaicos  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "LATA 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
// 	  graph export "$root\outputs\checks\\nfts\\lata4_nfts_gdp.png",replace
//  
//  restore
//
//
//
//   preserve
// keep if region =="NAOC"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	
//
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
// 
//
//  tsline Australia Bermuda Canada Fiji French_Polynesia Greenland Kiribati Marshall_Islands Micronesia Nauru  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "NAOC 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//  graph export "$root\outputs\checks\\nfts\\naoc1_nfts_gdp.png",replace
// 
//   tsline  New_Caledonia New_Zealand Palau Papua_New_Guinea Samoa Solomon_Islands Tonga Tuvalu USA Vanuatu , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "NAOC 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\naoc2_nfts_gdp.png",replace
//  
//  restore
//
//
//   preserve
// keep if region =="EURO"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	
//
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
//
//  tsline Albania Andorra Austria Belgium Bosnia Bulgaria Croatia Cyprus Czech_Republic Denmark  , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "EURO 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//   graph export "$root\outputs\checks\\nfts\\euro1_nfts_gdp.png",replace
// 
//   tsline Estonia Finland France Germany Gibraltar Greece Hungary Iceland Ireland Isle_of_Man , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "EURO 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//     graph export "$root\outputs\checks\\nfts\\euro2_nfts_gdp.png",replace
//  
//    tsline Italy Latvia Liechtenstein Lithuania Luxembourg Malta Moldova Monaco Montenegro Netherlands , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "EURO 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)   xla(1990(5)2025)
//      graph export "$root\outputs\checks\\nfts\\euro3_nfts_gdp.png",replace
//   
//      tsline North_Macedonia Norway Poland Portugal Romania San_Marino Serbia Slovakia Slovenia Spain Sweden Switzerland United_Kingdom, title("Net Foreign Taxes and Subsides % Gross Domestic Product" "EURO 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)    xla(1990(5)2025)
// 	   graph export "$root\outputs\checks\\nfts\\euro4_nfts_gdp.png",replace
// 
//  restore
//
//
// preserve
// keep if region =="SSEA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
// replace countryname="TimorLeste" if countryname=="Timor-Leste" 	
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
//
//  tsline Afghanistan Bangladesh Bhutan Brunei Cambodia India Indonesia Lao_PDR Malaysia Maldives , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSEA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\ssea1_nfts_gdp.png",replace
// 
// tsline Myanmar Nepal Pakistan Philippines Singapore Sri_Lanka Thailand TimorLeste Viet_Nam, title("Net Foreign Taxes and Subsides % Gross Domestic Product" "SSEA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
//   graph export "$root\outputs\checks\\nfts\\ssea2_nfts_gdp.png",replace
//  restore
// 
// 
// 
// 
//  preserve
// keep if region =="RUCA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *
//
// g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
// g nni_mer_usd=(inyixx*mgdpro)/xlcusx
//
// merge m:1 country using temp__.dta
// keep if _merge==3
// drop _merge
// keep  year nfts_mer_usd countryname nni_mer_usd
// tab year
//
// loc s countryname
// 		replace `s' = subinstr(`s', " ", "_", .)
// replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
// replace countryname="TimorLeste" if countryname=="Timor-Leste" 	
//
// g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
// keep  year countryname nfts_mer_ratio nfts_mer_usd
// replace nfts_mer_usd=nfts_mer_usd/1000000
// reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string
//
//
// ren nfts_mer_ratio* *
// foreach var of varlist _all {
// 	label var `var' ""
// }
//  tsset year
//
//  tsline Armenia Azerbaijan Belarus Georgia Kazakhstan Kyrgyzstan Russian_Federation Tajikistan Turkmenistan Ukraine Uzbekistan , title("Net Foreign Taxes and Subsides % Gross Domestic Product" "RUCA") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
//    graph export "$root\outputs\checks\\nfts\\ruca1_nfts_gdp.png",replace
// 
//
//  restore
// 
// 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 **# net foreign taxes and subsidies NDP RAW DATA

use "$root\raw-data\merge-historical-aggregates.dta",clear

keep if inlist(widcode,"mndpro999i",  "mtaxnx999i","inyixx999i","mnninc999i","xlcusx999i", "mnnfin999i", "mpinnx999i")
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
	
	
keep if (corecountry==1 | country=="WO")
keep year country value widcode
format value %30.10f
reshape wide value ,i(year country) j(widcode) string 
ren value* *
ren *999i *



keep if year>=1990
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region



 preserve
keep if region =="EASA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
		replace `s' = subinstr(`s', "'", "", .)
		replace `s' = subinstr(`s', "´", "", .)		
		replace `s' = subinstr(`s', "`", "", .)				
replace countryname="CAF" if countryname=="Central_African_Republic" 	
replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
replace countryname="Cote_dIvoire" if country=="CI" 	
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline  China Hong_Kong Japan Korea Macao Mongolia North_Korea Taiwan  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data EASA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
 graph export "$root\outputs\checks\\nfts\\easa1_nfts_ndp_rawdata.png",replace
 
 restore



 preserve
keep if region =="SSAF"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
		replace `s' = subinstr(`s', "'", "", .)
		replace `s' = subinstr(`s', "´", "", .)		
		replace `s' = subinstr(`s', "`", "", .)				
replace countryname="CAF" if countryname=="Central_African_Republic" 	
replace countryname="GuineaBissau" if countryname=="Guinea-Bissau" 	
replace countryname="SaoTomePrincipe" if countryname=="Sao_Tome_and_Principe"
replace countryname="Cote_dIvoire" if country=="CI" 	
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Angola Benin Botswana Burkina_Faso Burundi CAF Cabo_Verde Cameroon Chad Comoros  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSAF 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\ssaf1_nfts_rawdata.png",replace

  tsline   Congo Cote_dIvoire DR_Congo Djibouti Equatorial_Guinea Eritrea Ethiopia Gabon  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSAF 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssaf2_nfts_rawdata.png",replace


    tsline   Gambia Ghana Guinea GuineaBissau Kenya Lesotho  Liberia Madagascar Malawi Mali , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSAF 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssaf3_nfts_rawdata.png",replace
	
	    tsline   Mauritania Mauritius Mozambique Namibia Niger Nigeria Rwanda SaoTomePrincipe Senegal Seychelles , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSAF 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
		  graph export "$root\outputs\checks\\nfts\\ssaf4_nfts_rawdata.png",replace
		
		    tsline   Sierra_Leone Somalia South_Africa South_Sudan Sudan Swaziland Tanzania Togo Uganda Zambia Zimbabwe, title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSAF 5") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
			  graph export "$root\outputs\checks\\nfts\\ssaf5_nfts_rawdata.png",replace
 
 restore



 preserve
keep if region =="MENA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Syria" if countryname=="Syrian_Arab_Republic" 	
replace countryname="UAE" if countryname=="United_Arab_Emirates" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Algeria Bahrain Egypt Iran Iraq Israel Jordan Kuwait Lebanon Libya  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data MENA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\mena1_nfts_rawdata.png",replace

  tsline   Morocco Oman Palestine Qatar Saudi_Arabia Syria Tunisia Turkey UAE Yemen , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data MENA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
    graph export "$root\outputs\checks\\nfts\\mena2_nfts_rawdata.png",replace
 
 restore



 preserve
keep if region =="LATA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="AntiguaBarb" if countryname=="Antigua_and_Barbuda" 	
replace countryname="StKittsNevis" if countryname=="Saint_Kitts_and_Nevis" 	
replace countryname="StVincentGren" if countryname=="Saint_Vincent_and_the_Grenadines" 	
replace countryname="SintMaarten" if countryname=="Sint_Maarten_(Dutch_part)" 	
replace countryname="TriniTobago" if countryname=="Trinidad_and_Tobago" 
replace countryname="TurksCaicos" if countryname=="Turks_and_Caicos_Islands" 
replace countryname="BrVirginIslands" if countryname=="Virgin_Islands,_British" 

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Anguilla AntiguaBarb Argentina Aruba Bahamas Barbados Belize Bolivia Bonaire BrVirginIslands   , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data LATA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\lata1_nfts_rawdata.png",replace

  tsline  Brazil Cayman_Islands Chile Colombia Costa_Rica Cuba Curacao Dominica Dominican_Republic Ecuador Venezuela , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data LATA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\lata2_nfts_rawdata.png",replace
 
    tsline  El_Salvador Grenada Guatemala Guyana Haiti Honduras Jamaica Mexico Montserrat Nicaragua Uruguay , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data LATA 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
	graph export "$root\outputs\checks\\nfts\\lata3_nfts_rawdata.png",replace
	
	  tsline  Panama Paraguay Peru Puerto_Rico Saint_Lucia SintMaarten StKittsNevis StVincentGren Suriname TriniTobago TurksCaicos  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data LATA 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
	  graph export "$root\outputs\checks\\nfts\\lata4_nfts_rawdata.png",replace
 
 restore



  preserve
keep if region =="NAOC"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year


 tsline Australia Bermuda Canada Fiji French_Polynesia Greenland Kiribati Marshall_Islands Micronesia Nauru  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data NAOC 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
 graph export "$root\outputs\checks\\nfts\\naoc1_nfts_rawdata.png",replace

  tsline  New_Caledonia New_Zealand Palau Papua_New_Guinea Samoa Solomon_Islands Tonga Tuvalu USA Vanuatu , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data NAOC 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\naoc2_nfts_rawdata.png",replace
 
 restore


  preserve
keep if region =="EURO"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Bosnia" if countryname=="Bosnia_and_Herzegovina" 	


g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Albania Andorra Austria Belgium Bosnia Bulgaria Croatia Cyprus Czech_Republic Denmark  , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data EURO 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\euro1_nfts_rawdata.png",replace

  tsline Estonia Finland France Germany Gibraltar Greece Hungary Iceland Ireland Isle_of_Man , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data EURO 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
    graph export "$root\outputs\checks\\nfts\\euro2_nfts_rawdata.png",replace
 
   tsline Italy Latvia Liechtenstein Lithuania Luxembourg Malta Moldova Monaco Montenegro Netherlands , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data EURO 3") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)   xla(1990(5)2025)
     graph export "$root\outputs\checks\\nfts\\euro3_nfts_rawdata.png",replace
  
     tsline North_Macedonia Norway Poland Portugal Romania San_Marino Serbia Slovakia Slovenia Spain Sweden Switzerland United_Kingdom, title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data EURO 4") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)    xla(1990(5)2025)
	   graph export "$root\outputs\checks\\nfts\\euro4_nfts_rawdata.png",replace

 restore


preserve
keep if region =="SSEA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
replace countryname="TimorLeste" if countryname=="Timor-Leste" 	

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Afghanistan Bangladesh Bhutan Brunei Cambodia India Indonesia Lao_PDR Malaysia Maldives , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSEA 1") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ssea1_nfts_rawdata.png",replace

tsline Myanmar Nepal Pakistan Philippines Singapore Sri_Lanka Thailand TimorLeste Viet_Nam, title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data SSEA 2") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black) xla(1990(5)2025)
  graph export "$root\outputs\checks\\nfts\\ssea2_nfts_rawdata.png",replace
 restore




 preserve
keep if region =="RUCA"
// drop age pop percentile region
// reshape wide value, i(country year) j(variable) string
// ren value* *
// ren *999i *

g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g nni_mer_usd=(inyixx*mndpro)/xlcusx

merge m:1 country using temp__.dta
keep if _merge==3
drop _merge
keep  year nfts_mer_usd countryname nni_mer_usd
tab year

loc s countryname
		replace `s' = subinstr(`s', " ", "_", .)
replace countryname="Brunei" if countryname=="Brunei_Darussalam" 	
replace countryname="TimorLeste" if countryname=="Timor-Leste" 	

g nfts_mer_ratio=nfts_mer_usd/nni_mer_usd	
keep  year countryname nfts_mer_ratio nfts_mer_usd
replace nfts_mer_usd=nfts_mer_usd/1000000
reshape wide nfts_mer_ratio nfts_mer_usd, i(year) j(countryname) string


ren nfts_mer_ratio* *
foreach var of varlist _all {
	label var `var' ""
}
 tsset year

 tsline Armenia Azerbaijan Belarus Georgia Kazakhstan Kyrgyzstan Russian_Federation Tajikistan Turkmenistan Ukraine Uzbekistan , title("Net Foreign Taxes and Subsides % Net Domestic Product" " Raw Data RUCA") lpattern(dash dash dash dash shortdash shortdash shortdash shortdash  ) legend(size(small) row(3)) lcolor(green red  blue cyan magenta gold orange purple brown pink black)  xla(1990(5)2025)
   graph export "$root\outputs\checks\\nfts\\ruca1_nfts_rawdata.png",replace


 restore


 
drop if region==""
g nfts_mer_usd=(inyixx*mtaxnx)/xlcusx
g ndp_mer_usd=(inyixx*mndpro)/xlcusx

	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nfts_mer_usd, by(year )
	g nfts_mer_ratioWorld=nfts_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfts_mer_usd
	save nfts_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nfts_mer_usd, by(year region)
	*Format in Figure format
	g nfts_mer_ratio=nfts_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfts_mer_usd
	reshape wide nfts_mer_ratio , i(year) j(region) string
	merge 1:1 year using nfts_mer_ratioWorld.dta
	drop _merge 
	cap erase nfts_mer_ratioWorld.dta
	tsset year
	ren nfts_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World,yline(0,lcolor(gray)) xla(1990(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Taxes and Subsides % Net Domestic Product" "by world regions (Raw Data)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
graph export "$root\outputs\checks\\nfts\\regions_nfts_rawdata.png",replace

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 
 

**# NET remittances 
use "$root\raw-data\merge-historical-aggregates.dta",clear

keep if inlist(widcode,"mndpro999i",  "mtaxnx999i","inyixx999i","mnninc999i","xlcusx999i", "mnnfin999i", "mpinnx999i", "mscgnx999i")| inlist(widcode, "mscinx999i", "msconx999i", "mscrnx999i")
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
	
	
keep if (corecountry==1 | country=="WO")
keep year country value widcode
format value %30.10f
reshape wide value ,i(year country) j(widcode) string 
ren value* *
ren *999i *

keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""
*net other transfers
g not_mer_usd=(inyixx*msconx)/xlcusx

*net foreign aid
g nfa_mer_usd=(inyixx*mscgnx)/xlcusx

*net remittances
g nr_mer_usd=(inyixx*mscrnx)/xlcusx

*net domestic product
g ndp_mer_usd=(inyixx*mndpro)/xlcusx


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances % Net Domestic Product" "by world regions (Raw Data)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))



	
	
**# NET foreign aid 

use "$root\raw-data\merge-historical-aggregates.dta",clear

keep if inlist(widcode,"mndpro999i",  "mtaxnx999i","inyixx999i","mnninc999i","xlcusx999i", "mnnfin999i", "mpinnx999i", "mscgnx999i")| inlist(widcode, "mscinx999i", "msconx999i", "mscrnx999i")
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
	
	
keep if (corecountry==1 | country=="WO")
keep year country value widcode
format value %30.10f
reshape wide value ,i(year country) j(widcode) string 
ren value* *
ren *999i *

keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""
*net other transfers
g not_mer_usd=(inyixx*msconx)/xlcusx

*net foreign aid
g nfa_mer_usd=(inyixx*mscgnx)/xlcusx

*net remittances
g nr_mer_usd=(inyixx*mscrnx)/xlcusx

*net domestic product
g ndp_mer_usd=(inyixx*mndpro)/xlcusx


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nfa_mer_usd, by(year )
	g nfa_mer_ratioWorld=nfa_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfa_mer_usd
	save nfa_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nfa_mer_usd, by(year region)
	*Format in Figure format
	g nfa_mer_ratio=nfa_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nfa_mer_usd
	reshape wide nfa_mer_ratio , i(year) j(region) string
	merge 1:1 year using nfa_mer_ratioWorld.dta
	drop _merge 
	cap erase nfa_mer_ratioWorld.dta
	tsset year
	ren nfa_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Aid % Net Domestic Product" "by world regions (Raw Data)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))


	
 
 
 
 
 **# NET Other Transfers

use "$root\raw-data\merge-historical-aggregates.dta",clear

keep if inlist(widcode,"mndpro999i",  "mtaxnx999i","inyixx999i","mnninc999i","xlcusx999i", "mnnfin999i", "mpinnx999i", "mscgnx999i")| inlist(widcode, "mscinx999i", "msconx999i", "mscrnx999i")
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
	
	
keep if (corecountry==1 | country=="WO")
keep year country value widcode
format value %30.10f
reshape wide value ,i(year country) j(widcode) string 
ren value* *
ren *999i *

keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""

*net other transfers
g not_mer_usd=(inyixx*msconx)/xlcusx

*net foreign aid
g nfa_mer_usd=(inyixx*mscgnx)/xlcusx

*net remittances
g nr_mer_usd=(inyixx*mscrnx)/xlcusx

*net domestic product
g ndp_mer_usd=(inyixx*mndpro)/xlcusx


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd not_mer_usd, by(year )
	g not_mer_ratioWorld=not_mer_usd/ndp_mer_usd
	drop ndp_mer_usd not_mer_usd
	save not_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd not_mer_usd, by(year region)
	*Format in Figure format
	g not_mer_ratio=not_mer_usd/ndp_mer_usd
	drop ndp_mer_usd not_mer_usd
	reshape wide not_mer_ratio , i(year) j(region) string
	merge 1:1 year using not_mer_ratioWorld.dta
	drop _merge 
	cap erase not_mer_ratioWorld.dta
	tsset year
	ren not_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Other Transfers % Net Domestic Product" "by world regions (Raw Data)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))


	
 
 
 
  
 **# NET Remittances antes

use "$root\raw-data\merge-historical-aggregates.dta",clear

keep if inlist(widcode,"mndpro999i",  "mtaxnx999i","inyixx999i","mnninc999i","xlcusx999i", "mnnfin999i", "mpinnx999i", "mscgnx999i")| inlist(widcode, "mscinx999i", "msconx999i", "mscrnx999i")
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
	
	
keep if (corecountry==1 | country=="WO")
keep year country value widcode
format value %30.10f
reshape wide value ,i(year country) j(widcode) string 
ren value* *
ren *999i *

keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""

// *net other transfers
// g nr_mer_usd=(inyixx*msconx)/xlcusx
//
// *net foreign aid
// g nfa_mer_usd=(inyixx*mscgnx)/xlcusx
//
// *net remittances new
// g nr_mer_usd_new=(inyixx*mscrnx)/xlcusx

*net remittances old
g nr_mer_usd=(inyixx*(mscrnx+msconx+mscgnx))/xlcusx

*net domestic product
g ndp_mer_usd=(inyixx*mndpro)/xlcusx


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances Old % Net Domestic Product" "by world regions (Raw Data)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))


	
	
	

*use WID 
wid, ind(inyixx mscinx xlcusx mndpro) ag(999) pop(i)  clear	
keep country year variable value
reshape wide value, i(country year) j(variable) string 
ren value* *
ren *999i *

*net remittances old
g nr_mer_usd=(inyixx*mscinx)/xlcusx

*net domestic product
g ndp_mer_usd=(inyixx*mndpro)/xlcusx


 *Keep core countries
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
keep if (corecountry==1 | country=="WO")

*Generate Region variable
 gen region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

replace region="World" if country=="WO"


preserve
keep inyixx xlcusx mndpro country year
save "$work_data\temp_inyixx_xlcusx_mndpro.dta",replace
restore

	keep if year>=1970
	drop if country=="WO"
	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}	
	tsset year
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances Old % Net Domestic Product" "by world regions (WID)") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))


 
  
 **# secondary income (raw from IMF) (mscrnx+msconx+mscgnx)
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
 use "$root\raw-data\bop_currentacc.dta",clear
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
		
keep if (corecountry==1 | country=="WO")


keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""


g mscrnx=scrnx*gdp_usd
g msconx=sconx*gdp_usd
g mscgnx=scgnx*gdp_usd

*net remittances old
g nr_mer_usd=(mscrnx+msconx+mscgnx)

*net domestic product
g ndp_mer_usd=gdp_usd 


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances ((mscrnx+msconx+mscgnx)) % GDP" "by world regions (secondary income (raw from IMF))") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))

	
 **# secondary income (raw from IMF) (mscrnx)
 use "$root\raw-data\bop_currentacc.dta",clear
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
		
keep if (corecountry==1 | country=="WO")


keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""


g mscrnx=scrnx*gdp_usd
g msconx=sconx*gdp_usd
g mscgnx=scgnx*gdp_usd

*net remittances old
g nr_mer_usd=(mscrnx)

*net domestic product
g ndp_mer_usd=gdp_usd 


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Remittances ((mscrnx)) % GDP" "by world regions (secondary income (raw from IMF))") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
		
	
	
	
 **# secondary income (raw from IMF) (msconx)
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
 use "$root\raw-data\bop_currentacc.dta",clear
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
		
keep if (corecountry==1 | country=="WO")


keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""


g mscrnx=scrnx*gdp_usd
g msconx=sconx*gdp_usd
g mscgnx=scgnx*gdp_usd

*net remittances old
g nr_mer_usd=(msconx)

*net domestic product
g ndp_mer_usd=gdp_usd 


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Other Transfers ((msconx)) % GDP" "by world regions (secondary income (raw from IMF))") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	
	
	
	
 **# secondary income (raw from IMF) (mscgnx)
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
 use "$root\raw-data\bop_currentacc.dta",clear
ren iso country
gen corecountry=.
foreach c of global corecountries {
	replace corecountry=1 if country=="`c'"
	}
		
keep if (corecountry==1 | country=="WO")


keep if year>=1970
g region2=""
foreach c of global EURO {
	replace region2="EURO" if country=="`c'"
	}
foreach c of global NAOC {
	replace region2="NAOC" if country=="`c'"
	}
foreach c of global LATA {
	replace region2="LATA" if country=="`c'"
	}
foreach c of global MENA {
	replace region2="MENA" if country=="`c'"
	}
foreach c of global SSAF {
	replace region2="SSAF" if country=="`c'"
	}
foreach c of global RUCA {
	replace region2="RUCA" if country=="`c'"
	}
foreach c of global EASA {
	replace region2="EASA" if country=="`c'"
	}	
foreach c of global SSEA {
	replace region2="SSEA" if country=="`c'"
	}		
ren region2 region

drop if region==""


g mscrnx=scrnx*gdp_usd
g msconx=sconx*gdp_usd
g mscgnx=scgnx*gdp_usd

*net remittances old
g nr_mer_usd=(mscgnx)

*net domestic product
g ndp_mer_usd=gdp_usd 


	preserve
	*Aggregate at the national-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year )
	g nr_mer_ratioWorld=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	save nr_mer_ratioWorld.dta,replace
	restore 
 	*Aggregate at the region-year level
	collapse (sum) ndp_mer_usd nr_mer_usd, by(year region)
	*Format in Figure format
	g nr_mer_ratio=nr_mer_usd/ndp_mer_usd
	drop ndp_mer_usd nr_mer_usd
	reshape wide nr_mer_ratio , i(year) j(region) string
	merge 1:1 year using nr_mer_ratioWorld.dta
	drop _merge 
	cap erase nr_mer_ratioWorld.dta
	tsset year
	ren nr_mer_ratio* *
	 foreach var of varlist _all {
	label var `var' ""
}
	tsline EASA EURO LATA MENA NAOC RUCA SSAF SSEA World if inrange(year,1970,2023),yline(0,lcolor(gray)) xla(1970(2)2023,angle(90) labsize(small)) ///
	title("Net Foreign Aid ((mscgnx)) % GDP" "by world regions (secondary income (raw from IMF))") ///
	lcolor(red ebblue green gold magenta orange sienna purple black) lwidth(thick thick thick thick thick thick thick thick thick) legend(row(2))
	