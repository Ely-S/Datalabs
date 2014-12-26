clear
est clear
cd "C:\Users\sakoveT430\Desktop\"
use "C:\Users\sakoveT430\Desktop\metrix\lab session materials\datasets for labs\Sportscards.dta"
sum


ci trade

sort goodb
by goodb: ci trade

eststo: reg trade goodb, r
//probit trade goodb, r

sort dealer
by dealer: ci trade

eststo: reg trade dealer, r
//probit trade dealer, r

eststo: reg trade years_trade trades_p_m if dealer==0, r
//probit trade years_trade trades_p_m if dealer==0, r
rm t.rtf
esttab using t.rtf, label legend b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) nogaps

