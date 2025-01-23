from flask import Flask
from web_routes.employee import employee_bp
from web_routes.commodities import commodities_bp
from flask_cors import CORS
app = Flask(__name__)
app.register_blueprint(employee_bp, url_prefix='/employee')
app.register_blueprint(commodities_bp, url_prefix='/commodities')

CORS(app)



@app.route('/', methods=['GET'])
def index():


    return "backend server is running"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5009, threaded=False)




