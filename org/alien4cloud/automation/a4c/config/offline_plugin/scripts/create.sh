#!/bin/bash

sudo mkdir "${document_root}/kikoo"

sudo bash -c "echo '<html><body>kikoo listening on ${ip_address}:${port} !</body></html>' > '${document_root}/kikoo/index.html'"
