#!/bin/bash

function save_todays_work {
    check_var_set
    readonly today="$(date +'%Y%m%d')"
    readonly local_dir="/Users/alek.binion/study/deep-learning-with-python/workspace/notebooks/"
    scp -r -i aws_key "ubuntu@$NOTEBOOK_IP:/home/ubuntu/deep-learning-with-python-notebooks/workspace" "$local_dir"
    rm -rf "$local_dir/$today"
    mv "$local_dir/workspace" "$local_dir/$today"
}
