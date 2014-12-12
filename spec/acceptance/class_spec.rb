require 'spec_helper_acceptance'

describe 'common class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'common': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

  end

  context 'manage packages' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'common': install_packages => ['wget', 'curl'], absent_packages => ['telnet'] }
      EOS

      # ensure telnet is installed
      puppet_resource('package', 'telnet', 'ensure=installed')
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('wget') do
      it { is_expected.to be_installed }
    end

    describe package('curl') do
      it { is_expected.to be_installed }
    end

    describe package('telnet') do
      it { is_expected.not_to be_installed }
    end
  end

  context 'stop services' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'common': stopped_services => [cups] }
      EOS

      # ensure cups is installed and running
      puppet_resource('package', 'cpus', 'ensure=installed')
      puppet_resource('service', 'cpus', 'ensure=running')

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end


    describe service('cups') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

  end
end
