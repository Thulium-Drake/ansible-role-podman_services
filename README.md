# Podman services catalogue
This role contains a collection of services that run on a Podman node. All persistent storage is configured to use Podman Volumes. If desired, you can change the driver used by the volumes, by default it uses 'local'.

The catalogus currently contains:

* arr: A full arr stack with transmission
* authentik: Open-source Identity Provider focused on flexibility and versatility
* hello_world: a simple container that will return 'hello world' via a REST API
* homeassistant: Open source home automation that puts local control and privacy first
* vaultwarden: A free alternative server for the Bitwarden Password Manager
* factorio: The Factorio server
* minecraft: The Minecraft Server

# Deployment
In order to use the services from this catalogue, do the following:

* Install the ```containers.podman``` collection on your Ansible controller
* Install Podman (tip: use my Podman role)
* Copy ``` defaults/main.yml ``` and configure it
* Run the role with a playbook such as:

```
---
- hosts: 'podman'
  roles:
    - 'podman_services'
```

## Deployment scenarios
This role can support running rootless, but it requires one of the following:

* Run the role with ```become: false```, the role will detect the current user and use that for configuring services.
* Run the role with ```become: true``` and ```podman_user_account``` defined to the target user that runs the contianers.

If you want to run the containers as root:

* Run the role with ```become: true``` and no ```podman_user_account``` configured.

## ARR stack notes
Configuring the ARR stack should mostly still be done by hand, all containers are reachable for each other by their container name (which is arr-$APP, e.g. arr-sonarr) on their default ports.

NOTE: Keep in mind that reaching the apps from your pc uses the hostname of the podman host! The apps themselves are configured to connect to each other using a Podman network and uses an alternative DNS source!

Configuring the integrations between the different apps works as follows:

  * Go to the source app -> Settings -> General and retrieve the API key
  * Go to the target app and paste the API key
  * The server address inside the app will be http://arr-$APP:$PORT (e.g. http://arr-prowlarr:9696 and http://arr-radarr:7878)

### Sabnzbd specific notes
The application uses a sort of hostname matching to prevent all kinds of nastiness. You'll need to follow the instructions on https://sabnzbd.org/wiki/extra/hostname-check.html to configure the app properly.

When doing so, also make sure to add ```arr-sabnzbd``` as a hostname in order for the integrations with the rest of the tools to work!

## Homeassistant notes
If you don't directly expose homeassistant to your network and use a reverse proxy, add the following to the ```configuration.yaml``` to enable reverse proxying:

1. Go to the folder where the homeassistant volume's data is (default should be something like ```~/.local/share/containers/storage/volumes/homeassistant/_data``` or ```/var/lib/containers/storage/volumes/homeassistant/_data```
2. Edit ```configuration.yaml``` and add the following:
```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1/32
    - ::1/128
```

3. Restart the service

## Authentik notes
Authentik is an open-source Identity Provider that provides authentication and authorization services. The service consists of multiple containers:

* **PostgreSQL**: Database backend for authentik
* **Redis**: Cache and message broker
* **Server**: Main authentik web interface and API
* **Worker**: Background task processor

### Important configuration
Before deploying authentik, you **must** change the following default values:

1. **authentik_secret_key**: Generate a secure random key (at least 50 characters)
2. **authentik_postgres_password**: Set a strong database password

### Initial setup
1. After deployment, access authentik at `http://your-host:9000` (or your configured port)
2. The initial setup wizard will guide you through creating an admin account
3. Configure your authentication flows and providers as needed

### Docker socket access
The worker container can optionally access the Docker socket for container management features. This is controlled by:
* `authentik_worker_docker_socket: true/false`
* `authentik_worker_user_root: true/false` (required for socket access)

If you don't need container management features, set both to `false` for better security.

### Containers and networking
The authentik service consists of multiple containers that communicate via a dedicated network:
* `authentik-postgresql`: Database backend
* `authentik-redis`: Cache and message broker
* `authentik-server`: Main web interface and API (exposed on configured ports)
* `authentik-worker`: Background task processor

All containers communicate via the `authentik-backend` network.

### Volumes
The service creates the following Podman volumes for persistent data:
* `authentik-postgresql_data`: PostgreSQL database data
* `authentik-redis_data`: Redis cache data
* `authentik-media`: Media files and uploads
* `authentik-templates`: Custom templates
* `authentik-certs`: SSL certificates

All volumes use the configured `podman_volume_driver` (default: 'local').
