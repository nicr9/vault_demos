# Flask/MySQL example

Flask note taking webapp; Tasks/notes are stored in MySQL and Flask uses Vault
to retrieve MySQL creds at runtime.

Under the hood, this webapp consists of a Flask app, Vault and MySQL each
running in their own containers. The Flask app connects to Vault to receive
MySQL credentials and then connects to this DB to store the tasks for the app.

## Security procautions

* MySQL user used by Flask only has privledges to `INSERT` or `SELECT`
* Sysadmin can call `make vault-revoke` to revoke all MySQL users used by Flask app in event of a compromise

## Security warnings!

* MySQL root password is hardcoded in `docker-compose.yaml` and in `Makefile`
* Flask app makes no efforts to sanitise input - SQL injection attacks are a possiblity
* It should be possible to give Vault access to a more restricted MySQL user than root. As far as I know they just need privileges to create other users
* Vault token for Flask app containers is passed through a mount, kubernetes secrets might be a safer option but I'm not 100% sure why yet (that means using k8s instead of compose)
* Because we're using Vault's development server, it's easy to `docker exec /bin/sh` into the Vault server and have root access to secrets stored there

## What to expect from this demo

When you've got the demo up and running you should be able to visit the webapp
[in your browser](http://localhost:5000).

Fill in the form with a new task and click the "Add task" button. This should
update the list at the bottom of the page.

If you want to make sure that the webapp is using Vault's dynamic credentials
you can run the following to list MySQL users:

```bash
make db-users
```

It should list root as well as one or more dynamically created users.

Then you can tail MySQL's general query log while you interact with the demo:

```bash
make db-query-logs
```

This should detail which users are connecting to MySQL (it should be one of the
dynamic users you saw listed in the previous step, not root) and what queries
they are running.
