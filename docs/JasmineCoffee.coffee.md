# boco-mdd-jasmine-coffee

Jasmine + CoffeeScript generator for [boco-markdown-driven]

    JasmineCoffee = require 'boco-mdd-jasmine-coffee'
    MarkdownDriven = require '../../boco-markdown-driven'

## Compiling

Just pass in a new `JasmineCoffee.Generator` to the `MarkdownDriven.Compiler` constructor:

    generator = new JasmineCoffee.Generator
    compiler = new MarkdownDriven.Compiler generator: generator

Let's go ahead and test compiling using our generator:

    markdown = $files['example.md']
    expected = $files['example.coffee']
    compiled = compiler.compile markdown
    expect(compiled).toEqual expected

```markdown
<!-- file: "example.md" -->
# Mather

Mather is a library for doing Math.

    Mather = require "mather"
    mather = new Mather

## Adding numbers

It adds two numbers:

  mather.add 2, 2, (error, result) ->
    throw error if error?
    expect(result).toEqual 4
    ok()

It adds more than two numbers:

  mather.add 3, 4, 5, (error, result) ->
    throw error if error?
    expect(result).toEqual 12
    ok()
```

```coffee
# file: "example.coffee"
$files = null

describe "Mather", ->
  [Mather, mather] = []

  beforeEach ->
    Mather = require "mather"
    mather = new Mather

  describe "Adding numbers", ->

    it "It adds two numbers:", (ok) ->
      result = mather.add 2, 2
      expect(result).toEqual 4
      ok()

    it "It adds more than two numbers:", (ok) ->
      result = mather.add 3, 4, 5
      expect(result).toEqual 12
      ok()
```

[boco-markdown-driven]: "https://github.com/bocodigitalmedia/boco-markdown-driven"
