#! /bin/bash
# login to A4C
curl -c cookie.txt -L -k -s -d "username=${A4C_LOGIN}&password=${A4C_PWD}" ${A4C_URL}/login
