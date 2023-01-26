#!/bin/bash

read -p "Enter Command Number: " cmd_no

echo "executing command " $cmd_no

localdb="cwilsontest"

remoteconf="./cw1180.conf"
localconf="./defaults.conf"

case $cmd_no in

    1) # Print defaults
        mysql --defaults-file=./defaults.conf --print-defaults -t
        ;;

    2) # Drop and create remote database
        mysql --defaults-file=./cw1180.conf -t < recreate.sql
        ;;

    3) # Show remote tables
        mysql --defaults-file=$remoteconf -t < set1.sql
        ;;

    31) # Show local tables
        mysql --defaults-file=$localconf -t < set2.sql
        ;;

    32) # Show char
        mysql --defaults-file=$remoteconf -t -e "SHOW VARIABLES LIKE '%char%';"
        mysql --defaults-file=$remoteconf -t -e "SHOW VARIABLES LIKE '%collation%';"
        ;;

    4) # Export local table
        read -p "Enter Table Name: " tbl_name
        mysqldump --defaults-file=$localconf $localdb $tbl_name > $tbl_name"-table.sql"
        ;;

    41) # Export local tables EXCEPT
        read -p "Enter EXCEPT Table Name: " tbl_name
        mysqldump --defaults-file=$localconf $localdb --ignore-table=$localdb.$tbl_name > "except-"$tbl_name"-table.sql"
        ;;    

    5) # Import to remote DB
        read -p "Enter Table Name: " tbl_name
        sql=$tbl_name"-table.sql"
        mysql --defaults-file=$remoteconf -t < $sql
        ;;

    51) # Import to remote DB
        mysql --defaults-file=$remoteconf -t < "except-wp_posts-table.sql"
        # mysql --defaults-file=$remoteconf -t < "wp_posts-table.sql"
        ;;
esac