#!/usr/bin/env python
# encoding: utf-8
"""
One File Django App

Basically copypasta of
https://gist.github.com/mstepniowski/5278e27b66903227c611

Usage:

    $ pip install Django==1.6
    $ python django1.py runserver

"""

from django.conf import settings
from django.conf.urls import patterns, url
from django.http import HttpResponse


#---------------
#  settings.py
#---------------

if not settings.configured:
    settings.configure(
        DEBUG=True,
        ROOT_URLCONF='django1',
    )


#------------
#  views.py
#------------

def index(request):
    return HttpResponse('o hai')


#-----------
#  urls.py
#-----------

urlpatterns = patterns('',
    url(r'^$', index, name='index'),
)


#-------------
#  manage.py
#-------------

if __name__ == '__main__':
    import sys
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
