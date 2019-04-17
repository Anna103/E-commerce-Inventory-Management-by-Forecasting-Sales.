
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import math


# In[3]:


import matplotlib.image as mpimg


# In[4]:


data = pd.read_csv('../FeatureEng/seller_prd_customer.csv')
data.head()


# In[5]:


data.info()


# In[6]:


#missing values count
print('missing values count')
print(111023-111009)
print(111023-109868)
print(111023-108637)

print('\nmissing values percentage')
#missing value percentage
print((111023-111009)/111023,'%')
print((111023-109868)/111023,'%')
print((111023-108637)/111023,'%')


# In[7]:


data.describe()


# In[8]:


data = data.drop(columns = ['Unnamed: 0'])


# In[9]:


data.head()


# In[10]:


data.order_status.unique()


# In[11]:


data['order_status'].value_counts()


# In[12]:


len(data.order_id.unique())


# In[13]:


data['order_id'].value_counts().head(50)


# In[14]:


data['customer_id'].value_counts().head(50)


# In[15]:


data.order_item_id.unique()


# In[16]:


data['order_item_id'].value_counts()


# In[17]:


product_cat = list(data.product_category_name_english.unique())
product_cat


# In[18]:


data.product_category_name_english.value_counts()


# In[19]:


data['customer_city'].value_counts()


# In[20]:


data['customer_state'].value_counts()


# In[21]:


len(data.seller_id.unique())


# In[22]:


list_count = data['seller_id'].value_counts()
list_count


# In[23]:


from collections import Counter

#print(list_count.head(197))
count = Counter()
for i in list_count:
    count[i]+=1
    
print(sorted(count.items(), key=lambda pair: pair[1]))
list_names = data['seller_id'].value_counts()>=120
seller_id_final = list_names.keys()
seller_id_final = seller_id_final[:196]
print(seller_id_final)


# In[24]:


data_new = data.loc[data['seller_id'].isin(seller_id_final)]
data_new.info()


# In[25]:


data_seller = data_new.groupby('seller_id')['product_category_name_english'].value_counts()
data_seller_df = pd.DataFrame(data=data_seller)
column = ['seller_id','product_category','sales/category per seller']
data_seller_df.rename(columns={'seller_id':'seller_id','product_category_name_english':'product_category','product_category_name_english':'sales/category per seller'},inplace=True)
data_seller_df.head(50)


# In[26]:


data_new.groupby('seller_id')['product_category_name_english'].value_counts().sort_values(ascending=False).head(20)


# In[27]:


#selected_sellers=data_new.groupby('seller_id')['product_category_name_english'].value_counts().sort_values(ascending=False).head(20).to_frame()
#print(selected_sellers.reindex())

### Performing EDA on Sellers Hence collecting sellers who have made high sales

selected_sellers_grp=data_new.groupby(['seller_id','product_category_name_english']).size().sort_values(ascending=False).head(20).to_frame()
list_of_Sellers=(selected_sellers_grp.reset_index()['seller_id'])
list_of_Prod=(selected_sellers_grp.reset_index()['product_category_name_english'])


# In[28]:


# Trying to split data based on year as well as month
data_new['transaction_year'] = pd.DatetimeIndex(data_new['order_purchase_timestamp']).year
data_new['transaction_month'] = pd.DatetimeIndex(data_new['order_purchase_timestamp']).month
data_new['transaction_date'] = pd.DatetimeIndex(data_new['order_purchase_timestamp']).day
data_new['Bi-Weekly'] = np.where(data_new['transaction_date']<15,1,0)
#data_new['Bi-Weekly'] = data_new['transaction_month'].astype(str)  + '_' + data_new['Bi-Weekly']

data_new['Bi-Weekly']= (2*data_new['transaction_month']-1) - data_new['Bi-Weekly']
#data_new[data_new['transaction_date'] < 15,"Bi-Weekly"] = 0
#data_new[data_new['transaction_date'] >= 15,"Bi-Weekly"] = 1
data_new.head(40)


