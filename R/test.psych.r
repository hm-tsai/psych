"test.psych" <- 
function(first=1,last=5,short=TRUE) {  
s1 <- USArrests         #  Violent Crime Rates by US State  (4 variables)
s2 <- attitude          #The Chatterjee-Price Attitude Data
s3 <- Harman23.cor$cov     #   Harman Example 2.3 8 physical measurements
s4 <- Harman74.cor$cov     #   Harman Example 7.4  24 mental measurements
s5 <- ability.cov$cov       #  6 Ability and Intelligence Tests 

#convert covariance to correlation
d5 <- diag(1/sqrt(diag(s5)))
s5 <- d5 %*% s5 %*% d5

datasets <- list(s1,s2,s3,s4,s5)
out <- list()

for (i in first:last) {
   test.data <- datasets[[i]]
	pc <-   principal(test.data)
	pc2 <-    principal(test.data,2)
	if(i < 3) {
			fa2 <- factor.pa(test.data,2)
			fp <-    fa.parallel(test.data)
			vss2 <- VSS(test.data)
			vsspc <- VSS(test.data,pc="pc")
		} else {
			fa2 <- factor.pa(test.data,2,n.obs=200)
			cluster.plot(fa2)
			fp <-    fa.parallel(test.data,n.obs=200)
			vss2 <- VSS(test.data,n.obs=200)
			vsspc <- VSS(test.data,pc="pc",n.obs=200)
			

			}


	ic <-   ICLUST(test.data,plot=FALSE)
	if(require(GPArotation)) {om <-  omega(test.data,plot=FALSE)} else {warning("Omega requires the GPArotation package to be loaded")
	  om <- NULL}
	fc <- factor.congruence(pc2,fa2)
	
	d <- describe(test.data)
	
	keys <- matrix(rep(0,dim(test.data)[2]*2),ncol=2)
	keys[,1] <- 1
	keys[1:3,2] <- 1
	if( dim(test.data)[1] != dim(test.data)[2]) {test.score <- score.items(keys,test.data)} else {test.score <- cluster.cor(keys,test.data)}
	
	out <- list(out,paste("test",i),pc,pc2,fa2,fp,ic,om,fc,vss2,vsspc,d,test.score)
  } #end loop
    #a few more tests
  
  simple <- sim.item(nvar=24)
  circ <-  sim.circ(nvar=24)
  simple.par <- fa.parallel(simple)
  fa.simple <- factor.pa(simple,2)
  fa.simple.keys <- ICLUST.sort(fa.simple,keys=TRUE)
 
 simple.scores <-  score.items(fa.simple.keys$clusters,simple)
  pairs.panels(simple.scores$scores)
   f4 <- sim.VSS()
    psych.d <- NULL 
  #the next test, phi.demo, throws multiple warnings that are from the polycor package and can not be found
  #if (!require(polycor)) { warning("psycho.demo requires the polycor package")  psych.d <- NULL  } else  {psych.d <- phi.demo() } 
  cong <- sim.congeneric()
  

   
   cluster.plot(factor.pa(sim.circ(nvar=24),nf=2),title="two circumplex factors")
 pairs.panels(cong) 
 #this section tests various functions that use Rgraphviz (if it is installed) 
 if(require(Rgraphviz)) { fa.graph(factor.pa(item.sim(16),2) ,title="Principal factor of a simple structure") 
  	ic.out <- ICLUST(s4,title="ICLUST of 24 Mental abilities")
  	jen <-  omega(sim.hierarchical(),title="Omega with Schmid Leihman")
  	omega.graph(jen,sl=FALSE,title="Omega with hierarchical factors")
  	   #set up the parameters for the structure graph
		X6 <- matrix(c("a","b","c",rep(0,6),"d","e","f"),nrow=6)
		colnames(X6) <- c("L1","L2")
		rownames(X6) <- c("x1","x2","x3","x4","x5","x6")
		Y3 <- matrix(c("u","w","z"),ncol=1)
		colnames(Y3) <- "Y"
		rownames(Y3) <- c("y1","y2","y3")
		phi21 <- matrix(c(1,0,"r1",0,1,"r2",0,0,1),ncol=3)
		colnames(phi21) <- rownames(phi21) <-  c("L1","L2","Y")
	structure.graph(X6,phi21,Y3,title="Symbolic structural model")

 } else {warning("fa.graph, omega.graph, ICLUST.rgraph, structure.graph require Rgraphviz") }
  
  out <- list(out,fa.simple,psych.d)
 if (!short) { return(out)}

}#end function
