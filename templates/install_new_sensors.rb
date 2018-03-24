#! /usr/bin/env ruby
customer = ARGV[0]
raise 'customer is required' if customer.nil?

win_sensor_version = ARGV[1] || 'cb-sensor-6.1.2.70914-win'
raise 'win_sensor_version is required' if win_sensor_version.nil?

def run(command)
  puts command
  system command, out: $stdout, err: :out
end

run %Q{
  ssh #{customer}-cb.redcanary.core "sed -i 's/baseurl=.*/baseurl=https:\/\/yum.distro.carbonblack.io\/enterprise\/controldistro_v6\/x86_64\//g' /etc/yum.repos.d/CarbonBlack.repo &&
                                     yum install #{windows_sensor_verion} -y &&
                                     yum upgrade cb-osx-sensor -y &&
                                     sed -i 's/baseurl=.*/baseurl=https:\/\/yum.carbonblack.com\/enterprise\/stable\/x86_64\//g' /etc/yum.repos.d/CarbonBlack.repo &&
                                     /usr/share/cb/cbcheck sensor-builds --update"
}