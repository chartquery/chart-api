// Chart Render API – Go example
// Usage: CHARTQUERY_API_KEY=your-key go run chart.go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"time"
)

var client = &http.Client{Timeout: 120 * time.Second}

func call(method, target string, body []byte) []byte {
	var reader io.Reader
	if body != nil {
		reader = bytes.NewReader(body)
	}
	req, _ := http.NewRequest(method, target, reader)
	req.Header.Set("x-api-key", os.Getenv("CHARTQUERY_API_KEY"))
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(resp.Body)
	if resp.StatusCode >= 400 {
		fmt.Fprintf(os.Stderr, "HTTP %d: %s\n", resp.StatusCode, data)
		os.Exit(1)
	}
	return data
}

func main() {
	_ = url.Values{}
	_ = json.Valid
	params := url.Values{}
	params.Set("query", "{\"type\":\"bar\",\"title\":\"Monthly Sales\",\"legend\":\"bottom\",\"width\":1200,\"height\":600,\"device_pixel_ratio\":1,\"data\":{\"labels\":[\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\",\"Jun\"],\"datasets\":[{\"label\":\"2025\",\"data\":[42,58,37,65,49,72],\"backgroundColor\":\"rgba(99,102,241,0.85)\"},{\"label\":\"2026\",\"data\":[51,67,44,71,58,85],\"backgroundColor\":\"rgba(249,115,22,0.85)\"}]},\"scales\":{\"y\":{\"beginAtZero\":true}}}")
	target := "https://api.chartquery.com/v1/chart"
	if len(params) > 0 {
		target += "?" + params.Encode()
	}
	data := call("GET", target, nil)
	if err := os.WriteFile("chart.png", data, 0o644); err != nil {
		panic(err)
	}
	fmt.Println("Saved chart.png")
}
