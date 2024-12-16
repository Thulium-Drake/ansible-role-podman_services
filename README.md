# Podman services catalogue
This role contains a collection of services that run on a Podman node. All persistent storage is configured to use Podman Volumes. If desired, you can change the driver used by the volumes, by default it uses 'local'.

The catalogus currently contains:

* arr: A full arr stack with tranmission
* hello_world: a simple container that will return 'hello world' via a REST API
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

## ARR stack notes
Configuring the ARR stack should mostly still be done by hand, all containers are reachable for each other by their container name (which is arr-$APP, e.g. arr-sonarr) on their default ports.

NOTE: Keep in mind that reaching the apps from your pc uses the hostname of the podman host! The apps themselves are configured to connect to each other using a Podman network and uses an alternative DNS source!

Configuring the integrations between the different apps works as follows:

  * Go to the source app -> Settings -> General and retrieve the API key
  * Go to the target app and paste the API key
  * The server address inside the app will be http://arr-$APP:$PORT (e.g. http://arr-prowlarr:9696 and http://arr-radarr:7878)
