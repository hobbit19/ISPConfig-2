# Linux distros check

LinuxDistros() {
#Extract information on system
  . /etc/os-release

# Set DISTRO variable to null
  DISTRO=''

# Ubuntu 16.04
  if echo $ID-$VERSION_ID | grep -iq "ubuntu-16.04"; then
		DISTRO=ubuntu-16.04
  fi
    
# CentOS 7
  if echo $ID-$VERSION_ID | grep -iq "centos-7"; then
		DISTRO=centos7
  fi

}

