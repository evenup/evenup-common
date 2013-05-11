require 'spec_helper'

describe 'common', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  describe "Common class with no parameters, basic test" do

    it { should create_class('common') }
    [ 'bash-completion', 'iftop', 'iotop', 'lsof', 'man', 'openssh-clients', 'rsync', 'screen',
      'unzip', 'wget' ].each do |package|
      it { should create_package(package) }
    end
    it { should create_package('ec2-boot-init').with_ensure('absent') }

    it { should contain_service('cups').with(
      'ensure'  => 'stopped',
      'enable'  => 'false'
    ) }

    it { should contain_file('/etc/init/control-alt-delete.conf').with_ensure('absent') }
    it { should contain_file('/etc/sysconfig/init') }
    it { should contain_file('/etc/profile.d/ps1.sh') }

  end

  describe 'beaver logging' do
    let(:params) { { :logsagent => 'beaver' } }

    it { should contain_beaver__stanza('/var/log/messages') }
    it { should contain_beaver__stanza('/var/log/secure') }
    it { should contain_beaver__stanza('/var/log/sudolog') }
  end

end
