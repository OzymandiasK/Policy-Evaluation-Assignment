clear
use "C:\Users\Kogimandias\Documents\GitHub\Policy-Evaluation-Assignment\data_brazil.dta"

*Include some descriptive stats
describe
*Summarize provides us with simple, straightforward descriptive statistics (to be completed)
summarize

*Use of a simple scatter plot is not informative because too many data points
twoway(scatter mv_incpartyfor1 mv_incparty,mcolor(black) xline(0, lcolor(black))), graphregion(color(white)) ytitle(Outcome) xtitle(Score)

*In order to produce an RD plot with ES bins and an MV total number of bins on either side, we use the option binselect ="esmv".
*here Y = Probability of Uncoditional Victory at t+1
*X = Incumbent Party Vote Margin at T = mv_incparty
*A triangular kernel is used in the paper so same here
*polynomial order in paper = 4 so we use 4
*bandwidth is determined according to the paper by titiunik and it's the MSE-optimal one that is chosen

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

*rdplot mv_incpartyfor1 mv_incparty, nbins(20 20) binselect(esmv) ///
	*graph_options(graphregion(color(white)) ///
	*xtitle(Score) ytitle(Outcome))
	

***Email: Dependent variable = mv_incpartyfor1, running variable = mv_incparty and the cutoff is at 0
*find some coefficient??	
	
***Play around with the functional form (order of the polynomial)	

	
*Step further: Matching
*"If sharp RDD, then you can define the treatment variable ('1' if incparty<0 and '0' if incparty>0) and you can then match treated to control units by matching on the municipal charectiristics population and pibpc.

*create a dummy variable that equals 1 if the incumbent party has won in time t and 0 if it lost. so 1 if cutoff value is greater than 0 and 0 otherwise
generate dummy_win = (mv_incparty>0)
summarize dummy_win


*covariate matching
gen pop_without_ext = population if population<100000
summarize pop_without_ext

teffects nnmatch (mv_incpartyfor1 population pibpc) (dummy_win)
twoway (scatter mv_incpartyfor1 pop_without_ext if dummy_win==1, mcolor(red)) (scatter mv_incpartyfor1 pibpc if dummy_win==0, mcolor(blue)), legend (label(1 "Treated") label(2 "Untreated"))


