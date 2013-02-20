# == Define: common::line
#
# This define manipulates individual lines within a file.  It can add, remove,
# comment, or uncomment a line
#
# === Parameters
#
# [*file*]
#   String.  This is the file to manipulate.  Required.
#
# [*line*]
#   String.  This is the line to match.  Required.
#
# [*ensure*]
#   String.  Defaults to present.  Available options are present, absent,
#   comment, or uncomment.
#
# === Examples
#
# common::line {
#   'peerntp-eth0-y':
#     file    => '/etc/sysconfig/network-scripts/ifcfg-eth0',
#     line    => 'PEERNTP=yes',
#     ensure  => absent;
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
# === Copyright
#
# Copyright 2012 EvenUp.
#
define common::line($file, $line, $ensure = 'present') {
  case $ensure {
    present: {
      exec { "/bin/echo '${line}' >> '${file}'":
        logoutput => on_failure,
        unless    => "/bin/grep -qFx '${line}' '${file}'"
      }
    }

    absent: {
      exec { "/usr/bin/perl -ni -e 'my \$string = quotemeta(\"${line}\") ; print unless /^(\$string)\$/' '${file}'":
        logoutput => on_failure,
        onlyif    => "/bin/grep -qFx '${line}' '${file}'"
      }
    }

    uncomment: {
      exec { "/bin/sed -i -e'/${line}/s/^#\\+//' '${file}'":
        logoutput => on_failure,
        onlyif    => "/bin/grep '${line}' '${file}' | /bin/grep '^#' | /usr/bin/wc -l"
      }
    }

    comment: {
      exec { "/bin/sed -i -e'/${line}/s/^\\(.\\+\\)$/#\\1/' '${file}'":
        logoutput => on_failure,
        onlyif    => "/usr/bin/test `/bin/grep '${line}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
      }
    }

    default: {
      err ( "unknown ensure value ${ensure}" )
    }
  }
}
