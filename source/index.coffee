configure = ($ = {}) ->

  $.indentationString ?= "  "
  $.joinString ?= "\n\n"
  $.globalVariables ?= ["jasmine", "window", "require"]
  $.reduceUnique ?= (arr, v) -> arr.push(v) if arr.indexOf(v) is -1; arr
  $.CoffeeScript ?= require("coffee-script")

  class Snippets
    snippets: null
    indentationString: null
    joinString: null

    constructor: (props = {}) ->
      @[key] = val for own key, val of props
      @snippets ?= []
      @indentationString ?= $.indentationString
      @joinString ?= $.joinString

    indent: (code, depth) ->
      indentation = [1...depth].map(=> @indentationString).join('')
      code.replace /^/gm, indentation

    add: (code, depth = 0) ->
      @snippets.push @indent(code, depth)

    compile: ->
      @snippets.join(@joinString) + "\n"

  class CoffeeToken
    type: null
    value: null
    variable: null
    firstLine: null
    firstColumn: null
    lastLine: null
    lastColumn: null

    constructor: (props = {}) ->
      @[key] = val for own key, val of props

    @isVariable: (token) ->
      token.type is "IDENTIFIER" and token.variable

    @getValue: (token) ->
      token.value

    @convert: (csToken) ->
      [type, value, {first_line, first_column, last_line, last_column}] = csToken
      new CoffeeToken
        type: type, value: value, variable: csToken.variable,
        firstLine: first_line, firstColumn: first_column,
        lastLine: last_line, lastColumn: last_column

  class CoffeeService
    globalVariables: null

    constructor: (props) ->
      @[key] = val for own key, val of props
      @globalVariables ?= $.globalVariables

    tokenize: (code) ->
      $.CoffeeScript.tokens(code).map CoffeeToken.convert

    getVariableNames: (code) ->
      tokens = @tokenize(code).filter CoffeeToken.isVariable
      names = tokens.map CoffeeToken.getValue
      names.reduce $.reduceUnique, []

    isGlobalVariable: (v) ->
      v in @globalVariables

  class Generator
    coffeeService: null

    constructor: (props = {}) ->
      @[key] = val for own key, val of props
      @coffeeService ?= new CoffeeService

    getContextVariableNames: (node) ->
      beforeEachNodes = node.getBeforeEachNodes()
      code = beforeEachNodes.map(({code}) -> code).join("\n")
      vars = @coffeeService.getVariableNames code

      if (ancestorContexts = node.getAncestorContexts())?
        reduceAncestorVars = (vars, ancestorContext) => vars.concat @getContextVariableNames(ancestorContext)
        ancestorVars = ancestorContexts.reduce reduceAncestorVars, []
        vars = vars.filter (v) -> ancestorVars.indexOf(v) is -1

      vars.filter (v) => !@coffeeService.isGlobalVariable(v)

    compileFileNodes: (snippets, nodes) ->
      return snippets unless nodes.length

      depth = nodes[0].depth
      mockFsObject = nodes.reduce ((memo, {path, data}) -> memo[path] = data; memo), {}
      mockFsString = JSON.stringify mockFsObject, null, 2

      snippets.add "beforeEach ->", depth
      snippets.add "mockFsObject = #{mockFsString}", depth + 1
      snippets.add "require('mock-fs')(mockFsObject)", depth + 1
      snippets.add "afterEach ->", depth
      snippets.add "require('mock-fs').restore()", depth + 1
      snippets

    compileBeforeEachNodes: (snippets, nodes) ->
      return snippets unless nodes.length

      depth = nodes[0].depth
      code = nodes.map(({code}) -> code).join("\n")

      snippets.add "beforeEach ->", depth
      snippets.add code, depth + 1
      snippets

    compileAssertionNode: (snippets, node) ->
      {depth, text, code} = node
      snippets.add "it #{JSON.stringify(text)} ->", depth
      snippets.add code, depth + 1
      snippets

    compileAssertionNodes: (snippets, nodes) ->
      return snippets unless nodes.length
      nodes.reduce @compileAssertionNode.bind(@), snippets

    compileContextNode: (snippets, node) ->
      vars = @getContextVariableNames node
      snippets.add "describe #{JSON.stringify(node.text)} ->", node.depth
      snippets.add "[#{vars.join(', ')}] = []", node.depth + 1 if vars.length

      snippets = @compileFileNodes snippets, node.getFileNodes()
      snippets = @compileBeforeEachNodes snippets, node.getBeforeEachNodes()
      snippets = @compileAssertionNodes snippets, node.getAssertionNodes()
      snippets = @compileContextNodes snippets, node.getContextNodes()
      snippets

    compileContextNodes: (snippets, nodes) ->
      return snippets unless nodes.length
      nodes.reduce @compileContextNode.bind(@), snippets

    generate: (parseTree) ->
      snippets = @compileContextNodes new Snippets(), parseTree.getContextNodes()
      snippets.compile()

  JasmineCoffee =
    configuration: $
    configure: configure
    Generator: Generator
    CoffeeService: CoffeeService
    CoffeeToken: CoffeeToken
    Snippets: Snippets

module.exports = configure()
