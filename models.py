from pydantic import BaseModel

class FlightModel(BaseModel):
    id: str
    fleet_average_age: str
    airline_id: str
    callsign: str 
    hub_code: str
    iata_code: str 
    icao_code: str 
    country_iso2: str
    date_founded: str 
    iata_prefix_accounting: str 
    airline_name: str 
    country_name: str
    fleet_size: str 
    status: str 
    type: str
    