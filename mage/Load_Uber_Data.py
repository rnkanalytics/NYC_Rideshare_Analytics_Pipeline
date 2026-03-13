from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

@data_exporter
def export_data_to_big_query(data, **kwargs) -> None:
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

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
        table_id = f'project-9e8fe6e9-80e0-472b-b51.uber.{table_name}'
        BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).export(
            DataFrame(df),
            table_id,
            if_exists='replace',
        )
        print(f'Exported {table_name} successfully')
