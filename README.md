# docker nginx-http3

public image
```
docker run -p 8443:8443 -p 8443:8443/udp -v <path to>/certs:/etc/nginx/certs --rm -it masanetes/nginx-http3:latest
```

self build
```
git clone https://github.com/masanetes/nginx-http3.git
cd nginx-http3
docker build . -t nginx-http3:latest
docker run -p 8443:8443 -p 8443:8443/udp -v $(pwd)/certs:/etc/nginx/certs --rm -it nginx-http3:latest
```

# Ref

https://boringssl.googlesource.com/boringssl/+/HEAD/BUILDING.md

https://quic.nginx.org/readme.html
