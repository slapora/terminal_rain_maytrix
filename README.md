# terminal_rain_maytrix


maytrix.sh - run in a terminal on RHEL8, resize before starting app.

maytrix2.sh - best one, but some refresh lag.

maytrix3.py - python version, not as good


For go app (compiled and faster than bash app)
---------

$ mkdir matrixrain

$ cd matrixrain

$ go mod init matrixrain (create go.mod module file)

put main.go file in this directory, tidy then run go app.

$ go mod tidy

$ go run main.go

compile from diretory with main.go

$ go build -o matrixrain main.go

$ ./matrixrain


