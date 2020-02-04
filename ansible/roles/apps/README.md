Apps
=========

Installs the applications needed to produce and consume messages from the Kafka.


Requirements
------------

Requires a statsd client running on host to send metrics to (it's also used as a target for Prometheus scrape)

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - apps

License
-------

BSD
