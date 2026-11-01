--Hello World in Editor
#eval 5 + 15
#eval String.append "Hello " "World"
#eval String.append "it is " (if 5<3 then "yes" else "no")


--TYPES
#eval (1+2 : Nat) --Type hinting
#eval 1-2 --Returns 0, as Nat is always positive
#eval (1-2 : Nat) --Returns 0, as Nat is always positive
#eval (1-2 : Int) --Returns -1
#check (1-5) --tells us the type!


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

-- Datatypes and Patterns.
/-
Product types (==complex data types) such as structures cannot represent everything in an easy manner.
Many applications may require a data structure with an arbitrary number of elements (e.g. a tree).
Datatypes that can include instances of themselves are called recursive datatypes,
while datatypes that allow choices (i.e. have more than one constructor) are called sum types.
Recursive + Sum types are called inductive datatypes, because we can use induction to prove statements
about them.

Inductive datatypes are close to writing an abstract class with two concrete classes in Scala or Java.
Instead of writing

abstract class Bool {}
class True extends Bool {}
class False extends Bool {}

we can write:
-/
inductive Bool2 where --cannot use the actual names, as they already exist.
 | false2 : Bool2 --constructor nr 1
 | true2 : Bool2 --constructor nr 2


inductive Nat2 where
  | zero2 : Nat2
  | succ2 (n : Nat2) : Nat2 --second constructor takes an argument

def three2: Nat2 := Nat2.succ2 (Nat2.succ2 (Nat2.succ2 Nat2.zero2))
-- The main difference is that here we only have one type with many constructors of one type,
--while in Java we have many types.

--Pattern matching
def isZero (n : Nat2) : Bool2 :=
  match n with
  | Nat2.zero2 => Bool2.true2
  | Nat2.succ2 k => Bool2.false2

-- Lean identifies recursive functions that won't finish, e.g.
def evenLoops (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => not (evenLoops n) --calls evenLoops with the same n.

--Polymorphism
-- Just as Lean uses a space to pass an argument into a function, it also uses a space
-- to pass an argument to a type. E.g. a List of Strings is:
def myList: List String := ["hello", "world"]

-- A polymorphic version of a Ppoint<T> is:
structure PPoint (T : Type) where
  x: T
  y: T

--normally written with greek letters:
structure PPoint2 ( α : Type) where
  x: α
  y: α


def natOrigin : PPoint Nat :=
  {x:= Nat.zero, y:= 0}

--the following function replaces the value of x of a PPOint with a value of type alpha
-- see how definitions may also be ploymorphic,
def replaceX (α : Type) (point : PPoint α) (newX : α) : PPoint α :=
  { point with x := newX }

#eval replaceX Nat natOrigin 5 --PPoint with x = 5.


/-
Implicit arguments are declared by wrapping them in curly braces instead
of parentheses when defining a function.
-/

def replaceY {α : Type} (point: PPoint α) (newY : α) : PPoint α :=
  {point with y := newY}

#eval replaceY natOrigin 3


def listLenght {T : Type} (xs: List T) : Nat :=
match xs with
| [] => 0
| _ :: ys => 1 + (listLenght ys)

#eval listLenght [2,3,45]
#eval [1,2,34].length --already part of the standard library


--In some cases, the compiler can automatically see the implicit parameters:
def listLength2 (xs: List α): Nat :=
  match xs with
  | [] => 0
  | _ :: ys => 1 + (listLength2 ys)

--Even easier: if we're pattern matching directly on the arguments provided, we
--don't need the match with keyword. Note how we have to rewrite the definition so that
-- the return type is a function
def listLength3: List α -> Nat
  | [] => 0
  | _ :: ys => 1 + (listLength3 ys)

def drop1 : Nat → List α → List α
  | Nat.zero, xs => xs
  | _, [] => []
  | Nat.succ n, _ :: xs => drop1 n xs


--Named arguments and patterns can also be used in the same definition
def fromOption (default : α) : Option α → α
  | none => default
  | some x => x

#eval fromOption 5 (some 3) --3
#eval fromOption 5 none --5
#check fromOption

--natural numbers can be matched using literal numbers and +.
def even : Nat → Bool
  | 0 => true
  | n + 1 => not (even n)


-- Further built-in datatypes (besides List):

--Option is used as follows.
def List.getHead {T : Type} (xs: List T): Option T :=
  match xs with
  | [] => none
  | y :: _ => some y

/-
Some naming convetions:
def List.head? --> method will return an Option (as above) (in Scala: list.get(0))
def List.head! --> Method fails if nothing found  (in Scala list(0))
def List.headD --> MEthod returns the provided default argument (in Scala list.getOrElse(0, 5))
-/

#eval [].head? -- fails, as the type of the list couldn't be determined by the compiler
#eval [].head? (α := Int) --explicitly provide type hint for empty list
#eval ([] : List Int).head? --easier...


/-
The Prod structure (Product) is a generic way of joining two values together. For instance,
a Prod Nat String contains a Nat and a String. It is very much like a 2-tuple. We could also
all it a Pair instead of a Product.
The Type Prod is typically written α × β:
-/

def fives1 : String × Int := {fst:= "five", snd:=5} --write times to get this sign.
def fives2 : String × Int := ("five", 5) --special notation for Prod Types.
def fives3 : Prod String Int := ("five", 5) --old-school way as we've learned before.
def fives4 : String × Int × Nat := ("five", 7, 4+3) --three elements, works because:
def fives5 : String × (Int × Nat) := ("five", (7, 4+3)) --this is what happens in the background (right associative)


/-
The Unit datatype has one argumentless constructor as it describes only a single value.

The Sum datatype is a generic way of allowing a choice between values of different types.
For example, a Sum String Int is either a String or an Int. Only use when writing very generic code,
otherwise use use inductive types. See example in book.
-/

def PetName : Type := String ⊕ String --write oplus to get this sign. a PetName can be a name of dogs or a name of cats.

def animals : List PetName :=
  [Sum.inl "Spot", Sum.inr "Tiger", Sum.inl "Fifi",
   Sum.inl "Rex", Sum.inr "Floof"]

def howManyDogs (pets : List PetName) : Nat :=
  match pets with
  | [] => 0
  | Sum.inl _ :: morePets => howManyDogs morePets + 1
  | Sum.inr _ :: morePets => howManyDogs morePets


/-
Exercises on Polymorphism
-/

--function that finds last entry of list
def lastEntry {a: Type} (xs: List a) :=
  match xs with
  | List.nil => none
  | y :: List.nil => some y
  | _ :: ys => lastEntry ys

--Find first entry that satisfies a given predicate
def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α :=
  match xs with
  | [] => none
  | x :: xs => if predicate x then some x else List.findFirst? xs predicate


def Prod.switch {α β : Type} (pair : α × β) : β × α := (pair.snd, pair.fst)

def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) :=
  match xs, ys with
  | [], _ | _, [] => []
  | x::xss, y::yss => (x, y) :: zip xss yss


