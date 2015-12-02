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

    mather.add 2, 2, (error, result) ->
      throw error if error?
      expect(result).toEqual 4
      ok()

It adds more than two numbers:

    result = mather.add 2, 2, 2, (error, result) ->
      throw error if error?
      expect(result).toEqual 6
      ok()

"""

MarkdownDriven = require '../boco-markdown-driven/source'
JasmineCoffee = require './source'
parser = new MarkdownDriven.Parser nativeLanguages: ["coffee", "coffeescript"]
generator = new JasmineCoffee.Generator
compiler = new MarkdownDriven.Compiler parser: parser, generator: generator
tokens = require("coffee-script").tokens(example).filter ([type, text]) -> text is "eval"
result = compiler.compile example
console.log result
