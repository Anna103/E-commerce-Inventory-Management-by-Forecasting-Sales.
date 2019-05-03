from flask import Flask, render_template,request
import Model_building as Mb
import HeatMap_day_hour as Hm
import understanding_data as ud
import os
from time import gmtime, strftime
import glob
import fileinput
import shutil

app = Flask(__name__)

source="/Users/admin/Desktop/Spring 2019/DPA/brazilian-ecommerce/E-commerce-Inventory-Management-by-Forecasting-Sales./code/background/background_m.jpg"
dest="/Users/admin/Desktop/Spring 2019/DPA/brazilian-ecommerce/E-commerce-Inventory-Management-by-Forecasting-Sales./code/static"

@app.route("/")
def home():
    return render_template('home.html')

@app.route("/",methods=['POST'])

def getinfo():
    if request.method == 'POST':
        if request.form['submit_button'] == 'Get Product Cat Info':
            seller_i=request.form['seller_id']
            x,y=Mb.getData(seller_i)      
            with fileinput.FileInput('templates/getData.html', inplace=True, backup='.bak') as file:
                for line in file:
                    print(line.replace("<tbody>","<style>\nbody {background-image: url(\"../static/background_m.jpg\");})</style>\n<body>\n<tbody>"), end='')
            return render_template('getData.html')
        
        elif request.form['submit_button'] == 'Get Sale Info':
            seller_i=request.form['seller_id']
            Mb.getInformation(seller_i)
            with fileinput.FileInput('templates/getInformation.html', inplace=True, backup='.bak') as file:
                for line in file:
                    print(line.replace("<tbody>","<style>\nbody {background-image: url(\"../static/background_m.jpg\");})</style>\n<body>\n<tbody>"), end='')
            shutil.copy(source,dest)
            return render_template('getInformation.html')
        
        elif request.form['submit_button'] == 'Get Graph':
            for filename in os.listdir('static/'):
                os.remove('static/' + filename)
            seller_i=request.form['seller_id']
            prod_cat=request.form['product_category']
            ud.seller_monthly_transaction_count_line_graph(seller_i,prod_cat)
            prod_list=glob.glob('static/prod_seller*.png')
            print(prod_list)
            prod=prod_list[0][7:]

            shutil.copy(source,dest)
            return render_template('get_Dashboard.html', prod=prod)
        
        elif request.form['submit_button'] == 'Get Insights':
            for filename in os.listdir('static/'):
                os.remove('static/' + filename)
            seller_i=request.form['seller_id']
            prod_cat=request.form['product_category']
            Hm.generate_heatmap_seller(seller_i,prod_cat)
            Hm.diffReviewSale(seller_i,prod_cat)
            heatmap_list=glob.glob('static/heatmap_*.png')
            heatmap=heatmap_list[0][7:]
            diff_list=glob.glob('static/reviewscore_dif*.png')
            diff=diff_list[0][7:]
            shutil.copy(source,dest)
            return render_template('get_heatMaps.html', graph=heatmap,diffgraph=diff)
        
        elif request.form['submit_button'] == 'Get Prediction':
            for filename in os.listdir('static/'):
                os.remove('static/' + filename)
            seller_i=request.form['seller_id']
            prod_cat=request.form['product_category']
            Mb.prophet_model(seller_i,prod_cat)
            shutil.copy(source,dest)
            return render_template('Prediction.html')
        else:
            return render_template('home.html')
    elif request.method == 'GET':
            return render_template('home.html')
if __name__=='__main__':
    app.run(debug=True)

