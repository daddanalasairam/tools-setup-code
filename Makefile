infra:
    terraform init
    terraform apply -auto-approve

ansible:
    ansible-playbook -i $(tool_name)-internal.sairamdevops.online, -e ansible_user=ec2-user -e ansible_password=DevOps321 -e tool_name=$(tool_name) -e vault_token=$(vault_token) main.yml

#Run the file by using : git pull; Make ansible vault_token="" tool_name=vault

#To check in the website : https://vault.sairamdevops.online:8200/ui/