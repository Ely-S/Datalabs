clear
cd "C:\Users\sakoveT430\Documents\Econometrics"
use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\Guns.dta"
tsset state year
gen lnvio = ln(vio)
gen lnrob = ln(rob)
gen lnmur = ln(mur)

eststo: reg lnvio shall , r
eststo: reg lnvio shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , r

eststo: areg lnvio shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(state)  vce(robust)
eststo: areg lnvio shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(year)  vce(robust)

eststo: areg lnrob shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(state)  vce(robust)
eststo: areg lnrob shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(year)  vce(robust)

eststo: areg lnmur shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(state)  vce(robust)
eststo: areg lnmur shall incarc_rate density avginc pop pw1064 pm1029 pb1064 , absorb(year)  vce(robust)

esttab using guns.rtf, se ar2 label legend

