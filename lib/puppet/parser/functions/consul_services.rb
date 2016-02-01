require 'net/http'
require 'uri'
require 'json'

module Puppet::Parser::Functions
  newfunction(
    :consul_services,
    :type  => :rvalue,
    :doc   => <<-'EOS'

This function returns a hash of the form:
  (name => ip_address)
for each host that registers a service in consul

EOS
  ) do |args|
    begin
      consul_host = args.shift || '127.0.0.1'
      consul_port = args.shift || '8500'
      uri = URI("http://#{consul_host}:#{consul_port}/v1/catalog/services")
      res = Net::HTTP.get_response(uri)
      if res.code == '200'
        results = JSON.parse(res.body)
#        ret_hash = {}
#        results.each do |node|
#          ret_hash[node['Node']] = node['Address']
#        end
      else
        raise(Puppet::Error, "Uri: #{uri.to_s}, returned code #{res.code}")
      end
    rescue Errno::ECONNREFUSED => e
      # connection refused indicates that consul is not operational
      # yet. We should return an empty {} to ensure this does not
      # block catalog compilation
      return {}
    end
  end
end
