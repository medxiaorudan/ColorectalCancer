#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# ------------------------------------------------------------------------------------
#option(encoding="UTF-8")
options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(data.table)
library(tools)
library(datasets)
library(shinythemes)

shinyServer(function(input, output,session){
  score<- reactive({
    inFile<-input$filename
    if(is.null(inFile))
      return(NULL)
    loaddata<-read.table(inFile$datapath, sep="\t", stringsAsFactors = F)
    tabdata<-vcf2tab(loaddata)
    scoredata<-version3(tabdata)
    return(scoredata)
  })
  output$plot <- renderPlot({
    sdata<-score()
    d1000<-read.table("D:/ColorectalCancer/data/1000Genome_ColorectalCancer.txt",head=T,sep="\t",stringsAsFactors = F)
    library(RColorBrewer)
    selectdata<-sdata[1,c("Sum(OR)")]
    de1000<-density(log(d1000[,2]))
    if(min(de1000$x)<0){x1000<-(de1000$x+abs(min(de1000$x)))}else{
      x1000<-(de1000$x-min(de1000$x))
    }
    pdex1000<-x1000*(dim(d1000)[1])/max(x1000)-0.5
    pdey1000<-de1000$y*(dim(d1000)[1])/max(x1000)
    ymax<-round(max(pdey1000)/100)*100
    barplot(rep(-0.4*(ymax/3),dim(d1000)[1]),col=colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlGn")))(dim(d1000)[1]),
            ylim=c(-ymax/4,ymax+100),axes=F,border=NA,space=0,width=rep(1,dim(d1000)[1]),xlim=c(0,3000))
    points(pdex1000,pdey1000,type="l",col="#32CD32",lwd=2)
    if(!is.null(selectdata)){
      if(selectdata!=0){
      points(which.min(abs(sort(d1000[,2])-selectdata))[1]-0.5,-0.8*(ymax/3),pch=17,cex=4,col="deepskyblue2")
      }
    }
    text(dim(d1000)[1]/2,ymax+70,"Density Curve of Population Genetic Risk",cex=2)
    legend(2000,ymax+50,c("1000 Genome"),bty="n",lty=1,col=c("#32CD32"),lwd=3)

    
  })
  output$or <- renderText({
  calc.or <- reactive({
    sdata<-score()	
    sdata[,25]
  })
  calc.or()
})        
  output$score2 <- renderText({
score.score <- reactive({
  sdata<-score()	
  d1000<-read.table("D:/ColorectalCancer/data/1000Genome_ColorectalCancer.txt",head=T,sep="\t",stringsAsFactors = F)
  selectdata<-sdata[1,25]
  dim(d1000)[1]-which.min(abs(sort(d1000[,2])-selectdata))[1]
})
score.score()
})   
  output$range <- renderText({
    calc.range <- reactive({
      sdata<-score()
      selectdata<-sdata[1,c("Sum(OR)")]
      if(!is.null(selectdata)){
        if(selectdata==0){print("VCF文件未包含结直肠癌相关位点")}else{
        d1000<-read.table("D:/ColorectalCancer/data/1000Genome_ColorectalCancer.txt",header=TRUE,sep="\t",stringsAsFactors = F)
        score2=(which.min(abs(sort(d1000[,2])-selectdata))[1]-0.5)/dim(d1000)[1]
        if(!is.na(score2)){
        if(score2<0.05){print("较低")}else if(score2>0.95){print("偏高")}else{print("处于正常范围")}
   }
  }
}
         
        })
    calc.range()
  })
  
  
})

