# Comment out common.sh to save apt-get update
# . /vagrant/common.sh

# The routeable IP of the node is on our eth1 interface
MY_IP=$(ifconfig eth1 | awk '/inet addr/ {split ($2,A,":"); print A[2]}')


. /vagrant/client/install-prereqs.sh

# For setting up horizon, we want vagrant, not root
sudo -u vagrant /vagrant/client/setup-horizon.sh

# Configure ssh access to compute nodes
sudo -u vagrant cp /vagrant/id_rsa_libvirt /home/vagrant/.ssh/
sudo -u vagrant cp /vagrant/id_rsa_libvirt.pub /home/vagrant/.ssh/
eval `ssh-agent -s` && ssh-add /home/vagrant/.ssh/id_rsa_libvirt
# Test:
# ssh vagrant@172.16.80.211 uname 
# virsh -c  qemu+ssh://vagrant@172.16.80.211/system?socket=/var/run/libvirt/libvirt-sock list
