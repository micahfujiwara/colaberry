from flask import Flask, render_template
import polars as pl
import pathlib

__PROJECT_DIR__: pathlib.Path = pathlib.Path(__file__).parent.parent.parent
DATABASE_FILE: pathlib.Path = __PROJECT_DIR__ / 'database.db'


app = Flask(__name__)


@app.route('/')
def index():
    df = pl.read_database(query = 'SELECT * FROM Weather', connection = f'sqlite:///{DATABASE_FILE}')
    return df

posts = index()

print(posts)