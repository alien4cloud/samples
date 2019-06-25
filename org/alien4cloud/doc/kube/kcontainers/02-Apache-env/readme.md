In this example, we just deploy an apache and expose it via a NodePort services.
The apache container has an environnement variable, ANYARG.
It is displayed in the index.html file by using postStart command in the deployment