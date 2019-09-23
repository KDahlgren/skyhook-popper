#! bin/bash

set -x

FILE_ADDRESSES=(
  "https://users.soe.ucsc.edu/~kdahlgren/pdsw19/expecteddata/expected_$1_q1_match.txt"
  "https://users.soe.ucsc.edu/~kdahlgren/pdsw19/expecteddata/expected_$1_q2_match.txt"
  "https://users.soe.ucsc.edu/~kdahlgren/pdsw19/expecteddata/expected_$1_q3_match.txt"
  "https://users.soe.ucsc.edu/~kdahlgren/pdsw19/expecteddata/expected_$1_q4_match.txt"
)
rm expected_*.txt ;
wget "${FILE_ADDRESSES[@]}" ;
