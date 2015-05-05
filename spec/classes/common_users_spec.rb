require 'spec_helper'

describe 'common::users', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  describe "no parameters" do
    it { should create_class('common::users') }
    it { should_not contain_user('root') }
    it { should_not contain_group('ohshit') }
    it { should_not contain_user('ohshit') }
    it { should_not contain_file('/root/.ssh/id_rsa') }
  end

  describe 'root_pw' do
    let(:params) { { :root_pw => 'asdf' } }
    it { should contain_user('root').with(:password => 'asdf') }
    it { should_not contain_user('ohshit') }
  end

  describe 'root_keys' do
    let(:params) { { :root_pw => 'asdf', :root_ssh_key => 'puppet:///data/root/pub_key', :root_priv_key => 'puppet:///data/root/priv_key' } }
    it { should contain_user('root') }
    it { should contain_ssh_authorized_key('root').with(:key => 'puppet:///data/root/pub_key') }
    it { should contain_file('/root/.ssh/id_rsa').with(:mode => '0400') }
  end

  describe 'ohshit_pw' do
    let(:params) { { :ohshit_pw => 'asdf' } }
    it { should contain_group('ohshit').with(:system => true) }
    it { should contain_user('ohshit').with(:system => true, :password => 'asdf', :key => nil) }

    describe 'ohshit_key' do
      let(:params) { { :ohshit_pw => 'asdf', :ohshit_key => 'biglongstring' } }
      it { should contain_user('ohshit').with(:password => 'asdf') }
      it { should contain_ssh_authorized_key('ohshit').with(:key =>'biglongstring') }
    end
  end

  describe 'remove users' do
    let(:params) { { :absent_users => 'bin' } }
    it { should contain_user('bin').with(:ensure => 'absent') }
  end

  describe 'remove groups' do
    let(:params) { { :absent_groups => 'tape' } }
    it { should contain_group('tape').with(:ensure => 'absent' ) }
  end

end
