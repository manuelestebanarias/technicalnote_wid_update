//----------------------------------------------------------------------------//
//               1.  Set up Directories 
//----------------------------------------------------------------------------//



// Objective: Stata code used to set the data directory
//      Note 1: Stata code to be run before all other codes
//      Note 2: Directory to be modified by the user


clear all
set more off
set maxvar 6000

* Years
global year 2026
global prev_year 2025

* User definition
if c(username)=="ricar" {
	global wid_dir "C:\Users\ricar\Dropbox\Dropbox\W2ID"
    global root "C:\Users\ricar\Dropbox\Piketty2025GlobalJusticeProjectMacroUpdates"
}

if c(username)=="r.gomez-carrera" {
	global wid_dir "C:\Users\ricar\Dropbox\Dropbox\W2ID"
    global root "C:\Users\r.gomez-carrera\Dropbox\Piketty2025GlobalJusticeProjectMacroUpdates"
}

if substr("`c(pwd)'",1,25)=="/Users/manuelestebanarias" {
    global wid_dir "/Users/manuelestebanarias/Dropbox/W2ID"
    global root "/Users/manuelestebanarias/Documents/GitHub/technicalnote_wid_update"
}



* Directories
global code "$root/code"
global work_data "$root/work-data"
global raw_data "$root/raw-data"

global output "$root/Ariasetal${year}Macro.xlsx"

global codes_dictionary ///
    "$wid_dir/Methodology/Codes_Dictionnary_WID.xlsx"
