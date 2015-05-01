# == Class: adobe::package::adobereader
#
# Define pared down Adobe repo.
# Install AdobeReader_enu (i386, as x86_64 does not exist)
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
# class { 'adobe::package::adobereader': }
#
# include adobe::package::adobereader
#
# === Authors
#
# Author <author@domain.tld>
#
# === Copyright
#
# No copyright expressed, or implied.
#
class adobe::package::adobereader {

    # there is some amount of annoyance here
    # there is no 64-bit package so only install 32-bit

    # need Adobe repo GPG key, but could be present from other pacakges
    if ! defined(File['/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux']) {
        file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux':
            ensure => 'file',
            source => 'puppet:///modules/yum/gpgkeys/RPM-GPG-KEY-adobe-linux',
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
        }
    }

    # define limited version of Adobe repo which will only bring in AdobeReader
    yumrepo {'adobereader-i386':
        name           => 'adobereader-i386',
        descr          => 'AdobeReader package from Adobe',
        baseurl        => 'http://linuxdownload.adobe.com/linux/i386/',
        failovermethod => 'priority',
        enabled        => '1',
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux',
        gpgcheck       => '1',
        includepkgs    => 'AdobeReader*',
        require        => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux'],
    }

    # install the package
    package { 'AdobeReader_enu':
        ensure  => 'latest',
        require => Yumrepo['adobereader-i386'],
    }

}
