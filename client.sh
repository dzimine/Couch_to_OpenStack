. /vagrant/common.sh

# The routeable IP of the node is on our eth1 interface
MY_IP=$(ifconfig eth1 | awk '/inet addr/ {split ($2,A,":"); print A[2]}')

# Install client packages:
sudo apt-get -y install vim python-keystoneclient python-glanceclient python-novaclient python-cinderclient python-quantumclient

# Install horizon dashboard (Available at http://MY_IP/horizon)
sudo apt-get install -y memcached libapache2-mod-wsgi openstack-dashboard

sudo sed -i "s/^OPENSTACK_HOST.*/OPENSTACK_HOST = \"${CONTROLLER_HOST}\"/g" /etc/openstack-dashboard/local_settings.py

# TODO: turn off memcached in Horizon
# sed -e '//,+4 s/^/#/' 

# # Create a netork and a few vm instances
. /vagrant/.stackrc
NET_NAME=thenet
NET_ID=$(quantum net-create $NET_NAME | awk '/\ id \ /{print $4}')
quantum subnet-create $NET_NAME 192.169.0.0/24

#Create smaller flavors
# nova flavor-create m1.nano `uuidgen` 128 0 1
nova flavor-create m1.micro 101 128 0 1
nova flavor-create m1.nano 102 64 0 1

nova boot --image 'Cirros 0.3' --flavor 1 --nic net-id=$NET_ID  who
nova boot --image 'Cirros 0.3' --flavor 1 --nic net-id=$NET_ID  lets
nova boot --image 'Unreal 7.1' --flavor 102 --nic net-id=$NET_ID  the_dogs
nova boot --image 'LAMP on Cirros' --flavor 102 --nic net-id=$NET_ID  out

