#!/bin/python

import os
import sys

HOME_PATH = os.environ[ 'HOME']
COPYFROMAPPEND_TIMES_PATH = HOME_PATH + "/copyfromappend_merge_time_results.txt"
CLIENT_TIMES_PATH = HOME_PATH + "/clientmerge_time_results.txt"

# take avg of copy-from-append merge times from file
duration_list = []
with open( COPYFROMAPPEND_TIMES_PATH, 'r' ) as f :
  for line in f:
    line = line.rstrip()
    if line.startswith( "copyfromappend_merge_time_start" ) :
      line = line.split()
      duration = line[-1]
      duration = duration.split( "=" )
      duration = duration[-1]
      print duration
      duration_list.append( float( duration ) )

print duration_list
avg_duration = sum( duration_list )/len( duration_list )
print "copyfromappend merge avg duration : " + str( avg_duration )

# take avg of client-merge times from file
client_duration_list = []
with open( CLIENT_TIMES_PATH, 'r' ) as f :
  for line in f:
    line = line.rstrip()
    if line.startswith( "clientmerge_time_start" ) :
      line = line.split()
      duration = line[-1]
      duration = duration.split( "=" )
      duration = duration[-1]
      print duration
      client_duration_list.append( float( duration ) )

print client_duration_list
client_avg_duration = sum( client_duration_list )/len( client_duration_list )
print "client merge avg duration : " + str( client_avg_duration )
