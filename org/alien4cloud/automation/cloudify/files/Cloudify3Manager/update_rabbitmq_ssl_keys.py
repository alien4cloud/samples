#!/usr/bin/env python

import os
import shutil
import argparse
import subprocess


KEY_FILE = '/tmp/key.pem'
CERTIFICATE_FILE = '/tmp/cert.pem'


def _generate_new_key():
  print "Generate new key/certificate (key={} cert={})".format(KEY_FILE, CERTIFICATE_FILE)
  command = "/usr/bin/openssl req -x509 -nodes -newkey rsa:2048 -keyout {0} -out {1} -days 365 -batch".format(KEY_FILE, CERTIFICATE_FILE)
  process = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
  process.wait()
  output = process.communicate()[0]
  print(output)


def _backup_file(file):
  # Make a backup of the original file
  backup_file = file + '.save'
  if not os.path.isfile(backup_file):
    print "Backup file {} to {}".format(file, backup_file)
    shutil.copy(file, backup_file)

def replaceCertificate(inputs_file, certificate_file=CERTIFICATE_FILE):
  print "Replacing the certificate ({0})".format(certificate_file)

  with open(certificate_file, 'r') as f:
      cert_file = ''
      for line in f:
          cert_file += '    '+line

  with open(inputs_file, 'r') as f:
      content = f.read()

  # index() will raise an error if not found...
  BEGIN = '    -----BEGIN CERTIFICATE-----'
  END   = '  -----END CERTIFICATE-----'
  f1_start = content.index(BEGIN)
  f1_end = content.index(END, f1_start) + len(END)

  # Replace the certificate
  new_content=content[:f1_start]
  new_content+=cert_file
  new_content+=content[f1_end:]

  # Make a backup of the original file
  _backup_file(inputs_file)

  # Override the input file
  with open(inputs_file, 'w') as f:
      f.write(new_content)


def replaceKey(inputs_file, key_file=KEY_FILE):
  print "Replacing the private key ({0})".format(key_file)

  with open(key_file, 'r') as f:
      cert_file = ''
      for line in f:
          cert_file += '    '+line

  with open(inputs_file, 'r') as f:
      content = f.read()

  # index() will raise an error if not found...
  BEGIN = '    -----BEGIN PRIVATE KEY-----'
  END   = '  -----END PRIVATE KEY-----'
  f1_start = content.index(BEGIN)
  f1_end = content.index(END, f1_start) + len(END)

  # Replace the certificate
  new_content=content[:f1_start]
  new_content+=cert_file
  new_content+=content[f1_end:]

  # Make a backup of the original file
  _backup_file(inputs_file)

  # Override the input file
  with open(inputs_file, 'w') as f:
      f.write(new_content)


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('-src','--source_file', type=str, required=True)
  parser.add_argument('-cert','--certificate_file', type=str, required=False)
  parser.add_argument('-key','--key_file', type=str, required=False)
  kwargs = parser.parse_args()

  if 'certificate_file' not in kwargs or kwargs.key_file not in kwargs:
    _generate_new_key()
    replaceCertificate(kwargs.source_file)
    replaceKey(kwargs.source_file)
  else:
    replaceCertificate(kwargs.source_file, kwargs.certificate_file)
    replaceKey(kwargs.source_file, kwargs.key_file)


if __name__ == "__main__":
  main()