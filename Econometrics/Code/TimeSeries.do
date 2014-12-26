clear
est clear
import excel "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\UsMacro_Quarterly.xlsx", sheet("Sheet1") firstrow
cd "\\hass11.win.rpi.edu\classes\ECON-4570\stata extensions"
drop if Year<1955
drop if Year>2004
gen time = ym(Year, Quarter)
tsset time
sum
gen Y = ln(RealGDP) 
eststo: var D.RealGDP D.Y, lags(1/4)
esttab, b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3)  scalars(aic bic) nogaps
vargranger
su
