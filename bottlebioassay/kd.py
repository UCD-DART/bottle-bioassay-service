from . import BottleGroup, Bottle, BottleResult, BottleTest
from sqlalchemy import func
from db import SessionManager
import csv
import tempfile
import subprocess


class KD(SessionManager):
    def get_kd(self, bottle_groups):
        import logging
        logging.basicConfig()
        logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)
        output = {}
        for bottle_group in bottle_groups:
            query = self.session.query(BottleGroup.id, BottleResult.time, func.sum(BottleResult.alive).label('alive'))
            query = query.filter(BottleGroup.id == Bottle.bottle_test_group)
            query = query.filter(Bottle.id == BottleResult.bottle)
            query = query.filter(BottleGroup.id == bottle_group)
            query = query.group_by(BottleGroup.id, BottleResult.time)
            query = query.order_by(BottleResult.time)
            bottle_counts = query.all()

            input = self.write_csv(bottle_counts)
            result_file = self.run_R(input)
            if result_file:
                data = self.retrieve_results(result_file)
                print('%s %s' % (input, result_file))
                print(data)
                output[bottle_group] = data
        return output

    def write_csv(self, bottle_results):
        file = tempfile.NamedTemporaryFile(delete=False).name
        with open(file, 'w') as file:
            writer = csv.writer(file,
                                delimiter=',',
                                quotechar='"',
                                quoting=csv.QUOTE_MINIMAL)
            writer.writerow(['id', 'time', 'alive'])
            for bottle_result in bottle_results:

                writer.writerow([bottle_result.id,
                                 bottle_result.time,
                                 bottle_result.alive])
        return file.name

    def run_R(self, input_name):
        output = tempfile.NamedTemporaryFile(delete=False)
        if subprocess.call(
            ['Rscript', 'R/run.R', input_name, output.name]
        ) == 0:
            return output.name
        else:
            return False

    def retrieve_results(self, output_name):
        with open(output_name, 'r') as file:
            reader = csv.reader(file,
                                delimiter=',',
                                quotechar='"',
                                quoting=csv.QUOTE_MINIMAL)
            lines = 0
            for row in reader:
                if lines == 0:
                    header = row[1:]
                else:
                    data = row[1:]
                lines += 1
            output = {v: data[k] for k, v in enumerate(header)}
        return output


def kd(bottle_groups):
    kd = KD()
    return kd.get_kd(bottle_groups)
