*Fukushima project, Masanori Matsuura
*Updated: 2024/05/12

clear
set more off
clear mata
set maxvar   32000
 
global data="C:\Users\mm_wi\Documents\research\jp_eq\data\stata\data"
global figure="C:\Users\mm_wi\Documents\research\jp_eq\data\stata\figure"
use $data\fukushima_matsuura.dta, clear
drop _merge

*市町村・旧市町村・集落コードが平成の大合併で2010年（or2005年）から変更されている。
*region_code_trans20190917_05_fukushima_niigataは95-15で市町村・旧市町村・集落コードが統一されたデータ（コードは2015年基準）
merge m:m id year using $data\region_code_trans20190917_05_fukushima_niigata.dta
keep if _merge==3
drop _merge

*replace namere
rename baa9515_0001 prfctr
drop   baa9515_0002
drop   baa9515_0003 
rename rc04  mnc 
rename rc05  omnc 
rename rc06  vil 

*関係ないデータを落とす

******キョリをmerge
merge m:m  prfctr mnc  omnc  vil  using distance_2015.dta
keep if _merge==3



*パネルデータの設定
xtset id year 
xtdes

*95-15の間に何回でてきたか。
egen number_obs     = count(id)  , by (id)

*自治体レベルのID
egen double  vil_id   = group(prfctr mnc omnc vil)
egen double  omnc_id  = group(prfctr mnc omnc    )
egen double  mnc_id   = group(prfctr mnc         )




*****************
****データの作成***
*****************

*農業地域類型
egen ruikei= max(baa9515_0016), by (id)

*専業農家・兼業農家
gen d_senken_1 =.
replace d_senken_1 = 1 if baa9515_1557 == 10 | baa9515_1557 == 20 
replace d_senken_1 = 2 if baa9515_1557 == 21
replace d_senken_1 = 3 if baa9515_1557 == 22 
replace d_senken_1 = 4 if baa9515_1557 == 90

gen d_senken_2 = .
replace d_senken_2 = 1 if baa9515_1557 == 10 | baa9515_1557 == 20 
replace d_senken_2 = 0 if baa9515_1557 == 21 | baa9515_1557 == 22  | baa9515_1557 == 90 

gen d_sengyo_3 = .
replace d_sengyo_3 = 1 if baa9515_1557 == 10 
replace d_sengyo_3 = 0 if baa9515_1557 == 20  | baa9515_1557 == 21 | baa9515_1557 == 22  | baa9515_1557 == 90 

gen d_sengyo_4 =.
replace d_sengyo_4  = 1   if  baa9515_1557 == 10 
replace d_sengyo_4  = 0   if  d_sengyo_4 ==.

*主業農家・副業農家
gen d_syugyo_1 =.
replace d_syugyo_1 = 1 if baa9515_1549 == 11 | baa9515_1549 == 12 
replace d_syugyo_1 = 2 if baa9515_1549 == 21 | baa9515_1549 == 22
replace d_syugyo_1 = 3 if baa9515_1549 == 30 
replace d_syugyo_1 = 4 if baa9515_1549 == 90

gen d_syugyo_2 =.
replace d_syugyo_2 = 1 if baa9515_1549 == 11 | baa9515_1549 == 12 
replace d_syugyo_2 = 0 if baa9515_1549 == 21 | baa9515_1549 == 22 | baa9515_1549 == 30 | baa9515_1549 == 90

gen d_syugyo_3 =.
replace d_syugyo_3 = 1 if baa9515_1549 == 11  
replace d_syugyo_3 = 0 if baa9515_1549 == 12 | baa9515_1549 == 21 | baa9515_1549 == 22 | baa9515_1549 == 30 | baa9515_1549 == 90

gen d_syugyo_4 =.
replace d_syugyo_4 = 1   if  baa9515_1549 == 11 | baa9515_1549 == 21 
replace d_syugyo_4 = 0   if  d_syugyo_4 ==.

