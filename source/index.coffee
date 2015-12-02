configure = ($ = {}) ->

  $.indentationString ?= "  "
  $.joinString ?= "\n"
  $.reduceUnique ?= (arr, v) -> arr.push(v) if arr.indexOf(v) is -1; arr
  $.CoffeeScript ?= require("coffee-script")
  $.globalVariables ?= require("./global-variables")
  $.filesVariableName ?= "$files"
  $.doneFunctionName ?= "ok"

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

    add: (code, depth = 1) ->
      @snippets.push @indent(code, depth)

    break: ->
      @snippets.push ''

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
    filesVariableName: null
    doneFunctionName: null

    constructor: (props = {}) ->
      @[key] = val for own key, val of props
      @coffeeService ?= new CoffeeService
      @filesVariableName ?= $.filesVariableName
      @doneFunctionName ?= $.doneFunctionName

    getContextVariableNames: (contextNode) ->
      beforeEachNodes = contextNode.getBeforeEachNodes()
      code = beforeEachNodes.map(({code}) -> code).join("\n")
      vars = @coffeeService.getVariableNames code

      if (ancestorContexts = contextNode.getAncestorContexts())?
        reduceAncestorVars = (vars, ancestorContext) => vars.concat @getContextVariableNames(ancestorContext)
        ancestorVars = ancestorContexts.reduce reduceAncestorVars, []
        vars = vars.filter (v) -> ancestorVars.indexOf(v) is -1

      vars.filter (v) => !@coffeeService.isGlobalVariable(v)

    isAsyncAssertion: (code) ->
      name = @doneFunctionName
      ///\b#{name}\(\)///.test code

    generateBeforeEach: (snippets, contextNode) ->
      beforeEachNodes = contextNode.getBeforeEachNodes()
      fileNodes = contextNode.getFileNodes()
      return snippets unless beforeEachNodes.length or fileNodes.length

      snippets.break()
      snippets.add "beforeEach ->", contextNode.depth + 1

      if fileNodes.length
        mockFsObject = fileNodes.reduce ((memo, {path, data}) -> memo[path] = data; memo), {}
        mockFsString = JSON.stringify mockFsObject, null, 2
        snippets.add "#{@filesVariableName} = #{mockFsString}", contextNode.depth + 2

      if beforeEachNodes.length
        beforeEachCode = beforeEachNodes.map(({code}) -> code).join("\n")
        snippets.add beforeEachCode, contextNode.depth + 2

      snippets

    generateAfterEach: (snippets, contextNode) ->
      fileNodes = contextNode.getFileNodes()
      return snippets unless fileNodes.length

      snippets.break()
      snippets.add "afterEach ->", contextNode.depth + 1
      snippets.add "#{@filesVariableName} = null", contextNode.depth + 2
      snippets

    generateAssertion: (snippets, assertionNode) ->
      {depth, text, code} = assertionNode
      fnStartStr = if @isAsyncAssertion(code) then "(#{@doneFunctionName}) ->" else "->"

      snippets.break()
      snippets.add "it #{JSON.stringify(text)}, #{fnStartStr}", depth
      snippets.add code, depth + 1
      snippets

    generateAssertions: (snippets, assertionNodes) ->
      return snippets unless assertionNodes.length
      assertionNodes.reduce @generateAssertion.bind(@), snippets

    generateDescribe: (snippets, contextNode) ->
      {depth, text} = contextNode
      vars = @getContextVariableNames contextNode
      snippets.break() if depth > 1
      snippets.add "describe #{JSON.stringify(text)}, ->", depth
      snippets.add "[#{vars.join(', ')}] = []", depth + 1 if vars.length

      snippets = @generateBeforeEach snippets, contextNode
      snippets = @generateAfterEach snippets, contextNode
      snippets = @generateAssertions snippets, contextNode.getAssertionNodes()
      snippets = @generateDescribes snippets, contextNode.getContextNodes()
      snippets

    generateDescribes: (snippets, contextNodes) ->
      return snippets unless contextNodes.length
      contextNodes.reduce @generateDescribe.bind(@), snippets

    generate: (parseTree) ->
      snippets = new Snippets()
      snippets.add "#{@filesVariableName} = null\n"
      snippets = @generateDescribes snippets, parseTree.getContextNodes()
      snippets.compile()

  JasmineCoffee =
    configuration: $
    configure: configure
    Generator: Generator
    CoffeeService: CoffeeService
    CoffeeToken: CoffeeToken
    Snippets: Snippets

module.exports = configure()
