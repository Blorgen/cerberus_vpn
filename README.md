# Cerberus vpn

It's a learning project and just a good tool for me that I might wanna use in the future

## How I want to build it?

I plan it to be a vpn infrastructure with 3 heads (hence the name), each of 3 heads being a separate VPS.

1 - control center
2 - vpn node
3 - healthcheck instrument

The 1 one will have terraform, ansible and kuber implemented and will do some python scripts. It will make the other 2 ready and working and will also keep it in check. 

The 2 one will be just a vpn router for my traffic. I plan to use xray and amneziaWG as it's working in my country for now but I also want to check on Hysteria later.

The 3 one will be just an instrument for checking availability of the 2 one from the country of the user (ideally the same city and internet provider of course). 

## Tools

Orchestra: k3s and docker
IaC: Terraform
Configuration: Ansible
Scripts for automation: Python


_______

I haven't used most of these tools before so I though having a project would be a good way to learn them.
