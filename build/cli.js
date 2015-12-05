// Generated by CoffeeScript 1.10.0
var JasmineCoffee, MarkdownDriven, cli, compiler, converter, generator, parser;

MarkdownDriven = require('boco-markdown-driven');

JasmineCoffee = require('./');

parser = new MarkdownDriven.Parser({
  nativeLanguages: ["coffee", "coffeescript"]
});

generator = new JasmineCoffee.Generator;

compiler = new MarkdownDriven.Compiler({
  parser: parser,
  generator: generator
});

converter = new MarkdownDriven.Converter({
  compiler: compiler,
  readDir: "docs",
  writeDir: "spec",
  writeExt: ".spec.coffee"
});

cli = new MarkdownDriven.CLI({
  converter: converter
});

cli.run();

//# sourceMappingURL=cli.js.map