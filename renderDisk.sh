#!/bin/bash

export DISK=disk_120bbd9a1d10f0d0.img
export WORLD=TestWorld

acme --cpu 65el02 -o images/$DISK $@
cp images/$DISK ~/Library/Application\ Support/minecraft/saves/$WORLD/redpower/$DISK
