# encoding: utf-8
# copyright: 2018, The Authors

title 'tomcat'

# you add controls here
control 'tomcat-100' do                        # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title 'Create /tmp directory'             # A human-readable title
  desc 'Must have a /tmp directory'
  describe file('/tmp') do                  # The actual test
    it { should be_directory }
  end
end
