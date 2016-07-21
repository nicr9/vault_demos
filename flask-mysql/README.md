# Flask/MySQL example

Flask note taking webapp; Tasks/notes are stored in MySQL and Flask uses Vault
to retrieve MySQL creds at runtime.

## Security warnings!

* MySQL root password is hardcoded in `docker-compose.yaml` and in `Makefile`
* Flask app takes no procautions against SQL injection attacks
* It should be possible to give Vault access to a more restricted MySQL user than root. As far as I know they just need privileges to create other users.
* I should write a more restricted policy for Vault to use when generating MySQL credentials. Flask doesn't need access to everything.
* Vault token for flask app containers is passed through a mount, kubernetes secrets might be a safer option but I'm not 100% sure why yet (that means using k8s instead of compose)
* Because we're using Vault's development server, it's easy to `docker exec /bin/sh` into the vault server and have root access to secrets stored there

## What to expect from this demo

When you've got the demo up and running you should be able to visit the webapp
[in your browser](http://localhost:5000).

Fill in the form with a new task and click the "Add task" button. This should
update the list at the bottom of the page.

Under the hood, this webapp consists of a flask app, vault and mysql each
running in their own containers. The flask app connects to Vault to receive
MySQL credentials and then connects to this DB to store the tasks for the app.
