import sqlite3

connection = sqlite3.connect('database.db')


with open('src/flask_app/schema.sql') as f:
    connection.executescript(f.read())


connection.commit()
connection.close()

