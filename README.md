What is it?
===========

Puppet module to provide a location to push custom functions and ensure specific
packages are installed (or not) and services are stopped.  It also removes
default users and groups that aren't used and appear to only be included for
legacy reasons.

Since many environments have a central directory for authentication and the
ssh configured to not allow root to log in, how do you log into machines when
the worst happens?  common::users allows configuring the root password (handy
when sudo goes funky) and an "ohsit" user you can set an SSH key and password
for.

Released under the Apache 2.0 licence

Usage:
------

To install:
<pre>
  include common
</pre>

To configure ohshit:
<pre>
  class { 'common::users':
    ohshit_pw   => 'pwhash',
    ohshit_key  => 'rsa_key',
  }
</pre>

Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