def take {a : Type} (n: Nat) (xs : List a): List a :=
  match n, xs with
  | 0, _ | _, [] => []
  | _, x :: xss => x :: take (n-1) xss

#eval take 20 [1,2,5,3,6,8,3,74,47]
#eval take 5 [1,2,5,3,6,8,3,74,47]

--write a function that distributes products over sums
def distribute {a b y : Type} (pair : a × (b ⊕ y)) : (a × b) ⊕ (a × y) :=
  match pair.snd with
  | Sum.inr be => Sum.inr (pair.fst, be)
  | Sum.inl ypsilon => Sum.inl (pair.fst, ypsilon)


/-
CHARACTERS, STRINGS and SLICES
- characters are unicode
- Strings are an array of UTF-8 bytes paired with a cached character count. This means
that removing  a single character from a String can result in copying the remaining
characters to a new String.
- Slices are (sub)parts of the string and have the type String.Slice. They contain a reference
to a string along with the start and end poisitions of the slice. Operations such as dropping
prefixes of strings return slices rahter than allocating new strings, and large parts of the string API
are also implemented for slices.


- Many String functions similar to other Programming languages
-/

#eval "Hello " ++ "World" --concat
#eval "addchar".push '!' --add character to String

def tortoise := ("small tortoiseshell".drop 6).dropEnd 5 --Has type String.Slice
#check tortoise.copy -- Has type String --> Creates a String from a Slice.

--String methods are overloaded
#eval "red admiral".dropEndWhile 'l' --"red admira"
#eval "red admiral".dropEndWhile Char.isAlpha --"red "


--ADDITIONAL SYNTAX
/-Local Definitions:
Instead of doing:
-/
def unzip1 : List (α × β) → List α × List β
  | [] => ([], [])
  | (x, y) :: xys =>
    (x :: (unzip1 xys).fst, y :: (unzip1 xys).snd) --Problem: Each entry does two (non-tail) recursive calls.

def unzip : List (α × β) → List α × List β
  | [] => ([], [])
  | (x, y) :: xys =>
    let unzipped : List α × List β := unzip xys --Recursive call is named.
    (x :: unzipped.fst, y :: unzipped.snd) --The expression in which the local definition is avaiaible (body)must be on a new line


--Recursive let definitions must be explicitly named (unlike def).
def reverse (xs : List α) : List α :=
  let rec helper : List α → List α → List α
    | [], soFar => soFar
    | y :: ys, soFar => helper ys (y :: soFar)
  helper xs []


-- Anonymous functions are written with the fun keyword:
#check fun x => x + 1 -- Nat -> Nat
#check fun (x: Int) => x + 1 -- Int -> Int



/-
Each name in Lean occurs in a namespace, which is a collection of names.
Names are placed in namespaces using a dot "." so List.map is the name "map"
in the "List" namespace. Names in different namespaces do not conlfic with each other,
even if they are otherwise identical.

Names can be direclty defined within a namespace:
-/

def Nat.double (x: Nat) := x + x --we can add functions to predefined namespaces!
#eval 4.double --doesn't work
#eval (4 : Nat).double --help the compiler
#eval Nat.double 4


--create a new Namespace (without a type!)
namespace NewNamespace
def triple (x : Nat) : Nat := 3 * x
def quadruple (x : Nat) : Nat := 2 * x + 2 * x
end NewNamespace

#eval NewNamespace.triple 5 --15


--if let is syntactic sugar for Sum types:
inductive Inline : Type where
  | lineBreak
  | string : String → Inline
  | emph : Inline → Inline
  | strong : Inline → Inline

--a function that recognizes string elements and extracts their contents can be written:
def Inline.string? (inline : Inline) : Option String :=
  match inline with
  | Inline.string s => some s
  | _ => none

--An alternative way of writing this function's body uses if together with let:
def Inline.string2? (inline : Inline) : Option String :=
  if let Inline.string s := inline then some s
  else none


--String interpolation
#eval s!"three fives is {NewNamespace.triple 5}"
#check s!"three fives is {NewNamespace.triple}" --Don't pass a function to the String interpolation!
