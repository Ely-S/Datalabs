use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\SeatBelts.dta", clear

sum
reg fatalityrate sb speed65 speed70 ba08 drinkage21 lnincome age, r
gen lnincome = ln(income)

areg fatalityrate sb speed65 speed70 ba08 drinkage21 lnincome age, absorb(state) r

areg fatalityrate sb speed65 speed70 ba08 drinkage21 lnincome age , absorb(year) r

areg fatalityrate sb speed65 speed70 ba08 drinkage21 lnincome age i.year, absorb(state) r

areg sb_useage speed65 speed70 age drinkage21 ba08 primary secondary lnincome i.year, absorb(state) r
