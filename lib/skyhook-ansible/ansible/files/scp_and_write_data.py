#!/bin/python

import os
import subprocess
import sys

this_user               = sys.argv[1]
data_node_addr          = sys.argv[2]
data_path               = sys.argv[3]
data_dir                = sys.argv[4]
data_file_prefix        = sys.argv[5]
data_file_suffix        = sys.argv[6]
osd_dev_name = sys.argv[7]
pool_name               = sys.argv[8]
numobjs                 = int( sys.argv[9] )

# get file names from remote storage
#remote_files_str = subprocess.check_output(["sudo", "bash", \
#                                            "rsync_command.sh", \
#                                            "kat", \
#                                            data_node_addr, \
#                                            "/mnt/sda4/arity3datasets/flatflex/fbxrows-arity3-1mb-100objs/"])
#remote_files_str = remote_files_str.rstrip() ;
#remote_files_list = [ f1.split()[-1] for f1 in [ f for f in remote_files_str.split("\n") ] ]
#print remote_files_list

# generate remote files list bc rsync isn't working well with ansible
remote_files_list = []
for i in range( 0, numobjs ) :
  if( data_file_suffix == "NONE" ) :
    remote_files_list.append( data_file_prefix + str(i) )
  else :
    remote_files_list.append( data_file_prefix + str(i) + data_file_suffix )


obj_counter=0
for f in remote_files_list :
  # scp one object file at a time into secondary storage on local
  cmd0 = "su - " + this_user + " -c 'scp -o StrictHostKeyChecking=no -r " + \
             this_user + "@" + data_node_addr + ":" + data_path + "/" + data_dir + "/" + f + " /mnt/" + osd_dev_name + "/'" + " ;"
  print cmd0
  os.system( cmd0 )

  # load object file into ceph
  remote_files_str = subprocess.check_output(["bash", \
                                              "rados_put.sh", \
                                              pool_name, \
                                              osd_dev_name, \
                                              f, \
                                              str( obj_counter )])
  obj_counter += 1

  # delete the object file from local
  cmd2 = "rm -rf /mnt/" + osd_dev_name + "/" + f + " ; sleep 1 ;"
  print cmd2
  os.system( cmd2 )
