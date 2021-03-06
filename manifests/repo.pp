class ksplice::repo {
  case $::operatingsystem {
    'CentOS', 'RedHat', 'Fedora': {

      # convert the various operating systems to the names the ksplice-uptrack repo uses
      $os = $::operatingsystem ? {
        'CentOS' => 'centos',
        'RedHat' => 'rhel',
        'Fedora' => 'fedora',
      }

      yumrepo {$ksplice::repo_name:
        ensure   => $ksplice::repo_ensure,
        baseurl  => "${ksplice::repo_yum_baseurl_prefix}/${os}/\$releasever/\$basearch/",
        enabled  => $ksplice::repo_enabled,
        gpgcheck => $ksplice::repo_gpgcheck,
        gpgkey   => $ksplice::repo_gpgkey,
      }
    }
    'Debian', 'Ubuntu': {
      include ::apt
      apt::source {$ksplice::repo_name:
        ensure   => $ksplice::repo_ensure,
        location => $ksplice::repo_apt_location,
        repos    => $ksplice::repo_name,
        key      => {
          'id'     => $ksplice::repo_key_id,
          'source' => $ksplice::repo_key_source,
        }
      }
      Class['apt::update'] -> Class['ksplice::install']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
