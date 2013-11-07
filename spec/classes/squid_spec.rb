require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'squid' do

  let(:title) { 'squid' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard Centos installation' do
    let(:facts) { { :operatingsystem => 'Centos' } }
    it { should contain_package('squid').with_ensure('present') }
    it { should contain_service('squid').with_ensure('running') }
    it { should contain_service('squid').with_enable('true') }
    it { should contain_file('squid.conf').with_ensure('present') }
  end

  describe 'Test standard Debian installation' do
    let(:facts) { { :operatingsystem => 'Debian' } }
    it { should contain_package('squid3').with_ensure('present') }
    it { should contain_service('squid').with_ensure('running') }
    it { should contain_service('squid').with_enable('true') }
    it { should contain_file('squid.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('squid').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:params) { {:monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }
    it { should contain_package('squid').with_ensure('present') }
    it { should contain_service('squid').with_ensure('running') }
    it { should contain_service('squid').with_enable('true') }
    it { should contain_file('squid.conf').with_ensure('present') }
    it { should contain_monitor__process('squid_process').with_enable('true') }
    it { should contain_firewall('squid_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it 'should remove Package[squid]' do should contain_package('squid').with_ensure('absent') end
    it 'should stop Service[squid]' do should contain_service('squid').with_ensure('stopped') end
    it 'should not enable at boot Service[squid]' do should contain_service('squid').with_enable('false') end
    it 'should remove squid configuration file' do should contain_file('squid.conf').with_ensure('absent') end
    it { should contain_monitor__process('squid_process').with_enable('false') }
    it { should contain_firewall('squid_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('squid').with_ensure('present') }
    it 'should stop Service[squid]' do should contain_service('squid').with_ensure('stopped') end
    it 'should not enable at boot Service[squid]' do should contain_service('squid').with_enable('false') end
    it { should contain_file('squid.conf').with_ensure('present') }
    it { should contain_monitor__process('squid_process').with_enable('false') }
    it { should contain_firewall('squid_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('squid').with_ensure('present') }
    it { should_not contain_service('squid').with_ensure('present') }
    it { should_not contain_service('squid').with_ensure('absent') }
    it 'should not enable at boot Service[squid]' do should contain_service('squid').with_enable('false') end
    it { should contain_file('squid.conf').with_ensure('present') }
    it { should contain_monitor__process('squid_process').with_enable('false') }
    it { should contain_firewall('squid_tcp_42').with_enable('true') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('squid').with_noop('true') }
    it { should contain_service('squid').with_noop('true') }
    it { should contain_file('squid.conf').with_noop('true') }
    it { should contain_monitor__process('squid_process').with_noop('true') }
    it { should contain_monitor__process('squid_process').with_noop('true') }
    it { should contain_monitor__port('squid_tcp_42').with_noop('true') }
    it { should contain_firewall('squid_tcp_42').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "squid/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'squid.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'squid.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/squid/spec"} }
    it { should contain_file('squid.conf').with_source('puppet:///modules/squid/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/squid/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('squid.dir').with_source('puppet:///modules/squid/dir/spec') }
    it { should contain_file('squid.dir').with_purge('true') }
    it { should contain_file('squid.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "squid::spec" } }
    it { should contain_file('squid.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'squid.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('squid').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('squid_process').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }
    it { should contain_firewall('squid_tcp_42').with_tool('iptables') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }
    it { should contain_monitor__process('squid_process').with_tool('puppi') }
    it { should contain_firewall('squid_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('squid').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('squid_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :squid_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour module specific vars' do should contain_monitor__process('squid_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :squid_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('squid_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('squid_process').with_enable('true') end
  end

end

