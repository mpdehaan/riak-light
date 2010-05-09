# (C) 2010, Puppet Labs
# Michael DeHaan <michael@puppetlabs.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301  USA

require 'curb' 
require 'json'

# NOTE:
#   does not yet grok vector clocks
#   needs to pay attention to HTTP error codes
#   doesn't attempt to do riak links or tags yet

class RiakLight

  attr_accessor :server, :port, :read_quorum, :write_quorum, :jsonify

  def initialize(server='127.0.0.1', port=8098, jsonify=false, read_quorum=1, write_quorum=1)
     @server=server
     @port=port
     @read_quorum=read_quorum
     @write_quorum=write_quorum
     @jsonify=jsonify
  end

  def conn(postfix)
     Curl::Easy.new("http://#{@server}:#{@port}/#{postfix}")
  end

  def bucket_info(bucket)
     c = conn("/riak/#{bucket}")
     c.perform
     return JSON.load(c.body_str)
  end

  def bucket_add(bucket, key, value, vclock=nil)
     headers = {}
     headers['Content-Type'] = 'text/json'
     headers['X-Riak-Vclock'] = vclock unless vclock.nil?
     # parameters:
     # * w=2 (write quorum) how many replicas to write to before returning a successful response (default is 2).
     # * dw=0 how many replicas to commit to durable storage before returning a successful response (default is 0)
      #* returnbody=[true|false] whether to return the contents of the stored object.
     data = jsonify ? JSON.dump(value) : value
     c = conn("/riak/#{bucket}/#{key}?w=#{write_quorum}")
     c.headers = headers
     c.http_post(data) # ?w=#{@write_quorum}", data)
  end

  def bucket_get(bucket, key)
     c = conn("/riak/#{bucket}/#{key}?r=#{read_quorum}")
     c.perform
     #begin 
        headers = c.headers
        vclock = headers['X-Riak-Vclock']
        return [ jsonify ? JSON.load(c.body_str) : c.body_str, vclock]
     #rescue
     #   raise "error accessing such key '#{key}' in bucket '#{bucket}', got #{c.body_str}"
     #end
  end

end

