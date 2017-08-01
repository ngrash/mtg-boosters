#!/bin/bash
docker build -t magic_limiter .
docker rm -f magiclimiter
docker run -d -e PORT=3000 -p 3000:3000 --link magiclimiterdb:database --name magiclimiter magic_limiter
