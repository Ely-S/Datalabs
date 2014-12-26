clear
use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\fertility.dta"
sum

reg weeksm1 morekids, r
reg morekids samesex, r

ivregress 2sls weeksm1 (morekids = samesex), r first
ivregress 2sls weeksm1 (morekids = samesex) black agem1 hispan othrace, first r
