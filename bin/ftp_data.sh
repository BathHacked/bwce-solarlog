#!/usr/bin/env bash
#Download all data files from BWCE monitoring site

#SCHOOLS=(271096109 1344890667 1076738551 539780016 1882044826 2997345 1345174470 1345186820 1613593593 808303126)

cd data

for id in "$@"
do
  mkdir -p $id
  cd $id
  ncftpget -f ../../config/ncftp_config . $id/*.csv
  cd ..
done