*自給農家
gen d_subsistence =.
replace d_subsistence = 1 if baa9515_1549 == 90
replace d_subsistence = 0 if d_subsistence  ==.

*販売農家
gen d_com =.
replace d_com = 1 if baa9515_1549 != 90 & year != 1995  
replace d_com = 0 if baa9515_1549 == 90 & year != 1995  

replace d_com = 1 if baa9515_0021 == 1 & year ==1995 
replace d_com = 0 if baa9515_0021 == 2 & year ==1995 

*世帯員数
gen  pop =baa9515_0124

*世帯員数_男子割合
gen share_male = baa9515_0125/ pop

*世帯員数_15歳以下の割合
gen share_u15 = ( pop - baa9515_0133 ) / pop

*世帯主の年齢
*age
replace baa9515_0136 = 148 - baa9515_0138  if  baa9515_0137 ==1 & year == 2015 
replace baa9515_0136 = 104 - baa9515_0138  if  baa9515_0137 ==2 & year == 2015 
replace baa9515_0136 = 90  - baa9515_0138  if  baa9515_0137 ==3 & year == 2015  
replace baa9515_0136 = 27  - baa9515_0138  if  baa9515_0137 ==4 & year == 2015 

replace baa9515_0161 = 148 - baa9515_0163  if  baa9515_0162 ==1 & year == 2015 
replace baa9515_0161 = 104 - baa9515_0163  if  baa9515_0162 ==2 & year == 2015 
replace baa9515_0161 = 90  - baa9515_0163  if  baa9515_0162 ==3 & year == 2015  
replace baa9515_0161 = 27  - baa9515_0163  if  baa9515_0162 ==4 & year == 2015 

replace baa9515_0186 = 148 - baa9515_0188  if  baa9515_0187 ==1 & year == 2015 
replace baa9515_0186 = 104 - baa9515_0188  if  baa9515_0187 ==2 & year == 2015 
replace baa9515_0186 = 90  - baa9515_0188  if  baa9515_0187 ==3 & year == 2015  
replace baa9515_0186 = 27  - baa9515_0188  if  baa9515_0187 ==4 & year == 2015 

replace baa9515_0211 = 148 - baa9515_0213  if  baa9515_0212 ==1 & year == 2015 
replace baa9515_0211 = 104 - baa9515_0213  if  baa9515_0212 ==2 & year == 2015 
replace baa9515_0211 = 90  - baa9515_0213  if  baa9515_0212 ==3 & year == 2015  
replace baa9515_0211 = 27  - baa9515_0213  if  baa9515_0212 ==4 & year == 2015 

replace baa9515_0236 = 148 - baa9515_0238  if  baa9515_0237 ==1 & year == 2015 
replace baa9515_0236 = 104 - baa9515_0238  if  baa9515_0237 ==2 & year == 2015 
replace baa9515_0236 = 90  - baa9515_0238  if  baa9515_0237 ==3 & year == 2015  
replace baa9515_0236 = 27  - baa9515_0238  if  baa9515_0237 ==4 & year == 2015 

replace baa9515_0261 = 148 - baa9515_0263  if  baa9515_0262 ==1 & year == 2015 
replace baa9515_0261 = 104 - baa9515_0263  if  baa9515_0262 ==2 & year == 2015 
replace baa9515_0261 = 90  - baa9515_0263  if  baa9515_0262 ==3 & year == 2015  
replace baa9515_0261 = 27  - baa9515_0263  if  baa9515_0262 ==4 & year == 2015 

replace baa9515_0286 = 148 - baa9515_0288  if  baa9515_0287 ==1 & year == 2015 
replace baa9515_0286 = 104 - baa9515_0288  if  baa9515_0287 ==2 & year == 2015 
replace baa9515_0286 = 90  - baa9515_0288  if  baa9515_0287 ==3 & year == 2015  
replace baa9515_0286 = 27  - baa9515_0288  if  baa9515_0287 ==4 & year == 2015 

