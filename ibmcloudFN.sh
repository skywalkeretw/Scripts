#! /bin/bash

#
# login to IBM Cloud: ibmcloud login 
# target default: ibmcloud target -g Default
# traget rest: ibmcloud target --cf  
# create a action: ibmcloud fn action create <action_name> <action_file>
# invoke action: ibmcloud fn action invoke <action_name>
# get activation: ibmcloud fn get activation <activation_ID>

help () {
echo 'IBM Cloud Functions Template Generator

Usage: ibmcloudFN.sh <language>

Supported languages:
    go, php, node, python, swift, ruby

Note: IBM Cloud Functions (OpenWhisk) has been deprecated.
      Consider migrating to IBM Cloud Code Engine.
'
}

case $1 in
    go)
    FILENAME="main.go"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo 'package main

import "fmt"

// Main is the function implementing the action
func Main(params map[string]interface{}) map[string]interface{} {
    // parse the input JSON
    name, ok := params["name"].(string)
    if !ok {
        name = "World"
    }
    msg := make(map[string]interface{})
    msg["body"] = "Hello " + name + "!"
    // can optionally log to stdout (or stderr)
    fmt.Println("hello Go action")
    // return the output JSON
    return msg
}' > $FILENAME
    ;;

    php)
    FILENAME="main.php"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo '<?php

function main(array $args) : array
{
    $name = $args["message"] ?? "stranger";
    $greeting = "Hello $name!";
    echo $greeting;
    return ["greeting" => $greeting];
}' > $FILENAME
    ;;

    node)
    FILENAME="main.js"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo 'function main(params) {
    return { message: "Hello World" };
}' > $FILENAME
    ;;

    python)
    FILENAME="main.py"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo 'import sys

def main(dict):
    return { "message": "Hello world" }' > $FILENAME
    ;;

    swift)
    FILENAME="main.swift"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo 'struct Input: Codable {
    let name: String?
}
struct Output: Codable {
    let greeting: String
}
func main(param: Input, completion: (Output?, Error?) -> Void) -> Void {
    let result = Output(greeting: "Hello \(param.name ?? "stranger")!")
    completion(result, nil)
}' > $FILENAME
    ;;

    ruby)
    FILENAME="main.rb"
        if [[ -f "$FILENAME" ]]; then
            echo "Error: $FILENAME already exists. Aborting."
            exit 1
        fi
        echo "Creating $1 template in $FILENAME"
        echo 'def main(param)
name = param["name"] || "stranger"
greeting = "Hello #{name}!"
puts greeting
{ "greeting" => greeting }
end' > $FILENAME
    ;;
    
    help | -h | --help)
        help
        exit 0
    ;;

    *)
        echo "Error: '$1' is not a supported language"
        echo "Run 'ibmcloudFN.sh --help' for usage information"
        exit 1
    ;;

esac