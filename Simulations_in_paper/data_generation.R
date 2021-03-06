# This code serves as generating the simulation data set. It includes Logistic Setting, Interaction Setting and Piecewise Linear Setting of binary and continuous secondary trait under random sample. It also gives the example of convenient sample and stratified sample.
# It includes a continuous covariates Z. (The covariates Z is deleted in simulations of type I error and power comparisons in the paper, to accelerate the computation of 100,000 simulations in each scenario.)




rm(list=ls()) 
set.seed(123) 
setwd(dir) # set workding directory to save the data. The data has to be saved, as the SPML is performed in a separete software requiring individual data set.
#---------------- Logistic Setting with Binary outcome -----------------#

# population of 500,000 subjects
n=500000 

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)


# generate the genetic variant X with MAF=0.3
x = rbinom(n,size=2,prob=0.3)

# generate the standardized continuous covariate Z correlated with X
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate the binary secondary trait Y
py=exp(-1+beta[1]*x+beta[2]*z)/(1+exp(-1+beta[1]*x+beta[2]*z))
y=rbinom(n,1, py)

# generate the primary disease D (alpha changes to make sure the disease prevalence =0.1 )
alpha= -2.88
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)))
d = rbinom(n,size=1,prob=pd)

# form the population dataset
dat = as.data.frame(cbind(d, y, z, x))

# generate 500 sample dataset from the population with 2000 cases and 2000 controls, and save the sample files
dat_cases = dat[which(dat$d==1),]
dat_controls= dat[which(dat$d==0),]


for (i in 1:500) {
	print(i)
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),2000, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0), 2000, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)	
	colnames(sample)=c("D", "y", "z","x")
	sample2=t(as.matrix(sample)) # data is tranformed to match the format of input file in SPML approach
	string=paste("/Bbasecase/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}



#-------------- Interaction Setting with Binary outcome ------------------#

rm(list=ls())

set.seed(716)
# population 
n=500000

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2), 0.2) #P(D|X,Y,Z)

# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)
cor(x, z)

# generate Y
py=exp(-1+beta[1]*x+beta[2]*z)/(1+exp(-1+beta[1]*x+beta[2]*z))
y=rbinom(n,1, py)

# generate D
alpha= -2.96
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+x*y*0.2) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+x*y*0.2))
d = rbinom(n,size=1,prob=pd)

# population dataset
dat = as.data.frame(cbind(d, y, z, x))
colnames(dat)<-c("d", "y", "z", "x")
dat_cases = dat[which(dat$d==1),]
dat_controls= dat[which(dat$d==0),]

# generate 500 sample dataset
for (i in 1:500) {
	print(i)
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),500, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0),500, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)	
	colnames(sample)=c("D", "y", "z","x")
	sample2=t(as.matrix(sample))
	string=paste("/Binteraction/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}

#------------- Piecewise linear Setting with Binary outcome  ------------#

rm(list=ls())
set.seed(314)
# population 
n=500000

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)

# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate Y
py=exp(-1+beta[1]*x+beta[2]*z)/(1+exp(-1+beta[1]*x+beta[2]*z))
y=rbinom(n,1, py)
mean(y)

# generate D
temp=0.3*x+log(2)*y+log(2)*z
qt=quantile(temp)
pd=ifelse(temp<qt[2], 0.05, ifelse(temp<qt[4], (temp-qt[2])/(qt[4]-qt[2])*0.1+0.05, 0.15))
mean(pd)
d=rbinom(n, 1, pd)
dat=as.data.frame(cbind(d, y, z, x))

# generate 500 sample dataset 
dat_cases = dat[which(dat$d==1),]
dat_controls= dat[which(dat$d==0),]
for (i in 1:500) {
	print(i)
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),500, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0),500, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)
	colnames(sample)=c("D", "y", "z","x")
	sample2=t(as.matrix(sample))
	string=paste("/Bpiecewise/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}

#------------- Logistic Setting with continous outcome ------------------#

rm(list=ls())

# population 
set.seed(512)
n=500000

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)

# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate Y
y=1+beta[1]*x+beta[2]*z+rnorm(n)

# generate disease status D
alpha= -3.62
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)))
d = rbinom(n,size=1,prob=pd)

dat=as.data.frame(cbind(d, y, z, x))

# generate 500 sample dataset 
for (i in 1:500) {
	print(c(i))
	dat_cases = dat[which(dat$d==1),]
	dat_controls= dat[which(dat$d==0),]
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),500, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0),500, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)
	colnames(sample)=c("D", "y", "z","x")
	sample2=t(as.matrix(sample))
	string=paste("/Cbasecase/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}



#-------------- Interaction Setting with continous outcome ----------------#

rm(list=ls())

# population 
n=500000
set.seed(513)

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)

# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate Y
y=1+beta[1]*x+beta[2]*z+rnorm(n)

# generate disease status D
alpha= -3.93
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+x*y*0.2) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+x*y*0.2))
d = rbinom(n,size=1,prob=pd)


dat=as.data.frame(cbind(d, y, z, x))

# generate 500 sample dataset 
dat_cases = dat[which(dat$d==1),]
dat_controls= dat[which(dat$d==0),]
for (i in 1:500) {
	print(c(i))
	dat_cases = dat[which(dat$d==1),]
	dat_controls= dat[which(dat$d==0),]
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),500, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0),500, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)
	colnames(sample)=c("D", "y", "z","x")
	sample2=t(as.matrix(sample))
	string=paste("/Cinteraction/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}



#---------- Piecewise Linear Setting with continous outcome --------------#

rm(list=ls())
set.seed(514)
# population 
n=500000

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)

# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate Y
y=1+beta[1]*x-0.1*z+1*rnorm(n)


# generate disease status D
temp=0.3*x+log(2)*y+log(2)*z
qt=quantile(temp)
pd=ifelse(temp<qt[2], 0.05, ifelse(temp<qt[4], (temp-qt[2])/(qt[4]-qt[2])*0.1+0.05, 0.15))
d=rbinom(n, 1, pd)

dat=as.data.frame(cbind(d, y, z, x))

# generate 500 sample dataset 
dat_cases = dat[which(dat$d==1),]
dat_controls= dat[which(dat$d==0),]

for (i in 1:500) {
	print(c(i))
	dat_cases = dat[which(dat$d==1),]
	dat_controls= dat[which(dat$d==0),]
	dat_cases_sample = dat_cases[sample(sum(dat$d==1),500, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0),500, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)
	sample2=t(as.matrix(sample))
	string=paste("/Cpiecewise/input", i, ".txt", sep="")
	write.table(sample2, string, col.names=F, row.names=F)
}




#-------- (Example of convenient sampling scheme: Bbasecase with unmeasured confounding factor) --------#
#set.seed(123)
set.seed(127)
#set.seed(521)
# population 
n=500000 #(500,000)

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)
# generate X
x = rbinom(n,size=2,prob=0.3)

# generate Z
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# generate Y
py=exp(-1+beta[1]*x+beta[2]*z)/(1+exp(-1+beta[1]*x+beta[2]*z))
y=rbinom(n,1, py)

# generate the unmeasured counfounding factor v
alpha=-1
pv = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)))
v=rbinom(n, 1, pv)

# generate D
alpha = -2.88 #basecase
#alpha=-2.95 # interaction
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2))) # basecase
#pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+0.2*x*y) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)+0.2*x*y)) # interaction
#temp=0.3*x+log(2)*y+log(2)*z #piecewsie
#qt=quantile(temp)
#pd=ifelse(temp<qt[2], 0.05, ifelse(temp<qt[4], (temp-qt[2])/(qt[4]-qt[2])*0.1+0.05, 0.15))
d=rbinom(n, 1, pd)

# population data
dat=as.data.frame(cbind(d, y, z, x, v))

# 500 samples
dat_cases = dat[which(dat$d==1 & dat$v==1),]
dat_controls= dat[which(dat$d==0 & dat$v==1),]
for (i in 1:500) {
	print(i)
	dat_cases_sample = dat_cases[sample(sum(dat$d==1 & dat$v==1),2000, replace=F),]
	dat_controls_sample = dat_controls[sample(sum(dat$d==0 & dat$v==1),2000, replace=F),]
	sample=rbind(dat_cases_sample,dat_controls_sample)
	colnames(sample)[1]=c("D")
	sample=sample[,c("D", "y", "z", "x" )]
	# sample2=t(as.matrix(sample))	
	write.table(sample2, file=paste("CBpiecewise/", i, ".txt", sep=""), col.names=F, row.names=F)
	
}


#-------- (Example of stratified sampling scheme: Bbasecase with oversample obs) --------#
# population size 
n=500000 #(500,000)

# parameters
beta=c(0.2, 0.1) # P(Y|X,Z)
gamma=c(0.3, log(2), log(2)) #P(D|X,Y,Z)


# generate X -- genetic marker (additive model)
x = rbinom(n,size=2,prob=0.3)

# generate Z -- covariate
z=rnorm(n, mean=0.5*x-0.3, sd=1)

# weights 
w=rnorm(n)

# generate Y -- secondary outcome 
py=exp(-1+beta[1]*x+beta[2]*z)/(1+exp(-1+beta[1]*x+beta[2]*z))
y=rbinom(n,1, py)

# generate d -- primary disease
alpha= -2.88
pd = exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)) / (1+exp(alpha+ x*gamma[1] + y*log(2)+ z*log(2)))
d = rbinom(n,size=1,prob=pd)
mean(pd)

# population dataset
dat = as.data.frame(cbind(d, y, z, x, w))


# generate 500 Monta-Carlo dataset with 2000 cases and 2000 controls from the population
dat_cases1 = dat[which(dat$d==1 & dat$w>0),]
dat_cases2 = dat[which(dat$d==1 & dat$w<0),]
dat_controls1= dat[which(dat$d==0 & dat$w>0),]
dat_controls2= dat[which(dat$d==0 & dat$w<0),]

for (i in 1:500) {
	print(c(i))
	dat_cases_sample1 = dat_cases1[sample(sum(dat$d==1 & dat$w>0),1800, replace=F),]
	dat_cases_sample2 = dat_cases2[sample(sum(dat$d==1 & dat$w<0),200, replace=F),]
	dat_controls_sample1 = dat_controls1[sample(sum(dat$d==0 & dat$w>0),1800, replace=F),]
	dat_controls_sample2 = dat_controls2[sample(sum(dat$d==0 & dat$w<0),200, replace=F),]

	sample= as.matrix(rbind(dat_cases_sample1,dat_cases_sample2,dat_controls_sample1,dat_controls_sample2))
	sample1=sample[, 1:4]
	sample2=t(sample)
	sample3=t(sample1)
	string1=paste("WBbasecase/input", i, ".txt", sep="")
	string2=paste("WBbasecase/input_w", i, ".txt", sep="")
	write.table(sample2, string2, col.names=F, row.names=F)
	write.table(sample3, string1, col.names=F, row.names=F)

}
