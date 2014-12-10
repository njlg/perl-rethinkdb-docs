_ = require 'underscore'

module.exports = (env, callback) ->
  ### Paginator plugin. Defaults can be overridden in config.json
      e.g. "paginator": {"perPage": 10} ###

  defaults =
    template: 'toc.jade'

  # assign defaults any option not set in the config file
  options = env.config.toc or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  getPages = (contents) ->
    pages = []
    for filename in Object.keys contents
      content = contents[filename]
      if content instanceof env.plugins.MarkdownPage
        if content.filepath.relative.indexOf('index.md') > 0
          pages.push content
      else if content instanceof env.ContentTree
        Array::push.apply pages, getPages content
    pages

  class PackagePage extends env.plugins.Page
    ### A page has a number and a list of packages ###

    constructor: (@filepath, @content) ->
      @getContent()

    getFilename: ->
      # console.log @filepath.relative.replace('index.md', 'toc.html')
      @filepath.relative.replace('index.md', 'toc.html')

    getContent: ->
      @headers = []

      # console.log 'processing %s', @filepath.relative
      level = 0
      last = {}
      outside_code_block = true

      for line in @content.markdown.split '\n'
        if line.indexOf('```perl') >= 0
          outside_code_block = false
        else if line.indexOf('```') >= 0
          outside_code_block = true
        else if (line.indexOf('#') == 0) and outside_code_block
          [s, h, name] = /^(#+) (.+)$/.exec(line)
          hl = h.length

          # console.log '     h = %s', h
          # console.log '  name = %s', name

          item =
            level: hl
            name: name
            children: []

          if level is 0
            @headers.push item
            level = hl
            last[level] = item
          else if hl > level
            last[level].children.push item
            level = hl
            last[level] = item
          else if hl == level
            last[hl - 1].children.push item
          else if hl < level
            # console.log '   going back to %s', (hl - 1)
            # console.dir last[hl - 1]
            last[hl - 1].children.push item
            level = hl
            last[hl] = item

      # console.dir @headers[0].children
      # if @headers.children and @headers.children.length > 0
        # console.dir @headers.children[0]

      @headers

    getView: -> (env, locals, contents, templates, callback) ->
      # simple view to pass packages and pagenum to the paginator template
      # note that this function returns a funciton

      # get the pagination template
      template = templates[options.template]
      if not template?
        return callback new Error "unknown paginator template '#{ options.template }'"

      # setup the template context
      ctx = {headers: @headers}

      # extend the template context with the enviroment locals
      env.utils.extend ctx, locals

      # finally render the template
      template.render ctx, callback

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'toc', (contents, callback) ->

    # find all packages
    pages = getPages contents
    # console.dir pages

    # populate pages

    # create the object that will be merged with the content tree (contents)
    # do _not_ modify the tree directly inside a generator, consider it read-only
    rv = {toc: {}}

    for page in pages
      pp = new PackagePage(page.filepath, page)
      render = pp.getView()
      render()
      rv.toc[page.filepath.relative] = pp
      page.toc = pp

    # console.dir rv.toc

    # callback with the generated contents
    callback null, rv
    # callback null, null

  # add the article helper to the environment so we can use it later
  env.helpers.getPages = getPages

  # tell the plugin manager we are done
  callback()
