from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.snowflake import Snowflake
from pandas import DataFrame
from google.cloud import bigquery
from google.auth import default
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

config_path = path.join(get_repo_path(), 'io_config.yaml')
config_profile = 'default'

@data_exporter
def export_data(data, **kwargs) -> None:

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

    # --- Load to BigQuery ---
    credentials, project = default()

    for table_name, df in tables.items():
        DataFrame(df).to_gbq(
            destination_table=f'uber.{table_name}',
            project_id='project-9e8fe6e9-80e0-472b-b51',
            if_exists='replace',
            credentials=credentials,
        )
        print(f'BigQuery: {table_name} loaded successfully')

    # --- Load to Snowflake ---
    with Snowflake.with_config(
        ConfigFileLoader(config_path, config_profile)
    ) as snowflake:
        for table_name, df in tables.items():
            df = DataFrame(df)
            df.columns = [col.upper() for col in df.columns]
            snowflake.export(
                df,
                table_name.upper(),
                database='UBER_DB',
                schema='ANALYTICS',
                if_exists='replace',
            )
            print(f'Snowflake: {table_name} loaded successfully')

    print('All tables loaded to BigQuery and Snowflake successfully')
