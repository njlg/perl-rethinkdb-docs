
module.exports = (env, callback) ->
  ### Paginator plugin. Defaults can be overridden in config.json
      e.g. "paginator": {"perPage": 10} ###

  defaults =
    template: 'toc.jade' # template that renders pages

  # assign defaults any option not set in the config file
  options = env.config.toc or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  getPages = (contents) ->
    return packages

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'toc', (contents, callback) ->

    # find all pages
    pages = getPages contents

    # create the object that will be merged with the content tree (contents)
    # do _not_ modify the tree directly inside a generator, consider it read-only
    rv = {pages: {}}

    # callback with the generated contents
    callback null, rv

  # add the article helper to the environment so we can use it later
  env.helpers.getPages = getPages

  # tell the plugin manager we are done
  callback()
