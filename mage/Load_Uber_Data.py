from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from google.cloud import bigquery
from google.auth import default
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

@data_exporter
def export_data_to_big_query(data, **kwargs) -> None:
    credentials, project = default()
    client = bigquery.Client(credentials=credentials, project='YOUR-PROFILE-ID')

    tables = {
        'fact_table': data['fact_table'],
        'datetime_dim': data['datetime_dim'],
        'passenger_count_dim': data['passenger_count_dim'],
        'trip_distance_dim': data['trip_distance_dim'],
        'rate_code_dim': data['rate_code_dim'],
        'pickup_location_dim': data['pickup_location_dim'],
        'dropoff_location_dim': data['dropoff_location_dim'],
        'payment_type_dim': data['payment_type_dim'],
    }

    for table_name, df in tables.items():
        DataFrame(df).to_gbq(
            destination_table=f'uber.{table_name}',
            project_id='YOUR-PROFILE-ID',
            if_exists='replace',
            credentials=credentials,
        )
        print(f'Exported {table_name} successfully')
