
# coding: utf-8

# In[11]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt, mpld3
import math
from datetime import datetime
import seaborn as sns
from time import gmtime, strftime


# In[2]:



#Lets create heatmap for purchases with regards to day of week and hours
"""day_hours=data[['weekday','hour']]
day_hours_freq = day_hours.groupby('weekday')['hour'].value_counts().reset_index(name='count')
#day_hours_freq
days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
day_hours_freq['weekday'] = pd.Categorical(day_hours_freq['weekday'], categories=days, ordered=True)
day_hours_freq=day_hours_freq.sort_values(["weekday","hour"])
day_hours_freq=day_hours_freq.pivot("weekday",'hour','count')
print(day_hours_freq)"""


# In[23]:


def generate_heatmap_seller(seller,prod_cat_i):
    data = pd.read_csv('../FeatureEng/data_under_observation_count1.csv')
    ## Create new columns for day,time:
    data['weekday']=pd.to_datetime(data['order_purchase_timestamp']).dt.weekday_name
    data['hour']=pd.to_datetime(data['order_purchase_timestamp']).dt.hour
    data_filtered=data[data['seller_id']==seller]
    i=prod_cat_i
    if(len(data_filtered)==0):
        print("Sorry!!!! Not much information about this seller at this moment. Try some other seller")
    else:
        prod_cat=list(set(data_filtered['product_category_name_english']))
        if(i in prod_cat):
            day_hours=data_filtered[data_filtered['product_category_name_english']==i][['weekday','hour']]
            day_hours_freq = day_hours.groupby('weekday')['hour'].value_counts().reset_index(name='count')
            days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            day_hours_freq['weekday'] = pd.Categorical(day_hours_freq['weekday'], categories=days, ordered=True)
            day_hours_freq=day_hours_freq.sort_values(["weekday","hour"])
            day_hours_freq=day_hours_freq.pivot("weekday",'hour','count')

            #HeatMap with respect to sellers and their product category
            plt.clf()
            plt.figure(figsize=(10,5))
            fig, ax = plt.subplots()
            fig.set_size_inches(10.5, 6.5)
            ax=sns.heatmap(day_hours_freq,annot=True,cmap="OrRd")
            ax.set_xlabel("Hour")
            ax.set_ylabel("Day")
            ax.set_title("Heatmap of tranactions over the hour by day for %s for category %s"%(seller,i),size=10)
            dat=strftime("%Y-%m-%d%H:%M", gmtime())
            filename='static/heatmap_%s.png'%str(dat)
            print(filename)
            plt.savefig(filename)
            #mpld3.save_html(fig, 'templates/interactive_fig.html')
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")                                                                                                                                                                                                                                                                                                                                                                                                                  
# In[6]:


"""#General HeatMap irrespective of sellers or products

plt.figure(figsize=(15,8))
ax=sns.heatmap(day_hours_freq,annot=True,fmt="d",cmap="OrRd")
ax.set_xlabel("Hour")
ax.set_ylabel("Day")
ax.set_title("Heatmap of tranactions over the hour by day",size=10)"""


# In[28]:


#Analysing the reviews
def check_reviews(seller,prod_cat_i):
    data = pd.read_csv('../FeatureEng/data_under_observation_count1.csv')
    ## Create new columns for day,time:
    data['weekday']=pd.to_datetime(data['order_purchase_timestamp']).dt.weekday_name
    data['hour']=pd.to_datetime(data['order_purchase_timestamp']).dt.hour
    data['year_month'] = pd.to_datetime(data['order_purchase_timestamp']).dt.to_period('M')
    i=prod_cat_i
    data_filtered=data[data['seller_id']==seller]
    if(len(data_filtered)==0):
        print("Sorry!!!! Not much information about this seller at this moment. Try some other seller")
    else:
        prod_cat=list(set(data_filtered['product_category_name_english']))
        if(i in prod_cat):
            data_prod=data_filtered[data_filtered['product_category_name_english']==i]
            reviews_timeseries = data_prod.groupby('year_month')['review_score'].agg(['count', 'mean'])
            #print(reviews_timeseries.index)
            ax = sns.lineplot(
            x=reviews_timeseries.index.to_timestamp(), 
            y='count', 
            data=reviews_timeseries, 
            color='#984ea3', 
            label='count'
            )
            plt.clf()
            #plt.figure(figsize=(10,5))
            plt.title("%s for category %s"%(seller,i))
            sns.lineplot(
                x=reviews_timeseries.index.to_timestamp(),
                y='mean',
                data=reviews_timeseries, 
                ax=ax.twinx(), 
                color='#ff7f00', 
                label='mean'
            ).set(ylabel='Average Review Score');
            plt.savefig('static/reviewscore.png')
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")
# In[8]:

