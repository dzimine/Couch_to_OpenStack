# 
# Creatively copied from devstack 
# http://devstack.org/lib/horizon.html
# Only Ubuntu for now, for cross-distro, see devstack

############################################
# Install Horizon from sources
. /vagrant/.controller
. /vagrant/client/params.sh


sudo mkdir -p $TOP_DIR
sudo chown $USER $TOP_DIR

git clone https://github.com/openstack/horizon.git $HORIZON_DIR

cp $HORIZON_DIR/openstack_dashboard/local/local_settings.py.example $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sudo sed -i "s/^OPENSTACK_HOST.*/OPENSTACK_HOST = \"${CONTROLLER_HOST}\"/g" $HORIZON_DIR/openstack_dashboard/local/local_settings.py

sudo pip install -r $HORIZON_DIR/requirements.txt

# At this point, we can run horizon in django dev server 
# cd $HORIZON_DIR
# python manage.py runserver 0.0.0.0:80
#


############################################
# Configure to run Horozon on Apache

APACHE_NAME=apache2
APACHE_USER=${APACHE_USER:-$USER}
APACHE_GROUP=${APACHE_GROUP:-$(id -gn $APACHE_USER)}
DEST=not_used
FILES=/vagrant/client
ST2_HORIZON=$TOP_DIR/stackstorm/horizon-plugins

mkdir -p $HORIZON_DIR/.blackhole

sudo sh -c "sed -e \"
      s,%USER%,$APACHE_USER,g;
      s,%GROUP%,$APACHE_GROUP,g;
      s,%HORIZON_DIR%,$HORIZON_DIR,g;
      s,%APACHE_NAME%,$APACHE_NAME,g;
      s,%DEST%,$DEST,g;
      s,%HORIZON_REQUIRE%,$HORIZON_REQUIRE,g;
  \" $FILES/apache-horizon.template >horizon.conf"

sudo mv horizon.conf /etc/$APACHE_NAME/conf.d/horizon.conf

sudo sudo /etc/init.d/apache2 restart