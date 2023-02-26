#!/bin/bash

function check_var_set {
    if [[ -z ${NOTEBOOK_IP} ]]; then  
        echo "You must set your NOTEBOOK_IP environment variable"
        kill -INT $$
    fi
}
