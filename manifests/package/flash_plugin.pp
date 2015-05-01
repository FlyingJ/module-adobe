# == Class: adobe::package::flash_plugin
#
# Define pared down Adobe repo.
# Install flash-plugin.
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Examples
#
# class { 'adobe::package::flash_plugin': }
#
# include adobe::package::flash_plugin
#
# === Authors
#
# Author <author@domain.tld>
#
# === Copyright
#
# No copyright expressed, or implied.
#
class adobe::package::flash_plugin {

    # there is some amount of annoyance here
    # only i386 works reliably on SLF5, but we follow arch on SLF6
    $reliable_arch = $::lsbmajdistrelease ? {
        '5' => 'i386',
        '6' => $::architecture,
        '7' => $::architecture,
    }

    # need Adobe repo GPG key, but could be present from other packages
    if ! defined(File['/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux']) {
        file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux':
            ensure => 'file',
            source => 'puppet:///modules/yum/gpgkeys/RPM-GPG-KEY-adobe-linux',
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
        }
    }

    # define limited version of Adobe repo which will only bring in flash-plugin
    yumrepo {"flash-plugin-${reliable_arch}":
        name           => "flash-plugin-${reliable_arch}",
        descr          => 'flash-plugin package from Adobe',
        baseurl        => "http://linuxdownload.adobe.com/linux/${reliable_arch}/",
        failovermethod => 'priority',
        enabled        => '1',
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux',
        gpgcheck       => '1',
        includepkgs    => 'flash-plugin',
        require        => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux'],
    }

    # install the package
    package {'flash-plugin':
        ensure  => 'installed',
        require => Yumrepo["flash-plugin-${reliable_arch}"],
    }

}
