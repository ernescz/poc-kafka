Prometheus
=========

Sets up the Grafana dashboards for Kafka and applications.


Requirements
------------

None.

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
---
- hosts: all
  become: True
  roles:
    - grafana
```

License
-------

BSD
