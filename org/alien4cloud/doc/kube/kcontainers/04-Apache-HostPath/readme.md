In this example, we deploy an apache and expose it via a NodePort services.
A volume of type HostPath is attached to the container and /proc/1 from the host is mounted at /usr/local/apache2/htdocs so we can access logs from web browser.
