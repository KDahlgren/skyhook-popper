import subprocess
import sys

def main() :
  try :
    subprocess.check_output( [ 'diff', sys.argv[1], sys.argv[2] ] )
  except subprocess.CalledProcessError :
    print "ERROR: contents of files '" + sys.argv[1] + "' and '" + sys.argv[2] + "' do not match."

if __name__ == "__main__" :
  assert sys.version_info >= (2, 7)
  main()
