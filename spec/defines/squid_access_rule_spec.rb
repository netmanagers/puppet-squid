require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'squid::access_rule' do

  let(:title) { 'squid::access_rule' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
    }
  end

  describe 'Test access_rule.conf is created with no options' do
    let(:params) do
      {
        :name             => 'sample1',
        :order            => '001',
        :type_redirection => "always_direct",
        :action           => "allow",
        :acl1             => "acl1",
        :acl2             => "acl2",
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

always_direct allow acl1 acl2
'
    end
    it { should contain_file('access-rule-sample1.conf').with_path('/etc/squid3/conf.d/001-access-rule-sample1.conf').with_content(expected) }
  end

end
