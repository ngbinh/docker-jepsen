#!/bin/bash

<%= import 'scripts/vagrant-shell-scripts/ubuntu.sh' %>
<%= import 'scripts/vagrant-shell-scripts/ubuntu-extras.sh' %>

# }}}

# Use Google Public DNS for resolving domain names.
# The default is host-only DNS which may not be installed.
# nameservers-local-purge
# nameservers-append '8.8.8.8'
# nameservers-append '8.8.4.4'

# Update packages cache.
apt-packages-update

# Install VM packages.
apt-packages-install \
  rsync \
  telnet \
  wget \
  git \
  curl\
  whois

download_dir="/vagrant/.downloads/oracle-jdk-download"
# Get new values here
# http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
mkdir -p "$download_dir" && oracle-jdk-install "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz" "$download_dir"

# create user spark if necessary
if [ getent passwd ubuntu > /dev/null 2>&1 ]; then
	echo "user ubuntu exists. Skipping create user"
else
	echo "creating (sudo) user ubuntu"
    #sudo useradd -m -G `groups vagrant | cut -d" " -f4- | sed 's/ /,/g'` -s/bin/bash -p `mkpasswd spark` spark-user
  sudo useradd -m -G `id -Gn vagrant | tr ' ' ','` -p `mkpasswd spark` ubuntu
  echo "sucess"
fi
# done. Create user