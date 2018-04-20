# Squid

Minimal Squid docker image based on Alpine Linux 3.7.

[![](https://images.microbadger.com/badges/version/rootlogin/squid.svg)](https://microbadger.com/images/rootlogin/squid "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/rootlogin/squid.svg)](https://microbadger.com/images/rootlogin/squid "Get your own image badge on microbadger.com")

## Usage

It's recommended that you use host networking when running squid, that you can see the source IP. Otherwise you will see the IP of your docker host.

```
docker run --net=host --name=myproxy rootlogin/squid
```

To use this proxy, configure your environment or operating system correctly:

```
export http_proxy=http://PROXY_HOST:3128
export https_proxy=http://PROXY_HOST:3128
```

**Port 3128** is default.

### Volumes

* **/cache**: Here goes the squid cache
* **/logs**: Here goes the squid logs

## Configuration

If you want to configure things like authentication, you should overwrite the default squid configuration. You can do this either by using the volume function of docker, or by creating a child image. You should use the included configuration as base.

**Via Volume**
```
docker run --net=host --name=myproxy -v ./mysquid.conf:/etc/squid/squid.conf rootlogin/squid
```

**Via childimage**
```
FROM rootlogin/squid

COPY mysquid.conf /etc/squid/squid.conf
```
