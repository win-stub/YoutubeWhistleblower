# -*- coding: utf-8 -*-
"""
Created on Wed Jun 15 13:47:52 2016

@author: saber
"""
import argparse
from oauth2client import file, client, tools

#SCOPES = 'https://www.googleapis.com/auth/youtube'# one or more scopes (str or iterable)
SCOPES = 'https://www.googleapis.com/auth/youtube.force-ssl'# one or more scopes (str or iterable)
store = file.Storage('storage.json')
creds = store.get()
if not creds or creds.invalid:
    flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
    flow = client.flow_from_clientsecrets('chemin vers le fichier JSON du code scret', SCOPES)
    creds = tools.run_flow(flow, store, flags)

print ("token "+creds.access_token)
print ("frefresh token "+creds.refresh_token)
#SERVICE = discovery.build(API, VERSION, http=creds.authorize(Http()))