def cumReviewSale(seller,prod_cat_i):
    data = pd.read_csv('../FeatureEng/data_under_observation_count.csv')
    ## Create new columns for day,time:
    data['weekday']=pd.to_datetime(data['order_purchase_timestamp']).dt.weekday_name
    data['hour']=pd.to_datetime(data['order_purchase_timestamp']).dt.hour
    data['year_month'] = pd.to_datetime(data['order_purchase_timestamp']).dt.to_period('M')
    i=prod_cat_i
    data_filtered=data[data['seller_id']==seller]
    if(len(data_filtered)==0):
        print("Sorry!!!! Not much information about this seller at this moment. Try some other seller")
    else:
        prod_cat=list(set(data_filtered['product_category_name_english']))
        if(i in prod_cat):
            print(i)
            #Selecting each Product categories of the given seller
            data=data_filtered[data_filtered['product_category_name_english']==i]
            #print(data)
            reviews_timeseries = data.groupby('year_month',as_index=True)['review_score'].agg(['count', 'sum'])
            df_review=reviews_timeseries.cumsum().reset_index()
            df_review['sum']=df_review['sum']/df_review['count']
            df_review.set_index(df_review['year_month'])
            plt.clf()
            fig, ax = plt.subplots()
            
            plt.title("%s for category %s"%(seller,i))
            x= np.arange(0,len(df_review),1)
            ax.bar(x,df_review['count'])
            ax.set_xticks(x)
            ax.set_xticklabels(df_review.index,rotation="vertical")
            ax2=ax.twinx()
            ax2.plot(ax.get_xticks(),df_review['sum'])
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")


# In[6]:


def diffReviewSale(seller,prod_cat_i):
    data = pd.read_csv('../FeatureEng/data_under_observation_count1.csv')
    ## Create new columns for day,time:
    data['weekday']=pd.to_datetime(data['order_purchase_timestamp']).dt.weekday_name
    data['hour']=pd.to_datetime(data['order_purchase_timestamp']).dt.hour
    data['year_month'] = pd.to_datetime(data['order_purchase_timestamp']).dt.to_period('M')
    data_filtered=data[data['seller_id']==seller]
    i=prod_cat_i
    if(len(data_filtered)==0):
        print("Sorry!!!! Not much information about this seller at this moment. Try some other seller")
    else:
        prod_cat=list(set(data_filtered['product_category_name_english']))
        if(i in prod_cat):
            print(i)
            #Selecting each Product categories of the given seller
            data=data_filtered[data_filtered['product_category_name_english']==i]
            #print(data)
            reviews_timeseries = data.groupby('year_month',as_index=True)['review_score'].agg(['count', 'sum'])            
            #Find the difference in sale with respect to each month
            reviews_timeseries['diff_sale']=reviews_timeseries['count'].diff(1)
            #print("Reviews timeseries",reviews_timeseries)            
            df_review=reviews_timeseries.reset_index()
            df_review['sum']=df_review['sum']/df_review['count']
            df_review.set_index(df_review['year_month'], inplace=True, drop=True)
            #print(df_review.index)
            plt.clf()
            fig, ax = plt.subplots()
            fig.set_size_inches(10.5, 6.5)
            plt.title("%s for category %s"%(seller,i))
            x= np.arange(0,len(df_review),1)
            ax.bar(x,df_review['diff_sale'])
            ax.set_xticks(x)
            ax.set_xticklabels(df_review.index,rotation="vertical")
            ax2=ax.twinx()
            ax2.plot(ax.get_xticks(),df_review['sum'])
            dat=strftime("%Y-%m-%d%H:%M", gmtime())
            filename='static/reviewscore_dif%s.png'%str(dat) 
            plt.savefig(filename)
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")


