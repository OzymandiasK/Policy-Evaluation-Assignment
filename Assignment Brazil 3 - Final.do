clear
use "C:\Users\Kogimandias\Documents\GitHub\Policy-Evaluation-Assignment\data_brazil.dta"

*Include some descriptive stats for each variable present in the dataset.
describe
*Summarize provides us with simple, straightforward descriptive statistics (to be completed).
summarize

*Use of a simple scatter plot is not informative because, as can be seen on the scatterplot, there are too many data points.
twoway(scatter mv_incpartyfor1 mv_incparty,mcolor(black) xline(0, lcolor(black))), graphregion(color(white)) ytitle(Outcome) xtitle(Score)

*In order to produce an RD plot with ES bins and an MV total number of bins on either side, we use the option binselect ="esmv".
*A triangular kernel is used in the paper so same here.
*polynomial order in paper = 1 so we use 1 but we also try different polynomial fits to see if there are significant differences.
*bandwidth is determined according to the paper by titiunik and it's the MSE-optimal one that is chosen.

*Linear regression - RD
rdrobust mv_incpartyfor1 mv_incparty, c(0) p(1) kernel(triangular) bwselect(mserd)
rdplot  mv_incpartyfor1 mv_incparty, c(0) p(1) kernel(triangular) bwselect(mserd) xtitle(Vote's margin at t) ytitle(Vote's margin at t+1))

*Quadratic regression - RD
rdrobust mv_incpartyfor1 mv_incparty, c(0) p(2) kernel(triangular) bwselect(mserd)
rdplot  mv_incpartyfor1 mv_incparty, c(0) p(2) kernel(triangular) bwselect(mserd) xtitle(Vote's margin at t) ytitle(Vote's margin at t+1))

*Cubic regression - RD
rdrobust mv_incpartyfor1 mv_incparty, c(0) p(3) kernel(triangular) bwselect(mserd)
rdplot  mv_incpartyfor1 mv_incparty, c(0) p(3) kernel(triangular) bwselect(mserd) xtitle(Vote's margin at t) ytitle(Vote's margin at t+1))

*Fourth order polynomial fit - RD
rdrobust mv_incpartyfor1 mv_incparty, c(0) p(4) kernel(triangular) bwselect(mserd)
rdplot  mv_incpartyfor1 mv_incparty, c(0) p(4) kernel(triangular) bwselect(mserd) xtitle(Vote's margin at t) ytitle(Vote's margin at t+1))

***Covariate Matching
*First, we create a dummy_variable that equals 1 if the incumbent party has won in time t and 0 if it lost. so 1 if cutoff value is greater than 0 and 0 otherwise
generate dummy_win = (mv_incparty>0)
summarize dummy_win
*Second, apply matching with Nearest-Neighbour Matching and covariates are population and GDP per capita for each municipality

teffects nnmatch (mv_incpartyfor1 population pibpc) (dummy_win), metric(mahalanobis)

gen pop_without_ext = population if population<100000
tebalance density pop_without_ext
gen pibpc_without_ext = population if pibpc_without_ext<100000
tebalance density pibpc_without_ext

*summarize pop_without_ext
*twoway (scatter mv_incpartyfor1 pop_without_ext if dummy_win==1, mcolor(red)) (scatter mv_incpartyfor1 pibpc if dummy_win==0, mcolor(blue)), legend (label(1 "Treated") label(2 "Untreated"))
