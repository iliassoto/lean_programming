### How to configure a project

- Lean can be compiled on the fly (using `lean --run MyFile.lean`), but it can also be compiled before for performance reasons. 
- The standard Lean build tool is called Lake (Lean Make). Lake is typically configured using a TOML file that declaratively specifies dependencies and describes what is to be built.
- `lake new greeting` will create a directory and a project called `greeting`.