#!/usr/bin/bash

sudo swapoff /swapfile

sudo dd if=/dev/zero of=/swapfile bs=1N count=1024

sudo mkswap /swapfile

sudo swapon /swapfile
