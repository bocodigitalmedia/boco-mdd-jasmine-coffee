# boco-mdd-jasmine-coffee

Jasmine + CoffeeScript generator for [boco-markdown-driven]

    JasmineCoffee = require 'boco-mdd-jasmine-coffee'
    MarkdownDriven = require 'boco-markdown-driven'

## Configure the MarkdownDriven Compiler

Just pass in a new `JasmineCoffee.Generator` to the `MarkdownDriven.Compiler` constructor:

    compiler = new MarkdownDriven.Compiler
      generator: new JasmineCoffee.Generator

## Compiling

Let's go ahead and test compiling using our generator:

    compiled = compiler.compile require('fs').readFileSync('example.md').toString()
    expect(compiled).toEqual require('fs').readFileSync('expected.coffee').toString()

```markdown
<!-- file: "example.md" -->
# Mather

Mather is a library for doing Math.

    Mather = require 'mather'
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
describe "Mather", ->

  [Mather, mather] = []

  beforeEach ->

    Mather = require "mather"
    mather = new Mather

  it "adds two numbers", ->

    result = mather.add 2, 2
    expect(result).toEqual 4

  it "adds more than two numbers", ->

    result = mather.add 3, 4, 5
    expect(result).toEqual 12
```

[boco-markdown-driven]: "https://github.com/bocodigitalmedia/boco-markdown-driven"
