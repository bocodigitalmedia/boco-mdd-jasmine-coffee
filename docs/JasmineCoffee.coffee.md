
# boco-mdd-jasmine-coffee
![npm version](https://img.shields.io/npm/v/boco-mdd-jasmine-coffee.svg)
![npm license](https://img.shields.io/npm/l/boco-mdd-jasmine-coffee.svg)
![dependencies](https://david-dm.org/bocodigitalmedia/boco-mdd-jasmine-coffee.png)

Jasmine + CoffeeScript generator for [boco-markdown-driven].

* [Installation](#installation)
* [Using the CLI](#using-the-cli)
* [Using the API](#using-the-api)

## Installation

Install both this library and [boco-markdown-driven] via [npm]:

```sh
$ npm install boco-mdd-jasmine-coffee boco-markdown-driven
```

## Using the CLI

Create a configuration file called `markdown-driven.json`:

```js
// file: "markdown-driven.json"
{
  "generator": "boco-mdd-jasmine-coffee",
  "parserOptions": {
    "nativeLanguages": ["coffee", "coffeescript"],
    "assertionCodePattern": /\bexpect\b/
  },
  "converterOptions": {
    "readDir": "docs",
    "writeDir": "spec",
    "writeExt": ".spec.coffee"
  }
}
```

Run the CLI:

```sh
$ boco-markdown-driven -c markdown-driven.json "docs/**/*.coffee.md"
```

See the CLI documentation on [boco-markdown-driven] for more information.

## Using the API

_note: you can view the example markdown and coffeescript files at the end of this section_

```coffee
JasmineCoffee = require 'boco-mdd-jasmine-coffee'
MarkdownDriven = require 'boco-markdown-driven'

generator = new JasmineCoffee.Generator
compiler = new MarkdownDriven.Compiler generator: generator
```

The compiler will now generate jasmine specs for your markdown:

``` coffee
markdown = $files['example.coffee.md']
expected = $files['example.spec.coffee']

compiled = compiler.compile $files['example.coffee.md']
expect(compiled).toEqual expected
```

---

```markdown
<!-- file: "example.coffee.md" -->
# Mather

Mather is a library for doing Math.

    Mather = require "mather"
    mather = new Mather

The following is made available to the `$files` variable:

    # file: "foo.coffee"
    # and this is the content

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
# file: "example.spec.coffee"
$files = {}

describe "Mather", ->
  [Mather, mather] = []

  beforeEach ->
    $files["foo.coffee"] = "# and this is the content\n"

    Mather = require "mather"
    mather = new Mather

  afterEach ->
    delete $files["foo.coffee"]

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

[boco-markdown-driven]: https://github.com/bocodigitalmedia/boco-markdown-driven
[npm]: https://npmjs.org
