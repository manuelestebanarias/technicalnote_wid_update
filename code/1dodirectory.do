//----------------------------------------------------------------------------//
//               1.  Set up Directories 
//----------------------------------------------------------------------------//



// Objective: Stata code used to set the data directory
//      Note 1: Stata code to be run before all other codes
//      Note 2: Directory to be modified by the user


*#delimit;
clear all
set more off
set maxvar 6000
 
// User definition
* Ricardo
if c(username)=="ricar"{
global root "C:\Users\ricar\Dropbox\Piketty2025GlobalJusticeProjectMacroUpdates"
 } 
 if c(username)=="r.gomez-carrera"{
gl root "C:\Users\r.gomez-carrera\Dropbox\Piketty2025GlobalJusticeProjectMacroUpdates"
 }  

 * Manuel Esteban
if substr("`c(pwd)'",1,25) == "/Users/manuelestebanarias" {
	global wid_dir "/Users/manuelestebanarias/Dropbox/W2ID"
    global root "/Users/manuelestebanarias/Documents/GitHub/technicalnote_wid_update"
}



// Directory set up
global code 		"$root/code"
global work_data 	"$root/work-data"
global raw-data 	"$root/raw-data"
global output "$root/Ariasetal2025Macro.xlsx"

global codes_dictionary "$wid_dir/Methodology/Codes_Dictionnary_WID.xlsx"
global output "$root/Ariasetal2025Macro.xlsx"
// year setup
global year 2025 
global pastyear 2024 
