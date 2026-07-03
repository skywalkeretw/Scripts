/**
 *
 * main() will be run when you invoke this action
 *
 * @param Cloud Functions actions accept a single parameter, which must be a JSON object.
 *
 * @return The output of this action, which must be a JSON object.
 *
 */
 package main

 import (
	 "encoding/json"
	 "fmt"
	 "io"
	 "net/http"
 )
 
 type Joke struct {
	 IconURL string `json:"icon_url"`
	 ID      string `json:"id"`
	 URL     string `json:"url"`
	 Value   string `json:"value"`
 }
 
 // Main is the function implementing the action
 func Main(params map[string]interface{}) map[string]interface{} {
 
	 resp, err := http.Get("https://api.chucknorris.io/jokes/random")
	 if err != nil {
		 return map[string]interface{}{"error": err.Error()}
	 }
	 defer resp.Body.Close()
 
	 body, err := io.ReadAll(resp.Body)
	 if err != nil {
		 return map[string]interface{}{"error": err.Error()}
	 }
 
	 var joke Joke
 
	 err = json.Unmarshal(body, &joke)
	 if err != nil {
		 return map[string]interface{}{"error": "failed to parse joke: " + err.Error()}
	 }
	 
	 msg := make(map[string]interface{})
	 msg["body"] = joke.Value
	 // can optionally log to stdout (or stderr)
	 fmt.Println("Chuck Norris joke retrieved successfully")
	 // return the output JSON
	 return msg
 }