infra:
	terraform init
	terraform apply -auto-approve

ansible:
	ansible-playbook -i $(tool_name)-internal.sairamdevops.online, -e ansible_user=ec2-user -e ansible_password=DevOps321 -e tool_name=$(tool_name) -e vault_token=$(vault_token) main.yml

#Run the file by using : git pull; Make ansible vault_token="" tool_name=vault

#To check in the website : https://vault.sairamdevops.online:8200/ui/

#Run the below command to get the github token
#  gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/daddanalasairam11/actions/runner/registration-token