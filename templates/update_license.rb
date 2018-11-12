#! /usr/bin/env ruby
customer = ARGV[0]
raise 'customer is required' if customer.nil?

license_file = ARGV[1]
raise 'license_file is required' if license_file.nil?
raise 'license_file must exist' if !File.exists?(license_file)

user = ARGV[2]
raise 'puppet server user is required' if user.nil?

def run(command)
  puts command
  system command, out: $stdout, err: :out
end

# automatically change the owner of the file, scp oftens fails if you weren't the last person to write that file
run %Q{
  ssh puppetmaster01.redcanary.core "sudo chown #{user} /puppet/modulebase/modules/cb_server/files/#{customer}-cb.rpm"
}

run %Q{
  scp #{license_file} puppetmaster01.redcanary.core:/puppet/modulebase/modules/cb_server/files/#{customer}-cb.rpm
}


run %Q{
  ssh puppetmaster01.redcanary.core "cd /puppet/modulebase/modules/cb_server/files/ &&
                                     git pull &&
                                     git add #{customer}-cb.rpm &&
                                     git commit -m 'add license for #{customer}' #{customer}-cb.rpm &&
                                     git push"
}

run %Q{
  ssh #{customer}-cb.redcanary.core "sudo puppet agent -t"
}

# this command will only be needed if the above command fails
# run %Q{
#   ssh #{customer}-cb.redcanary.core "sudo rpm -ivh --force /root/cb.rpm &&
#                                      sudo service cb-enterprise restart"
# }

puts "Navigate to https://#{customer}-cb.my.redcanary.co/#/dashboard"
