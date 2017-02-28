# web-proxy

## use
```
docker run -it -e JWT_SECRET=secret -v `pwd`/nginx.conf:/nginx.conf -v `pwd`/bearer.lua:/bearer.lua -p 8080:8080 .
```