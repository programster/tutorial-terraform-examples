#!/bin/bash
# This is an example script for rundeck to run against servers in order to update them.

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get dist-upgrade -y