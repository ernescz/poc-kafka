Prometheus
=========

Sets up the Prometheus monitoring for Kafka and applications.


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
    - prometheus
```

License
-------

BSD
