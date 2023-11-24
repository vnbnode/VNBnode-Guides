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
echo "/dev/sdc /plot2 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sdd /plot3 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sde /plot4 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sdf /plot5 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sdg /plot6 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sdh /plot7 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/sdi /plot8 ext4 defaults 0 0" >> /etc/fstab
mount -a

df -h