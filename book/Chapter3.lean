/-
Lean implements overloading ofmethods using a mechanism called type classes. A type class
describes a collection of overloadable operations.

Type classes in Lean are not the same as OOP-classes. They describe types that share
common attributes (e.g. implementations of certain operations). So they are closer to
the concept of interfaces in Java. An instance of a Lean class is the implementation of
the "requirements" in the Type belonging to that class.

We start with the definition for positive numbers (one or greater)
-/

inductive Pos : Type where
 | one : Pos
 | succ : Pos -> Pos

def three : Pos := Pos.succ (Pos.succ (Pos.one))


/-
The error "failed to synthetize" points to the fact that there are overloaded methods
or operations that haven't been implemented. Both errors describe the type classes that
must be implemented.
-/
def three_error : Pos := 3 --throws an error
def six_error : Pos := three + three --throws another error

/-
A type class (see above, it's like an interface in Java) consists of
- a name,
- some parameters --> Types for which overloadable operations are being defined.
- a collection of methods --> Signatures of overloadable operations.

We overload addition by defining a type class Plus with an a method plus.
Then we implement the type class for the Type Nat (== we create an instance of the class)
-/

class Plus (α : Type) where
    plus : α -> α -> α

instance : Plus Nat where --we're telling the compiler that Plus Nat is now a type (has now been implemented)
    plus := Nat.add --Each method has to be assigned.

-- we now implement the type class for our Positive numbers Type Pos:

def Pos.plus : Pos -> Pos -> Pos
    | Pos.one, k => Pos.succ k
    | Pos.succ n, k => Pos.succ (n.plus k)

instance : Plus Pos where
    plus := Pos.plus

-- Method is now overloaded!
#eval Plus.plus three three
#eval Plus.plus 5 3
