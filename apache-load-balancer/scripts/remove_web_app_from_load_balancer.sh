#!/bin/bash

sudo sed -i "/BalancerMember $WEB_APPLICATION_URL/d" /etc/apache2/conf.d/proxy-balancer

sudo /etc/init.d/apache2 restart