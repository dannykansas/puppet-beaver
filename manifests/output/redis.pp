# == Define: beaver::output::redis
#
#   send events to a redis database using RPUSH  For more information
#   about redis, see http://redis.io/
#
#
# === Parameters
#
# [*host*]
#   Redis host to submit to
#   Value type is string
#   This variable is mandatory
#
# [*port*]
#   Redis port number
#   Value type is number
#   Default value: 6379
#   This variable is optional
#
# [*db*]
#   Redis database number
#   Value type is number
#   Default value: 0
#   This variable is optional

# [*namespace*]
#   Redis key namespace
#   Value type is string
#   Default value: logstash:beaver
#   This variable is optional
#
# [*ssh_options*]
#   Comma separated list of SSH options to Pass through to the SSH Tunnel.
#   Default value: None
#   This variable is optional
#
# [*ssh_key_file*]
#   Full path to id_rsa key file
#   Default value: None
#   This variable is optional
#
# [*ssh_tunnel*]
#   SSH Tunnel in the format user@host:port
#   Default value: None
#   This variable is optional
#
# [*ssh_tunnel_port*]
#   Local port for SSH Tunnel
#   Default value: None
#   This variable is optional
#
# [*ssh_remote_host*]
#   Remote host to connect to within SSH Tunnel
#   Default value: None
#   This variable is optional
#
# [*ssh_remote_port*]
#   Remote port to connect to within SSH Tunnel
#   Default value: None
#   This variable is optional
#
# [*ssh_options*]
#   Example: 'StrictHostKeyChecking=no, Compression=yes, CompressionLevel=9'
#   See OpenBSD's ssh_config(5) for further details
#   Default value: None
#   This variable is optional
#
# === Examples
#
#  beaver::output::redis{'redisout':
#    host => 'redishost'
#  }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
# * Dan Fowler <mailto:dan@logickc.com>

define beaver::output::redis(
  $host,
  $port      = 6379,
  $db        = 0,
  $namespace = 'logstash:beaver',
  $ssh_options = '',
  $ssh_key_file = '',
  $ssh_tunnel = '',
  $ssh_tunnel_port = '',
  $ssh_remote_host = '',
  $ssh_remote_port = '',
  $logstash_version = 1,
) {

  #### Validate parameters
  if $host {
    validate_string($host)
  }

  if ! is_numeric($port) {
    fail("\"${port}\" is not a valid port parameter value")
  }

  if ! is_numeric($db) {
    fail("\"${db}\" is not a valid db parameter value")
  }

  $opt_url = "redis_url: redis://${host}:${port}/${db}\n"

  if ($namespace != '') {
    validate_string($namespace)
    $opt_namespace = "redis_namespace: ${$namespace}\n"
  }

  if ($ssh_options != '') {
    validate_string($ssh_options)
    $opt_ssh_options = "ssh_options: ${$ssh_options}\n"
  }

  if ($ssh_key_file != '') {
    validate_string($ssh_key_file)
    $opt_ssh_key_file = "ssh_key_file: ${$ssh_key_file}\n"
  }

  if ($ssh_tunnel != '') {
    validate_string($ssh_tunnel)
    $opt_ssh_tunnel = "ssh_tunnel: ${$ssh_tunnel}\n"
  }

  if ($ssh_tunnel_port != '') {
    validate_string($ssh_tunnel)
    $opt_ssh_tunnel_port = "ssh_tunnel_port: ${$ssh_tunnel_port}\n"    
  }
 
  if ($ssh_remote_host != '') {
    validate_string($ssh_remote_host)
    $opt_ssh_remote_host = "ssh_remote_host: ${$ssh_remote_host}\n"
  }
  
  if ! is_numeric($ssh_remote_port) {
    $opt_ssh_remote_port = "ssh_remote_port: ${$ssh_remote_port}\n"    
  }

  if ! is_numeric($logstash_version) {
    $opt_logstash_version = "logstash_version: ${$logstash_version}\n"    
  }

  #### Create file fragment

  file_fragment{ "output_redis_${::fqdn}":
    tag     => "beaver_config_${::fqdn}",
    content => "${opt_url}${opt_namespace}${opt_ssh_options}${opt_ssh_key_file}${opt_ssh_tunnel}${opt_ssh_tunnel_port}${$opt_ssh_remote_host}${opt_ssh_remote_port}${opt_logstash_version}\n",
    order   => 20
  }

}
