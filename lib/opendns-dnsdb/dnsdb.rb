
require 'date'
require 'ethon'
require 'hashie'
require 'multi_json'

require_relative 'dnsdb/response'
require_relative 'dnsdb/by_ip'
require_relative 'dnsdb/by_name'
require_relative 'dnsdb/label'
require_relative 'dnsdb/related'
require_relative 'dnsdb/traffic'

module OpenDNS
  class DNSDB
    include OpenDNS::DNSDB::Response
    include OpenDNS::DNSDB::ByIP
    include OpenDNS::DNSDB::ByName
    include OpenDNS::DNSDB::Label
    include OpenDNS::DNSDB::Related
    include OpenDNS::DNSDB::Traffic
    
    DEFAULT_TIMEOUT = 15
    DEFAULT_MAXCONNECTS = 10
    SGRAPH_API_BASE_URL = 'https://sgraph.umbrella.com'

    attr_reader :timeout
    attr_reader :sslcert
    attr_reader :sslcerttype
    attr_reader :sslcertpasswd
    attr_reader :maxconnects

    def initialize(params = { })
      raise UsageError, 'Missing certificate file' unless params[:sslcert]
      @sslcert = params[:sslcert]
      @timeout = DEFAULT_TIMEOUT
      @timeout = params[:timeout].to_f if params[:timeout]
      @maxconnects = DEFAULT_MAXCONNECTS
      @maxconnects = params[:maxconnects].to_i if params[:maxconnects]
      @sslcerttype = params[:sslcerttype] || 'p12'
      @sslcertpasswd = params[:sslcertpasswd] || ''
      @options = {
        followlocation: true,
        timeout: @timeout,
        sslcert: @sslcert,
        sslcerttype: @sslcerttype,
        sslcertpasswd: @sslcertpasswd
      }
    end

    def query_handler(endpoint, method = :get, options = { })
      url = SGRAPH_API_BASE_URL + endpoint
      query = Ethon::Easy.new(@options)
      query.http_request(url, method, options)
      query
    end
  end
end
