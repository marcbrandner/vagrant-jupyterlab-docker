require 'yaml'

if File.exist?('vagrant_custom.yaml')
  settings_file = 'vagrant_custom.yaml'
else
  settings_file = 'vagrant_default.yaml'
end

vagrant_config = YAML.load_file(settings_file)

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.name = "jupyterlab-docker"
    vb.cpus = vagrant_config.fetch('machine').fetch('cpu')
    vb.memory = vagrant_config.fetch('machine').fetch('memory')
  end
    config.vm.define :"jupyterlab-docker" do |t|
  end
  config.vm.hostname = "jupyterlab"
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 8888, host: 8123   # access JupyterLab
  config.vm.network "forwarded_port", guest: 8050, host: 8050   # access Plotly Dash Server (started from within a notebook)
  config.vm.network "forwarded_port", guest: 8787, host: 8787   # Dask Dashboard
  config.vm.network "forwarded_port", guest: 8321, host: 8321   # Streamlit app
  if vagrant_config['synced_folders']
    vagrant_config.fetch('synced_folders').each do |record|
      config.vm.synced_folder record['host_path'], record['box_path'], disabled: false, mount_options: ["dmode=777,fmode=777"]
    end
  end
  config.vm.provision "shell", path: "scripts/install_docker.sh", privileged: true
  config.vm.provision :reload
  config.vm.provision "shell", path: "scripts/build.sh", privileged: false
  config.vm.provision "shell", path: "scripts/run.sh", privileged: false, run: "always"
  config.vm.post_up_message = "Access JupyterLab using: http://localhost:8123"
end
