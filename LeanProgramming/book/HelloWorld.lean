/-
- IO α is the type of program that will either throw an exception or it will return a value of type α.
- During execution, this program may have side effects (interacting with the outside world). The executions
with the outside world are called IO actions.

- IO.println has the type String -> IO Unit

- We talk about Lean's Run-Time-System (RTS) as the part of Lean that will interact with the outside world.
Its primitives are written mostly in C, whereas the Lean language (which is purely functional) is also written in Lean.

- One can think of IO-actions as instructions that need to be carried out by the Lean part.
-/

def main : IO Unit := IO.println s!"Hello, World!" --main has to have the IO Unit Type.
