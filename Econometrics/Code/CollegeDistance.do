 use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\CollegeDistance.dta", clear
//Part a
eststo: regress yrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))
//Part b
gen lnyrsed = ln(yrsed)
eststo: regress lnyrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))
//Part c
gen distsq = dist^2
eststo: regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))

//Replace the twoway below with the function evaluated for the constants
//given in part e.
twoway (function y= 8.82+x* -.0017278) (function y=8.92+x*_b[dist]) in 1/10

//Part g
gen dadmomcoll = dadcoll*momcoll
eststo: regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll dadmomcoll cue80 stwmfg80
margins , at(dadcoll=(0 0.5 1))
margins , at(momcoll=(0 0.5 1))
margins , at(dadmomcoll=(0 0.5 1))

//Part h
gen distincomehi = dist*incomehi
eststo: regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll distincomehi cue80 stwmfg80
margins , at(dist=(0 5 10))
margins , at(incomehi=(0 0.5 1))
margins , at(distincomehi=(0 0.5 1))



 use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\CollegeDistance.dta", clear
//Part a
eststo: yrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))
//Part b
gen lnyrsed = ln(yrsed)
eststo: lnyrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))
//Part c
gen distsq = dist^2
eststo: yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80
margins , at(dist=(2 2.5 3))
margins , at(dist=(6 6.5 7))

//Replace the twoway below with the function evaluated for the constants
//given in part e.
twoway (function y= 8.82+x* -.0017278) (function y=8.92+x*_b[dist]) in 1/10

//Part g
gen dadmomcoll = dadcoll*momcoll
eststo: yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll dadmomcoll cue80 stwmfg80
margins , at(dadcoll=(0 0.5 1))
margins , at(momcoll=(0 0.5 1))
margins , at(dadmomcoll=(0 0.5 1))

//Part h
gen distincomehi = dist*incomehi
eststo: regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll distincomehi cue80 stwmfg80
margins , at(dist=(0 5 10))
margins , at(incomehi=(0 0.5 1))
margins , at(distincomehi=(0 0.5 1))



regress yrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80, vce(robust)
regress lnyrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80, r
regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80, r
regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll dadmomcoll cue80 stwmfg80, r
regress yrsed dist distsq female bytest tuition black hispanic incomehi ownhome dadcoll momcoll distincomehi cue80 stwmfg80, r



