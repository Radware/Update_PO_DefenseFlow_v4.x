# Updating List of PO's in DefenseFlow version 4.x
The radware-ansible project provides an Ansible collection for managing and automating your Radware devices. It consists of a set of modules and roles for performing tasks related to Radware devices configuration.

## Requirements 
Python 3.8:
-----------
  - Requests
  - Xlsxwriter
  - Pandas
  - Xlrd

## Installation
```
# ansible-galaxy collection install radware.radware_modules
```

## Example Usage
Once the collection is installed, you can use it in a playbook by specifying the full namespace path to the module, plugin and/or role.

```
- hosts: localhost

  tasks:
  - name: alteon configuration command
    radware.radware_modules.alteon_config_l2_vlan:
      provider: 
        server: 192.168.1.1
        user: admin
        password: admin
        validate_certs: no
        https_port: 443
        ssh_port: 22
        timeout: 5
      state: present
      parameters:
        index: 45
        state: enabled
        name: test_vlan
        source_mac_learning: enabled
        ports:
          - 1
          - 2
```

## Copyright

Copyright 2021 Radware LTD

## License
GNU General Public License v3.0
