# Linux distros check
# 리눅스 베포판 체크하여 OS에 맞는 폴더 지정

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

