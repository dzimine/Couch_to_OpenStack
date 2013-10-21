# Comment out common.sh to save apt-get update
# . /vagrant/common.sh

source /vagrant/.controller

# The routeable IP of the node is on our eth1 interface
MY_IP=$(ifconfig eth1 | awk '/inet addr/ {split ($2,A,":"); print A[2]}')


. /vagrant/client/install-prereqs.sh

sudo -u vagrant /vagrant/client/setup-horizon.sh


