## producer app

Go binary for reading Unix timestamp and pushing those messages to a Kafka queue.
See source code comments for more detailed explanation.

#### cross compile
To compile for a different platform, use Go env settings:
```bash
env GOOS=linux GOARCH=amd64 go build . 
env GOOS=darwin GOARCH=amd64 go build . 
env GOOS=windows GOARCH=arm64 go build . 
```