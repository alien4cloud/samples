#!/bin/bash

( sudo service docker status | grep -q 'running' ) || sudo service docker start