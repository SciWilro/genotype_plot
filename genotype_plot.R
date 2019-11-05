.libPaths("~/~R/library")## need to change to your R package library directory
return_genotype<-function(pedfile,marker){
  if (!require(ggplot2)) install.packages('ggplot2')## if not installed, install first
  library(ggplot2)
  ped<-read.table(paste(pedfile,'.ped',sep = ""),header = F)
  map<-read.table(paste(pedfile,".map",sep=""),header = F)
  markers<-read.table(paste(marker,sep=""),header=F)
  markers<-as.vector(markers[,1])
  map[,2]<-as.character(map[,2])
  plot_list<-list()
  for (i in 1:length(markers)) {
    index<-which(map[,2]==markers[i])
    genotype<-ped[,c(1:6,2*index+5,2*index+6)]
    genotype<-genotype[which(genotype[,7]!=0),]
    genotype<-genotype[which(genotype[,8]!=0),]
    genotype<-genotype[order(genotype[,6]),]
    genotype[,7]<-paste(genotype[,7],genotype[,8],sep = "")
    genotype<-genotype[,-8]
    colnames(genotype)<-c("group","ID","Dad","Mom","Sex","Affection","Genotype")
    genotype[which(genotype$Genotype=='TA'),7]<-'AT'
    genotype[which(genotype$Genotype=='CA'),7]<-'AC'
    genotype[which(genotype$Genotype=='GA'),7]<-'AG'
    genotype[which(genotype$Genotype=='CT'),7]<-'TC'
    genotype[which(genotype$Genotype=='CG'),7]<-'GC'
    genotype[which(genotype$Genotype=='TG'),7]<-'GT'
    genotype<-genotype[which(genotype$Genotype!="00"),]
    genotype$Affection<-as.character(genotype$Affection)
    p<-ggplot(data = genotype,aes(x=Affection,fill=Genotype))
    p<-p+geom_bar()
    p<-p+ggtitle(markers[i])
    plot_list[[i]]<-p
  }
  for (i in 1:length(markers)) {
    png(filename = paste(markers[i],'_geno.png',sep = ""),width = 1280,height = 720)
    print(plot_list[[i]])
    dev.off()
  }
}
if(!require(optparse)) install.packages('optparse')
library(optparse)
option_list<-list(
  make_option(c('-f','--file'),type = "character",default = NULL,help = "ped file prefix",
              metavar = 'character'),
  make_option(c('--snp'),type = "character",help = "snp list file",default = NULL)
)
opt_parser<-OptionParser(option_list = option_list)
opt<-parse_args(opt_parser)

return_genotype(pedfile = opt$file,marker = opt$snp)
