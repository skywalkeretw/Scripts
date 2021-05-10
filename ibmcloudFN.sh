#! /bin/bash

#
# login to IBM Cloud: ibmcloud login 
# target default: ibmcloud target -g Default
# traget rest: ibmcloud target --cf  
# create a action: ibmcloud fn action create <action_name> <action_file>
# invoke action: ibmcloud fn action invoke <action_name>
# get activation: ibmcloud fn get activation <activation_ID>

case $1 in
    go)
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
}' > main.go
    ;;

    php)
        echo '<?php

function main(array $args) : array
{
    $name = $args["message"] ?? "stranger";
    $greeting = "Hello $name!";
    echo $greeting;
    return ["greeting" => $greeting];
}' > main.php
    ;;

    node)
        echo 'function main(params) {
    return { message: "Hello World" };
}' > main.js
    ;;

    python)
        echo 'import sys

def main(dict):
    return { "message": "Hello world" }' > main.py
    ;;

    swift)
    echo 'struct Input: Codable {
    let name: String?
}
struct Output: Codable {
    let greeting: String
}
func main(param: Input, completion: (Output?, Error?) -> Void) -> Void {
    let result = Output(greeting: "Hello \(param.name ?? "stranger")!")
    completion(result, nil)
}' > main.swift
    ;;

    ruby)
        echo 'def main(param)
name = param["name"] || "stranger"
greeting = "Hello #{name}!"
puts greeting
{ "greeting" => greeting }
end' > main.rb
    ;;

esac