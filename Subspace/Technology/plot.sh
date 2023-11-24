df -h

fdisk -l

fdisk /dev/sdb
n
p
1
2048
w

mkfs.ext4 /dev/sdb

mkdir /plot1

echo "/dev/sdb /plot1 ext4 defaults 0 0" >> /etc/fstab

mount -a

df -h