clear
est clear
import excel "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\UsMacro_MonthlyNEW.xlsx", sheet("Sheet1") firstrow
cd "\\hass11.win.rpi.edu\classes\ECON-4570\stata extensions"


// DONT NEED WRITEUP. JUST ANSWER QUESTIONS. DON"T NEED Variables descriptions.
// Describe how get results DUE MONDAY @ 5pm in office

gen time = ym(Year, Month)
tsset time

gen ip_growth = 100*ln(IP/L.IP)
sum ip_growth
scatter Oil time

// calculate number of lags
// lags = 6
//qui sum time
//sca lagn = round(0.75 * (r(max)^(1/3)))

newey ip_growth L(1/18).O, lag(6)

*For dynamic multipliers, need to first run the distributed lag model
*Afterwords...
 estimates store oillags
 #delimit ;
 coefplot oillags, vertical drop(_cons) recast(line) xlabel(1/18) xtitle(Lag)
 ytitle(Dynamic Multiplier);

 #delimit cr
 *vertical--puts the value of the coefficients on the y-axis instead of the x-axis
 *Drop(_cons) tells stata that we do not want to plot the constant from the regression
 *Recast(line) tells stata to connect the point estimates
 *xlabel(1/18) tells stata to label the points on the x-axis as 1 to 18
 
 *Cumulative Multipliers
 
 matrix cumulmult = J(1,18,0)
 matrix cumulmultse = J(1,18,0)

local mystr "L1.O"
qui forvalues i = 2(1)18{
	lincom `mystr' + L`i'.O
	matrix cumulmult[1,`i'] = r(estimate)
	matrix cumulmultse[1,`i'] = r(se)
	local mystr `mystr' + L`i'.O
}

*Lincom adds the dynamic multipliers and gets the standard errors.
coefplot matrix(cumulmult), se(cumulmultse) vertical drop(_cons) xlabel(1/18)
