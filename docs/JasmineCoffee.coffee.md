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

    result = mather.add 2, 2
    expect(result).toEqual 4

It adds more than two numbers:

    result = mather.add 3, 4, 5
    expect(result).toEqual 12
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

    it "It adds two numbers:", ->
      result = mather.add 2, 2
      expect(result).toEqual 4

    it "It adds more than two numbers:", ->
      result = mather.add 3, 4, 5
      expect(result).toEqual 12
```

[boco-markdown-driven]: "https://github.com/bocodigitalmedia/boco-markdown-driven"