replace baa9515_0311 = 148 - baa9515_0313  if  baa9515_0312 ==1 & year == 2015 
replace baa9515_0311 = 104 - baa9515_0313  if  baa9515_0312 ==2 & year == 2015 
replace baa9515_0311 = 90  - baa9515_0313  if  baa9515_0312 ==3 & year == 2015  
replace baa9515_0311 = 27  - baa9515_0313  if  baa9515_0312 ==4 & year == 2015 


replace baa9515_0336 = 148 - baa9515_0338  if  baa9515_0337 ==1 & year == 2015 
replace baa9515_0336 = 104 - baa9515_0338  if  baa9515_0337 ==2 & year == 2015 
replace baa9515_0336 = 90  - baa9515_0338  if  baa9515_0337 ==3 & year == 2015  
replace baa9515_0336 = 27  - baa9515_0338  if  baa9515_0337 ==4 & year == 2015 


replace baa9515_0331 = 148 - baa9515_0363  if  baa9515_0362 ==1 & year == 2015 
replace baa9515_0361 = 104 - baa9515_0363  if  baa9515_0362 ==2 & year == 2015 
replace baa9515_0361 = 90  - baa9515_0363  if  baa9515_0362 ==3 & year == 2015  
replace baa9515_0361 = 27  - baa9515_0363  if  baa9515_0362 ==4 & year == 2015 






gen age =.
replace age =  baa9515_0136  if (  baa9515_0155 == 1 | baa9515_0159 ==1  )
replace age =  baa9515_0161  if (  baa9515_0180 == 1 | baa9515_0184 ==1  )
replace age =  baa9515_0186  if (  baa9515_0205 == 1 | baa9515_0209 ==1  ) 
replace age =  baa9515_0211  if (  baa9515_0230 == 1 | baa9515_0234 ==1  ) 
replace age =  baa9515_0236  if (  baa9515_0255 == 1 | baa9515_0259 ==1  ) 
replace age =  baa9515_0261  if (  baa9515_0280 == 1 | baa9515_0284 ==1  )
replace age =  baa9515_0286  if (  baa9515_0305 == 1 | baa9515_0309 ==1  )
replace age =  baa9515_0311  if (  baa9515_0330 == 1 | baa9515_0334 ==1  )
replace age =  baa9515_0336  if (  baa9515_0355 == 1 | baa9515_0359 ==1  )
replace age =  baa9515_0361  if (  baa9515_0380 == 1 | baa9515_0384 ==1  )



replace age = baa9515_0136  if year == 1995 
replace age = baa9515_0161  if year == 1995 & age == 0
replace age = baa9515_0136  if year != 1995 & age == .
replace age = baa9515_0136  if year == 2015 & age == .


*世帯主の性別
gen gender =.

replace gender = 1 if baa9515_0140 == 1 & baa9515_0141 == 1 
replace gender = 1 if baa9515_0140 == 1 & baa9515_0158 == 1 

replace gender = 1 if baa9515_0165 == 1 & baa9515_0166 == 1 
replace gender = 1 if baa9515_0165 == 1 & baa9515_0183 == 1

replace gender = 1 if baa9515_0190 == 1 & baa9515_0191 == 1 
replace gender = 1 if baa9515_0190 == 1 & baa9515_0208 == 1


replace gender = 1 if baa9515_0215 == 1 & baa9515_0216 == 1 
replace gender = 1 if baa9515_0215 == 1 & baa9515_0233 == 1

replace gender = 1 if baa9515_0240 == 1 & baa9515_0241 == 1 
replace gender = 1 if baa9515_0240 == 1 & baa9515_0258 == 1

replace gender = 1 if baa9515_0265 == 1 & baa9515_0266 == 1 
replace gender = 1 if baa9515_0265 == 1 & baa9515_0283 == 1

replace gender = 1 if baa9515_0290 == 1 & baa9515_0291 == 1 
replace gender = 1 if baa9515_0290 == 1 & baa9515_0308 == 1

