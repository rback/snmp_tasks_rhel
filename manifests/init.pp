class snmp_tasks_rhel::wget {
  package { "wget":
    ensure => installed
  }
}

define snmp_tasks_rhel::http_smoke_test(
  $application = $title,
  $http_port,
  $http_hostname_or_ip = 'localhost',
  $tasks_home_directory,
  $smoke_test_path = '/') {

  include snmp_tasks_rhel::wget

  $file_path = "$tasks_home_directory/$application-http_smoke_test.sh"

  file { $file_path:
    content => template("snmp_tasks_rhel/http_smoke_test.sh.erb"),
    path    => $file_path,
    mode    => "0750"
  }

  snmp_rhel::snmpd_exec { $application:
    command => $file_path
  }
}

define snmp_tasks_rhel::file_max_age(
  $task_name = $title,
  $file_to_test,
  $max_age_in_days,
  $error_message,
  $tasks_home_directory) {

  $task_file_path = "$tasks_home_directory/$task_name-max_age_test.sh"
  $max_age_in_minutes = $max_age_in_days * 24 * 60

  file { $title:
    content => template("snmp_tasks_rhel/file_max_age_test.sh.erb"),
    path    => $task_file_path,
    mode    => "0750"
  }

  snmp_rhel::snmpd_exec { $task_name:
    command => $task_file_path
  }
}

define snmp_tasks_rhel::file_max_age_minutes(
  $task_name = $title,
  $file_to_test,
  $max_age_in_minutes,
  $error_message,
  $tasks_home_directory) {

  $task_file_path = "$tasks_home_directory/$task_name-max_age_test.sh"

  file { $title:
    content => template("snmp_tasks_rhel/file_max_age_test.sh.erb"),
    path    => $task_file_path,
    mode    => "0750"
  }

  snmp_rhel::snmpd_exec { $task_name:
    command => $task_file_path
  }
}

class snmp_tasks_rhel::ruby {
  package { 'ruby':
    ensure => present
  }
}

define snmp_tasks_rhel::file_emptiness_test(
  $task_name = $title,
  $file_to_test,
  $tasks_home_directory) {
  include snmp_tasks_rhel::ruby

  $task_file_path = "$tasks_home_directory/$task_name-file_emptiness_test.rb"

  file { $title:
    content => template("snmp_tasks_rhel/file_emptiness_test.rb.erb"),
    path    => $task_file_path,
    mode    => "0750"
  }

  snmp_rhel::snmpd_exec { $task_name:
    command => $task_file_path
  }
}
