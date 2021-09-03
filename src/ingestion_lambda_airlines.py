import os
import requests
from dynamo import DynamoService
from models import ResponseModel, AirlineCacheModel
from typing import List


API_KEY = os.getenv('API_KEY')

airline_db = DynamoService(
    table_name = 'ingestion_dynamo_airlines', 
    model = AirlineCacheModel
)

def get_airline_data() -> List[AirlineCacheModel]:
    """
    Queries Aviation Stack for airline data
    """
    try:
        print('Attempting to retrieve airline data...')
        response = requests.get(
            'http://api.aviationstack.com/v1/airlines', 
            params={
                'access_key': API_KEY
            }
        )
        print(f'Response received... status: {response.status_code}')

        response = ResponseModel(**response.json())

    except:
        print('Error querying aviation stack...')
        raise


    db_records: List[AirlineCacheModel] = []
    for record in response.data:
        db_records.append(
            AirlineCacheModel(
                iata=record.iata_code,
                airline=record.airline_name
            )
        )
    return db_records

def lambda_handler(event: dict, context) -> dict:
    """
    """
    db_records = get_airline_data()

    return airline_db.batch_put(db_records)


# if __name__ == '__main__':
#     lambda_handler({}, {})