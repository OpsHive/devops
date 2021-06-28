#!/bin/bash

NAME="DjangoQ"
DJANGODIR=/home/ubuntu/cogniable/cogniable_application               # Django project director

USER=ubuntu                                         # the user to run as
GROUP=ubuntu                                        # the group to run as
NUM_WORKERS=5                                       # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=cogniable_application.settings      # which settings file should Django use
DJANGO_WSGI_MODULE=cogniable_application.wsgi              # WSGI module name
echo "Starting $NAME as `whoami`"

# Activate the virtual environment

cd $DJANGODIR
source /home/ubuntu/cogniable/django_env/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist

exec python manage.py qcluster

