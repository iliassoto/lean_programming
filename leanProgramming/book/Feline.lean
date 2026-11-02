--Exercise to implement the cat function

--How big of a block of data will we read before printing it (20 kb here)
def bufsize : USize := 20 * 1024

/-
dump will read input one block at a time, dumping the result
to the standard output until the end of the input has been reached.

Note how the function should normally run on an endless loop. The stream does
not get smaller! This only works because we use the "partial" function
declaration. It means that the function calls itself recursively on input that
is not immediately smaller than an argument. The reason is that we know that
the stream will eventually terminate, but there is no way of proving it.

In a partial function, Lean does not need proof that the function will terminate.
Partial functions are therefore dangerous and way less sound for proving correctness.
-/

partial def dump (stream: IO.FS.Stream) : IO Unit := do
  let buf <- stream.read bufsize --read max20 kb from the provided input
  if buf.isEmpty then pure ()
  else
    let stdout <- IO.getStdout
    stdout.write buf
    dump stream --The stream is the same object, but it has changed in the meantime...



/-
We also want to be able to read files and provide their content as a stream so that
it can also be displayed. This means that our function fileStream will return an
Option IO.FS.Stream.

Opening a file as a stream takes two steps:
1. First, a file handle is created by opening the file in read mode.
2. Second, the file handle is given the same interface as a POSIX stream, which
fills each field of the Stream structure with the correspoding IO action that
works on file handles.In other words, the handle constucts the Stream structure
with several IO-actions.
-/
def fileStream (filename: System.FilePath) : IO (Option IO.FS.Stream) := do
  let fileExists <- filename.pathExists
  if not fileExists then
    let errorConsole <- IO.getStderr
    errorConsole.putStrLn s!"File not found {filename}"
    pure none
  else
    let handle <- IO.FS.Handle.mk filename IO.FS.Mode.read
    pure (some (IO.FS.Stream.ofHandle handle))



/-
We want to process arguments that are "-" as lines in the console that can be printed out as well
-/
def process (exitCode: UInt32) (args: List String): IO UInt32 := do
  match args with
  | [] => pure exitCode --if no args, return initial exit code
  | "--help" :: _ =>
    let console_out <- IO.getStdout
    console_out.putStrLn "These are the instructions"
    pure exitCode
  | "-" :: args =>
    let console_in <- IO.getStdin
    dump console_in
    process exitCode args
  | filename :: args =>
    let stream <- fileStream filename
    match stream with
    | none => process exitCode args
    | some stream =>
        dump stream
        process exitCode args

--Concat function
def main (args: List String): IO UInt32 :=
  match args with
  | [] => process 0 ["-"]
  | _ => process 0 args
