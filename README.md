# docker nginx-http3

public image
```
docker run -p 8443:8443 -p 8443:8443/udp --rm -it masanetes/nginx-http3:latest
```

self build
```
git clone https://github.com/masanetes/nginx-http3.git
cd nginx-http3
docker build . -t nginx-http3:latest
docker run -p 8443:8443 -p 8443:8443/udp --rm -it nginx-http3:latest
```

# Ref

https://boringssl.googlesource.com/boringssl/+/HEAD/BUILDING.md

https://quic.nginx.org/readme.html
