/-
In order to make mathematical proofs, we need to "propose" something that needs
to be proven. Propositions are:
1 + 1 = 2
1 + 1 = 5
"Paris is the capital of France"

The following aren't propositions, as they are nonsense statements:
1 + 1 = ice-cream
"All capital cities are prime numbers"

In Lean, propositions are fact types(of type Prop):
-/

def OnePlusOneIsTwoProp : Prop := 1 + 1 = 2

/-
We now write a proof onePlusOneIsTwo. See that its type is not the general Prop,
but a specific proposition OnePlusOneIsTwoProp. Functions that have as type a
specific proposition have to be written as:

def <function_name> : <proposition> := <proof as a series of tactics>

We prove the proposition with reflexivity
-/

def onePlusOneIsTwo : OnePlusOneIsTwoProp := rfl --Compiles, but we get a warning... see below

def onePlusOneIsTwoo : 1 + 1 = 2 := rfl --We can also provide an anonymous propostition

def onePlusOneIsFive : 1 + 1 = 15 := rfl --prover sees that reflexivity cannot be applied here...


/-
1 + 1 evaluates directly to 2, which is why we can use rfl.
When a proposition has been proven (and we don't really care how), it's called a "theorem".
We can use the theorem keyword instead of def. It is not only good for redaibility,
but it also helps the compiler.

Theorems are written in the form:
theorem <theoremName> : <proposition> := <proof as a series of tactics>
-/

theorem onePlusOneIs2 : OnePlusOneIsTwoProp := rfl --no warning


/-
- Tactics are small programs that construct evidence for a proposition.
- Tactics run a proof state that tracks the statement that is to be proved (called the "goal")
- Running a tactic on a goal results in a new proof state that contains one or more new goals.
  The proof is finished when all the goals have been proven!

- To write a proof with tactics, we can begin the definition with the keyword "by".
  For example, we can write:
-/

theorem zero_mul (m : ℕ) : 0 * m = 0 := by --What is it we're proving?
  induction m with h hf --Which tactic are we using
  ... --Here comes the proof.


/-
Some tactics:

- rw --> Rewrite using another theorem? (see Natural Numbers game)

- rfl --> used to express that x = x

- decide --> Invokes a decision procedure, tries to return proof.
  Primarily used when working with concrete values like 1 or 2 (uses a collection of techniques).

- simp --> (short for simplify). Rewrites the goal to as simple a form as possible.
  In many cases, this rewriting simplifies the statement so much that it can be
  automatically proven. Behind the scenes, a detailed formal proof is constructued.

- grind --> Also uses techniches from SMT solvers. Unlike simp, grind can never make
  progress towards a proof without completing it entirely; it either succeeds or fails.
  The tactic is very powerful and customizable.
-/


/-
Connectives: "and", "or", "true", "false", "not" and implies are called "logical connectives".
- If A and B are propositions, then A ∧ B is also a proposition.

The decide tactic can prove theorems that use these connectives
-/

theorem onePlusOneOrLessThan : 1 + 1 = 2 ∨ 3 < 5 := by decide
theorem notTwoEqualFive : ¬(1 + 1 = 5) := by decide

/-
We can provide evidence as arguments!
-/

def third1 (xs : List String) := xs[3] --The compiler doesn't know if this won't fail!
def third2 (xs : List String) (myProof : xs.length > 3) := xs[3]
def third3 (xs : List String) : Option String := xs[3]? --Returns an option! (alternative approach)

#eval third2 ["hello", "how", "are", "you"] (by decide) --provide the proof as argument!


--Exercises:

theorem first: 2 + 3 = 5 := rfl

theorem smallerive: 5 < 18 := by decide
