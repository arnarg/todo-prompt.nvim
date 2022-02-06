build/parser.so:
	go build -o build/parser.so -buildmode=c-shared ./src/parser.go
