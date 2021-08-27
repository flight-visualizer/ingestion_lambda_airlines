from Backend.ingestion_lambda_airlines.models import FlightModel
import requests
from models import FlightModel


def handler(event, context):

    print(event, context)

    

def query_airlines():
    key = 'fea7d4c61d5cff92ae5823a3016bce40'
    r = requests.get(
        f'http://api.aviationstack.com/v1/airlines?access_key={key}'
    )




model = FlightModel(**sample_json1)

print(model)

key = 'fea7d4c61d5cff92ae5823a3016bce40'
r = requests.get(
    f'http://api.aviationstack.com/v1/airlines?access_key={key}'
    )

output = r.json()

print(f"Ingesting {output['pagination']['count']} airline records of {output['pagination']['total']} total available records")


for record in output['data']:
    FieldModel(record) # Data Validation

output_model = FieldModel(**output['data'])
    

sample_json = {
    'pagination': 
    {
        'offset': 0, 
        'limit': 100, 
        'count': 100, 
        'total': 13131
    }, 
    'data': [
        {
            'id': '1', 
            'fleet_average_age': '10.9', 
            'airline_id': '1', 
            'callsign': 'AMERICAN', 
            'hub_code': 'DFW', 
            'iata_code': 'AA', 
            'icao_code': 'AAL', 
            'country_iso2': 'US', 
            'date_founded': '1934', 
            'iata_prefix_accounting': '1', 
            'airline_name': 'American Airlines', 
            'country_name': 'United States', 
            'fleet_size': '963', 
            'status': 'active', 
            'type': 'scheduled'
        }
    ]
}