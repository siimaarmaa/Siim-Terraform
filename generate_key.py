import os
import json

if not os.path.exists('key_siimaarmaa.pem'):
  os.system("ssh-keygen -t rsa -b 4096 -C \"siim.aarmaa@hotmail.com\" -f key_siimaarmaa.pem -q -N \"\"")

result = {
  'public_key': open('key_siimaarmaa.pem.pub', 'r').read().replace('\n', '\n'),
  'private_key': open('key_siimaarmaa.pem', 'r').read().replace('\n', '\n')
}

print(json.dumps(result))
