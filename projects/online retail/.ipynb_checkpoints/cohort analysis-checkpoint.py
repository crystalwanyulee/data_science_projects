# -*- coding: utf-8 -*-
"""
Created on Tue Mar 10 00:15:46 2020

@author: wanyu
"""

import pandas as pd
import os
os.chdir("C://Users/wanyu/Documents/Project/online retail")

online = pd.read_excel('Online Retail.xlsx')
online.head()

import matplotlib.pyplot as plt
import seaborn as sns


online.info()
online.UnitPrice.head()
online.Quantity.head()


first_buy = online.groupby(['CustomerID'])['InvoiceDate'].agg('min')
online = online.set_index('CustomerID')
online['cohort_year'] = first_buy.dt.year
online['cohort_month'] = first_buy.dt.month
online['cohort_day'] = first_buy.dt.day
online['cohort_index'] = ( (online.InvoiceDate.dt.year - online.cohort_year )*12
                         + (online.InvoiceDate.dt.month - online.cohort_month))


online['spending'] = online.Quantity*online.UnitPrice


online = online.reset_index()
online.head()

cohort_analysis = pd.pivot_table(data= online,
                                 index = ['cohort_year', 'cohort_month'],
                                 columns = ['cohort_index'],
                                 values = 'CustomerID',
                                 aggfunc = 'count')

cohort_analysis = cohort_analysis.div(cohort_analysis[0.0], axis = 0)

plt.figure(figsize=(16,10))
ax = sns.heatmap(cohort_analysis, cmap="YlGnBu", annot=True)

import numpy as np

cohort_analysis = pd.pivot_table(data= online.loc[online.cohort_year != 2010],
                                 index = ['cohort_year', 'cohort_month'],
                                 columns = ['cohort_index'],
                                 values = 'spending',
                                 aggfunc = np.sum)

plt.figure(figsize=(16,10))
ax = sns.heatmap(cohort_analysis, cmap="YlGnBu", annot=True)