replace gender = 1 if baa9515_0315 == 1 & baa9515_0316 == 1 
replace gender = 1 if baa9515_0315 == 1 & baa9515_0333 == 1

replace gender = 1 if baa9515_0330 == 1 & baa9515_0331 == 1 
replace gender = 1 if baa9515_0330 == 1 & baa9515_0358 == 1

replace gender =0 if gender !=1

*後継者の有無
gen d_successor =.
replace d_successor = 1 if baa9515_1544 == 1
replace d_successor = 1 if baa9515_1546 >= 1101 & baa9515_1546 <= 1113
replace d_successor = 0 if d_successor ==. & year != 1995 

replace d_successor = 1  if baa9515_0158 ==3
replace d_successor = 1  if baa9515_0183 ==3
replace d_successor = 1  if baa9515_0208 ==3 
replace d_successor = 1  if baa9515_0233 ==3 
replace d_successor = 1  if baa9515_0258 ==3
replace d_successor = 1  if baa9515_0283 ==3 
replace d_successor = 1  if baa9515_0308 ==3 
replace d_successor = 1  if baa9515_0333 ==3 
replace d_successor = 1  if baa9515_0358 ==3 

replace d_successor = 0  if d_successor ==. & year == 1995 

*農産物販売金額
gen d_rev = baa9515_1316 

*dairy farmer(少しでもlivestockを含む)
gen dairy  = 1 if baa9515_1337 != 0 | baa9515_1339  != 0 | baa9515_1341!= 0 | baa9515_1343 != 0 | baa9515_1345 != 0 | baa9515_1347 != 0 

*販売金額が1位の作付け作物
gen torikumi_2 =.
replace torikumi_2 = 1  if baa9515_1318 == 1
replace torikumi_2 = 2  if baa9515_1320 == 1
replace torikumi_2 = 3  if baa9515_1322 == 1
replace torikumi_2 = 4  if baa9515_1324 == 1
replace torikumi_2 = 5  if baa9515_1326 == 1
replace torikumi_2 = 6  if baa9515_1328 == 1
replace torikumi_2 = 7  if baa9515_1330 == 1
replace torikumi_2 = 8  if baa9515_1332 == 1
replace torikumi_2 = 9  if baa9515_1334 == 1
replace torikumi_2 = 10 if baa9515_1336 == 1
replace torikumi_2 = 11 if baa9515_1338 == 1
replace torikumi_2 = 12 if baa9515_1340 == 1
replace torikumi_2 = 13 if baa9515_1342 == 1
replace torikumi_2 = 14 if baa9515_1344 == 1
replace torikumi_2 = 15 if baa9515_1346 == 1


*経営の法人化
gen corpration = .
replace corpration = 0 if baa9515_0042	== 0 
replace corpration = 1 if corpration	== .





***************************
**********outcome**********
***************************

*総経営耕地面積
gen land_ha = baa9515_0604 /100
gen lnland = ln(land_ha )

gen IHS_land    = ln(baa9515_0604 + ((baa9515_0604^2 + 1 )^0.5))
gen IHS_land_ha = ln(land_ha + ((land_ha^2 + 1 )^0.5))

*総所有耕地面積
gen own_ha = baa9515_0605 /100
gen lnown = ln(own_ha)

gen IHS_own    = ln(baa9515_0605 + ((baa9515_0605^2 + 1 )^0.5))
gen IHS_own_ha = ln(own_ha + ((own_ha^2 + 1 )^0.5))

*総貸付耕地面積
gen lent_ha = baa9515_0606 / 100 

gen IHS_lent = ln(baa9515_0606 + ((baa9515_0606^2 + 1 )^0.5))
gen IHS_lent_ha = ln(lent_ha + ((lent_ha^2 + 1 )^0.5))


*総耕作放棄地面積
gen aband_ha = baa9515_0608 /100

gen IHS_aband    = ln(baa9515_0608 + ((baa9515_0608^2 + 1 )^0.5))
gen IHS_aband_ha = ln(aband_ha + ((aband_ha^2 + 1 )^0.5))


