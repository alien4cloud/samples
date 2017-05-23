import os

publicIp = os.environ.get('PUBLIC_IP')

lines = []
with open('/opt/cloudify-stage/conf/manager.json') as infile:
    for line in infile:
        line = line.replace('127.0.0.1', publicIp)
        lines.append(line)
with open('/opt/cloudify-stage/conf/manager.json', 'w') as outfile:
    for line in lines:
        outfile.write(line)
