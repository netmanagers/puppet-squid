require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'squid::acl' do

  let(:title) { 'squid::acl' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
    }
  end

  describe 'Test acl.conf is created with full options' do
    let(:params) do
      {
        :name  => 'sample1',
        :type  => "src",
        :vaalues => "/etc/squid/conf.d/denegados.lst",
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

acl sample1 src /etc/squid/conf.d/denegados.lst
'
    end
    it { should contain_file('acl-sample1.conf').with_path('/etc/squid3/conf.d/acl-sample1.conf').with_content(expected) }
  end

end
