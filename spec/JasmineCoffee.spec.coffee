$files = {}

describe "boco-mdd-jasmine-coffee", ->

  describe "Using the API", ->
    [JasmineCoffee, MarkdownDriven, generator, compiler] = []

    beforeEach ->
      $files["example.coffee.md"] = "# Mather\n\nMather is a library for doing Math.\n\n    Mather = require \"mather\"\n    mather = new Mather\n\nThe following is made available to the `$files` variable:\n\n    # file: \"foo.coffee\"\n    # and this is the content\n\n## Adding numbers\n\nIt adds two numbers:\n\n    mather.add 2, 2, (error, result) ->\n      throw error if error?\n      expect(result).toEqual 4\n      ok()\n\nIt adds more than two numbers:\n\n    mather.add 3, 4, 5, (error, result) ->\n      throw error if error?\n      expect(result).toEqual 12\n      ok()\n"
      $files["example.spec.coffee"] = "$files = {}\n\ndescribe \"Mather\", ->\n  [Mather, mather] = []\n\n  beforeEach ->\n    $files[\"foo.coffee\"] = \"# and this is the content\\n\"\n\n    Mather = require \"mather\"\n    mather = new Mather\n\n  afterEach ->\n    delete $files[\"foo.coffee\"]\n\n  describe \"Adding numbers\", ->\n\n    it \"It adds two numbers:\", (ok) ->\n      mather.add 2, 2, (error, result) ->\n        throw error if error?\n        expect(result).toEqual 4\n        ok()\n\n    it \"It adds more than two numbers:\", (ok) ->\n      mather.add 3, 4, 5, (error, result) ->\n        throw error if error?\n        expect(result).toEqual 12\n        ok()\n"

      JasmineCoffee = require 'boco-mdd-jasmine-coffee'
      MarkdownDriven = require 'boco-markdown-driven'
      
      generator = new JasmineCoffee.Generator
      compiler = new MarkdownDriven.Compiler generator: generator

    afterEach ->
      delete $files["example.coffee.md"]
      delete $files["example.spec.coffee"]

    it "The compiler will now generate jasmine specs for your markdown:", ->
      markdown = $files['example.coffee.md']
      expected = $files['example.spec.coffee']
      
      compiled = compiler.compile $files['example.coffee.md']
      expect(compiled).toEqual expected
