require 'spec_helper'

describe 'common', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  describe "no parameters" do

    it { should create_class('common') }
    [ 'bash-completion', 'iftop', 'iotop', 'lsof', 'man', 'openssh-clients', 'rsync', 'screen',
      'unzip', 'wget' ].each do |package|
      it { should create_package(package) }
    end
    it { should create_package('ec2-boot-init').with_ensure('absent') }

    it "should disable services" do
      [ 'cups', 'messagebus', 'netfs', 'portreserve' ].each do |service|
        should contain_service(service).with(
          'ensure'  => 'stopped',
          'enable'  => 'false'
        )
      end
    end

    it { should contain_file('/etc/init/control-alt-delete.conf').with_ensure('absent') }
    it { should contain_file('/etc/sysconfig/init') }
    it { should contain_file('/etc/profile.d/ps1.sh') }
    it { should contain_mailalias('root').with_ensure('absent') }
    it { should_not contain_mount('/') }
    it { should_not contain_beaver__stanza('/var/log/messages') }
    it { should_not contain_beaver__stanza('/var/log/secure') }
    it { should_not contain_beaver__stanza('/var/log/sudolog') }
  end

  describe 'root alias' do
    let(:params) { { :root_mail => 'sucker@example.com' } }

    it { should contain_mailalias('root').with_ensure('present').with_recipient('sucker@example.com') }
    it { should contain_exec('common_newaliases') }
  end

  describe 'beaver logging' do
    let(:params) { { :logsagent => 'beaver' } }

    it { should contain_beaver__stanza('/var/log/messages') }
    it { should contain_beaver__stanza('/var/log/secure') }
    it { should contain_beaver__stanza('/var/log/sudolog') }
  end

end
