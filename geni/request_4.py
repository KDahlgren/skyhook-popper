import os

from geni.aggregate import cloudlab
from geni.rspec import pg
from geni import util
from random import randint

def baremetal_node(name, img, hardware_type):
    node = pg.RawPC(name)
    node.disk_image = img
    node.hardware_type = hardware_type
    return node

experiment_name = 'popper-test' + str( randint( 0, 9999) )
img = "urn:publicid:IDN+wisconsin.cloudlab.us+image+emulab-ops//UBUNTU18-64-STD"

request = pg.Request()
request.addResource(baremetal_node("client0", img, 'c220g5'))
request.addResource(baremetal_node("osd0", img, 'c220g5'))
request.addResource(baremetal_node("osd1", img, 'c220g5'))
request.addResource(baremetal_node("osd2", img, 'c220g5'))
request.addResource(baremetal_node("osd3", img, 'c220g5'))

# load context
ctx = util.loadContext(key_passphrase=os.environ['GENI_KEY_PASSPHRASE'])

# create slice
util.createSlice(ctx, experiment_name, renew_if_exists=True)

# create sliver on emulab
manifest = util.createSliver(ctx, cloudlab.Wisconsin, experiment_name, request)

# grouping inventory
groups = {
  'osds': ['osd0','osd1','osd2','osd3'],
  'clients': ['client0']
}

# output files: ansible inventory and GENI manifest
outdir = os.path.dirname(os.path.realpath(__file__))
util.toAnsibleInventory(manifest, groups=groups, hostsfile=outdir+'/hosts')
manifest.writeXML(outdir+'/manifest.xml')
