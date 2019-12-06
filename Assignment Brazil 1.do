clear
use "C:\Users\Kogimandias\Google Drive\MA2\Policy Evaluation\Assignment\data_brazil.dta"

*Include some descriptive stats
describe
*need to remove races that weren't close =>  Sample of close races only includes elections where the winner party’s margin of victory is no larger than two percentage points
*keep if (mv_incparty <= 2) 
*& !missing(mv_incpartyfor1)
*drop if missing()

describe
*Summarize provides us with simple, straightforward descriptive statistics (to be completed)
summarize



*Use of a simple scatter plot is not informative because too many data points
twoway(scatter mv_incpartyfor1 mv_incparty,mcolor(black) xline(0, lcolor(black))), graphregion(color(white)) ytitle(Outcome) xtitle(Score)

*We first smooth/aggregate the data before plotting
*Typical RD plot present 1) a global polynomial fit and 2) local sample means (dots).

*gen obs = 1
*collapse (mean) rdplot_mean_x rdplot_mean_y (sum) obs, by(rdplot_id)
*order rdplot_id
*sort rdplot_id

*In order to produce an RD plot with ES bins and an MV total number of bins on either side, we use the option binselect ="esmv".
*here Y = Probability of Uncoditional Victory at t+1
*X = Incumbent Party Vote Margin at T = mv_incparty
*A triangular kernel is used in the paper so same here
*polynomial order in paper = 4 so we use 4
*bandwidth is determined according to the paper by titiunik and it's the MSE-optimal one that is chosen

rdrobust mv_incpartyfor1 mv_incparty, c(0) p(4) kernel(triangular) bwselect(mserd)
rdplot  mv_incpartyfor1 mv_incparty, c(0) p(4) kernel(triangular) bwselect(mserd) xtitle(vote's margin at t) ytitle(Vote's margin at t+1))
*rdplot mv_incpartyfor1 mv_incparty, nbins(20 20) binselect(esmv) ///
	*graph_options(graphregion(color(white)) ///
	*xtitle(Score) ytitle(Outcome))