*総借入耕地面積
gen brrw_ha = baa9515_0609  /100

gen IHS_brrw    = ln(baa9515_0609 + ((baa9515_0609^2 + 1 )^0.5))
gen IHS_brrw_ha = ln(brrw_ha + ((brrw_ha^2 + 1 )^0.5))

*所有している田
gen own_pd_ha = baa9515_0610 /100

gen IHS_own_pd    = ln(baa9515_0610 + ((baa9515_0610^2 + 1 )^0.5))
gen IHS_own_pd_ha = ln(IHS_own_pd + ((IHS_own_pd^2 + 1 )^0.5))

*他に貸している田
gen lent_pd_ha = baa9515_0611 /100

gen IHS_lent_pd    = ln(baa9515_0611 + ((baa9515_0611^2 + 1 )^0.5))
gen IHS_lent_pd_ha = ln(lent_pd_ha + ((lent_pd_ha^2 + 1 )^0.5))

**耕作を放棄した田
gen aband_pd_ha = baa9515_0612 /100

gen IHS_aband_pd   = ln(baa9515_0612 + ((baa9515_0612^2 + 1 )^0.5))
gen IHS_aband_pd_ha = ln(aband_pd_ha + ((aband_pd_ha^2 + 1 )^0.5))

*他から借り入れている田
gen brrw_pd_ha = baa9515_0613 /100

gen IHS_brrw_pd    = ln(baa9515_0613 + ((baa9515_0613^2 + 1 )^0.5))
gen IHS_brrw_pd_ha = ln(brrw_pd_ha + ((brrw_pd_ha^2 + 1 )^0.5))

*田の経営耕地
gen land_pd_ha = baa9515_0616 /100

gen IHS_land_pd    = ln(baa9515_0616 + ((baa9515_0616^2 + 1 )^0.5))
gen IHS_land_pd_ha = ln(land_pd_ha + ((land_pd_ha^2 + 1 )^0.5))

*稲を作った田
gen clt_pd = baa9515_0619 / 100 

gen IHS_clt_pd    = ln(baa9515_0619 + ((baa9515_0619^2 + 1 )^0.5))
gen IHS_clt_pd_ha = ln(clt_pd + ((clt_pd^2 + 1 )^0.5))

*水田率
gen r_paddy =  (  land_pd_ha /land_ha )  * 100

*農産物の販売金額
gen rev =.
replace rev = 0     if baa9515_1316 ==1
replace rev = 7.5   if baa9515_1316 ==2
replace rev = 32.5  if baa9515_1316 ==3
replace rev = 75    if baa9515_1316 ==4
replace rev = 150   if baa9515_1316 ==5
replace rev = 250   if baa9515_1316 ==6
replace rev = 400   if baa9515_1316 ==7
replace rev = 600   if baa9515_1316 ==8
replace rev = 850   if baa9515_1316 ==9
replace rev = 1250  if baa9515_1316 ==10
replace rev = 1750  if baa9515_1316 ==11
replace rev = 2500  if baa9515_1316 ==12
replace rev = 4000  if baa9515_1316 ==13
replace rev = 7500  if baa9515_1316 ==14
replace rev = 10000  if baa9515_1316 ==15

gen IHS_rev = ln(rev + ((rev^2 + 1 )^0.5))


*農産物の販売金額(per ha)
gen rev_ha = rev / land_ha  
gen IHS_rev_ha = ln(rev_ha + ((rev_ha^2 + 1 )^0.5))

*環境保全型農業への取り組み_化学肥料
gen env_manure = baa9515_0055 

*環境保全型農業への取り組み_農薬
gen env_pst = baa9515_0056

**環境保全型農業への取り組み_堆肥による土づくり
gen env_comp =  baa9515_0057



*****************************************************************
*95年に存在する農家に限定&途中から現れる農家を除く&消えて再度現れる農家は除く
*****************************************************************

