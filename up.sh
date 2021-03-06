# Generate key pair and register keys for ssh
# The public keys will be deployed to compute nodes

ssh-keygen -t rsa -N "libvirt access" -P "" -f id_rsa_libvirt
cp id_rsa_libvirt ~/.ssh/
cp id_rsa_libvirt.pub ~/.ssh/
# eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa_libvirt

# Trigger vagrant (time it)
source timer.sh 
t=$(timer)
vagrant up
printf 'Elapsed time: %s\n' $(timer $t)
