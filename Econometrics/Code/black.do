clear
use "\\hass11.win.rpi.edu\classes\ECON-4570\lab session materials\datasets for labs\Names.dta"
sum 
gen bf = black*female

sort black
by black: ci call_back
reg call_back black, r
reg call_back black female bf, r
reg call_back black female bf high, r

sort high
by high: reg call_back black female, r
probit call_back black female bf, r

// nonrandom assignment
by high: ci black
