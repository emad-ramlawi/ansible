## Ansible Tricks and Tips

Make sure target(s) has the public SSH key of the controller (AWX) machine installed + python/python3 installed.

```
ssh root@target
nano ~/.ssh/authorized_keys
#add awx pub key
```

If you want to use hostnames and not IPs, be sure to add the the hostnames in AWS /etc/hosts:


```
nano /etc/hosts

```
