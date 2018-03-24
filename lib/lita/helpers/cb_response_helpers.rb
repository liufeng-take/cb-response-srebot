require 'open3'
require 'lita/helpers/nix_helpers'

module CbResponseHelpers
  include NixHelpers

  def cb_response_status
    stdout, stderr, status = Open3.capture3 <<-EOS
      /usr/bin/sudo /usr/share/cb/cbcluster status
    EOS
    p "STDOUT", stdout, "STDERR", stderr, '------'
    parse_service_status stderr
  end

  def stop_cb_response
    stdout, stderr, status = Open3.capture3 <<-EOS
      echo "Stopping cb-enterprise" &&
      /usr/bin/sudo /usr/share/cb/cbcluster stop &&
      sleep 2 && 
      echo "Killing remaining processes" &&
      /usr/bin/sudo pkill -u cb
    EOS
  end

  def start_cb_response
    stdout, stderr, status = Open3.capture3 <<-EOS
      echo "Starting cb-enterprise" &&
      /usr/bin/sudo /usr/share/cb/cbcluster start
    EOS
    parse_service_status stderr
  end
end
