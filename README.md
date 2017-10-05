-=- October 1, 2017 -=-

# DevOps Exercise
Below is the overall idea of a solution from what I could understand by reading the exercise. HF.

# Prerequisites
- Amazon EC2 instance with HTTP + HTTPS security groups binding
- Any reasonable Linux flavor installed, updated and upgraded
- Instance IP or DNS
- Ruby and RubyGem basic ecosystem
- Chef Solo (included with Chef)
- Chef Solo installation log's location
- Knife, Knife Solo and Librarian-Chef tools
- OpenSSL
- SSL key and certificate may already be generated and currently accessible from the server hard drive (optional - can be generated using Chef as well)
- A _log_ directory at the root level of your account's home directory

# Plan
According to the exercice's description, the following technical steps are to automated in order to fully complete the sequence:

- install node.js (from packages - any LTS version is always a good pick, ie. v6 or v8 in a few days)
- check for NPM
- grab and install node-static from npmjs.com
- apply node-static server configuration as defined (to serve Chef Solo installation log file)
- launch the node-static server
- grab and install nginx
- generate a self-signed SSL certificate (for development purpose only)
- generate a tuple username:password in htpasswd
- apply nginx configuration as defined (SSL/TLS for HTTPS and Basic HTTP Authentication)
- start/reload the nginx server
- issue a HTTP HEAD request in order to ping https://arterys.com/install-complete (is it serviceable?)
- if the response if successful then issue an HTTP POST request to the same endpoint URL
- try and check the response from the second request and log it somewhere appropriately

# Chef Solo Execution
```
$ sudo chef-solo -c ~/chef-repo/solo.rb -j ~/chef-repo/nodes/node.json > ~/log/chef_install.log
```

If you want to get rid of all these color codes in output just use the following command instead:

```
$ sudo chef-solo -c ~/chef-repo/solo.rb -j ~/chef-repo/nodes/node.json sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" > ~/log/chef_install.log
```

Access is granted by using the foo:bar tuple identifier.

# Design and Use
This setup typically matches the configuration of reverse proxy cache servers. Their primary function is to deliver static content files/assets faster (usually by being closer) to clients. They form the basic building blocks of a CDN network.

# Comments and Thoughs
This was my first experience using both Chef and the Ruby language. I have listed all the manual steps to achieve the expected result. These are fairly simple and can be completed in less than half an hour in a (nut)shell.
I could not finish entirely though as I spent quite some time reading and testing and getting a bit less apart from the entire Ruby/Chef ecosystem. The entire process took me about 24 hours, which is a crazy big amount of time for such a simple sequence of tasks. I went at first for the low-paced manual way towards the solution and relied strongly on shell commands. But as I was learning my way around Chef I tried and partially replaced those instructions with some Chef recipes, resources, templates and attributes. And all the content that can be found on supermarket.chef.io and other sites alike.

SSL keys should be handled using Encrypted Data Bags. I am getting there.

This is my first commit. Tomorrow I will try and finish the exercise entirely as I am very close to completing the automated sequence of tasks, one way (fancy cookbooks, elaborated templates, encrypted data-bags and obscure librairies) or the other (more basic bash commands lightly wrapped inside Chef/Ruby resources).

I left environments and roles aside. These are great to have yet they do not leverage any substantial benefit in this particular case.

I feel balance between static and dynamic installation is still to be found. It is depending quite a lot on the infrastructure - is it moving a lot or not.

# Troubleshooting
If you let Ubuntu (16.04 LTS) apt install Chef Client automagically it it will pick a version that is older than 12.5.
The most popular (and currently not deprecated) Knife supermarket cookbook for nodejs is NOT compatible with this older version.
See https://github.com/chef-cookbooks/iptables/issues/49 for reference.

# Additional Questions
-1- Explain various options available to email the chef-solo log file when the installation is complete.

- Setup a mail server like postfix, sendmail or exim. Can be achieved by using Chef cookbooks.
- Post the file to another server which is going to grab the file and mail it as attachement.
- Send the file once it has been generated to a queue to get processed and mailed by another server/service.
- Once the log file has been detected/created, extract its content and text it using AWS SNS.

-2- Explain various options available to monitor the system logs on this server remotely.

- old school fully manual: SSH + tail -f (depends on the level of accuracy you want/need to achieve)
- fancy fully managed: LogStash + Kibana + FileBeat (from the Open Source Elastic Stack - very powerful combination)
- programmatic: StatsD + Grafana
- Go-between solutions: home-made Bash/PHP/Python/Node scripts using parsing commands (grep, sed, awk, etc) and powerful JSON processors like jq
- methodologic: producing reports on a regular basis is a good way to monitor systems as well

These solutions do not contradict. They can definitely be used alongside each other or in combination.

It also depends on the nature of the monitoring: is it real-time or post-generation observation? What are we looking for? On which volume and time scale?

If you want to reach a better control and raise your overall perspective on logging accuracy you could also implement other solutions like StatsD + Grafana, then find and install or custom build a comparison tool (so Grafana hopefully ends up giving you the same picture of the actual gobal state as your log file processing and analysis do).
The general idea is to multiply the sources of information related to the on-going operations so you can linearly mulitply your analysis abilities, by comparing results and find any potential missing pieces.

