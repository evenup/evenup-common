require 'spec_helper'

describe 'common::fw_pre', :type => :class do
  let(:pre_condition) { 'define firewall ($iniface = undef, $destination = undef, $action = undef, $state = undef, $dport = undef, $proto = undef) {}' }

  context 'default' do
    it { should contain_firewall('000 accept all icmp') }
  end

  context 'pass rules' do
    let(:params) { { :rules => {'test1' => {} } } }
    it { should contain_firewall('test1') }
  end

end
