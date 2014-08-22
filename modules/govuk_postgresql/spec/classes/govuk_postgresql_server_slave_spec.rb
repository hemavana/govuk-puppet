require_relative '../../../../spec_helper'

describe 'govuk_postgresql::server::slave', :type => :class do
  let(:param_host) { 'master.example.com' }
  let(:param_pass) { 'supersekret' }

  let(:pg_version) { '9.2' }
  let(:pg_user) { 'pg_user' }
  let(:pg_group) { 'pg_group' }
  let(:recovery_conf) { "/var/lib/postgresql/#{pg_version}/main/recovery.conf" }

  let(:facts) {{
    :concat_basedir => '/tmp/concat',
  }}
  let(:params) {{
    :host     => param_host,
    :password => param_pass,
  }}
  let(:pre_condition) { <<-EOS
    class {
      'postgresql::globals':
        user    => #{pg_user},
        group   => #{pg_group},
        version => #{pg_version};
      'postgresql::server': ;
    }
    EOS
  }

  describe 'recovery.conf' do
    it 'should use $datadir, $user and $group from upstream postgres module' do
      should contain_file(recovery_conf).with(
        :owner => pg_user,
        :group => pg_group,
      )
    end

    it 'should not be world readable' do
      should contain_file(recovery_conf).with_mode('0600')
    end

    it 'should write details of master' do
      should contain_file(recovery_conf).with_content(<<-EOS
standby_mode     = 'on'
primary_conninfo = 'host=#{param_host} user=replication password=#{param_pass}'
      EOS
      )
    end
  end
end
