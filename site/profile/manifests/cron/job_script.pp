class profile::cron::job_script (
  String $script_path = '/usr/local/bin/job_script.sh',
  String $user = 'root',
  String $hour = '*/3',
  String $minute = '0',
  Optional[String] $log_path = '/var/log/job_script.log',
  String $message = "Hello from Puppet cron job",
) {
  file { $script_path:
    ensure  => file,
    mode    => '0755',
    owner   => $user,
    group   => $user,
    content => "#!/bin/bash\necho \"[$(date)] ${message}\"",
  }

  cron { 'job_script_every_3h':
    ensure  => present,
    user    => $user,
    minute  => $minute,
    hour    => $hour,
    command => $log_path ? {
      undef   => $script_path,
      default => "${script_path} >> ${log_path} 2>&1",
    },
  }
}
