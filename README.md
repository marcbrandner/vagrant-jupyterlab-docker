__THIS REPOSITORY IS ARCHIVED.__ Use the [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/) instead. Working with containers - including building custom container images - is way more efficient than installing Python packages and JupyterLab extensions in a Vagrant box.

_____

A Vagrant box providing my JupyterLab environment. Comes with many popular Data Science packages for Python and doesn't care about Python Virtual Envs. Based on a container run by Docker ([`docker.io/jupyter/base-notebook:python`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#core-stacks)). Choice of packages is strongly opinionated.


# Requirements

* VirtualBox 6.x
* Vagrant


# Getting Started

## Clone This Repo

```
git clone https://github.com/marcbrandner/vagrant-jupyterlab-docker.git
```

## Adjust Sizing

Adjust the sizing to your needs by copying `vagrant_default.yaml` to `vagrant_custom.yaml` and modfiying its properties.

## Set Synced Folder

The box mounts the path given in property `synced_folders` in files `vagrant_default.yaml` or `vagrant_custom.yaml` (has precedence). This way you can access your existing notebooks and data files and also make sure, that your notebooks are saved persistently on your host machine. Example for a Windows machine:
```
[...]
synced_folders:
  - box_path: "/data/project_a"
    host_path: "C:/some/path"
  - box_path: "/data/project_b"
    host_path: "C:/some/other/path"
[...]
```
__NOTICE:__ Use a `box_path` starting with a root path of `/data/` to be able to use it JupyterLab.

## Install Vagrant Plugins

```
vagrant plugin install \
    vagrant-disksize \
    vagrant-hostmanager \
    vagrant-hosts \
    vagrant-reload \
    vagrant-vbguest
```

## Build Box

Then fire up the box:
```
vagrant up
```

__Please note:__ Some of selected packages are heavy (100 MB +). Depending on your bandwidth and allocated CPU cores, setting up the box for the first time may take up time for one or two cups of coffee.

## Access JupyterLab

After the box is up, access it with a browser on the VirtualBox host: `http://localhost:8123`.

__Be careful:__ Token authentication is disabled.

Files mounted using `synced_paths` in `vagrant_custom.yaml` can be accessed via folder `work` in JupyterLab's scope in the file browser.


# Advanced

## Modifying JupyterLab

__First Option:__

To install Python packages without a complete rebuild, enter the container in the VM:
```
# Enter VM
vagrant ssh

# Enter container
docker exec -it jupyterlab /bin/bash

# Install package (for example 'wget')
pip install wget

# Exit the container
exit

# Persists the changes to the pre-built image
docker commit $(sudo docker ps -a --filter name=jupyterlab -q) jupyterlab-custom:latest
```

__Second Option:__

Alternative way of adding Python packages or JupyterLab extensions:
* Modify `Dockerfile`
* Enter the Vagrant box: `vagrant ssh`
* Run the `install.sh` script once again:
```
bash /vagrant/scripts/build.sh
bash /vagrant/scripts/run.sh
```

## Recreate JupyterLab Container

Delete and recreate the container using script `run.sh`:
```
# Enter VM
vagrant ssh

# Execute run.sh script
bash /vagrant/scripts/run.sh
```

__Notice:__ The `jupyterlab` container mounts `/tmp/python-cache` from the Vagrant box into the container on `/home/jovyan/.cache`. This way downloaded TensorFlow models, PyTorch models and other cached downloads survive a container restart.

## Exec JupyterLab Container as `root`
```
docker exec -it --user root jupyterlab bash
```
