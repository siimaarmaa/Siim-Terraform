import os
import json

if not os.path.exists('generated_key.pem'):
  os.system("ssh-keygen -t rsa -b 4096 -C \"siim.aarmaa@hotmail.com\" -f generated_key.pem -q -N \"\"")

result = {
  'public_key': open('generated_key.pem.pub', 'r').read().replace('\n', '\n'),
  'private_key': open('generated_key.pem', 'r').read().replace('\n', '\n')
}

print(json.dumps(result))
