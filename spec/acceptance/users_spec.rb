require 'spec_helper_acceptance'

describe 'common::users class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'common::users': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

  end

  context 'remove users and groups' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'common::users': absent_users => 'bin', absent_groups => 'tape' }
      EOS

      # ensure telnet is installed
      puppet_resource('user', 'bin', 'ensure=present')
      puppet_resource('group', 'tape', 'ensure=present')
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe user('bin') do
      it { is_expected.not_to exist }
    end

    describe group('tape') do
      it { is_expected.not_to exist }
    end
  end

end
