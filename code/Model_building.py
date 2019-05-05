
# coding: utf-8

# In[13]:


import pandas as pd
import datetime
import math
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt, mpld3
import math
from datetime import datetime
import seaborn as sns


# In[14]:


from understanding_data import seller_monthly_transaction_count_line_graph
#from understanding_data import seller_biweekly_transaction_count_line_graph


# In[15]:


import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import ensemble
from sklearn.metrics import mean_squared_error
import numpy as np
from sklearn.ensemble import RandomForestRegressor


# In[16]:


def getInformation(s_id):
    sellerdf, unique_prod_categories = getData(s_id)
    print('Unique Product Categories Sold by Seller:', unique_prod_categories)
    startdate = sellerdf['order_purchase_timestamp'].min()
    enddate = sellerdf['order_purchase_timestamp'].max()
    print('Earliest Sale Date:', startdate)
    print('Last Sale Date:',enddate)
    print('\n Basic Information on sales by seller:\n')
    dataseller = sellerdf['product_category_name_english'].value_counts()
    dataseller_df = pd.DataFrame(data=dataseller)
    dataseller_df.rename(columns={'product_category_name_english':'sales per product category'},inplace=True)
    dataseller_df.to_html('templates/getInformation.html')

def getDashboard(s_id):
    sellerdf, unique_prod_categories = getData(s_id)
    prod_select = input('Enter Product Category:')
    print('Monthly Sales of Category:',prod_select)
    seller_monthly_transaction_count_line_graph(s_id, prod_select)
    print('Bi Weekly Sales of Product Category:', prod_select)
    seller_biweekly_transaction_count_line_graph(s_id, prod_select)


# In[20]:


def getData(s_id):
    data_new = pd.read_csv('../Data/Primary_Secondary.csv')
    data_new = data_new.drop(columns = ['Unnamed: 0'])
    data_new['order_purchase_timestamp'] = pd.to_datetime(data_new['order_purchase_timestamp'])
    new_data = data_new[data_new.seller_id==s_id]
    new_data = new_data.sort_values(by='order_purchase_timestamp')
    new_data = new_data.drop(['order_id', 'customer_id', 'order_status',
       'order_approved_at', 'order_delivered_carrier_date',
       'order_delivered_customer_date', 'order_estimated_delivery_date',
       'order_item_id', 'product_id', 'shipping_limit_date',
       'seller_zip_code_prefix', 'seller_city',
       'seller_state', 'product_name_lenght', 'product_description_lenght',
       'customer_unique_id','Bi-Weekly','datediff_purchase_deliver'],axis=1)
    unique = new_data['product_category_name_english'].unique()
    print("UNI")
    print(unique)
    pd.DataFrame(unique).to_html('templates/getData.html')
    return new_data, unique


# In[21]:


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
            print(reviews_timeseries.index)
            ax = sns.lineplot(
            x=reviews_timeseries.index.to_timestamp(), 
            y='count', 
            data=reviews_timeseries, 
            color='#984ea3', 
            label='count'
            )
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
            plt.savefig('static/reviews.png')
        else:
            print("Sorry!!!! Not much information about this Product Category at this moment. Try some other category")


# In[22]:


#check_reviews('289cdb325fb7e7f891c38608bf9e0962','perfumery')


# In[23]:


