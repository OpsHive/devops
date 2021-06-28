#!/bin/bash

DJANGODIR=/home/ubuntu/cogniable/cogniable_application
DJANGO_WSGI_MODULE=cogniable_application.asgi

cd $DJANGODIR
source /home/ubuntu/cogniable/django_env/bin/activate

exec daphne -b 0.0.0.0 -p 8001 ${DJANGO_WSGI_MODULE}:application
