package main

import "C"
import (
	"fmt"
	"time"
)

//export fmtTime
func fmtTime(position int, duration int, rate int) *C.char {
	return C.CString(fmt.Sprintf("%.2f%% %v of %v %dx to %v",
		float64(position)/float64(duration)*100,
		time.Millisecond*time.Duration(position),
		time.Millisecond*time.Duration(duration),
		rate,
		time.Millisecond*time.Duration(duration/rate)))
}
