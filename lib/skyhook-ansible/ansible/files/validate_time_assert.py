import subprocess
import sys

def main() :

  real_time_lhs = 0
  lhs_counter   = 0
  with open( sys.argv[1] ) as fp:
    for i, line in enumerate(fp):
      if "real" in line :
        line = line.rstrip()
        line = line.split()
        real_time_lhs += float( line[1] )
        lhs_counter += 1

  real_time_rhs = 0
  rhs_counter   = 0
  with open( sys.argv[2] ) as fp:
    for i, line in enumerate(fp):
      if "real" in line :
        line = line.rstrip()
        line = line.split()
        real_time_rhs += float( line[1] )
        rhs_counter += 1

  lhs_avg = (real_time_lhs / lhs_counter)
  rhs_avg = (real_time_rhs / rhs_counter)

  try :
    assert( lhs_avg <= rhs_avg )
  except AssertionError :
    print "ERROR: avg execution time in '" + sys.argv[1] + " (" + str( lhs_avg ) + "sec)" + \
          "' is not <= avg execution time in '" + sys.argv[2] + " (" + str( rhs_avg ) + "sec)"

if __name__ == "__main__" :
  assert sys.version_info >= (2, 7)
  main()
