# docker-haproxygen
Dockerfile for Haproxy + Dockergen

## Configuration
### Virtual host configuration
### HTTP Redirection

Use the environment variable **HTTP_REDIRECT_FROM** to redirect from a domain or a list of domains.

Example 1:
```
    environment:
      - VIRTUAL_HOST_SECURE=www.example.com
      - HTTP_REDIRECT_FROM=example.com
```

This configuration declares **www.example.com** as the main domain, and will redirect all requests without the leading www to this domain.

Example 2:
```
    environment:
      - VIRTUAL_HOST_SECURE=www.example.com
      - HTTP_REDIRECT_FROM=example.com,example.fr,example.de
```

This configuration declares **www.example.com** as the main domain, and will redirect all requests without the leading www, from example.fr and from example.de to this domain.

### Proxy statistics

- **STATS_ENABLE** : Enable the HAProxy stats page at /haproxy
- **STATS_USER** : Basic HTTP authentication user
- **STATS_PASSWORD** : Basic HTTP authentication password

Example:
```
docker run -e 'STATS_ENABLE=true' ...
docker run -e 'STATS_ENABLE=true' -e 'STATS_USER=haproxy' -e 'STATS_PASSWORD=password' ...
```

### Expose the Docker Engine

This feature offers an alternative to [securing the Docker daemon socket with a client certificate](https://docs.docker.com/engine/security/https/).

The Docker API is exposed through the reverse proxy with TLS and an optional basic authentication.

- **EXPOSE_DOCKER_API_HOST** : Expose the docker engine API on this host name
- **EXPOSE_DOCKER_API_USER** : Basic HTTP authentication user
- **EXPOSE_DOCKER_API_PASSWORD** : Basic HTTP authentication password

Example 1:
```
    environment:
      - EXPOSE_DOCKER_API_HOST=docker.mycompany.com
```

Configure your Docker client:

```
DOCKER_CERT_PATH=~/.docker/certs
DOCKER_HOST=tcp://docker.mycompany.com:443
DOCKER_TLS_VERIFY=1
```

As an alternative, you can use the command **docker --tls [...]**

Example 2:
```
    environment:
      - EXPOSE_DOCKER_API_HOST=docker.mycompany.com
      - EXPOSE_DOCKER_API_USER=admin
      - EXPOSE_DOCKER_API_PASSWORD=secret123
```

Configure your Docker client:

```
export DOCKER_CERT_PATH=~/.docker/certs
export DOCKER_HOST=tcp://docker.mycompany.com:443
export DOCKER_TLS_VERIFY=1
export DOCKER_CONFIG=~/.docker
```

```
In your ~/.docker/config.json
{
	"HttpHeaders": {
		"Authorization": "Basic YWRtaW46c2VjcmV0MTIz"
	}
}
```

### Use prerender

This feature allows websites to be crawled by search engines (Google, Facebook...). You must install [Prerender](https://prerender.io/) as a backend first. 

Environment variables:

- **PRERENDER_HOST** : The Prerender backend is configured at this address 
- **PRERENDER_AUTH_HEADER** : Authentify with this header

Example:

```
      - PRERENDER_HOST=prerender.mycompany.com
      - PRERENDER_AUTH_HEADER=YWRtaW46c2VjcmV0MTIz
```

