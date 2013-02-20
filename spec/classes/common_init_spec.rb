require 'spec_helper'

describe 'common', :type => :class do
  let(:title) { 'init' }

  describe "Common class with no parameters, basic test" do

    it { should create_class('common') }
    [ 'iftop', 'iotop', 'lsof', 'man', 'openssh-clients', 'rsync', 'screen',
      'unzip', 'wget' ].each do |package|
      it { should create_package(package) }
    end
    it { should create_package('ec2-boot-init').with_ensure('absent') }

    it { should contain_service('cups').with(
      'ensure'  => 'stopped',
      'enable'  => 'false'
    ) }

    it { should contain_file('/etc/init/control-alt-delete.conf').with_ensure('absent') }

  end

end
