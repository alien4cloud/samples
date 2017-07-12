#!/bin/bash -e

if [ -d /etc/ansible ] ; then
    echo "ansible already installed on this machine, aborting"
    exit 1
fi

sudo yum -y install python-cffi
sudo yum -y install gcc
sudo yum -y install python-devel
sudo yum -y install libffi-devel 
sudo yum -y install openssl-devel
sudo yum -y install python-setuptools python-setuptools-devel
sudo easy_install pip
sudo pip install cffi --upgrade
sudo pip install ansible==2.0.1.0
sudo pip install --upgrade setuptools

cat <<EOF > /tmp/ansible.cfg
[defaults]
callback_whitelist = tree

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=600s
retries = 10
EOF

sudo mkdir /etc/ansible
sudo mv /tmp/ansible.cfg /etc/ansible/ansible.cfg

cat <<EOF > /tmp/tree.py.patch
@@ -19,6 +19,7 @@
 __metaclass__ = type

 import os
+import json

 from ansible.plugins.callback import CallbackBase
 from ansible.utils.path import makedirs_safe
@@ -39,26 +40,28 @@
     def __init__(self):
         super(CallbackModule, self).__init__()

-        self.tree = TREE_DIR
+        self.tree = os.environ['TREE_DIR']
         if not self.tree:
             self.tree = os.path.expanduser("~/.ansible/tree")
             self._display.warning("The tree callback is defaulting to ~/.ansible/tree, as an invalid directory was provided: %s" % self.tree)

-    def write_tree_file(self, hostname, buf):
+    def write_tree_file(self, hostname, name, buf):
         ''' write something into treedir/hostname '''

-        buf = to_bytes(buf)
+        buf = {'task_name': "{}".format(name), 'result': json.loads(buf)}
+        #buf = to_bytes(buf)
+        buf = json.dumps(buf)
         try:
             makedirs_safe(self.tree)
             path = os.path.join(self.tree, hostname)
-            with open(path, 'wb+') as fd:
-                fd.write(buf)
+            with open(path, 'ab+') as fd:
+                fd.write("{}\n".format(buf))
         except (OSError, IOError) as e:
             self._display.warning("Unable to write to %s's file: %s" % (hostname, str(e)))

     def result_to_tree(self, result):
         if self.tree:
-            self.write_tree_file(result._host.get_name(), self._dump_results(result._result))
+            self.write_tree_file(result._host.get_name(), result._task, self._dump_results(result._result))

     def v2_runner_on_ok(self, result):
         self.result_to_tree(result)
EOF

sudo yum -y  install patch
sudo cp /usr/lib/python2.7/site-packages/ansible/plugins/callback/tree.py tree.py.back
sudo patch /usr/lib/python2.7/site-packages/ansible/plugins/callback/tree.py /tmp/tree.py.patch
sudo pip install httplib2
sudo pip install boto
