##read ped and map file
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
import sys

def read_ped_map(ped_prefix,marker):
	print(ped_prefix+'.ped')
	ped = pd.read_csv(ped_prefix+'.ped',sep=" ",header=None)
	map = pd.read_csv(ped_prefix+'.map',sep="\t",header=None)
	test=open(marker,'r')
	snps=test.read().splitlines()
	for i in snps:
		index = map.loc[map[1]==i].index[0]
		print(index)
		allele1_index=2*index-1
		allele2_index=2*index
		allele1=ped.loc[:,[allele1_index]]
		allele2=ped.loc[:,[allele2_index]]
		genotype=ped.loc[:,[0,1,2,3,4,5,allele1_index,allele2_index]]
		genotype.columns=['group','ID','sire','dam','sex','affection','allele1','allele2']
		genotype['Geno']=genotype['allele1']+genotype['allele2']
		genotype.loc[genotype['Geno']=='GA',['Geno']]='AG'
		genotype.loc[genotype['Geno']=='CA',['Geno']]='AC'
		genotype.loc[genotype['Geno']=='TA',['Geno']]='AT'
		genotype.loc[genotype['Geno']=='CT',['Geno']]='TC'
		genotype.loc[genotype['Geno']=='GT',['Geno']]='TG'
		genotype.loc[genotype['Geno']=='GC',['Geno']]='CG'
		plt.ioff()#turn interative plotting off
		genotype.groupby(['affection','Geno']).size().unstack().plot(kind='bar',stacked=True)
		plt.title('i')
		plt.savefig(i+'.png')
		plt.close()

import argparse

ap = argparse.ArgumentParser()
ap.add_argument('-file',required=True,help='prefix of the plink ped file')
ap.add_argument('-snp',required=True,help='full name of the file containing all the snps want to test')
args = vars(ap.parse_args())

read_ped_map(ped_prefix=args['file'],marker=args['snp'])
