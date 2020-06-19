### What is this role for? ###

* Installing tomcat role
* 0.1

### How do I get set up? ###

Notice the prod and stg are being separated by different inventory files files, here is an example on how to run and setup.

```
git clone git@bitbucket.org:paramountcommercecom/ansible.git
cd ansible/roles/tomcat
```

Ensure you have the correct hosts specified, and that ansible controller can reach the target using ssh key exchange, then run:

```
ansible-playbook -i inventory.qa -l kvm_test main.yml --extra-vars "@vars/main.yml"
ansible-playbook -i inventory.qa -l kvm_test main.yml --extra-vars "@vars/main.yml" --ask-vault-pass

```

You can test connectivity by target machines without invoking commands by:

```
ansible test -i inventory.qa -m ping
```

Also be sure to edit/check the vars/main.yml first.

