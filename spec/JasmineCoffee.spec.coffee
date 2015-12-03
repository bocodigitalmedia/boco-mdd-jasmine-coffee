$files = null

describe "boco-mdd-jasmine-coffee", ->

  describe "Installation", ->

  describe "Using the CLI", ->

  describe "Using the API", ->
    [JasmineCoffee, MarkdownDriven, generator, compiler] = []

    beforeEach ->
      $files = {
        "example.md": "# Mather\n\nMather is a library for doing Math.\n\n    Mather = require \"mather\"\n    mather = new Mather\n\n## Adding numbers\n\nIt adds two numbers:\n\n    mather.add 2, 2, (error, result) ->\n      throw error if error?\n      expect(result).toEqual 4\n      ok()\n\nIt adds more than two numbers:\n\n    mather.add 3, 4, 5, (error, result) ->\n      throw error if error?\n      expect(result).toEqual 12\n      ok()\n",
        "example.spec.coffee": "$files = null\n\ndescribe \"Mather\", ->\n  [Mather, mather] = []\n\n  beforeEach ->\n    Mather = require \"mather\"\n    mather = new Mather\n\n  describe \"Adding numbers\", ->\n\n    it \"It adds two numbers:\", (ok) ->\n      mather.add 2, 2, (error, result) ->\n        throw error if error?\n        expect(result).toEqual 4\n        ok()\n\n    it \"It adds more than two numbers:\", (ok) ->\n      mather.add 3, 4, 5, (error, result) ->\n        throw error if error?\n        expect(result).toEqual 12\n        ok()\n"
      }
      JasmineCoffee = require 'boco-mdd-jasmine-coffee'
      MarkdownDriven = require 'boco-markdown-driven'
      
      generator = new JasmineCoffee.Generator
      compiler = new MarkdownDriven.Compiler generator: generator

    afterEach ->
      $files = null

    it "The compiler will now generate jasmine specs for your markdown:", ->
      compiled = compiler.compile $files['example.md']
      expect(compiled).toEqual $files['example.spec.coffee']