********* 販売農家
egen n_obs_5   = count(id) if                                                d_com == 1   , by (id)
egen n_obs_4   = count(id) if year != 2015                               &   d_com == 1   , by (id)
egen n_obs_3   = count(id) if year != 2015 & year != 2010                &   d_com == 1   , by (id)
egen n_obs_2   = count(id) if year != 2015 & year != 2010 & year != 2005 &   d_com == 1   , by (id)
egen n_obs_1   = count(id) if year == 1995                               &   d_com == 1   , by (id)

gen slct =.
replace slct = 1  if n_obs_5 == 5
replace slct = 1  if n_obs_4 == 4
replace slct = 1  if n_obs_3 == 3
replace slct = 1  if n_obs_2 == 2
replace slct = 1  if n_obs_1 == 1

*生存分析(販売農家)
egen n_obs   = count(id) if      slct == 1    , by (id)

gen suv =.
replace suv = 1  if n_obs == 5

replace suv = 0  if n_obs == 4 & year == 2010 
replace suv = 1  if n_obs == 4 & year <= 2005 

replace suv = 0  if n_obs == 3 & year == 2005
replace suv = 1  if n_obs == 3 & year <= 2000 

replace suv = 0  if n_obs == 2 & year == 2000
replace suv = 1  if n_obs == 2 & year <= 1995 

replace suv = 0  if n_obs == 1 & year == 1995

by year, sort:tab suv slct




********* 総農家
egen nobs_5   = count(id)                                                 , by (id)
egen nobs_4   = count(id) if year != 2015                                 , by (id)
egen nobs_3   = count(id) if year != 2015 & year != 2010                  , by (id)
egen nobs_2   = count(id) if year != 2015 & year != 2010 & year != 2005   , by (id)
egen nobs_1   = count(id) if year == 1995                                 , by (id)

gen select =.
replace select = 1  if nobs_5 == 5
replace select = 1  if nobs_4 == 4
replace select = 1  if nobs_3 == 3
replace select = 1  if nobs_2 == 2
replace select = 1  if nobs_1 == 1

*生存分析(総農家)
egen nobs   = count(id)    if   select == 1     , by (id)

gen sv =.
replace sv = 1  if nobs == 5

replace sv = 0  if nobs == 4 & year == 2010 
replace sv = 1  if nobs == 4 & year <= 2005 

replace sv = 0  if nobs == 3 & year == 2005
replace sv = 1  if nobs == 3 & year <= 2000 

replace sv = 0  if nobs == 2 & year == 2000
replace sv = 1  if nobs == 2 & year <= 1995 

replace sv = 0  if nobs == 1 & year == 1995

by year, sort:tab sv   select





*************************
******treatmentの作成*****
*************************

*2015年の市町村番号
*JAあいづ
*会津若松市(202)
*磐梯町(407)
*猪苗代町(408)

*JA会津みなみ
*只見町(367)
*南会津町(368)
*下郷町(362)
*檜枝岐村(364)

*JA会津みどり
*会津坂下町(421)

*JA会津いいで
*喜多方市(208)
*西会津町(405)

*unknown
*金山町(445)
*北塩原村(402)
*湯川村(422)
*柳津町(423)
*三島町(444)
*昭和村(446)
*会津美里町(447)


*魚沼市　　225 
*阿賀町　　385 
*三条市   204

*******treat town
gen treat_town = . 

*JAあいづ
*会津若松市
*replace treat_town = 1 if mnc == 202 & prfctr == 7
*磐梯町
*replace treat_town = 1 if mnc == 407 & prfctr == 7
*猪苗代町
*replace treat_town = 1 if mnc == 408 & prfctr == 7

*JA会津みなみ
**只見町**
replace treat_town = 1 if mnc == 367 & prfctr == 7
*南会津町
*replace treat_town = 1 if mnc == 368 & prfctr == 7
*下郷町
*replace treat_town = 1 if mnc == 362 & prfctr == 7
**檜枝岐村**
replace treat_town = 1 if mnc == 364 & prfctr == 7

