#!/bin/sh
docker run --rm -v $(pwd):/home/user/project winterhate/nim-avr-devel make "$@"