# Podman services catalogue
This role contains a collection of services that run on a Podman node. All persistent storage is bind-mounted into the container, this allows for placing that data on shared storage, such as NFS or GlusterFS.

The catalogus currently contains:

* hello_world: a simple container that will return 'hello world' via a REST API
* vaultwarden: A free alternative server for the Bitwarden Password Manager

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
