#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
echo "Test input with all types of variables"
# simple property
echo "Comment with instanciated variables : ${comment}"

# Diplaying data file
echo "Display local data artifact file"
cat ${data}

if [ -z "$http_artifact" ]; then
    echo "http_artifact is not set"
    #exit 1
else
    echo "Display http artifact file" 
    cat ${http_artifact}
fi

if [ -z "$git_artifact" ]; then
    echo "git_artifact is not set"
    #exit 1
else
    echo "Display git artifact file" 
    cat ${git_artifact}
fi

if [ -z "$maven_artifact" ]; then
    echo "maven_artifact is not set"
    #exit 1
else
    echo "Display maven artifact file" 
    cat ${maven_artifact}    
fi