# Hashicorp Vault Demos

A collection of practical examples for using Hashicorp Vault in your project.

## Security warnings!

Ironic I know...

These demos are not suitable for running in a production environment! This
project has been intended as a source of examples, as such some assumptions have
been made to simplify the deployment process.

Specific security concerns are listed in each demo's `README.md`.

## Demos

* [Flask/MySQL](flask-mysql/README.md)

### Ideas for future demos

Here's some other examples I wanna write up when I have the time:

* Autogenerate keys to access AWS S3 buckets (or any AWS resources)
* Can I store/dynamically create Let's Encrypt HTTPS certs via Vault?
* Using Vault's github authentication backend; Manage access for a whole company

## Preparing a demo

You'll need to install the following to get these demos working:

* [docker](https://docs.docker.com/engine/installation/)
* [docker-compose](https://docs.docker.com/compose/install/)

There are also some optional requirements. These aren't part of the critical
path (you can run the demos without them) but they are used to script some
common operations for debugging the demos.

* [jq](https://github.com/stedolan/jq)

## Running a demo

Each demo directory includes a fairly extensive `Makefile` with simple commands
to manage/debug the demo and a `README.md` with a description and demo-specific
instructions.

You should have a read over the `README.md` before running the demo to get an
idea of what to expect; each demo might have it's own specific quirks or you
might need to run certain commands to validate that it is indeed working if it
isn't immediately obvious.

At the very least you should be able to start up the demo by running:

```bash
make
```

To tear the demo down:

```bash
make down
```
