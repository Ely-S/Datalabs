// 15.2
clear
est clear
import excel "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\UsMacro_MonthlyNEW.xlsx", sheet("Sheet1") firstrow
cd "\\hass11.win.rpi.edu\classes\ECON-4570\stata extensions"

drop if mi(PCED) // drop if missing pced observation. screws up sample means

gen time = ym(Year, Month)
tsset time
sort time

gen picpi= 1200 * ln(CPI/L.CPI)
gen pipced = 1200 * ln(PCED/L.PCED)
gen Y = picpi-pipced

sum picpi pipced Y

/*
qui sum time
sca lagn = round(0.75 * (r(max)^(1/3)))
di "use " lagn " lags"
*/

reg Y, r 
newey Y, lag(6) 


