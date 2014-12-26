sum ahe if year==1992
sort female
by female: sum ahe
by female: sum ahe if year==2012
by female: sum ahe if year==1992
sort year
ci ahe if year==1992&bachelor==0
ttest ahe if year==1992, by(bachelor)
ttest ahe if year==2012, by(bachelor)
ci ahe if year==1992&bachelor==0
ci ahe if year==1992&bachelor==1
ci ahe if year==2012&bachelor==0
ci ahe if year==2012&bachelor==1
ttest ahe, by(year)
ttest ahe if bachelor==1, by(year)
ttest ahe if bachelor==0, by(year)
by female: sum ahe if year==2012 & bachelor==0
by female: sum ahe if year==2012 & bachelor==1
