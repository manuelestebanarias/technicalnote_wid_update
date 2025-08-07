/********Stata code used for global justice project *********/
/****definition of global variables: core territories, core countries, etc.***/

#delimit;
clear all;
set more off;
set maxvar 6000;

global coreterritories `" "RU" "OA" "CN" "JP" "OB" "DE" "ES" "FR" "GB" "IT" "SE" "OC" "QM"
"AR" "BR" "CL" "CO" "MX" "OD" "DZ" "EG" "TR" "OE" "CA" "US" "AU" "NZ" "OH" "IN" "ID" "OI" "ZA" "OJ" "';

global corecountries `" "AD" "AE" "AF" "AG" "AI" "AL" "AM" "AO" "AR" "AT" "AU" "AW" "AZ"
"BA" "BB" "BD" "BE" "BF" "BG" "BH" "BI" "BJ" "BM" "BN" "BO" "BQ" "BR" "BS" "BT" "BW" 
"BY" "BZ" "CA" "CD" "CF" "CG" "CH" "CI" "CL" "CM" "CN" "CO" "CR" "CU" "CV" "CW" "CY" 
"CZ" "DE" "DJ" "DK" "DM" "DO" "DZ" "EC" "EE" "EG" "ER" "ES" "ET" "FI" "FJ" "FM"
"FR" "GA" "GB" "GD" "GE" "GG" "GH" "GI" "GL" "GM" "GN" "GQ" "GR" "GT" "GW" "GY" "HK"
"HN" "HR" "HT" "HU" "ID" "IE" "IL" "IM" "IN" "IQ" "IR" "IS" "IT" "JE" "JM" "JO" "JP" 
"KE" "KG" "KH" "KI" "KM" "KN" "KP" "KR" "KS" "KW" "KY" "KZ" "LA" "LB" "LC" "LI" 
"LK" "LR" "LS" "LT" "LU" "LV" "LY" "MA" "MC" "MD" "ME" "MG" "MH" "MK" "ML" "MM" "MN"
"MO" "MR" "MS" "MT" "MU" "MV" "MW" "MX" "MY" "MZ" "NA" "NC" "NE" "NG" "NI" "NL" "NO"
"NP" "NR" "NZ""';
global corecountries `" $corecountries "OM" "PA" "PE" "PF" "PG" "PH" "PK" "PL" "PR" "PS"
"PT" "PW" "PY" "QA" "RO" "RS" "RU" "RW" "SA" "SB" "SC" "SD" "SE" "SG" "SI" "SK" "SL" 
"SM" "SN" "SO" "SR" "SS" "ST" "SV" "SX" "SY" "SZ" "TC" "TD" "TG" "TH" "TJ" "TL" 
"TM" "TN" "TO" "TR" "TT" "TV" "TW" "TZ" "UA" "UG" "US" "UY" "UZ" "VC" "VE" "VG" "VN"
"VU" "WS" "YE" "ZA" "ZM" "ZW""';

global coreterritoriesmer `" "RU" "OA-MER" "CN" "JP" "OB-MER" "DE" "ES" "FR" "GB" "IT" "SE" "OC-MER" "QM-MER"
"AR" "BR" "CL" "CO" "MX" "OD-MER" "DZ" "EG" "TR" "OE-MER" "CA" "US" "AU" "NZ" "OH-MER" "IN" "ID" "OI-MER" "ZA" "OJ-MER" "';

global EURO `" "AD" "AL" "AT" "BA" "BE" "BG" "CH" "CY" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GB" "GG" "GI" "GR" "HR" "HU" "IE" "IM" "IS" "IT" "JE" "KS" "LI" "LT" "LU" "LV" "MC" "MD" "ME" "MK" "MT" "NL" "NO" "PL" "PT" "RO" "RS" "SE" "SI" "SK" "SM" "';
global NAOC `" "AU" "BM" "CA" "FJ" "FM" "GL" "KI" "MH" "NC" "NR" "NZ" "PF" "PG" "PW" "SB" "TO" "TV" "US" "VU" "WS" "';
global LATA `" "AG" "AI" "AR" "AW" "BB" "BO" "BQ" "BR" "BS" "BZ" "CL" "CO" "CR" "CU" "CW" "DM" "DO" "EC" "GD" "GT" "GY" "HN" "HT" "JM" "KN" "KY" "LC" "MS" "MX" "NI" "PA" "PE" "PR" "PY" "SR" "SV" "SX" "TC" "TT" "UY" "VC" "VE" "VG" "';
global MENA `" "AE" "BH" "DZ" "EG" "IL" "IQ" "IR" "JO" "KW" "LB" "LY" "MA" "OM" "PS" "QA" "SA" "SY" "TN" "TR" "YE" "';
global SSAF `" "AO" "BF" "BI" "BJ" "BW" "CD" "CF" "CG" "CI" "CM" "CV" "DJ" "ER" "ET" "GA" "GH" "GM" "GN" "GQ" "GW" "KE" "KM" "LR" "LS" "MG" "ML" "MR" "MU" "MW" "MZ" "NA" "NE" "NG" "RW" "SC" "SD" "SL" "SN" "SO" "SS" "ST" "SZ" "TD" "TG" "TZ" "UG" "ZA" "ZM" "ZW" "';
global RUCA `" "AM" "AZ" "BY" "GE" "KG" "KZ" "RU" "TJ" "TM" "UA" "UZ" "';
global EASA `" "CN" "HK" "JP" "KP" "KR" "MN" "MO" "TW" "';
global SSEA `" "AF" "BD" "BN" "BT" "ID" "IN" "KH" "LA" "LK" "MM" "MV" "MY" "NP"  "PH" "PK" "SG" "TH" "TL" "VN" "';


