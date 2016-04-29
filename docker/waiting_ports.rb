require 'socket'
require 'timeout'
require 'yaml'
require 'erb'
require 'logger'
require 'fileutils'

@config_file_name = "waiting_ports.yml"
@path = ARGV[0]
@path ||= Dir.pwd
@config_file_path = "#{@path}/#{@config_file_name}"

def waiting_port(ip, port)
  is_online = false

  while !is_online
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          is_online = true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        end
      end
      sleep 0.5
    rescue Timeout::Error
    end
  end
end

# Logger.new(STDOUT).info @config_file_path
ports = YAML.load(ERB.new(File.read(@config_file_path)).result)
ports = ports['ports']

ports.each do |i|
  Logger.new(STDOUT).info "-- Waiting for #{i['name']} --"
  waiting_port i['ip'], i['port']
end
