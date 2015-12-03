$files = null

describe "boco-mdd-jasmine-coffee", ->
  [JasmineCoffee, MarkdownDriven] = []

  beforeEach ->
    JasmineCoffee = require 'boco-mdd-jasmine-coffee'
    MarkdownDriven = require '../../boco-markdown-driven'

  describe "Compiling", ->
    [generator, compiler] = []

    beforeEach ->
      $files = {
        "example.md": "# Mather\n\nMather is a library for doing Math.\n\n    Mather = require \"mather\"\n    mather = new Mather\n\n## Adding numbers\n\nIt adds two numbers:\n\n  mather.add 2, 2, (error, result) ->\n    throw error if error?\n    expect(result).toEqual 4\n    ok()\n\nIt adds more than two numbers:\n\n  mather.add 3, 4, 5, (error, result) ->\n    throw error if error?\n    expect(result).toEqual 12\n    ok()\n",
        "example.coffee": "$files = null\n\ndescribe \"Mather\", ->\n  [Mather, mather] = []\n\n  beforeEach ->\n    Mather = require \"mather\"\n    mather = new Mather\n\n  describe \"Adding numbers\", ->\n\n    it \"It adds two numbers:\", (ok) ->\n      result = mather.add 2, 2\n      expect(result).toEqual 4\n      ok()\n\n    it \"It adds more than two numbers:\", (ok) ->\n      result = mather.add 3, 4, 5\n      expect(result).toEqual 12\n      ok()\n"
      }
      generator = new JasmineCoffee.Generator
      compiler = new MarkdownDriven.Compiler generator: generator

    afterEach ->
      $files = null

    it "Let's go ahead and test compiling using our generator:", ->
      markdown = $files['example.md']
      expected = $files['example.coffee']
      compiled = compiler.compile markdown
      expect(compiled).toEqual expected
