est clear
clear
//import excel "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\UsMacro_Quarterly.xlsx", sheet("Sheet1") firstrow
import excel "C:\Users\sakoveT430\Desktop\metrix\lab session materials\datasets for labs\UsMacro_Quarterly.xlsx", sheet("Sheet1") firstrow
//cd "H:\public_html\econ"
//make sure you have quandt.do in your directory

//cd "P:\home\43\sakove\public_html\econ"
gen time = yq(Year, Quarter)
//gen time = Year+Quarter/4
tsset time
gen lnY = ln(RealGDP)
gen dlnY = ln(D.RealGDP)
gen growthRate = D.RealGDP/RealGDP
gen anGrowthRate = growthRate * 400
sum growthRate anGrowthRate
corrgram growthRate, lags(4) noplot

eststo: regress growthRate L.growthRate, vce(robust)
eststo: regress growthRate L(1/2).growthRate, vce(robust)
eststo: regress growthRate L(1/3).growthRate, vce(robust)
eststo: regress growthRate L(1/4).growthRate, vce(robust)


estat ic


dfuller RealGDP

//=== Calculate QLR ===



gen chow=.
gen interact = .
levelsof time if time>((252*.15)-52) & time<(199*.85), local(times)
//levelsof time, local(times) 
//sca qlrstat=0
gen late = .
quietly {
	foreach l of local times {
		replace late = `l' < time
		replace interact = late*L.growthRate
		reg d.Y late interact L.growthRate, r
		test late interact
		replace chow = r(F) if time==`l'
	}
}
scatter chow Year 
sum chow
sum if chow==r(max)


//regress growthRate L.growthRate, vce(robust)
//qui quandt growthRate, generate(lams)
//scatter lams Year 

// test each f statistic in a loop

//di "----Break Year------- min max"
//sum if lam==r(min)
//sum if lam==r(max)

gen DR= D.TBillRate
//14.5

// Grangercausality F Statistic
eststo: regress growthRate L(1/4).growthRate L(1/4).DR, vce(robust)
//esttab using mytable2, rtf b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) stats(bic aic rmsfe) nogaps

//esttab using ars2.rtf, ar2 cells((b(star) ci(par))(se(par))) label legend

replace chow=.
gen l1  = .
gen l2  =. 
gen l3 =.
gen l4 =.
quietly {
	foreach l of local times {
		replace late = `l' < time
		replace l4 = L4.DR*late
		replace l3 = L3.DR*late
		replace l2 = L2.DR*late
		replace l1 = L1.DR*late
		reg d.Y late L1.growthRate L2.growthRate L3.growthRate L4.growthRate l1 l2 l3 l4 L1.DR L2.DR L3.DR  L4.DR, r
		test late l1 l2 l3 l4
		replace chow = r(F) if time==`l'
	}
}
//scatter chow Year 
sum chow
sum if chow==r(max)
/*


//esttab using table3.rtf, ar2 cells((b(star) ci(par))(se(par))) label legend

//14.6 Psuedo out-of-sample Forecastw
gen Actual = growthRate
gen Forecast = .
gen rmsfe = .
gen fcastErr  = .
gen High =.
gen Low = .

qui forvalues p = 119/199{
	regress growthRate L.growthRate if time<`p', r
	predict yhatTemp, xb
	predict rmsfeTemp, stdp
	replace Forecast = yhatTemp if t==`p'+1
	replace rmsfe = rmsfeTemp if t==`p'+1
	drop yhatTemp rmsfeTemp
}
replace fcastErr = Actual - Forecast
tsline Actual Forecast
//Plot a graph of Actual y versus Forecasts made using prior data.
eststo: summarize fcastErr
//Check the mean and standard deviation of the Forecast errors.
replace Low = Forecast - 1.96*rmsfe
// Low end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
replace High = Forecast + 1.96*rmsfe
// High end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
tsline Actual Low Forecast High if Forecast<.
// Add Forecast intervals to the graph of
//Actual versus Forecast values of the y-variable

// same but for ADL 1/4 model


qui forvalues p = 119/199{
	regress growthRate L(1/4).growthRate if time<`p' , r
	predict yhatTemp, xb
	predict rmsfeTemp, stdp
	replace Forecast = yhatTemp if t==`p'+1
	replace rmsfe = rmsfeTemp if t==`p'+1
	drop yhatTemp rmsfeTemp
}

replace fcastErr = Actual - Forecast
tsline Actual Forecast
//Plot a graph of Actual y versus Forecasts made using prior data.
eststo: summarize fcastErr
//Check the mean and standard deviation of the Forecast errors.
replace Low  = Forecast - 1.96*rmsfe
// Low end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
replace High = Forecast + 1.96*rmsfe
// High end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
tsline Actual Low Forecast High if Forecast<.
// Add Forecast intervals to the graph of
//Actual versus Forecast values of the y-variable

// --niave model



replace l4 = (L1.growthRate + L2.growthRate + L3.growthRate + L4.growthRate)/4
qui forvalues p = 119/199{
	regress growthRate l4 if time<`p', r
	predict yhatTemp, xb
	predict rmsfeTemp, stdp
	replace Forecast = yhatTemp if t==`p'+1
	replace rmsfe = rmsfeTemp if t==`p'+1
	drop yhatTemp rmsfeTemp
}

replace fcastErr = Actual - Forecast
tsline Actual Forecast
//Plot a graph of Actual y versus Forecasts made using prior data.
eststo: summarize fcastErr
//Check the mean and standard deviation of the Forecast errors.
replace Low = Forecast - 1.96*rmsfe
// Low end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
replace High = Forecast + 1.96*rmsfe
// High end of 95% Forecast interval assuming there are
//normally distributed and homoskedastic errors (otherwise the 1.96
//would not be valid).
tsline Actual Low Forecast High if Forecast<.
// Add Forecast intervals to the graph of
//Actual versus Forecast values of the y-variable