def Gradient_Boosting_Model(seller_id):
    model_data,unique_names = getData(seller_id)
    
    category = input('Enter Product Category you want to analyze:')
    model_data = model_data[model_data['product_category_name_english']==category]
    
    #Extract date from order_purchase_timestamp
    model_data['order_purchase_timestamp'] = model_data['order_purchase_timestamp'].apply(lambda x: x.date()).astype('str')
    model_data = model_data.drop(['seller_id','product_category_name_english','customer_city','customer_state'],axis=1)
    
    ## Count the number sales on each day
    seller_count = model_data.groupby(['order_purchase_timestamp']).size().reset_index(name='count')
    model_data = pd.merge(model_data, seller_count, how='inner',left_on=['order_purchase_timestamp'],right_on=['order_purchase_timestamp'])
    print("model_data",model_data.sort_values(by='order_purchase_timestamp'))
    model_data = model_data.drop_duplicates(keep='first',subset = 'order_purchase_timestamp')
    
    print("model_data",model_data.sort_values(by='order_purchase_timestamp'))
    ## Perform train test split. We are taking last 30 days from data for testing. Remaining is used for training
    length = model_data.shape[0]
    num_rows_split = length - 30 
    model_data = model_data.drop(['order_purchase_timestamp','transaction_year','transaction_date'],axis = 1)
    model_train = model_data[:num_rows_split]
    model_test = model_data[num_rows_split:]
    
    x_train = model_train.drop(columns = 'count',axis = 1)
    y_train = model_train['count']

    x_test = model_test.drop(columns = 'count',axis = 1)
    y_test = model_test['count']

    learning_rate = [0.01,0.03,0.05,0.07,0.09]
    min_samples_split = [2,3,4]
    min_samples_leaf = [1,2]
    max_depth = [2,3,4]
    
    ## Grid Search for hyper parameter tuning
    mse_min = 9999
    lr_min = 0.01
    min_samples_split_min = 2
    min_samples_leaf_min = 1
    max_depth_min = 2
    for lr in learning_rate:
        for mss in min_samples_split:
            for msl in min_samples_leaf:
                for md in max_depth:
                    params = {'min_samples_split':mss,'learning_rate': lr, 'verbose':0,'max_depth':md,'min_samples_leaf':msl}
                    clf = ensemble.GradientBoostingRegressor(**params)
                    clf.fit(x_train, y_train)
                    mse = mean_squared_error(y_test, clf.predict(x_test))
                    
                    if mse < mse_min:
                        mse_min = mse 
                        lr_min = lr
                        min_samples_split_min = mss
                        min_samples_leaf_min = msl
                        max_depth_min = md
                        
    print("Best RMSE is ",math.sqrt(mse_min),"for ",lr_min,min_samples_split_min,min_samples_leaf_min,max_depth_min)
    params = {'min_samples_split':min_samples_split_min,'learning_rate': lr_min, 'verbose':0,'max_depth':max_depth_min,'min_samples_leaf':min_samples_leaf_min}
    clf = ensemble.GradientBoostingRegressor(**params)
    clf.fit(x_train, y_train)
    

    test_score = np.zeros((100,), dtype=np.float64)

    for i, y_pred in enumerate(clf.staged_predict(x_test)):
        test_score[i] = clf.loss_(y_test, y_pred)

    ## Plotting training and testing deviance
    plt.figure(figsize=(12, 6))
    plt.subplot(1, 2, 1)
    plt.title('Deviance')
    plt.plot(np.arange(100) + 1, clf.train_score_, 'b-',label='Training Set Deviance')
    plt.plot(np.arange(100) + 1, test_score, 'r-',label='Test Set Deviance')
    plt.legend(loc='upper right')
    plt.xlabel('Boosting Iterations')
    plt.ylabel('Deviance')
    plt.show()
    y_pred1 = clf.staged_predict(x_train)

    feature_importance = clf.feature_importances_
    # make importances relative to max importance
    feature_importance = 100.0 * (feature_importance / feature_importance.max())
    sorted_idx = np.argsort(feature_importance)
    pos = np.arange(sorted_idx.shape[0]) + .5

    fig = plt.gcf()
    fig.set_size_inches(12.5,8.5)
    plt.plot(1, 2, 2)
    plt.barh(pos, feature_importance[sorted_idx], align='center')
    plt.yticks(pos, x_train.columns[sorted_idx])
    plt.xlabel('Relative Importance')
    plt.title('Variable Importance')
    plt.show()
    
    fiveday_actual = []
    fiveday_pred = []
    for i in range(6):
        fiveday_actual.append(math.ceil(sum(y_test[5*i:5*i+5])))
        fiveday_pred.append(math.ceil(sum(clf.predict(x_test)[5*i:5*i+5])))
    
    agg_pred = math.ceil(sum(clf.predict(x_test)))
    agg_actual = math.ceil(sum(y_test))
    print("Actual count",agg_actual)
    print("Predicted count",agg_pred)
    
    plt.plot(fiveday_actual)
    plt.plot(fiveday_pred,'r')
    plt.show()


# In[24]:


#Gradient_Boosting_Model('6560211a19b47992c3666cc44a7e94c0')

## This is found to be the best model of all that we have tried.
## Type garden_tools when asked for category


# In[ ]:


#Gradient_Boosting_Model('6560211a19b47992c3666cc44a7e94c0')
## This doesn't perform well and the prediction is way off for this model. We'll probably need to build a separate model for such cases

## Enter watches_gifts when asked for category



# In[25]:


from fbprophet import Prophet


# In[35]:


