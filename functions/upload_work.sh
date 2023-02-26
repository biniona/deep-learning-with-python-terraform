#!/bin/bash

function upload_work {
    if [[ -z ${1} ]]; then  
        echo "Please specify a folder in the workspace directory to upload"
        kill -INT $$
    fi
    check_var_set
    readonly remote_path="/home/ubuntu/deep-learning-with-python-notebooks"
    scp -r -i aws_key "/Users/alek.binion/study/deep-learning-with-python/workspace/notebooks/$1" "ubuntu@$NOTEBOOK_IP:$remote_path"
    ssh -i aws_key "ubuntu@$NOTEBOOK_IP" rm -rf "$remote_path/workspace"
    ssh -i aws_key "ubuntu@$NOTEBOOK_IP" mv "$remote_path/$1" "$remote_path/workspace"
}
