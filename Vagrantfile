require 'yaml'

if File.exist?('vagrant_custom.yaml')
  settings_file = 'vagrant_custom.yaml'
else
  settings_file = 'vagrant_default.yaml'
end

x = YAML.load_file(settings_file)

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.name = "jupyterlab-docker"
    vb.cpus = x.fetch('machine').fetch('cpu')
    vb.memory = x.fetch('machine').fetch('memory')
  end
    config.vm.define :"jupyterlab-docker" do |t|
  end
  config.vm.hostname = "jupyterlab"
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 8888, host: 8123   # access JupyterLab
  config.vm.network "forwarded_port", guest: 8050, host: 8050   # access Plotly Dash Server (started from within a notebook)
  config.vm.network "forwarded_port", guest: 8787, host: 8787   # Dask Dashboard
  config.vm.synced_folder x.fetch('synced_folder'), "/data"
  config.vm.provision "shell", path: "scripts/install_docker.sh", privileged: false
  config.vm.provision "shell", path: "scripts/build_and_run.sh", privileged: false
  config.vm.post_up_message = "Access JupyterLab using: http://localhost:8123"
end
