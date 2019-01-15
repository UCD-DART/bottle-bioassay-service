from connexion.apps.flask_app import FlaskJSONEncoder
from bottle_bioassay import Base


class AlchemyEncoder(FlaskJSONEncoder):
    def default(self, o):  # pylint: disable=E0202
        if isinstance(o, Base):
            d = o.__dict__
            del d['_sa_instance_state']
            return d
        return FlaskJSONEncoder.default(self, o)
