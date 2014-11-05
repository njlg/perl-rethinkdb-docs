_ = require 'underscore'

module.exports = (env, callback) ->
  ### Paginator plugin. Defaults can be overridden in config.json
      e.g. "paginator": {"perPage": 10} ###

  defaults =
    template: 'index.jade' # template that renders pages
    packages: 'packages' # directory containing contents to paginate
    first: 'index.html' # filename/url for first page

  # assign defaults any option not set in the config file
  options = env.config.packages or {}
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

  class PackagePage extends env.plugins.Page
    ### A page has a number and a list of packages ###

    constructor: (@packages) ->

    getFilename: ->
      options.first

    getView: -> (env, locals, contents, templates, callback) ->
      # simple view to pass packages to the paginator template
      # note that this function returns a funciton

      # get the pagination template
      template = templates[options.template]
      if not template?
        return callback new Error "unknown paginator template '#{ options.template }'"

      # setup the template context
      ctx = {@packages}

      # extend the template context with the enviroment locals
      env.utils.extend ctx, locals

      # finally render the template
      template.render ctx, callback

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'packages', (contents, callback) ->

    # find all packages
    packages = getPackages contents

    # populate pages

    # create the object that will be merged with the content tree (contents)
    # do _not_ modify the tree directly inside a generator, consider it read-only
    rv =
      'index.page': new PackagePage packages

    # callback with the generated contents
    callback null, rv
    # callback null, null

  # add the article helper to the environment so we can use it later
  env.helpers.getPackages = getPackages

  # tell the plugin manager we are done
  callback()
