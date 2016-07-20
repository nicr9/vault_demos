from flask import Flask, render_template, json, request
from flask_mysqldb import MySQL
from json import load as json_load
from hvac import Client as Vault

# Initialise Flask and MySQL plugin
app = Flask(__name__)
mysql = MySQL(app)

# Configure
app.config['MYSQL_HOST'] = 'database'
app.config['MYSQL_DB'] = 'VaultDemo'

# Initialise Vault client
client = Vault("http://vault:8300")
with open("/opt/flaskapp/vault.token") as inp:
    token = json_load(inp)
    client.token = token['auth']['client_token']

# Grab MySQL creds from Vault
if client.is_authenticated():
    creds = client.read("mysql/creds/flaskapp")

    userpass = creds['data']
    app.config['MYSQL_PASSWORD'] = userpass['password']
    app.config['MYSQL_USER'] = userpass['username']
else:
    exit(1)

@app.route("/")
def main():
    try:
        cur = mysql.connection.cursor()
        query = 'SELECT * FROM todolist'
        status = cur.execute(query)
    except:
        results = []
    else:
        results = [{'title': title, 'body': body}
                for _, title, body in cur.fetchall()]

    return render_template("index.html", tasks=results)

@app.route("/send-task", methods=['POST'])
def send_task():
    """
    Takes title and body from request and inserts them into the DB.

    TODO: Beware SQL injection attacks!
    """
    _title = request.form['inputTitle']
    _body = request.form['inputBody']

    try:
        cur = mysql.connection.cursor()
        query = 'INSERT INTO todolist (title, body) VALUES ("{}", "{}")'
        status = cur.execute(query.format(_title, _body))
    except:
        return "Exception occured: {}".format(e), 500
    else:
        if status:
            return "ok: {}".format(status), 203
        else:
            return "Server Error: {}".format(status), 500
    finally:
        mysql.connection.commit()

if __name__ == "__main__":
    app.run(host="0.0.0.0")
