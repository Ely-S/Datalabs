clear
est clear
set more on
import delimited E:\Data\o.csv, clear 
encode country, gen(countryid)
tsset countryid year
gen ratio = ln( youthrate / primerate )

gen lnyr = ln(youthrate)
gen lnpr = ln(primerate)
gen lngdp = ln(gdp)
gen inter = primerate*epr_v1
gen intert = primerate*ept_v1
gen lninter = ln(gdp)*epr_v1
gen lnintert = ln(gdp)*ept_v1

reg lnyr epr_v1 ept_v1
reg lnyr lngdp epr_v1 ept_v1 lninter lnintert i.year, r
//reg ratio gdp epr_v1 ept_v1 inter intert i.countryid i.year, r
//reg ratio primerate gdp inter intert epr_v1 ept_v1 i.countryid i.year, r
//reg ratio D(1/4).primerate D(1/4).gdp D(1/4).inter D(1/4).intert D(1/4).epr_v1 D(1/4).ept_v1 i.countryid i.year, r

corr inter intert primerate youthrate gdp epr_v1 ept_v1
