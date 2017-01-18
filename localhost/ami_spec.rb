require 'spec_helper'
# Packages
#

describe package('awscli') do
  it { should be_installed }
end

describe package('aws-cfn-bootstrap') do
  it { should be_installed }
end

describe package('docker') do
  it { should be_installed }
end

describe package('mozilla-services-aws-release-7-1') do
  it { should be_installed }
end

describe package('puppet-3.8.7') do
  it { should be_installed }
end

describe package('sops') do
  it { should be_installed.with_version('2.0.6') }
end

describe package('yum-plugins-s3-iam') do
  it { should be_installed }
end

describe package('firewalld') do
  it { should_not be_installed }
end

# Files
describe file('/etc/svcops-release') do
  it { should be_file}
end

describe file('/etc/systemd/system/default.target') do
  it { should be_symlink }
  it { should be_linked_to '/lib/systemd/system/multi-user.target' }
end

describe file('/root/install_cloudops_puppet.sh') do
  it { should be_file }
  it { should be_mode 700 }
  its(:size) { should eq 568 }
end

describe file('/root/install_sysdig.sh') do
  it { should be_file }
  it { should be_mode 700 }
  its(:size) { should eq 310 }
end

describe file('/root/prep_ami.sh') do
  it { should be_file }
  it { should be_mode 755 }
end

describe file('/usr/bin/dockerpull.sh') do
  it { should be_file }
  it { should be_mode 755 }
  its(:size) { should eq 107 }
end

describe file('/usr/lib/systemd/system-shutdown/debug.sh') do
  it { should be_file }
  it { should be_mode 755 }
  its(:size) { should eq 80 }
end

describe file('/etc/cloud/cloud.cfg') do
  it { should be_file }
  its(:sha256sum) { should eq '8d314924ba14a97c9a4a7398741b07ad44a1724f158ad028cf61dcb8325113a1' }
end

describe file('/etc/lvm/profile/dvg-dockerdata.profile') do
  it { should be_file }
  its(:sha256sum) { should eq '6067923f3eb40f9b55ad71e6f7839e5d75a5dbf50489a6fdd1dda70c74b64730' }
end

describe file('/etc/systemd/journald.conf') do
  it { should be_file }
  its(:sha256sum) { should eq 'fc0b47add2bf2a5eb205cab75b0e1b0cc81827ed3880e4216a03bd506a8d9ff6' }
end

describe file('/etc/systemd/system/cloud-config.service.d/local.conf') do
  it { should be_file }
  its(:sha256sum) { should eq '5305ebf589538571cbd9d5add9e7f533549d0328ed00138480ea5427e93fc3f5' }
end

describe file('/etc/systemd/system/media-ephemeral0.mount') do
  it { should be_file }
  its(:sha256sum) { should eq '160ec56505ca46f211e9e03103df3b62fd11e2f42d8f1225fbb89f7a58955927' }
end

describe file('/etc/sysconfig/docker-storage') do
  it { should be_file }
  its(:sha256sum) { should eq 'da7572e2563a09906d05eaf5ca6bfdafd78bcc803fcd5028e123e95399dd5126' }
end

describe file('/etc/ssh/sshd_config') do
  its(:content) { should match /UseDNS no/ }
end

describe file('/etc/sysconfig/firstboot') do
  it { should be_file} 
  its(:content) { should match /RUN_FIRSTBOOT=NO/ }
end

describe file('/etc/yum/pluginconf.d/fastestmirror.conf') do
  its(:content) { should_not match /enabled=1/ }
end

describe file('/usr/lib/systemd/system/cloud-final.service') do
  its(:content) { should match /After.*systemd-journald.service$/ }
end


describe interface('eth0') do
  it { should exist }
end

# Other stuff

describe file('/dev/dvg/dockerdata') do
  it { should be_symlink }
  it { should be_linked_to '../dm-2' }
end

describe file('/dev/mapper/dvg-dockerdata_tmeta') do
  it { should be_symlink }
end

describe file('/dev/mapper/dvg-dockerdata_tdata') do
  it { should be_symlink }
end

describe file('/dev/xvda2') do
  it { should be_block_device }
end 

describe group('docker') do
  it { should exist }
end

describe yumrepo('cr') do
  it { should_not be_enabled }
end

describe command('/sbin/tuned-adm active') do
  its(:stdout) { should match /throughput-performance/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker info 2>&1 | grep -v WARNING | grep Pool\ Name') do
  its(:stdout) { should match /\ Pool\ Name: dvg-dockerdata/}
end
