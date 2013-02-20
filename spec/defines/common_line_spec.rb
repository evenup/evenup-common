require 'spec_helper'
 
describe 'common::line' do
  let :default_params do
    {
      'ensure'  => 'present'
    }
  end
  
  let(:title) { 'peerntp-eth0' }
  
  describe 'eth0 with PEERNTP=no present' do
    let :params do
      default_params.merge(
        {
          'file' => '/etc/sysconfig/network-scripts/ifcfg-eth0', 
          'line' => 'PEERNTP=no'
        }
      )
    end
    it {
      should contain_exec("/bin/echo 'PEERNTP=no' >> '/etc/sysconfig/network-scripts/ifcfg-eth0'").with(
        'logoutput' => 'on_failure',
        'unless'    => "/bin/grep -qFx 'PEERNTP=no' '/etc/sysconfig/network-scripts/ifcfg-eth0'"
      )
    }
  end
     
  describe 'eth0 with PEERNTP=yes absent' do
    let :params do
      default_params.merge(
        {
          'file'    => '/etc/sysconfig/network-scripts/ifcfg-eth0', 
          'line'    => 'PEERNTP=yes',
          'ensure'  => 'absent'
        }
      )
    end
    it {
      should contain_exec("/usr/bin/perl -ni -e 'my \$string = quotemeta(\"PEERNTP=yes\") ; print unless /^(\$string)\$/' '/etc/sysconfig/network-scripts/ifcfg-eth0'").with(
        'logoutput' => 'on_failure',
        'onlyif'    => "/bin/grep -qFx 'PEERNTP=yes' '/etc/sysconfig/network-scripts/ifcfg-eth0'"
      )
    }
  end

  describe 'eth0 with PEERNTP=yes commented' do
    let :params do
      default_params.merge(
        {
          'file'    => '/etc/sysconfig/network-scripts/ifcfg-eth0', 
          'line'    => 'PEERNTP=yes',
          'ensure'  => 'comment'
        }
      )
    end
    it {
      should contain_exec("/bin/sed -i -e'/PEERNTP=yes/s/^\\(.\\+\\)$/#\\1/' '/etc/sysconfig/network-scripts/ifcfg-eth0'").with(
        'logoutput' => 'on_failure',
        'onlyif'    => "/usr/bin/test `/bin/grep 'PEERNTP=yes' '/etc/sysconfig/network-scripts/ifcfg-eth0' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
      )
    }
  end

  describe 'eth0 with PEERNTP=yes uncommented' do
    let :params do
      default_params.merge(
        {
          'file'    => '/etc/sysconfig/network-scripts/ifcfg-eth0', 
          'line'    => 'PEERNTP=yes',
          'ensure'  => 'uncomment'
        }
      )
    end
    it {
      should contain_exec("/bin/sed -i -e'/PEERNTP=yes/s/^#\\+//' '/etc/sysconfig/network-scripts/ifcfg-eth0'").with(
        'logoutput' => 'on_failure',
        'onlyif'    => "/bin/grep 'PEERNTP=yes' '/etc/sysconfig/network-scripts/ifcfg-eth0' | /bin/grep '^#' | /usr/bin/wc -l"
      )
    }
  end

end
