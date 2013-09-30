# 
# THIS IS DOCUMENTATION! DON'T RUN :)
# HOW TO: Configure libvirt access to over ssh to compute node
#

# 1. On client (Vagrant host): create keypair and register private key for ssh
ssh-keygen -t rsa -N "libvirt access" -P "" -f id_rsa_libvirt
cp id_rsa_libvirt ~/.ssh/
cp id_rsa_libvirt.pub ~/.ssh/ #one day you'll want to delete it and need pub for this
# May be needed to fix Fix "Could not open a connection to your authentication agent."
# eval $(ssh-agent)
# Add key to ssh-agent
ssh-add ~/.ssh/id_rsa_libvirt

# 2. On target server(s) (compute node VM): deploy public key
cat id_rsa_libvirt.pub >>~/.ssh/authorized_keys

# 3. Test ssh
# On client (Vagrant host): 
# Test ssh
ssh  vagrant@172.16.80.201 uname -a

# 4. Test connection to libvirt
# On Linux client
virsh -c qemu+ssh://vagrant@172.16.80.201/system list
# On Mac client
virsh -c qemu+ssh://vagrant@172.16.80.201/system?socket=/var/run/libvirt/libvirt-sock list
