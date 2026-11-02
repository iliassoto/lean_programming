/-
- IO α is the type of program that will either throw an exception or it will return a value of type α.
- During execution, this program may have side effects (interacting with the outside world). The executions
with the outside world are called IO actions.

- IO.println has the type String -> IO Unit

- We talk about Lean's Run-Time-System (RTS) as the part of Lean that will interact with the outside world.
Its primitives are written mostly in C, whereas the Lean language (which is purely functional) is also written in Lean.

- One can think of IO-actions as instructions that need to be carried out by the Lean part.
-/

def main0 : IO Unit := IO.println s!"Hello, World!" --main has to have the IO Unit Type.

/-
In order to allow multiple effects in a program, the do-notation allows these IO
primitives to be safely composed into a larger, useful program.

In the following program, the IO action consists of one do block, which has a series of statements
defined with the help of the let notation and actions to be executed. Just as SQL can be thought of a
language interacting with databases, the do notation is a sub-language dedicated to modeling imperative programs.
Statements are executed in order.

In:
let a <- someExpression
let b := someOtherExpression

a returns an IO action type that will be executed later.
b only returns a value that will not be executed later.
-/

def main2: IO Unit := do
  let console_in <- IO.getStdin --IO action (not being executed, just found)
  let console_out <- IO.getStdout --IO action, also not being executed

  console_out.putStrLn "What's your name?" --actually executes an action!
  let input <- console_in.getLine
  let name := input.dropEndWhile Char.isWhitespace --expression will be evaluated, resulting value need not be an IO action!
  console_out.putStrLn s!"Hello, {name}!"


--Carry out an action n times
def nTimes (action : IO Unit) : Nat → IO Unit
  | 0 => pure () --Returns the base case of a Unit type.
  | n + 1 => do
    action
    nTimes action n


--Exercise
def main : IO Unit := do
  let englishGreeting := IO.println "Hello!" --Expression is evaluated and returns an action (without executing it)
  IO.println "Bonjour!" --action is executed
  englishGreeting --action is executed


--see feline code
