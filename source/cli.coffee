MarkdownDriven = require 'boco-markdown-driven'
JasmineCoffee = require './'

parser = new MarkdownDriven.Parser
  nativeLanguages: ["coffee", "coffeescript"]

generator = new JasmineCoffee.Generator

compiler = new MarkdownDriven.Compiler
  parser: parser
  generator: generator

converter = new MarkdownDriven.Converter
  compiler: compiler
  readDir: "docs"
  writeDir: "spec"
  writeExt: ".spec.coffee"

cli = new MarkdownDriven.CLI
  converter: converter

cli.run()
