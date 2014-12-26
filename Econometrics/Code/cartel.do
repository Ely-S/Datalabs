clear
use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\JEC.dta"
sum
//ivregress 2sls yvar exogXVarlist (endogXVarlist = otherInstruments), vce(robust)
gen lnq = ln(quantity)
gen lnp = ln(price)

reg lnq lnp ice seas1 seas2 seas3 seas4 seas5 seas6 seas7 seas8 seas9 seas10 seas11 seas12 , first r

ivregress 2sls lnq (lnp = cartel) ice seas1 seas2 seas3 seas4 seas5 seas6 seas7 seas8 seas9 seas10 seas11 seas12 , first r

//esttab est1 est2, b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) nogaps

// elasticity is less than 1, conclude cheating 
// writeup 12.2
