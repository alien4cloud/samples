In this example, we deploy an apache and expose it via a NodePort services.
A volume of type EmptyDir is attached to the container and /var/log from the host is mounted at /usr/local/apache2/htdocs so we can access logs from web browser.
