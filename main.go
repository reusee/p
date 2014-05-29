package main

/*
void run(int, char**);
#cgo pkg-config: Qt5Quick Qt5Widgets Qt5Qml
#cgo CXXFLAGS: --std=c++11
#cgo LDFLAGS: -lstdc++
*/
import "C"
import (
	"os"
	"runtime"
)

func main() {
	var cArgs []*C.char
	for _, arg := range os.Args {
		cArgs = append(cArgs, C.CString(arg))
	}
	runtime.LockOSThread()
	C.run(C.int(len(os.Args)), &cArgs[0])
}
