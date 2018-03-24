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

run %Q{
  ssh #{customer}-cb.redcanary.core "sudo rpm -ivh --force /root/cb.rpm &&
                                     sudo service cb-enterprise stop &&
                                     sleep 5
                                     sudo pkill -u cb &&
                                     sudo service cb-enterprise start"
}

puts "Navigate to https://#{customer}-cb.my.redcanary.co/#/dashboard"
