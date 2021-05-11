#! /bin/bash

#
# login to IBM Cloud: ibmcloud login 
# target default: ibmcloud target -g Default
# traget rest: ibmcloud target --cf  
# create a action: ibmcloud fn action create <action_name> <action_file>
# invoke action: ibmcloud fn action invoke <action_name>
# get activation: ibmcloud fn get activation <activation_ID>

help () {
echo 'Help use ohne of these params:
    go, php, node, python, swift, ruby  
'
}

echo "creating"

case $1 in
    go)
    FILENAME="main.go"
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
        echo 'function main(params) {
    return { message: "Hello World" };
}' > $FILENAME
    ;;

    python)
    FILENAME="main.py"
        echo 'import sys

def main(dict):
    return { "message": "Hello world" }' > $FILENAME
    ;;

    swift)
    FILENAME="main.swift"
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
        echo 'def main(param)
name = param["name"] || "stranger"
greeting = "Hello #{name}!"
puts greeting
{ "greeting" => greeting }
end' > $FILENAME
    ;;
    
    help | -h | --help)
        help
        exit 1
    ;;

    *)
        echo "$1 doesn't exist"
        exit 1
    ;;

esac

echo "Creating $1 template in $FILENAME"