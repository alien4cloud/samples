#!/bin/bash

sudo sed -i "/<Proxy balancer:\/\/mycluster>/a BalancerMember $WEB_APPLICATION_URL" /etc/apache2/conf.d/proxy-balancer

sudo /etc/init.d/apache2 restart