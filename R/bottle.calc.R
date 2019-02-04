bottle.calc = function(alive.1,
                       alive.2,
                       time.1,
                       time.2=time.1,
                       diag.time=NA,
                       mortality.control=0,
                       pred.mort.prop=c(0.001,seq(.01,.99,.01),.999),
                       plot.output=FALSE
                       ){
  require(survival)

  #####################################
  # analyze the first data series
  #####################################
  
  ##> check lengths of "alive" and "time" input vectors to make sure they are the same
  ##> compare separately for the first and second groups; return an error message and exit the loop if lengths are different.
  if (length(alive.1) != length(time.1)) stop("Length of test data is different from the number of time points provided.")

  ## return an error message if the mortality in the control group exceeds the CDC-recommended limit of 10%
  if (mortality.control > .1) stop("Mortality in the control bottle exceeds the recommended limit. Consider rerunning the assay.")

  # create data series (for both test and susc) that indicate the number of mosquitoes that died by each time
  #dead.1 = c(0,head(alive.1,length(alive.1))-tail(alive.1,length(alive.1)))
  dead.1 = c(0,head(alive.1,length(alive.1)-1)-tail(alive.1,length(alive.1)-1))
  
  ## convert the input test and susc data into the format expected for survival analysis

  # create a data frame with times of death for the mosquitoes that died
  data.1 = data.frame(time=time.1[rep(1:length(time.1), dead.1)],died=1)
  
  # then add rows to the data frame for all of the mosquitoes that were not dead at the end of the assay
  if (tail(alive.1,1) > 0)  data.1 = rbind(data.1,data.frame(time=rep(tail(time.1,1), tail(alive.1,1)),died=0)) 
  
  # fit Kaplan-Meier survival curve to the data
  s1.1 = survfit(Surv(time,died) ~ 1,data=data.1) 

  # fit survival regression curve to the data; distribution assumed to be Weibull, which is the default
  s2.1 = survreg(Surv(time,died) ~ 1,data=data.1) 

  # get predicted survival times over the range of percentiles above
  pred.time.1 <- predict(s2.1, newdata=data.frame(blah=2), type='quantile', p=pred.mort.prop, se=TRUE)

  # calculate KD50, KD90, and KD95 values, which are the predicted times at which 50%, 90%, and 95% of mosquitoes are "knocked down" (i.e., dead)
  kd.1 <- predict(s2.1, newdata=data.frame(blah=2), type='quantile', p=c(.50,.90,.95), se=TRUE)

    #Abbott's formula: 
  
  # if diag.time is missing, get the earliest time at which 0 susceptible mosquitoes are alive;
  # otherwise, use the user-specified diag.time value
  diag.time = ifelse(is.na(diag.time) & exists('alive.2'),min(time.2[alive.2==0]),diag.time)
  
  #diagnostic time for susc is 45 min for the sample data, abbott formula will calculate for any specified vectors from user
  mortality.1 <- 1 - (alive.1[which(time.1 == diag.time)] / alive.1[1]) # mortality proportion at the diagnostic time
  mortality.1.abbott <- (mortality.1 - mortality.control) / (1 - mortality.control) # Abbott's formula expressed as proportions, which corrects for any mortality in the control bottle at the diagnostic time
  
  # take the correctected mortality value from Abbott's formula above and assign one of the following:
  # c('Susceptible','Potentially Resistant','Resistant')
  resistance.status.1 <- ifelse(mortality.1.abbott < .80, 'Resistant', 
                                ifelse(mortality.1.abbott > .98, 'Susceptible', 'Potentially Susceptible')) 
   
  #####################################
  # analyze the second data series (if given)
  #####################################
  if (exists('alive.2')) {
  if (length(alive.2) != length(time.2)) stop("Length of the second data series is different from the number of time points provided.")

  ##> return an error if diag.time is not specified and at least some susceptibles did not die during the experiment.
  if (is.na(diag.time) & sum(alive.2 == 0)==0) stop("Diagnostic time was not specified and at least some susceptibles did not die during the experiment.")

  # create data series that indicates the number of mosquitoes that died by each time
  #dead.2 = c(0,head(alive.2,length(alive.2)-1)-tail(alive.2,length(alive.2)-1))
  dead.2 = c(0,head(alive.2,length(alive.2)-1)-tail(alive.2,length(alive.2)-1))

  # create a data frame with times of death for the mosquitoes that died
  data.2 = data.frame(time=time.2[rep(1:length(time.2), dead.2)],died=1)
  
  # then add rows to the data frame for all of the mosquitoes that were not dead at the end of the assay
  if (tail(alive.2,1) > 0)  data.2 = rbind(data.2,data.frame(time=rep(tail(time.2,1), tail(alive.2,1)),died=0))
  
  # fit Kaplan-Meier survival curve
  s1.2 = survfit(Surv(time,died) ~ 1,data=data.2) 
  
  # fit survival regression curve to the data; distribution assumed to be Weibull, which is the default
  s2.2 = survreg(Surv(time,died) ~ 1,data=data.2) 
  
  # get predicted survival times over the range of percentiles above
  pred.time.2 <- predict(s2.2, newdata=data.frame(blah=2), type='quantile', p=pred.mort.prop, se=TRUE)
  
  # calculate KD50, KD90, and KD95 values, which are the predicted times at which 50%, 90%, and 95% of mosquitoes are "knocked down" (i.e., dead)
  kd.2 <- predict(s2.2, newdata=data.frame(blah=2), type='quantile', p=c(.50,.90,.95), se=TRUE)
  
  mortality.2 <- 1 - (alive.2[which(time.2 == diag.time)] / alive.2[1]) # mortality proportion at the diagnostic time
  mortality.2.abbott <- (mortality.2 - mortality.control) / (1 - mortality.control) # Abbott's formula expressed as proportions, which corrects for any mortality in the control bottle at the diagnostic time

  # take the correctected mortality value from Abbott's formula above and assign one of the following:
  # c('Susceptible','Potentially Resistant','Resistant')
  resistance.status.2 <- ifelse(mortality.2.abbott < .80, 'Resistant', 
                                ifelse(mortality.2.abbott > .98, 'Susceptible', 'Potentially Susceptible')) 
  
#####################################
# compare curves
#####################################
  
  data.compare = rbind(data.frame(group='A',data.1),data.frame(group='B',data.2))
  
  # added this function to compare the survival curves and get a p-value
  s1.compare = survdiff(Surv(time,died) ~ group,data=data.compare) 
  # on the line below, need to write code to return the p-value from the chi-squared test from s1.compare
  p.value.survdiff = pchisq(s1.compare$chisq, length(s1.compare$n)-1, lower.tail = FALSE) 
}

  # data frame that includes the predicted survival times for each selected mortality proportion for test and susc
  pred.surv.times <- data.frame(group='A',prop.mort=pred.mort.prop,pred.time=pred.time.1)
  if (exists('pred.time.2'))   pred.surv.times <- rbind(pred.surv.times,data.frame(group='B',prop.mort=pred.mort.prop,pred.time=pred.time.2))
  
#####################################
# plot the results if option is turned on
#####################################
  
  if (plot.output == TRUE) {
    # plot the resulting curves
    plot(c(0,tail(time.1,1)),c(0,100),xlab='Minutes',ylab='Percent Mortality',xlim=c(0,tail(time.1,1)),lwd=2,type='n') # plot Kaplan-Meier curve for susc group
    #  lines(time.2,(1-alive.2/alive.2[1])*100,lwd=2) # simple line drawn through the data points for the susc group
    #  lines(time.1,(1-alive.1/alive.1[1])*100,col=2,lwd=2)  # simple line drawn through the data points for the test group
    lines(rep(time.2,c(1,rep(2,length(time.2)-1))),(1-rep(alive.2/alive.2[1],c(rep(2,length(alive.2)-1),1)))*100,lwd=2) # plot Kaplan-Meier curve for test group
    lines(rep(time.1,c(1,rep(2,length(time.1)-1))),(1-rep(alive.1/alive.1[1],c(rep(2,length(alive.1)-1),1)))*100,col=2,lwd=2) # plot Kaplan-Meier curve for test group
    lines(pred.time.2$fit,pred.mort.prop*100,col=1,lty=2,lwd=2) # plot fitted Weibull curve
    lines(pred.time.1$fit,pred.mort.prop*100,col=2,lty=2,lwd=2) # plot fitted Weibull curve
    legend(tail(time.1,1),0,c('Group 1','Group 2'),lty=1,col=c(2,1),xjust=.9,yjust=.1,bty='n',lwd=2) # include a legend at the upper right
  }
  
#####################################
# return the function's results
#####################################
  
  # tell R what to return from this function
  return(list(
      kd.1 = list(
              kd50.1=kd.1$fit[1], # point estimate for KD50
              kd50.ci.1=kd.1$fit[1]+c(-2,2)*kd.1$se.fit[1], # 95% CI for KD50
              kd90.1=kd.1$fit[2], # point estimate for KD90
              kd90.ci.1=kd.1$fit[2]+c(-2,2)*kd.1$se.fit[2], # 95% CI for KD90
              kd95.1=kd.1$fit[3], # point estimate for KD95
              kd95.ci.1=kd.1$fit[3]+c(-2,2)*kd.1$se.fit[3] # 95% CI for KD95
                ),
      kd.2 = list(
              kd50.2=kd.2$fit[1], # point estimate for KD50
              kd50.ci.2=kd.2$fit[1]+c(-2,2)*kd.2$se.fit[1], # 95% CI for KD50
              kd90.2=kd.2$fit[2], # point estimate for KD90
              kd90.ci.2=kd.2$fit[2]+c(-2,2)*kd.2$se.fit[2], # 95% CI for KD90
              kd95.2=kd.2$fit[3], # point estimate for KD95
              kd95.ci.2=kd.2$fit[3]+c(-2,2)*kd.2$se.fit[3] # 95% CI for KD95
                ),
              mortality.1.abbott = mortality.1.abbott, # mortality for group 1 adjusted for mortality in the control group (if any)
              mortality.2.abbott = mortality.2.abbott, # mortality for group 2 adjusted for mortality in the control group (if any)
              p.value.survdiff = p.value.survdiff, # p-value for the difference in survival curves for group 1 vs. group 2
              resistance.status.1 = resistance.status.1, # WHO resistance status for group 1
              resistance.status.2 = resistance.status.2, # WHO resistance status for group 2
              pred.surv.times = pred.surv.times)) # data frame with the predicted survival times and standard errors for selected percentiles of mortality and by group (A=group 1; B=group 2)
}
