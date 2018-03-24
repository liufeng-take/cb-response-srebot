#! /usr/bin/env ruby
customer = ARGV[0]
raise 'customer is required' if customer.nil?

license_file = ARGV[1]
raise 'license_file is required' if license_file.nil?
raise 'license_file must exist' if !File.exists?(license_file)

def run(command)
  puts command
  system command, out: $stdout, err: :out
end

run %Q{
  ssh puppetmaster01.redcanary.core "cd /puppet/modulebase/modules/cb_server/files/ &&
                                     cp /puppet/modulebase/modules/cb_server/files/devtest.rpm /puppet/modulebase/modules/cb_server/files/#{customer}-cb.rpm
                                     git pull &&
                                     git add #{customer}-cb.rpm &&
                                     git commit -m 'add license for #{customer} when building' #{customer}-cb.rpm &&
                                     git push"
}

run %Q{
  ssh ldap.redcanary.core "cd /puppet/overseer &&
                           overseer create #{customer}-cb &&
                           overseer edit --for #{customer}-cb"
}


