example = """
# Mather

Mather is a library for doing maths

    Mather = require 'mather'
    mather = new Mather

```
# file: "test.txt"
This is a text file
```
## Adding Numbers

    foo = eval()

It adds two numbers:

    result = mather.add 2, 2
    expect(result).toEqual 4

It adds more than two numbers:

    result = mather.add 2, 2, 2
    expect(result).toEqual 6

"""

MarkdownDriven = require '../boco-markdown-driven/source'
JasmineCoffee = require './source'
parser = new MarkdownDriven.Parser nativeLanguages: ["coffee", "coffeescript"]
generator = new JasmineCoffee.Generator
compiler = new MarkdownDriven.Compiler parser: parser, generator: generator
tokens = require("coffee-script").tokens(example).filter ([type, text]) -> text is "eval"
console.dir(tokens)
result = compiler.compile example
console.log result
