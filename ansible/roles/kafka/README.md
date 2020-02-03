Role Name
=========

Installs and configures Kafka and Zookeeper services on the host.

Requirements
------------

None.

Role Variables
--------------

All variables set in `defaults/main.yml`. Variables include default location for Kafka/Zookeeper files, usernames, and Kafka version. Most of them are self-explanatory. See the file for more info. 

Dependencies
------------

None.

Example Playbook
----------------

```yaml
  - hosts: servers
    roles:
      - kafka
```
License
-------

BSD
