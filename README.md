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
      mather.add 2, 2, (error, result) ->
        throw error if error?
        expect(result).toEqual 4
        ok()

    it "It adds more than two numbers:", (ok) ->
      mather.add 3, 4, 5, (error, result) ->
        throw error if error?
        expect(result).toEqual 12
        ok()
```

[boco-markdown-driven]: "https://github.com/bocodigitalmedia/boco-markdown-driven"

--------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2015 Christian Bradley, Boco Digital Media, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