# In[29]:


# Try taking count of product categories sold in monthly sales

data_new_count=data_new.groupby(['product_category_name_english','transaction_year','transaction_month']).size().reset_index(name='count')
print(data_new_count.head(30))


# In[30]:


# Try taking count of product categories sold in Bi-Weekly sales

data_new_count_weekly=data_new.groupby(['product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
print(data_new_count_weekly.head(30))


# In[31]:


list_of_prod_cat=list(data_new_count.product_category_name_english.unique())
print(list_of_prod_cat)


# In[32]:


list_of_prod_cat_weekly=list(data_new_count_weekly.product_category_name_english.unique())
print(list_of_prod_cat_weekly)


# In[33]:


data_new_count[(data_new_count['product_category_name_english']==list_of_prod_cat[0])]


# In[34]:


data_new_count_weekly[(data_new_count_weekly['product_category_name_english']==list_of_prod_cat[0])]


# In[35]:


for i in range(len(list_of_prod_cat)):
    data_new_count[(data_new_count['product_category_name_english']==list_of_prod_cat[i])].pivot("transaction_month", "transaction_year", "count").plot(kind='bar')
    plt.title(list_of_prod_cat[i])
    plt.ylabel("Total count")
    plt.subplot()


# In[36]:


for i in range(len(list_of_prod_cat_weekly)):
    data_new_count_weekly[(data_new_count_weekly['product_category_name_english']==list_of_prod_cat_weekly[i])].pivot("Bi-Weekly", "transaction_year", "count").plot(kind='bar')
    fig = plt.gcf()
    fig.set_size_inches(12.5, 6.5)
    plt.title(list_of_prod_cat_weekly[i])
    plt.ylabel("Total count")
    plt.subplot()


# In[37]:


#creating data frame of seller ids of our interest
data_under_observation=data_new[data_new['seller_id'].isin(list_of_Sellers)]


data_under_observation_count=data_under_observation.groupby(['seller_id','product_category_name_english','transaction_year','transaction_month']).size().reset_index(name='count')
data_under_observation_count.to_csv('../FeatureEng/data_under_observation_count.csv', sep=',')
print(data_under_observation_count)


# In[38]:


## Repeating the same for Bi-Weekly


data_under_observation_count_weekly=data_under_observation.groupby(['seller_id','product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
print(data_under_observation_count_weekly)


# In[39]:


for i in range(len(list_of_Sellers)):
    data_under_observation_count[((data_under_observation_count['product_category_name_english']==list_of_Prod[i]) & (data_under_observation_count['seller_id']==list_of_Sellers[i]))].pivot("transaction_month", "transaction_year", "count").plot(kind='bar')
    plt.title((list_of_Sellers[i],list_of_Prod[i]))
    plt.ylabel("Total count")
    plt.subplot()


# In[40]:


for i in range(len(list_of_Sellers)):
    data_under_observation_count_weekly[((data_under_observation_count_weekly['product_category_name_english']==list_of_Prod[i]) & (data_under_observation_count_weekly['seller_id']==list_of_Sellers[i]))].pivot("Bi-Weekly", "transaction_year", "count").plot(kind='bar')
    plt.title((list_of_Sellers[i],list_of_Prod[i]))
    plt.ylabel("Total count")
    plt.subplot()


# In[41]:


def seller_monthly_transaction_count(seller_id,product_category):
    seller = data_new[(data_new['seller_id']==seller_id)]
    seller_count = seller.groupby(['product_category_name_english','transaction_year','transaction_month']).size().reset_index(name='count')
    print("Monthly seller count for the particular seller:")
    print(seller_count)
    
    #graph for 2018

    month=(seller_count[(seller_count['transaction_year']==2018) & (seller_count['product_category_name_english']== product_category)]['transaction_month'])
    count=(seller_count[(seller_count['transaction_year']==2018) & (seller_count['product_category_name_english']==product_category)]['count'])
    plt.bar(month, count, color="blue")
    plt.title('Counts of product sold in 2018')
    plt.xlabel('Month')
    plt.ylabel('Count of Product sold')
    plt.show()
    
    #graph for 2017

    seller_count=seller.groupby(['product_category_name_english','transaction_year','transaction_month']).size().reset_index(name='count')
    month=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']== product_category)]['transaction_month'])
    count=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']==product_category)]['count'])
    plt.bar(month, count, color="blue")
    plt.title('Counts of products sold in 2017')
    plt.xlabel('Month')
    plt.ylabel('Count of Product sold')
    plt.show()


# In[42]:


def seller_biweekly_transaction_count(seller_id,product_category):
    seller = data_new[(data_new['seller_id']==seller_id)]
    seller_count = seller.groupby(['product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
    #print("Bi_weekly seller count for the particular seller:")
    #print(seller_count)
    
    #graph for 2018
    
    bi_week = ['Jan_1','Jan_2','Feb_1','Feb_2','Mar_1','Mar_2','Apr_1','Apr_2','May_1','May_2','June_1','June_2','July_1','July_2','Aug_1','Aug_2','Sep_1','Sep_2','Oct_1','Oct_2','Nov_1','Nov_2','Dec_1','Dec_2']
    bi_weekly=(seller_count[(seller_count['transaction_year']==2018) & (seller_count['product_category_name_english']== product_category)]['Bi-Weekly'])
    count=(seller_count[(seller_count['transaction_year']==2018) & (seller_count['product_category_name_english']==product_category)]['count'])
    
    fig = plt.gcf()
    fig.set_size_inches(12.5, 6.5)
    #x = bi_week[min(bi_weekly):max(bi_weekly) + 1]
    x = []
    for i in bi_weekly:
        x.append(bi_week[i])

    plt.bar(x, count, color="blue")
    plt.title('Counts of product sold in 2018')
    plt.xlabel('Bi_week')
    plt.ylabel('Count of Product sold')
    plt.show()
    
    #graph for 2017

    #seller_count=seller.groupby(['product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
    fig = plt.gcf()
    fig.set_size_inches(12.5, 6.5)
    bi_weekly=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']== product_category)]['Bi-Weekly'])
    count=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']==product_category)]['count'])
    
    x = []
    for i in bi_weekly:
        x.append(bi_week[i])

    plt.bar(x, count, color="blue")
    plt.title('Counts of products sold in 2017')
    plt.xlabel('Bi_Week')
    plt.ylabel('Count of Product sold')
    plt.show()


# In[43]:


seller_biweekly_transaction_count('1f50f920176fa81dab994f9023523100','baby')


# In[44]:


seller_monthly_transaction_count('1f50f920176fa81dab994f9023523100','garden_tools')


# In[45]:


seller_monthly_transaction_count('1f50f920176fa81dab994f9023523100','baby')


# In[46]:


def seller_biweekly_transaction_count_line_graph(seller_id,product_category):
    seller = data_new[(data_new['seller_id']==seller_id)]
    seller_count = seller.groupby(['product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
    #print("Bi_weekly seller count for the particular seller:")
    print(seller_count)
    
    #graph for 2018
    
    bi_week = ['Jan_1_17','Jan_2_17','Feb_1_17','Feb_2_17','Mar_1_17','Mar_2_17','Apr_1_17','Apr_2_17','May_1_17','May_2_17','June_1_17','June_2_17','July_1_17','July_2_17','Aug_1_17','Aug_2_17','Sep_1_17','Sep_2_17','Oct_1_17','Oct_2_17','Nov_1_17','Nov_2_17','Dec_1_17','Dec_2_17','Jan_1_18','Jan_2_18','Feb_1_18','Feb_2_18','Mar_1_18','Mar_2_18','Apr_1_18','Apr_2_18','May_1_18','May_2_18','June_1_18','June_2_18','July_1_18','July_2_18','Aug_1_18','Aug_2_18','Sep_1_18','Sep_2_18','Oct_1_18','Oct_2_18','Nov_1_18','Nov_2_18','Dec_1_18','Dec_2_18']
    bi_weekly= 24*(seller_count[(seller_count['product_category_name_english']== product_category)]['transaction_year'] - 2017) + seller_count[(seller_count['product_category_name_english']== product_category)]['Bi-Weekly']
    count=(seller_count[seller_count['product_category_name_english']==product_category]['count'])
    
    plt.figure(dpi = 300)
    fig = plt.gcf()
    fig.set_size_inches(34.5, 12.5)
    #x = bi_week[min(bi_weekly):max(bi_weekly) + 1]
    x = []
    for i in bi_weekly:
        x.append(bi_week[i])
    
    plt.plot(x, np.log10(count), color="blue")
    #plt.savefig("eg.jpeg",dpi = 450)
    
    
    
    
    
    
    plt.figure(dpi = 300)
    fig = plt.gcf()
    fig.set_size_inches(34.5, 12.5)
    #x = bi_week[min(bi_weekly):max(bi_weekly) + 1]
    x = []
    for i in bi_weekly:
        x.append(bi_week[i])
    plt.plot(x,count, color="blue")
    #plt.savefig("eg.jpeg",dpi = 450)
    #img=mpimg.imread("eg.jpeg")
    #plt.imshow(img)
    #plt.title('Counts of product sold in 2018')
    #plt.xlabel('Bi_week')
    #plt.ylabel('Count of Product sold')
    #plt.imshow(im,cmap='Greys_r')
    
    #graph for 2017

    #seller_count=seller.groupby(['product_category_name_english','transaction_year','Bi-Weekly']).size().reset_index(name='count')
    #fig = plt.gcf()
    #fig.set_size_inches(12.5, 6.5)
    #bi_weekly=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']== product_category)]['Bi-Weekly'])
    #count=(seller_count[(seller_count['transaction_year']==2017) & (seller_count['product_category_name_english']==product_category)]['count'])
    
    #plt.plot(bi_week[min(bi_weekly):max(bi_weekly) + 1], count, color="blue")
    ##plt.title('Counts of products sold in 2017')
    #plt.xlabel('Bi_Week')
    #plt.ylabel('Count of Product sold')
    #plt.show()


# In[47]:


seller_biweekly_transaction_count_line_graph('1f50f920176fa81dab994f9023523100','signaling_and_security')


# In[48]:


def seller_monthly_transaction_count_line_graph(seller_id,product_category):
    seller = data_new[(data_new['seller_id']==seller_id)]
    seller_count = seller.groupby(['product_category_name_english','transaction_year','transaction_month']).size().reset_index(name='count')
    print("Monthly seller count for the particular seller:")
    print(seller_count)
    
    #graph for 2018

    month_year=seller_count[seller_count['product_category_name_english']== product_category]['transaction_year'].astype(str) +"_" + seller_count[(seller_count['product_category_name_english']== product_category)]['transaction_month'].astype(str)
    count=(seller_count[seller_count['product_category_name_english']==product_category]['count'])
    
    fig = plt.gcf()
    fig.set_size_inches(16.5, 6.5)
    
    plt.plot(month_year, count, color="blue")
    plt.title('Counts of product sold in 2018')
    plt.xlabel('Month and Year')
    plt.ylabel('Count of Product sold')
    plt.show()
    
    fig = plt.gcf()
    fig.set_size_inches(16.5, 6.5)
    
    plt.plot(month_year,np.log(count), color="blue")
    plt.title('Counts of product sold in 2018')
    plt.xlabel('Month and Year')
    plt.ylabel('log(Count) of Product sold')
    plt.show()


# In[49]:


seller_monthly_transaction_count_line_graph('1f50f920176fa81dab994f9023523100','garden_tools')


