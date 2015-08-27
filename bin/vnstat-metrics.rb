#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   vnstat-metrics
#
# DESCRIPTION:
#
#  Outputs the results of vnstat -tr in Graphite text format
#
# OUTPUT:
#   metric data about traffic
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#
#   MIT
#
require 'sensu-plugin/metric/cli'
require 'socket'

#
# CPU Graphite
#
class CpuGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.vnstat"

  option :path,
         description: 'Full path to the vnstat executable to use',
         short: '-p PATH',
         long: '--path PATH',
         default: '/usr/bin/vnstat'

  option :time,
         description: 'The sample time to pass to the -tr flag',
         short: '-t TIME',
         long: '--time TIME',
         default: 5

  option :interface,
         description: 'The interface to query',
         short: '-i INTERFACE',
         long: '--interface INTERFACE',
         default: 'eth0'

  def match_and_scale(cmd_output, regular_exp, key)
    if cmd_output =~ regular_exp
      scaled_throughput = Regexp.last_match(1).to_f
      scale      = Regexp.last_match(2)

      case scale
      when 'kbit/s'
        throughput = scaled_throughput
      when 'mbit/s'
        throughput = scaled_throughput * 1000
      when 'gbit/s'
        throughput = scaled_throughput * 1000 * 1000
      end

      output "#{config[:scheme]}.#{config[:interface]}.#{key}", throughput
    else
      warning "#{key} not found in output"
    end
  end


  def run # rubocop:disable all
    vnstat_output = %x[#{config[:path]} -i #{config[:interface]} -tr #{config[:time]} 2>/dev/null]
    exit_code = $?.clone

    if exit_code.exitstatus > 0
      warning "vnstat returned a non-0 output"
    else
      match_and_scale(vnstat_output, /\n\s+rx\s+([\d\.]+)[\t ]+([kKmMbit\/s]+)/, 'rx')
      match_and_scale(vnstat_output, /\n\s+tx\s+([\d\.]+)[\t ]+([kKmMbit\/s]+)/, 'tx')
      ok
    end
  end
end
