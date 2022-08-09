# docker nginx-http3

Note: 

http3 quick uses udp to communicate, so open the udp port. Also, if you do not provide a certificate, a self-certificate will be used, but this may not result in http3 communication with some browsers, etc.



public image
```
docker run -p 8443:8443/tcp -p 443:443/udp -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf -v $(pwd)/certs:/etc/nginx/certs --rm -it ureuzy/nginx-http3:latest
```

self build
```
git clone https://github.com/ureuzy/nginx-http3.git
cd nginx-http3
docker build . -t nginx-http3:latest
docker run -p 8443:8443/tcp -p 443:443/udp -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf -v $(pwd)/certs:/etc/nginx/certs --rm -it nginx-http3:latest
```


# Ref

https://boringssl.googlesource.com/boringssl/+/HEAD/BUILDING.md

https://quic.nginx.org/readme.html
