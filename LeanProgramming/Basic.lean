--Hello World in Editor
#eval 5 + 11
#eval String.append "Hello " "World"
#eval String.append "it is " (if 5<3 then "yes" else "no")


--TYPES
#eval (1+2 : Nat) --Type hinting
#eval 1-2 --Returns 0, as Nat is always positive
#eval (1-2 : Nat) --Returns 0, as Nat is always positive
#eval (1-2 : Int) --Returns -1
#check (1-2) --tells us the type!


--Functions
def hello := "Hello" --of type String. The '=' operator is used for equality.
def w : String := " World!" --of type String with hint. Everything can be a def (a method, a value, a type, etc...) --> Everything is a function!
#eval String.append hello w --functions are values as well.
def add1 (n: Nat) : Nat := n + 1
#eval add1 8
def maximum (n:Nat) (m:Nat) : Nat := --type Nat -> Nat -> Nat
  if n < m then m else n
#eval maximum 2 3
#check maximum
def minimum(n m :Nat) := if n < m then n else m

def Str1 : Type := String --Types are a first-class part of the language, they are expressions like any other.
def hi : Str1 := "hi" --works

def NaturalNumber : Type := Nat
--def thirtyeights: NaturalNumber := 38 --fails because of overloading...
def thirtyeight2: NaturalNumber := (38 : Nat) --works.

abbrev NaturalNumberTwo : Type := Nat
def thirtyeight3: NaturalNumberTwo := 38 --works. Abbreviations are not the same as dfining new types.


--Structures. Defining a structure (like classes in Java) introduces a new type to Lean that can't be reduced to any other type.
structure Point where
  x: Float
  y: Float

def origin: Point := {x := 0.0, y:= 0.0}
#eval origin
#eval origin.x

def distance (p1 : Point) (p2 : Point) : Float :=
  Float.sqrt (((p2.x - p1.x) ^ 2.0) + ((p2.y - p1.y) ^ 2.0))
#eval distance { x := 1.0, y := 2.0 } { x := 5.0, y := -1.0 }
--#check { x := 0.0, y := 0.0 } -- doesn't recognize the type
#check ({ x := 0.0, y := 0.0 } : Point) -- Needs a hint
#check { x := 0.0, y := 0.0  : Point} -- Saves the parentheses...

def setXtoZero (p : Point) : Point := --setter in functional way
  {x:=0, y:=p.y}

def setXtoZero2 (p: Point): Point := --"copy" method for ease
  {p with x:=0}

--three types of constructors
def p1 := {x := 1, y := 2 : Point}
def p2 : Point := {x := 1, y := 2}
def p3 := Point.mk 1 2 --the "make" method (not very clean / elegant). The mk function has type Float -> Float -> Point

--The constructors default name of "mk" can be overriden by putting a :: before the arguments in the structure:
structure Book where
  makeBook ::
  title : String
  author : String

def book1 := Book.makeBook "Harry Potter" "JK Rowling"
