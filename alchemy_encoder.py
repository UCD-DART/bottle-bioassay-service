from connexion import jsonifier
from bottlebioassay import Base


class AlchemyEncoder(jsonifier):
    def default(self, o):  # pylint: disable=E0202
        if isinstance(o, Base):
            d = o.__dict__
            del d['_sa_instance_state']
            return d
        return jsonifier.default(self, o)
