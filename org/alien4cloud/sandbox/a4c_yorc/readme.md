# Rename inputs.json.tpl to inputs.json
# You need the following vars:
# - REMOTE_IP_ADDRESS: 34.247.177.225
# - REMOTE_USER: centos
# - PRIVATE_KEY_PATH: ~/work/env/aws/keys/vicos-awsproductteam.pem

# Install all stack on the remote machine
ansible-playbook -i $REMOTE_IP_ADDRESS, install-a4c-consul-yorc.yml --private-key $PRIVATE_KEY_PATH --user $REMOTE_USER --extra-vars "@inputs.json" -v

# change alien_url in inputs.json (ie. http://34.247.177.225:8088)
ansible-playbook -i $REMOTE_IP_ADDRESS, setup-a4c-artemis.yml --private-key $PRIVATE_KEY_PATH --user $REMOTE_USER --extra-vars "@inputs.json" -v

# That's all folk, the full system will be available

# To test the integration between A4C and Yorc:
# - Go to 'Application' / 'Nouvelle Application'
# - Give a name to your app (ie. MyFisrtTest)
# - In 'Modèle de topologie', choose '1TinyMock' template
# - Click on 'Créer'
# - In 'Work on an environment' section, click on the line 'Environment OTHER 0.1.0-SNAPSHOT'
# - Choose the "AWS Orchestrator: Yorc" under the 'Locations' blue button
# - Click on 'Vérifier & activer'
# - Click on 'Activer'
# - You will then see a progess bar ... if all is finally green, all is OK.
# - Click on 'Désactiver'
