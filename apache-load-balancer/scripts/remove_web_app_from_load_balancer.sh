#!/bin/bash

sed -i '/BalancerMember $WEB_APPLICATION_URL/d' /etc/apache2/conf.d/proxy-balancer

/etc/init.d/apache2 restart