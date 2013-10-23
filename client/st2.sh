# Attemps to install from sources.
# Run, inspect the output
#
# This doesn't attemp full reliable automation, 
# but rather a live, running documentation,
# capturing all the packages needed, and all the configurations

. params.sh

ST2_HOME=$TOP_DIR/stackstorm
mkdir -p $ST2_HOME
cd $ST2_HOME

git config --global credential.helper cache --timeout=3600

# Install Solr & set it up with osh-data
git clone --depth 1 https://github.com/StackStorm/osh-data.git
curl http://archive.apache.org/dist/lucene/solr/4.4.0/solr-4.4.0.tgz | tar xz
#TODO: clean up solr installation from all the crap...
cd osh-data/inventory/solr
sed -i "s/^SOLR_DIR.*/SOLR_DIR=..\/..\/..\/solr-4.4.0\/example/g" params.sh
# run Solr
./solr-testrun.sh

# Setup osh
cd $ST2_HOME
git clone --depth 1 https://github.com/StackStorm/osh.git
cd osh
sudo easy_install -U distribute
sudo pip install -r requirements.txt
# libvirt python bindings shall be already globally installed
# TODO: test run here
# TODO: daemonize (nohub?) and start! 

# Setup osh-ui
cd $ST2_HOME
git clone --depth 1 https://github.com/StackStorm/osh-ui.git
cd osh-ui
npm install
# test run
#TODO: daemonize and start! 

# Setup stackstorm horizon plugins
cd $ST2_HOME
git clone --depth 1 https://github.com/StackStorm/horizon-plugins.git

# Register horizon_plugins with openstack_dashboard:
# add the filed to HORIZON_CONFIG
# HORIZON_CONFIG["customization_module"] = "plugins.overrides"' in local_settings.py
# Warning: this will overwrite any existing customization modules
local_settings_file=$HORIZON_DIR/openstack_dashboard/local/local_settings.py
grep -q -e customization_module $local_settings_file || sed -i "s/^HORIZON_CONFIG = {.*/HORIZON_CONFIG = {\\
    'customization_module': 'plugins.overrides',/g" $local_settings_file

# Add plugin to python-path (so apache wsgi picks it up):
# in /etc/apache2/conf.d/horizon.conf
# add python-path=/path/to/horizon-plugins parameter to WSGIDaemonProcess
# https://code.google.com/p/modwsgi/wiki/ConfigurationDirectives#WSGIDaemonProcess
# The option that doesn't work: 
# sudo sed -i "s#\#WSGIPythonPath.*#WSGIPythonPath ${ST2_HOME}/horizon-plugins#g" /etc/apache2/conf.d/horizon.conf
sudo sed -i "s#python-path=.*#python-path=${ST2_HOME}/horizon-plugins#" /etc/apache2/conf.d/horizon.conf
sudo /etc/init.d/apache2 restart

# All shall work at this point...







