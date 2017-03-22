#!/bin/bash

( sudo service docker status | grep 'running' ) && sudo service docker stop