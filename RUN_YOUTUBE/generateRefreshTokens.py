# -*- coding: utf-8 -*-
"""
Created on Wed Jun 15 19:19:05 2016

@author: saber
"""

import httplib2
import os
import sys

from oauth2client.client import OAuth2WebServerFlow
import httplib2
from apiclient.discovery import build
from oauth2client.file import Storage
from oauth2client.client import flow_from_clientsecrets
from oauth2client.tools import run
from oauth2client import file, client, tools

import argparse
# CLIENT_SECRETS_FILE, name of a file containing the OAuth 2.0 information for
# this application, including client_id and client_secret. You can acquire an
# ID/secret pair from the API Access tab on the Google APIs Console
#   http://code.google.com/apis/console#access
# For more information about using OAuth2 to access Google APIs, please visit:
#   https://developers.google.com/accounts/docs/OAuth2
# For more information about the client_secrets.json file format, please visit:
#   https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
# Please ensure that you have enabled the YouTube Data API for your project.
CLIENT_SECRETS_FILE = "chemin vers le fichier client_secrets.json"

# Helpful message to display if the CLIENT_SECRETS_FILE is missing.
MISSING_CLIENT_SECRETS_MESSAGE = """
WARNING: Please configure OAuth 2.0
To make this sample run you will need to populate the client_secrets.json file
found at:
   %s
with information from the APIs Console
https://code.google.com/apis/console#access
For more information about the client_secrets.json file format, please visit:
https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
""" % os.path.abspath(os.path.join(os.path.dirname("/home/saber/resources/"),
CLIENT_SECRETS_FILE))

# A limited OAuth 2 access scope that allows for uploading files, but not other
# types of account access.
YOUTUBE_READONLY_SCOPE = "https://www.googleapis.com/auth/youtube.readonly"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

flow = OAuth2WebServerFlow(client_id='.....',
                           client_secret='..............',
                           scope='https://www.googleapis.com/auth/youtube',
                           redirect_uri='http://localhost:8080/Callback')

storage = Storage("%s-oauth2.json" % sys.argv[0])
creds = storage.get()
flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()

print(creds)

if creds is None or creds.invalid:
  #credentials = run(flow, storage)
  creds = tools.run_flow(flow, storage, flags)

print (creds.access_token)
print (creds.refresh_token)
