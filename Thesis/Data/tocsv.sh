#!/bin/bash
sqlite3 -header -csv data.db << SQL
  SELECT epl.c as country, 
  EPRC_V1, EPRC_V2, EPRC_V3, EPR_V1, EPR_V3, EPC, EPT_V1, EPT_V3,
  epl.year as year,  
  prime.rate as primerate, youth.rate as youthrate,
  old.rate as oldrate, gdp
  FROM epl
  JOIN g on g.year = epl.year and g.c = epl.c
  JOIN prime on prime.c = epl.c and prime.year = epl.year 
  JOIN old on old.c = epl.c and old.year = epl.year
  JOIN youth on youth.c = epl.c and youth.year = epl.year;
SQL


