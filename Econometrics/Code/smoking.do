clear
use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\Smoking.dta"
sum
sum smoker
sum smoker if smkban==1
sum smoker if smkban==0
eststo: reg smoker smkban, r

gen age2=age^2
eststo: reg smoker smkban female age age2 colgrad colsome hsgrad hsdrop hispanic black, r

margins, at(age=20 hsdrop=1 smkban=(0 1))
margins, at(age=40 colgrad=1 smkban=(0 1) black=1 female=1)

eststo: probit smoker smkban age age2 hsdrop hsgrad colsome colgrad black hispanic female

margins, at(age=20 hsdrop=1 smkban=(0 1))
margins, at(age=40 colgrad=1 smkban=(0 1) black=1 female=1)

gen old = 1 if age>37
sort old

by old: probit smoker smkban age age2 hsdrop hsgrad colsome colgrad black hispanic female
esttab, label legend b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) nogaps


// insurance
// reg insured healthy age anylim male deg_nd deg_ged deg_hs deg_ba deg_ma deg_phd deg_oth married selfemp familysz reg_ne reg_mw reg_so reg_we race_bl race_ot race_wht age2

//USE MARGINS for Pdi _b[_cons] + _b[female]*0 + _b[black]*0 + _b[hispanic]*0 + _b[age]*20 + _b[age2]*20 + _b[hsdrop]*1 + _b[hsgrad]*0 + _b[colsome]*0 + _b[colgrad]*0 + _b[smkban]*0
//repeat for ms b

//probit smoker smkban female age age_squared hsdrop hsgrad colsome colgrad black hispanic, r

//ttest smkban == 0  for population not coefficient... want coefficient?

//ttest smoker... see reg results again?




