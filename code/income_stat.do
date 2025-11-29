***作物統計
***Matsuura
***2025/03/02

cd "C:\Users\mm_wi\Documents\research\jp_eq\data\stata\analysis"
global fig "C:\Users\mm_wi\Documents\research\jp_eq\data\stata\figure"
**niigata
clear
import excel "C:\Users\mm_wi\Documents\research\jp_eq\data\stata\data\f002c-001-001-026-000.xls", cellrange(A5) firstrow // Excelファイルを読み込む

drop in 1/2

// 新しい西暦変数を作成
gen western_year = .

// 括弧内の西暦を抽出
replace western_year = real(regexs(1)) if regexm(年次, "\(([0-9]+)\)")

// 結果の確認
list 年次 western_year

keep 作付面積 平年収量 western_year

rename (作付面積 平年収量) (field_n production_n)
destring field production, replace

gen pref=1
label def pref 1 "Niigata"
save niigata.dta, replace

**fukushima
clear
import excel "C:\Users\mm_wi\Documents\research\jp_eq\data\stata\data\f002c-001-001-018-000.xls", cellrange(A5) firstrow // Excelファイルを読み込む

drop in 1/2

// 新しい西暦変数を作成
gen western_year = .

// 括弧内の西暦を抽出
replace western_year = real(regexs(1)) if regexm(年次, "\(([0-9]+)\)")

// 結果の確認
list 年次 western_year

keep 作付面積 平年収量 western_year

rename (作付面積 平年収量) (field_f production_f)
destring field production, replace
gen pref=2
label def pref 2 "Fukushima"
save fukushima.dta, replace

use fukushima, clear

merge 1:1 western_year using niigata.dta, nogen

save fukushima_niigata.dta, replace
** generate the difference
use fukushima_niigata, clear
keep if western_year>1999
keep if western_year<2016

label var pref "Prefecture"
label var western_year "Year"

twoway (line production_n western_year) || (line production_f western_year), ///
       legend(order(1 "Niigata" 2 "Fukushima") position(6) col(2) size(medium)) ///
       title("Prefecture-level production") ///
       ytitle("Ton") xtitle("Year") tline(2011)
graph export $fig\prodgap.png, replace