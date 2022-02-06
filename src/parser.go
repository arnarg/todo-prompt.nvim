package main

// #include <stdlib.h>
import "C"

import (
	"fmt"
	"strings"
	"time"
	"unsafe"

	"github.com/olebedev/when"
	"github.com/olebedev/when/rules/common"
	"github.com/olebedev/when/rules/en"
)

type Output struct {
	Task  string `json:"task"`
	Date  int64  `json:"date,omitempty"`
	Start int    `json:"start"`
	Stop  int    `json:"stop"`
}

func (o *Output) String() string {
	builder := strings.Builder{}

	fields := map[string]interface{}{
		"task":  o.Task,
		"date":  o.Date,
		"start": o.Start,
		"stop":  o.Stop,
	}

	for k, v := range fields {
		builder.WriteString(fmt.Sprintf("%s=%v\n", k, v))
	}

	return builder.String()
}

//export ParseTask
func ParseTask(task string) *C.char {
	output := &Output{
		Task: task,
	}

	w := when.New(nil)
	w.Add(en.All...)
	w.Add(common.All...)

	r, err := w.Parse(task, time.Now())
	if err != nil || r == nil {
		return C.CString(output.String())
	}

	// Remove date string from task
	t := strings.ReplaceAll(r.Source, r.Text, "")
	// Cleanup whitespace
	output.Task = strings.TrimSpace(t)
	output.Date = r.Time.Unix()
	output.Start = r.Index
	output.Stop = r.Index + len(r.Text)

	return C.CString(output.String())
}

//export Free
func Free(cptr *C.char) {
	C.free(unsafe.Pointer(cptr))
}

func main() {
}
