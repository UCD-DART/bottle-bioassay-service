from flask import render_template, jsonify
import connexion
from alchemy_encoder import AlchemyEncoder

# Create the application instance
app = connexion.FlaskApp(__name__, specification_dir='./openapi/v1')

# Read the swagger.yml file to configure the endpoints
app.add_api('bottle_bioassays.yml')
app.app.json_encoder = AlchemyEncoder


# Create a URL route in our application for "/"
@app.route('/')
def home():
    """
    This function just responds to the browser ULR
    localhost:5000/
    :return:        the rendered template 'home.html'
    """
    return render_template('home.html')


# If we're running in stand alone mode, run the application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
