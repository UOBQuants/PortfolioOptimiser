#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 23 08:50:07 2017

@author: ashley Robertson

@Software: Spyder
"""
from Google_Stock import *
import os
import shutil
import pandas as pd
import time
from datetime import date
import inspect, os
import numpy as np

Dates = pd.read_csv('dates.csv')

############## INSERT INPUT VARIABLES ####################
ID = 'NYSEARCA:IWV'
file = 'russell3000.csv'
start_date = (Dates.iloc[0][0],Dates.iloc[0][1],Dates.iloc[0][2])
end_date = (Dates.iloc[1][0],Dates.iloc[1][1],Dates.iloc[1][2])
#########################################################
Market = google_stocks('NYSEARCA:IWV', start_date, end_date)
Market = Market[['Date', 'Close']]
Nreturn = Market['Close']

for i in range(0,Market.shape[0]-1):
    today = Market.loc[i][1]
    yesterday = Market.iloc[i+1][1]
    frac = (today/yesterday)
    Nreturn.set_value(i, frac-1)
    
Nreturn.set_value(Market.shape[0]-1, 0)

Market['return'] = Nreturn
Market = Market[['Date', 'return']]
Market.to_csv('Russell3000R.csv')