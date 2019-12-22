// Main package for the producer
package main

import (
	"fmt"
	"time"
)

func main() {
	/* Stays on running indefinetely */
	done := make(chan bool)
	go unixNow()
	<-done

}

func unixNow() {
	/* Stays on running indefinetely */
	delaySeconds := 5
	for {
		fmt.Println(time.Now().Unix())
		time.Sleep(time.Second * time.Duration(delaySeconds))
	}
}
