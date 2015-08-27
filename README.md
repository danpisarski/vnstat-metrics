# vnstat-metrics

A Sensu plugin to output traffic metrics from vnstat in Graphite format.

##Example

```
vnstat-metrics.rb -i en0 -p /usr/local/bin/vnstat
```

Relies on the vnstat command line tool being installed.
