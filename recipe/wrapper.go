package main

//import "fmt"
import "os"
import "os/exec"
import "path/filepath"
import "github.com/kardianos/osext"


func main() {
  exec_name, _ := osext.Executable()
  dir, file := filepath.Split(exec_name)
  new_exec_name := filepath.Clean(filepath.Join(dir, "..", "Library", "miktex", "miktex", "bin", file))
  cmd := exec.Command(new_exec_name, os.Args[1:]...)
  cmd.Stdin = os.Stdin
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr
  err := cmd.Run()
  if err != nil {
//        fmt.Fprintf(os.Stderr, "%v\n", err)
        os.Exit(1)
    }
}
