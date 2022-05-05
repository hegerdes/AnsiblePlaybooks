# Symbic Ansible Playbooks

This project can do batch processes on any number of servers and perform defined tasks written in a playbook.

## Supported Tasks

 * **common:** Install basic packages (like ``curl``, ``wget``, ``tar``... ) to any Debian based host 
 * **promtail:** Install a log shipper to send *authlog*, *syslog*, *daemonlog*... to a management host (hostname mgmt)
 * **node-exporter:** Install system metrics exporter that can be scraped by Prometheus (listens on port 9100)
 * **nginx:** Installs the official nginx version, deploys default config, forwards logs, can automatically install hosts and https
 * **docker:** Install Docker[ce|ee] to the system, log into a registry, install a log plugin, init and join swarm nodes and install portainer-agent
 * **docker-deploy:** Deploys a docker compose|stack file to the host
 * **mgmt:** Installs Symbic management stack. Includes Prometheus, Grafana, Loki, Portainer and more on will. See [here]()
 * **mariadb:** Installs MariaDB - either via docker or directly on the host
 * **mongodb:** Installs MongoDB - either via docker or directly on the host
 * **influxdb:** Installs InfluxDB - either via docker or directly on the host
 * **maintenance:** Check for updates, and perform them

## Required Tools
You need the following:
 * Your public key on the server you want to deploy to
 * openssh - use the one from git-bash or the WSL (not putty) [Download](https://gitforwindows.org/)
 * python 3.7+ [Download](https://www.python.org/)
 * ansible [Download](https://docs.ansible.com/ansible/latest/index.html)

**Tipp:** Run it on a Linux system or use the [WSL](https://docs.microsoft.com/de-de/windows/wsl/about)
## How to use
Run
```bash
ansible-playbook -i <PATH_TO_INVENTORY> <PLAYBOOK> [--limit <ONLY_THIS_HOST[S]>] [--tags <ONLY_THIS_TAGS>]
# If the play contains secrets use:
ansible-playbook --ask-vault-password -i <PATH_TO_INVENTORY> <PLAYBOOK>
# If the play needs to become root use:
ansible-playbook --ask-become-pass -i <PATH_TO_INVENTORY> <PLAYBOOK>
# or
ansible-playbook --become-password-file <FILE_WITH_ROOT_PW> -i <PATH_TO_INVENTORY> <PLAYBOOK>
```

### Encrypt data
```bash
ansible-vault encrypt <PATH_TO_VAULT>
```

## Backgrund
The script performs all plays defined in the playbook. Every play can traget all hosts, a group of hosts or one sever:

```yml
- hosts: all          # all severs
  roles:
    - common
    - node-exporter

- hosts: webserver    # just webservers
  roles:
    - promtail
```
Each play can have multiple roles or tasks that are performed.  
To configure a role with custom settings to fit your server you can create `group_vars` and `host_vars` in your inventory folder.

The default values for each role are defined in `<role_name/defaults/main.yml>` and can look like that:
```yml
# promtail options
promtail_config_client_target: 'mgmt'
promtail_config_src_path: promtail-config.yml
promtail_config_dst_path: /srv/promtail/promtail-config.yml

promtail_args: '--client.external-labels=hostname={{ ansible_facts.hostname }} -config.file {{ promtail_config_dst_path }}'
```
Thes values can be overwritten by setting `group_vars` and `host_vars` or `--extra-vars KEY=VALUE` on the terminal

# Symbic Webserver Conf-Generator
This repo also contains a generator for different webserver configs.

See: [here](ingress-generator/ReadMe.md)