version3<-function(tabdata){
  version3database<-read.table("D:/ColorectalCancer/data/ColorectalCancer.txt",head=T,sep="\t",stringsAsFactors = F)
  cg<-c("C","G")
  at<-c("A","T")
  
  for(i in 1:length(sort(unique(version3database$Disease)))){
  data<-merge(version3database,tabdata,by.x="RSID",by.y="dbSNP")
  
  
   if(dim(data)[1]==0){next}
    unlink<-data[data$LD==0,]
    link<-data[data$LD!=0,]
    deallinkdata<-c()
    numlink<-sort(unique(link$LD))
    for(j in 1:length(numlink)){
      numlinkdata<-link[link$LD==numlink[j],]
      deallinkdata<-rbind(deallinkdata,numlinkdata[which.min(numlinkdata$Pvalue),])
    }
    data<-rbind(unlink,deallinkdata)
    }
  
  delindex<-c()
  if(dim(data)[1]!=0){
    for(l in 1:dim(data)[1]){
      if(substr(data[l,17],0,1)=="."){delindex<-c(delindex,l)}
    }
  }
  if(length(delindex)>0){data<-data[-delindex,]}
  num<-c()
  if(dim(data)[1]!=0){
    for(kk in 1:dim(data)[1]){
      if(sum(as.numeric(unlist(strsplit(data[kk,17],"/"))))==1){num<-c(num,1)}else{
        if(substr(data[kk,18],0,1) %in% cg & data[kk,3] %in% cg){
          num<-c(num,2);next
        }
        if(substr(data[kk,18],0,1) %in% at & data[kk,3] %in% at){
          num<-c(num,2);next
        }
        if(substr(data[kk,18],0,1) %in% at & data[kk,3] %in% cg){
          num<-c(num,0);next
        }
        if(substr(data[kk,18],0,1) %in% cg & data[kk,3] %in% at){
          num<-c(num,0);next
        }
      }
    }}
  if(dim(data)[1]==0){
    data[1,24]=0
    data[1,25]=0
    data[1,26]=0
    colnames(data)[24]<-c("Effect_allele_num")
    colnames(data)[25]<-c("Allele_OR")
    colnames(data)[26]<-c("Sum(OR)")
  }else{
    data<-cbind(data,num)
    colnames(data)[24]<-c("Effect_allele_num")
    
    data<-cbind(data,data[,6]^num)
    colnames(data)[25]<-c("Allele_OR")
    
    data<-cbind(data,round(exp(sum(data[,7]*data[,25])),4))
    colnames(data)[26]<-c("Sum(OR)")
    
  }
  return(data)
}
vcf2tab <- function(vcf){
  x <- vcf
  CHROM <- as.character(x$V1)
  POS <- x$V2
  REF <- x$V4
  ALT <- x$V5
  info <- x$V10
  GT1 <- substr(info,1,3)
  GT2 <- ""
  database4<-read.table("D:/ColorectalCancer/data/ColorectalCancer.txt",head=T,sep="\t",stringsAsFactors = F)
  DP <- ""
  AD <- ""
  PL <- ""
  dbSNP <- ""
  AC <- ""
  MAF <- ""
  x[,11]<-paste(x[,1],x[,2],sep="_")
  database4[,12]<-paste(database4$Chr,database4$Pos,sep="_")
  for(i in 1:dim(x)[1]){
    if(length(which(database4[,12]==x[i,11]))==0){dbSNP[i]<-""}else{
      dbSNP[i] <- database4[which(database4[,12]==x[i,11]),1]
    }
    CHROM[i] <- gsub("chr","",CHROM[i])
    base<-unlist(strsplit(as.character(ALT[i]),",", fixed = TRUE))
    base1<-base[1]
    base2<-base[2]
    if(GT1[i] == "0/0"){GT2[i]<-paste(REF[i],REF[i],sep="/")
    }else if (GT1[i]=="0/1"){
      GT2[i]<-paste(REF[i],base[1],sep="/")
    }else if (GT1[i]=="0/2"){
      GT2[i]<-paste(REF[i],base[2],sep="/")
    }else if (GT1[i]=="1/1"){
      GT2[i]<-paste(base[1],base[1],sep="/")
    }else if (GT1[i]=="1/2"){
      GT2[i]<-paste(base[1],base[2],sep="/")
    }else if (GT1[i]=="2/2"){
      GT2[i]<-paste(base[2],base[2],sep="/")
    }

  }
  w<-cbind.data.frame(CHROM,POS,REF,ALT,GT1,GT2,DP,AD,PL,dbSNP,MAF,AC,stringsAsFactors=F)
  return(w)
}
