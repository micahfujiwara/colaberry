import polars as pl
import pathlib
import sqlite3
from app import __PROJECT_DIR__, DATABASE_FILE

WX_DATA: pathlib.Path = __PROJECT_DIR__ / 'wx_data'
YLD_DATA: pathlib.Path = __PROJECT_DIR__ / 'yld_data' / 'US_corn_grain_yield.txt'

def wx_consolidation_cleanse(df: pl.DataFrame, weather_station_id:str) -> pl.DataFrame:
    df = df.with_columns(weather_station_id = pl.lit(weather_station_id).cast(pl.String),
                         date = pl.col('date').cast(pl.String).str.to_date(r'%Y%m%d'),
                         max_temp = pl.col('max_temp').str.strip_chars().cast(pl.Int32),
                         min_temp = pl.col('min_temp').str.strip_chars().cast(pl.Int32),
                         precipitation = pl.col('precipitation').str.strip_chars().cast(pl.Int32))
    
    
    df = df.with_columns(
        pl.when(pl.col(pl.Int32) == -9999)
        .then(None)
        .otherwise(pl.col(pl.Int32))
        .name.keep()
    )

    return df


def wx_consolidation(folderpath:str) -> pl.DataFrame:
    df: pl.DataFrame = []
    
    for file in folderpath.iterdir():
        if file.is_file():
            weather_station_id: str = file.name.replace('.txt', '')
            headers: list = ["date", "max_temp", "min_temp", "precipitation"]
            temp_df = pl.read_csv(file, separator='\t', new_columns = headers)
            temp_df = wx_consolidation_cleanse(temp_df, weather_station_id)
            
            df.append(temp_df)
    
    return pl.concat(df)


def yld_consolidation_cleanse(df: pl.DataFrame) -> pl.DataFrame:
    df = df.with_columns(year = pl.col('year').cast(pl.Int32),
                         yield_amt = pl.col('yield_amount').cast(pl.Int32))
    return df


def yld_consolidation(file:str) -> pl.DataFrame:
    headers: list = ["year", "yield_amount"]
    df = pl.read_csv(file, separator='\t', new_columns=headers)
    df = yld_consolidation_cleanse(df)
    print(df)
    
    
wx_df = wx_consolidation(WX_DATA)
yld_df = yld_consolidation(YLD_DATA)


def push_data(wx_df: pl.DataFrame | None = None, yld_df: pl.DataFrame | None = None) -> pl.DataFrame:
    try:
        if wx_df is not None:
            wx_df.write_database("Weather", connection = f'sqlite:///{DATABASE_FILE}', if_exists = 'replace')
        if yld_df is not None:
            yld_df.write_database("Yield_Data", connection = f'sqlite:///{DATABASE_FILE}', if_exists = 'replace')
    except Exception as e:
        print(f"Error: {e}")
        
push_data(wx_df)