def prophet_model(seller_id,prod_cat_i):
    model_data,unique_names = getData(seller_id)
    
    #category = input('Enter Product Category you want to analyze:')
    model_data = model_data[model_data['product_category_name_english']==prod_cat_i]
    
    if model_data.shape[0]<300:
        print("Not enough data to fit the model")
    ## Extract date from order_purchase_timestamp
    model_data['order_purchase_timestamp'] = model_data['order_purchase_timestamp'].apply(lambda x: x.date()).astype('str')
    model_data['order_purchase_timestamp'] = pd.to_datetime(model_data['order_purchase_timestamp'])
    
    seller_count = model_data.groupby(['order_purchase_timestamp']).size().reset_index(name='count')
    
    ## Calculate price for reveue calculation
    price = model_data['price'].mean()
    
    model_data = pd.merge(model_data, seller_count, how='inner',left_on=['order_purchase_timestamp'],right_on=['order_purchase_timestamp'],copy=False)

    model_data = model_data.drop_duplicates(keep='first',subset = 'order_purchase_timestamp')
    
    seller = model_data[['order_purchase_timestamp','count']]
    seller.columns  = ['ds','y']
    
    
    ## Split into train and test based on last 30 sales days
    number_of_obs = seller.shape[0]
    split = 30
    train = seller[:-split]
    test = seller[-split:]
    
    end = test['ds'].iloc[-1]
    start = test['ds'].iloc[0]
    diff = end -start
    
    ## Add holidays of interest for better prediction during this time
    holidays = pd.DataFrame({'holiday': 'days_of_interest','ds': pd.to_datetime(['2017-01-01','2017-02-27','2017-02-28',
    '2017-03-01','2017-04-14','2017-04-21','2017-05-01','2017-05-15','2017-07-09','2017-09-07','2017-10-12','2017-10-27',
    '2017-11-01','2017-11-02','2017-11-15','2017-11-20','2017-12-25','2018-01-01','2018-02-27','2018-02-28',
    '2018-03-01','2018-04-14','2018-04-21','2018-05-01','2018-05-15','2018-07-09']),
  'lower_window': -1,
  'upper_window': 1,
})
    prophet_model = Prophet(changepoint_prior_scale=0.8,weekly_seasonality=True,holidays=holidays)
    
    prophet_model.fit(train)
    
    
    ## set the extended periods as present in the test data
    predict = prophet_model.make_future_dataframe(periods=diff.days)
    
    forecast = prophet_model.predict(pd.DataFrame(test['ds']))
    forecast_tail = forecast[['ds','yhat','yhat_lower','yhat_upper']]
    
    rmse = math.sqrt(mean_squared_error(test['y'],forecast_tail['yhat']))
    
    ## plot the prophet forecasts to gain perspective on sales
    forecast = prophet_model.predict(pd.DataFrame(predict))
    fig1 = prophet_model.plot(forecast)
    
    fig2 = prophet_model.plot_components(forecast)
    
    ## Count extra number of days in training 
    #diff_train = (train['ds'].iloc[-1] - train['ds'].iloc[0]).days
    
    #extra_days_test = math.floor(((diff_train-train.shape[0])/train.shape[0])*30)    
    ## Predicted Count on the test
    predicted_count  = np.ceil(np.sum(forecast_tail[-diff.days:]['yhat']))
    print("Predictted Count",predicted_count)
    ## Average number of sales predicted per day
    average = round(test['y'].mean())
    
    
    ## Remove the extra count values coming from extra days
    #predicted_count = predicted_count - extra_days_test*average
    
    ## Actual count of the test set
    actual_count = np.sum(test['y'])
    
    actual_revenue = actual_count *price
    predicted_revenue = predicted_count * price 
    Pred_count=("Predicted count = "+str(predicted_count))
    Average_sales=("Average Sales = "+str(average))
    Actual_count=("Actual count = "+str(actual_count))
    Predicted_revenue=("Predicted revenue = "+str(predicted_revenue))
    Actual_revenue=("Actual revenue "+str(actual_revenue))   
    print("Percentage error in calculating revenue",(abs(actual_revenue - predicted_revenue)/actual_revenue)*100)    
    print("Root Mean Squared for this model is", rmse)    
    html =  "<html>\n<head></head>\n<title>Predictions</title><style>body {background-image: url(\"../static/background_m.jpg\");})</style><body>"
    html+=Pred_count+"<br>"+Average_sales+"<br>"+Actual_count+"<br>"+Predicted_revenue+"<br>"+Actual_revenue
    
    htmlfile="templates/Prediction.html"
    with open(htmlfile, 'w') as f:
        f.write(html + "\n</body>\n</html>")


# In[36]:


#prophet_model('6560211a19b47992c3666cc44a7e94c0','watches_gifts')

