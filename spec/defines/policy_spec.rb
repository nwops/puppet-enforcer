require 'spec_helper'
require 'shared_contexts'

describe 'enforcer::policy' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:title) { 'pol101' }

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:extra_facts) do
    {}
  end

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do      
      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to compile }
      if os_facts[:kernel] =~ /windows/i 
        it do
          is_expected.to contain_exec("#{title}_enforce").with({
            command: "\nexit 0",
            unless: "\nexit 0"
          })
        end
      else
        it do
          is_expected.to contain_exec("#{title}_enforce").with({
            command: "#!/usr/bin/env bash\n\n# install linux\n\nexit 0",
            unless: "#!/usr/bin/env\n\n\nuname -a |grep linux\n\nexit 0"
          })
        end
      end
      

    end
  end
end
