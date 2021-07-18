A Vagrant box providing my JupyterLab environment. Comes with many popular Data Science packages for Python and doesn't care about Python Virtual Envs. Based on a container run by Docker ([`docker.io/jupyter/tensorflow-notebook:latest`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#core-stacks)). 


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

The box mounts the path given in property `synced_folder` in files `vagrant_default.yaml` or `vagrant_custom.yaml` (has precedence). This way you can access your existing notebooks and data files and also make sure, that your notebooks are saved persistently on your host machine.

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

## Access JupyterLab

After the box is up, access it with a browser on the VirtualBox host: `http://localhost:8123`.

__Be careful:__ Token authentication is disabled.

Files monted on `synced_path` can be accessed via folder `work` in JupyterLab's scope in the file browser.


# Advanced

## Modifying JupyterLab

To add additional Python packages or JupyterLab extensions persistently
* modify `Dockerfile`
* enter the Vagrant box: `vagrant ssh`
* run the `install.sh` script once again:
```
bash /vagrant/scripts/build_and_run.sh
```

To install Python packages without a complete rebuild, enter the container in the VM:
```
# Enter VM
vagrant ssh

# Enter container
sudo docker exec -it jupyterlab /bin/bash

# Install package (for example 'wget')
pip install wget
```

## Adding New Shared Folders

After adding new shared folders in `vagrant_custom.yaml`, delete and recreate the container.

```
# Enter VM
vagrant ssh

# Execute run.sh script
bash /vagrant/scripts/run.sh
```