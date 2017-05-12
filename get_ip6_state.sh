#!/bin/bash
# Because ssh eats input after being called, we need to use different descriptor for input redirection for read
while read -u10 srv; do
   printf "$srv : "
   ssh root@$srv "ip a | grep inet6"
done 10< serv_list.txt

