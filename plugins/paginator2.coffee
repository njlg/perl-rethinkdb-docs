_ = require 'underscore'

module.exports = (env, callback) ->
  ### Paginator plugin. Defaults can be overridden in config.json
      e.g. "paginator": {"perPage": 10} ###

  defaults =
    template: 'index.jade' # template that renders pages
    packages: 'packages' # directory containing contents to paginate
    first: 'index.html' # filename/url for first page
    filename: 'page/%d/index.html' # filename for rest of pages

  # assign defaults any option not set in the config file
  options = env.config.paginator2 or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  getPackages = (contents) ->
    # helper that returns a list of packages found in *contents*
    # note that each article is assumed to have its own directory in the packages directory
    packages = contents[options.packages]._.directories.map (item) -> item.index

    contents[options.packages]['rethinkdb']._.directories.map (item) ->
      packages.push item.index

    contents[options.packages]['rethinkdb']['query']._.directories.map (item) ->
      packages.push item.index

    # skip packages that does not have a template associated
    packages = packages.filter (item) -> item.template isnt 'none'

    # _.map packages, (p) -> console.dir p.title

    # sort article by date
    packages.sort (a, b) -> a.title > b.title

    return packages

  class PaginatorPage2 extends env.plugins.Page
    ### A page has a number and a list of packages ###

    constructor: (@pageNum, @packages) ->

    getFilename: ->
      if @pageNum is 1
        options.first
      else
        options.filename.replace '%d', @pageNum

    getView: -> (env, locals, contents, templates, callback) ->
      # simple view to pass packages and pagenum to the paginator template
      # note that this function returns a funciton

      # get the pagination template
      template = templates[options.template]
      if not template?
        return callback new Error "unknown paginator template '#{ options.template }'"

      # setup the template context
      ctx = {@packages, @pageNum}

      # extend the template context with the enviroment locals
      env.utils.extend ctx, locals

      # finally render the template
      template.render ctx, callback

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'paginator2', (contents, callback) ->

    # find all packages
    packages = getPackages contents

    # populate pages

    # create the object that will be merged with the content tree (contents)
    # do _not_ modify the tree directly inside a generator, consider it read-only
    rv = {pages: {}}

    stuff = new PaginatorPage2 1, packages
    rv['index.page'] = stuff
    rv['pages']['1.page'] = stuff

    # callback with the generated contents
    callback null, rv
    # callback null, null

  # add the article helper to the environment so we can use it later
  env.helpers.getPackages = getPackages

  # tell the plugin manager we are done
  callback()