# In[24]:


#print("Heat Map")
#generate_heatmap_seller('1f50f920176fa81dab994f9023523100','garden_tools')


# In[29]:


#print("Reviews")
#check_reviews('289cdb325fb7e7f891c38608bf9e0962','perfumery')


# In[60]:


#data.head()
#cumReviewSale('289cdb325fb7e7f891c38608bf9e0962','perfumery')


# In[61]:


#diffReviewSale('289cdb325fb7e7f891c38608bf9e0962','perfumery')


# In[63]:


#print(pd.to_datetime(data['order_purchase_timestamp']).dt.date)


# In[59]:


def salePattern(seller,prod_cat_i):
    
    holidays = pd.DataFrame({'holiday': 'days_of_interest','ds': pd.to_datetime(['2017-01-01','2017-02-27','2017-02-28',
    '2017-03-01','2017-04-14','2017-04-21','2017-05-01','2017-05-15','2017-07-09','2017-09-07','2017-10-12','2017-10-27',
    '2017-11-01','2017-11-02','2017-11-15','2017-11-20','2017-11-24','2017-12-25','2018-01-01','2018-02-27','2018-02-28',
    '2018-03-01','2018-04-14','2018-04-21','2018-05-01','2018-05-15','2018-07-09']),
  'lower_window': -1,
  'upper_window': 1,
})
    listHolidays=holidays['ds']
    data = pd.read_csv('../FeatureEng/data_under_observation_count1.csv')
    ## Create new columns for day,time:
    data['date_purchase']=pd.to_datetime(data['order_purchase_timestamp']).dt.date
    data_filtered=data[data['seller_id']==seller]
    i=prod_cat_i
    if(len(data_filtered)==0):
        print("Sorry!!!! Not much information about this seller at this moment. Try some other seller")
    else:
        prod_cat=list(set(data_filtered['product_category_name_english']))
        #fig=plt.figure(figsize=(10,10))
        if(i in prod_cat):
            print(i)
            #Selecting Product categories of the given seller
            data=data_filtered[data_filtered['product_category_name_english']==i]
            #print(data)
            reviews_timeseries = data.groupby('date_purchase',as_index=True)['customer_id'].agg(['count'])            
            #Find the count in sale with respect to each date
            """print("Reviews timeseries",reviews_timeseries)"""            
            df_review=reviews_timeseries.reset_index()
            df_review_holidays=df_review[pd.to_datetime(df_review['date_purchase']).isin(listHolidays)]
            y_pos = np.arange(len(df_review_holidays))
            #print(df_review['date_purchase'])
            df_review_holidays.set_index(df_review_holidays['date_purchase'], inplace=True, drop=True)
            #print(df_review[pd.to_datetime(df_review['date_purchase']).isin(listHolidays)])
            #fig,ax = plt.subplots()
            fig = plt.figure(figsize=(5, 5))
            ax = fig.add_subplot(111)
            plt.title("%s for category %s"%(seller,i))
            df_review.sort_values(by=['count'],ascending=False, inplace=True)
            #print(df_review)
            #print(df_review_holidays)
            ax.barh(y_pos,df_review_holidays['count'])
            ax.set_yticks(y_pos)
            ax.set_yticklabels(df_review_holidays.index)
            
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")


# In[60]:


#salePattern('16090f2ca825584b5a147ab24aa30c86','auto')

