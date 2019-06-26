In this example,
First , we deploy a busybox which will create a emptyDir and add a message in an index.html file.
Second,  on same deployment we add a apache that will expose the content of emptyDir on web page via a NodePort services ,
since these two containers share the emptyDir volume.
The  EmptyDir volume  is attached to the container "/tmp/emptyDir"  as /tmp/emptyDir from the host