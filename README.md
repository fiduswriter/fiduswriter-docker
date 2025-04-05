# docker-fiduswriter

![GitHub tag (with filter)](https://img.shields.io/github/v/tag/fiduswriter/fiduswriter)
[![pulls](https://img.shields.io/docker/pulls/fiduswriter/fiduswriter.svg)](https://hub.docker.com/r/fiduswriter/fiduswriter/)

[FidusWriter](https://github.com/fiduswriter/fiduswriter) is a collaborative online writing tool. This is a docker image that was built following the official installation manual for Ubuntu as closely as possible.

| This project is the official Fidus Writer images and it's the continuation of the great work done by Moritz at https://github.com/moritzfl/docker-fiduswriter. <br /> Check his repository if you need older images. |
|---|

## Builds and Tags on DockerHub

Builds on Docker are tagged following this pattern and are triggered automatically through changes in this project (fiduswriter/fiduswriter):

- __latest__: latest release or prerelease of fiduswriter (ie: fiduswriter/fiduswriter:latest).
- __[MAJOR]__: the lastest MAJOR release of fiduswriter (ie: fiduswriter/fiduswriter:3) of the version indicated.
- __[MAJOR.minor]__: the lastest MAJOR.minor release of fiduswriter (ie: fiduswriter/fiduswriter:3.11) of the version indicated.
- __[MAJOR.minor.release]__: a fixed version of fiduswriter (ie: fiduswriter/fiduswriter:3.11.9).

Fixed versions are recommended for production sites.

## How to use this image

## Quick Start

```bash
# Clone the repository
git clone https://github.com/fiduswriter/fiduswriter-docker.git
cd fiduswriter-docker

# Set permissions for data directory
sudo mkdir -p volumes/data
sudo chown -R 999:999 volumes

# Start the container
docker compose up -d

# Create a superuser
docker compose exec fiduswriter fiduswriter createsuperuser

# Check logs
docker compose logs -f
```

Visit http://localhost:8000 to access Fidus Writer.

### Understanding how to use this image

In order to allow __access__ from any __URL other than localhost__ you will need to modify the entries for ALLOWED_HOSTS in the file /data/configuration.py.
This file will let you define the __domainname__ where your fiduswriter is running, your admin's mail and may other important settings.
To keep this file persistent in an easy way, we recommend mapping the data directory to a directory on your host machine for data persistence.

In order to persist your data and configuration, you __must grant write access for the executing user (fiduswriter)__ to the volumes directory that you want to map to on the host.
This can be achieved by issuing the command below. If you do not ensure access to the desired directory on the host, fiduswriter will not run correctly.

~~~~
$ sudo chown -R 999:999 ./volumes
~~~~

(Replace "./volumes" with the directory on your preference in your host machine)

If you like you can run fiduswriter without `docker compose`, just with a docker run call (you can do without -v ./volumes/data:/data but that means data won't be persistent):

~~~~
$ docker run -d -v ./volumes/data:/data -p 8000:8000 --name fiduswriter-fiduswriter fiduswriter/fiduswriter:latest
~~~~

If needed, you can create an administrative account for fiduswriter by attaching the container to your terminal and issuing the following command:

~~~~
$ python3 manage.py createsuperuser
~~~~

Notice that until you define a mail-server (also through /data/configuration.py), you won't be able to complete user's mail validation, but the mails and contained __links required for user registration__ will be printed to the __outputstream of the container__.


#### Making things easier with  Docker Compose

Former explanation talks about docker, but for a fast an easy setting and running we recommend `docker-compose.yml`.
This repository includes a `docker-compose.yml` file that describes a production like environment that uses a PostgreSQL database.
You can retrieve dependencies, create volumes and generate the Dockerimage for Fidus Writer you only need to run:

```
$ docker compose up
```

Add "-d" if you want it to run detached.

This will install all build-time dependencies into the image but, to configure it for the resulting container, we need to put some configuration in place.
One last adaptation is needed after the initial run, since else the registration emails will be sent from example.com.

Once started, to create a super user account you only need to run:
```
$ docker compose exec fiduswriter fiduswriter createsuperuser
```

and then login to /admin to change the site configuration.
The default Django site that is created during fiduswriter setup is called example.com, which will be used by django-allauth for email messages.
You will probably like to change this to a production value.

This application state needs to be adapted in /admin/sites/site/, which is only accessible to superusers, why we created the admin account just before.

Change the domain name to from where your instance can be reached, and the display name to indicate how you want it to be called. Then your Fidus Writer deployment should be complete.

Please leave comments in the issues if you have any remarks.

## Configuration

The configuration file is located at `volumes/data/configuration.py`. You can modify this file to customize your Fidus Writer instance.

Important settings to consider:
- `ALLOWED_HOSTS`: Add your domain name here
- `DEBUG`: Set to False in production
- `CONTACT_EMAIL`: Set your contact email
- `DATABASES`: Configure your database settings if you want to use a different database backend

## Persistence

Data is stored in the `./volumes/data` directory. This includes:
- SQLite database
- User uploads
- Configuration

Make sure to back up this directory regularly.

## Running Behind a Reverse Proxy

When running Fidus Writer behind a reverse proxy like Nginx or Apache, make sure to:
1. Forward the correct headers (X-Forwarded-For, X-Forwarded-Proto, etc.)
2. Add your domain to the `ALLOWED_HOSTS` in configuration.py
3. Set `CSRF_TRUSTED_ORIGINS` if using HTTPS

## Upgrading

To upgrade to a newer version of Fidus Writer:

1. Update the `VERSION` in the Dockerfile
2. Rebuild the container: `docker compose up -d --build`

## Troubleshooting

### Database Permissions

If you encounter database permission issues, ensure the data directory is owned by user and group ID 999:
```bash
sudo chown -R 999:999 volumes/data
```

### Email Configuration

By default, emails are printed to the console. To set up a real email service, configure the email settings in `configuration.py`.
