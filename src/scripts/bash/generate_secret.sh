#!/bin/sh

openssl rand -base64 32 | sed 's/[\/+=]//g' | tr -d '\n'