*JA会津みどり
*会津坂下町
*replace treat_town = 1 if mnc == 421 & prfctr == 7
*湯川村
*replace treat_town = 1 if mnc == 422 & prfctr == 7
*柳津町
*replace treat_town = 1 if mnc == 423 & prfctr == 7
**金山町**
replace treat_town = 1 if mnc == 445 & prfctr == 7
*会津美里町
*replace treat_town = 1 if mnc == 447 & prfctr == 7
*三島町
*replace treat_town = 1 if mnc == 444 & prfctr == 7
*昭和村
*replace treat_town = 1 if mnc == 446 & prfctr == 7


*JA会津いいで
*喜多方市
*replace treat_town = 1 if mnc == 208 & prfctr == 7
**西会津町**
replace treat_town = 1 if mnc == 405 & prfctr == 7
*北塩原村
*replace treat_town = 1 if mnc == 402 & prfctr == 7


*******control town
gen control_town =.

*魚沼市
replace control_town = 1 if mnc  == 225 & prfctr == 15
*阿賀町
replace control_town = 1 if mnc  == 385 & prfctr == 15 
*三条市
replace control_town = 1 if mnc  == 204 & prfctr == 15 


*******treatment
gen treat =.
replace treat = 1 if treat_town == 1 & year >= 2010 
replace treat = 0 if treat_town == 1 & year <  2010
replace treat = 0 if control_town == 1              

*******treatment2
gen treat_2 =.
replace treat_2 = 1 if treat_town == 1 
replace treat_2 = 0 if control_town == 1 

by year, sort: tab treat_2 if slct== 1
by year, sort: tab treat_2 if select== 1

save panel.dta, replace

use panel, clear

*松浦さんリクエスト*
log using kekka_0112_vol2.smcl, replace 

******************************DID *************************
global outcome IHS_lent_ha IHS_lent_pd_ha IHS_land_pd IHS_clt_pd  env_comp  IHS_lent IHS_rev IHS_rev_ha 

foreach out in $outcome{
reghdfe `out' treat i.year c.age##c.age i.gender d_successor i.corpration pop i.d_senken_1 if slct== 1 , abs(id)  cluster(id vil_id) 
 }
 

******Event study-Plot********
forvalues num = 1995/2015{
gen d_`num' = .
capture replace d_`num' = 1 if   treat_2 == 1 &  year == `num' 
capture replace d_`num' = 0 if   treat_2 == 1 &  year != `num'  
capture replace d_`num' = 0 if   treat_2 == 0  
}

foreach out in IHS_lent_ha IHS_lent_pd_ha IHS_land_pd IHS_clt_pd env_comp IHS_lent IHS_rev IHS_rev_ha {
reghdfe `out' d_1995  d_2000 d_2005 d_2015 i.year c.age##c.age i.gender d_successor i.corpration pop i.d_senken_1 if slct== 1,abs(id year) cluster(id vil_id) 

coefplot, keep(d_1995  d_2000 d_2005  d_2015)  vert omit relocate(d_1995=1995 d_2000=2000 d_2005=2005 d_2010=2010 d_2015=2015      )  xlabel(1995(5)2015) yline(0) level(5 95) ylabel(,grid) title("`out'") 

graph export "$figure/`out'.pdf", as(pdf) replace 

}

log close
 

 
******************************************************************
******************************Event study*************************
******************************************************************

log using kekka_1229.smcl, replace 

global outcome sv  IHS_land IHS_land_ha IHS_own IHS_own_ha IHS_lent IHS_lent_ha IHS_aband IHS_aband_ha  IHS_brrw IHS_brrw_ha IHS_own_pd IHS_own_pd_ha IHS_lent_pd IHS_lent_pd_ha IHS_aband_pd IHS_aband_pd_ha IHS_brrw_pd IHS_brrw_pd_ha IHS_land_pd IHS_land_pd_ha IHS_clt_pd IHS_clt_pd_ha IHS_rev IHS_rev_ha env_manure env_pst env_comp

