= riak_light

* http://github.com/mpdehaan/riak_light

== DESCRIPTION:

An extra lightweight Ruby binding for Riak that has less dependencies
than ripple.  

== FEATURES/PROBLEMS:

It works for basic storage and access.

* Otherwise, very minimal functionality at this point
* does not understand links and tags
* errors often come back as HTTPErrors rather than something translated
* no attempt to resolve vector clock collisions

== SYNOPSIS:

riak = RiakLight.new()
puts riak.bucket_info("llamas").inspect()
puts riak.bucket_add("llamas", "bob", { "says" => "I'm not a llama" }).inspect()
(obj, vclock) = riak.bucket_get("llamas", "bob")
puts obj.inspect()
# attempt to re-add
puts riak.bucket_add("llamas", "bob", { "says" => "I'm not a llama" }).inspect()
puts obj.vclock()
(obj, vclock) = riak.bucket_get("llamas", "steve")

== REQUIREMENTS:

* curb
* json
* an installation of Riak

== INSTALL:

* sudo gem install

== DEVELOPERS:

After checking out the source, run:

  $ sudo rake install jewler
  $ rake gemspec 
  $ sudo rake install # OR gem build riak_light.gemspec

== LICENSE:

(C) 2010, Puppet Labs
Michael DeHaan <michael@puppetlabs.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301  USA

