require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'squid::permisos' do

  let(:title) { 'squid::permisos' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
    }
  end

  describe 'Test permisos.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Name = "sample1"
'
    end
    it { should contain_file('permisos-sample1.conf').with_path('/etc/squid3/conf.d/permisos-sample1.conf').with_content(expected) }
  end

end