*販売農家ベース
collect clear 

reghdfe sv i.treat_2##ib2010.year  , abs(id  )  cluster(id vil_id) 

foreach out in $outcome{
reghdfe `out' i.treat_2##ib2010.year if slct== 1 , abs(id  )  cluster(id vil_id) 
 }
 
 
 
reghdfe suv i.treat_2##ib2010.year age i.gender pop i.corpration , abs(id  )  cluster(id vil_id) 

foreach out in $outcome{
reghdfe `out' i.treat_2##ib2010.year age i.gender pop i.corpration if slct== 1 , abs(id  )  cluster(id vil_id) 
 }
 
log close
 
********************************************************************************
******************************************************************************** 
********************************************************************************

 
 
*総農家ベース 
foreach out in $outcome{
reghdfe `out' i.treat_2##ib2010.year if select== 1 , abs(id year )  cluster(id vil_id) 
 }

 

 
 
******Event study-Plot********
forvalues num = 1995/2015{
gen d_`num' = .
capture replace d_`num' = 1 if   treat_2 == 1 &  year == `num' 
capture replace d_`num' = 0 if   treat_2 == 1 &  year != `num'  
capture replace d_`num' = 0 if   treat_2 == 0  
}


*田の経営耕地面積 
foreach out in IHS_land_pd_ha{
reghdfe `out' d_1995  d_2000 d_2005  d_2015 i.year  c.age##c.age i.gender d_successor i.corpration pop i.d_senken_1 if select== 1,abs(id year) vce(cl id)

coefplot, keep(d_1995  d_2000 d_2005  d_2015)  vert omit relocate(d_1995=1995 d_2000=2000 d_2005=2005 d_2010=2010 d_2015=2015      )  xlabel(1995(5)2015) yline(0) level(5 95) ylabel(,grid) title("田の経営耕地面積(総農家ベース)") name(`out')

coefplot, keep(d_1995  d_2000 d_2005  d_2015)  vert omit relocate(d_1995=1995 d_2000=2000 d_2005=2005 d_2010=2010 d_2015=2015      )  xlabel(1995(5)2015) yline(0) level(5 95) ylabel(,grid) title("田の経営耕地面積(販売農家ベース)") name(`out'_com)

graph combine `out' `out'_com

graph save $figure/pddyfld.gph",replace 
 }
 
 
 
 
 
**************************************************
********differrence in discontinuity *************
**************************************************

*販売農家ベース
foreach out in $outcome{
reghdfe `out' i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if slct== 1 , abs(id year )  cluster(id vil_id) 
 }
 
*総農家ベース 
foreach out in $outcome{
reghdfe `out' i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if select== 1 , abs(id year )  cluster(id vil_id) 
 }

*significant
collect clear 
collect _r_b _r_se ,tag (model[1]):reghdfe IHS_land_pd     i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if slct== 1 , abs(id year )  cluster(id vil_id) 
collect _r_b _r_se ,tag (model[2]):reghdfe IHS_land_pd_ha  i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if slct== 1 , abs(id year )  cluster(id vil_id) 
collect _r_b _r_se ,tag (model[3]):reghdfe IHS_clt_pd_ha   i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if slct== 1 , abs(id year )  cluster(id vil_id) 
collect _r_b _r_se ,tag (model[4]):reghdfe IHS_clt_pd_ha   i.treat_2##ib2010.year c.dist##ib2010.year c.dist##c.dist##c.dist if select== 1 , abs(id year )  cluster(id vil_id) 

collect layout (colname#result result[N])(model)
collect style cell result , nformat(%6.3f)
collect style cell result[_r_se] , sformat("(%s)")
collect style header result[_r_b _r_se],level(hide)
collect stars _r_p 0.01 "***" 0.05 "**" 0.1 "*" " 1" "",attach(_r_b)
collect preview 


 
 
 
 
 
 
 
 
 
