#!/bin/bash

if ! [ -z "$(pip3 list | grep winrm)" ]; then
    echo "Funciona"
fi