package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	"github.com/Shopify/sarama"
	"github.com/quipo/statsd"
)

// Stays up until killed:
func main() {
	done := make(chan bool)
	go publishMessage()
	<-done

}

// Publish the message to a Kafka topic:
func publishMessage() {
	// Configurations settings:
	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll
	// Due to Kafka slow startup 'producer' shuts down as no brokers are available
	// Bump max retries from 3 to 30
	config.Metadata.Retry.Max = 30
	// Increase timeout between retries from 250ms to 10 seconds
	config.Metadata.Retry.Backoff = 10000000000
	config.Producer.Return.Successes = true
	config.ClientID = "theProducer"

	// Verbose logging:
	sarama.Logger = log.New(os.Stdout, "[sarama] ", log.LstdFlags)

	// List of brokers to connect to.
	// NB! This will not be used directly, will use returned values from this broker:
	brokers := []string{"192.168.100.10:9092"}
	// Set topic here:
	topic := "input"

	// statsd initialization:
	prefix := "producer."
	statsdclient := statsd.NewStatsdClient("192.168.100.10:9125", prefix)
	statsdErr := statsdclient.CreateSocket()

	if statsdErr != nil {
		// Should not reach here
		log.Println(statsdErr)
		// os.Exit(1)
	}

	stats := statsd.NewStatsdBuffer(1, statsdclient)
	defer stats.Close()

	// producer initialization
	producer, err := sarama.NewSyncProducer(brokers, config)
	if err != nil {
		// Should not reach here
		panic(err)
	}

	defer func() {
		if err := producer.Close(); err != nil {
			// Should not reach here
			panic(err)
		}
	}()

	for {
		// Prepare the message via unixTS function:
		msg := &sarama.ProducerMessage{
			Topic: topic,
			Value: sarama.StringEncoder(unixTS()),
		}

		// Send the message itself:
		partition, offset, err := producer.SendMessage(msg)
		if err != nil {
			panic(err)
		}

		fmt.Printf("Message is stored in topic(%s)/partition(%d)/offset(%d)\n", topic, partition, offset)

		// Increment the metric of sent messages:
		statsdclient.Incr("messages", 1)

	}
}

// Gets the current Unix timestamp in milliseconds and returns it in a string
func unixTS() string {
	// Unix has only Nano seconds:
	TsCurrentNano := time.Now().UnixNano() / int64(time.Millisecond)

	// Kafka has issues displaying int64 as a message:
	TsCurrentString := strconv.FormatInt(TsCurrentNano, 10)

	// Slow down to a seconds.
	// If need other timeframe define "dealaySeconds" and set to int value as in example:
	// time.Sleep(time.Second * time.Duration(delaySeconds))
	time.Sleep(time.Second)
	return TsCurrentString
}
