require 'spec_helper'

describe 'common', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat', :disposition => 'prod' } }

  describe "no parameters" do

    it { should create_class('common') }
    it { should contain_file('/etc/sysconfig/init') }
    it { should contain_file('/etc/profile.d/ps1.sh') }
    it { should contain_mailalias('root').with_ensure('absent') }
    it { should_not contain_file('/usr/local/bin/tmpclean.sh') }
    it { should contain_cron('tmpclean').with(:ensure => 'absent') }
    it { should_not contain_mount('/') }
    it { should_not contain_beaver__stanza('/var/log/messages') }
    it { should_not contain_beaver__stanza('/var/log/secure') }
    it { should_not contain_beaver__stanza('/var/log/sudolog') }
  end

  describe 'install packages' do
    let(:params) { { :install_packages => ['wget', 'lsof'] } }

    it { should contain_package('wget').with(:ensure => 'installed') }
    it { should contain_package('lsof').with(:ensure => 'installed') }
  end

  describe 'remove packages' do
    let(:params) { { :absent_packages => ['cups', 'nfs-utils'] } }

    it { should contain_package('cups').with(:ensure => 'absent' ) }
    it { should contain_package('nfs-utils').with(:ensure => 'absent' ) }
  end

  describe 'stop services' do
    let(:params) { { :stopped_services => [ 'cups', 'cloud-init' ] } }
    it { should contain_service('cups').with(:ensure => 'stopped', :enable => false ) }
    it { should contain_service('cloud-init').with(:ensure => 'stopped', :enable => false ) }
  end

  describe 'remove files' do
    let(:params) { { :absent_files => '/etc/init/control-alt-delete.conf' } }

    it { should contain_file('/etc/init/control-alt-delete.conf').with(:ensure => 'absent' ) }
  end

  describe 'root alias' do
    let(:params) { { :root_mail => 'sucker@example.com' } }

    it { should contain_mailalias('root').with_ensure('present').with_recipient('sucker@example.com') }
    it { should contain_exec('common_newaliases') }
  end

  describe 'tmpclean' do
    let(:params) { { :clean_tmp => true } }

    it { should contain_file('/usr/local/bin/tmpclean.sh') }
    it { should contain_file('/usr/local/bin/tmpclean.sh').with(:content => /TMP_DIRS="\/tmp \/var\/tmp"/) }
    it { should contain_file('/usr/local/bin/tmpclean.sh').with(:content => /AGE=\+30/) }
    it { should contain_cron('tmpclean').with(:ensure => 'present', :command => '/usr/local/bin/tmpclean.sh') }
  end

  describe 'beaver logging' do
    let(:params) { { :logsagent => 'beaver' } }

    it { should contain_beaver__stanza('/var/log/messages') }
    it { should contain_beaver__stanza('/var/log/secure') }
    it { should contain_beaver__stanza('/var/log/sudolog') }
  end

end
