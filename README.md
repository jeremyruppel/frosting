[![build status](https://secure.travis-ci.org/jeremyruppel/frosting.png)](http://travis-ci.org/jeremyruppel/frosting)
Frosting
========

> Task helpers for Cakefiles

About
-----

I've always been a little frustrated with the node filesystem API, especially
when trying to get a build process in place for a javascript project. Frosting
is really not much more than an abstraction layer over the filesystem module
that helps keep Cakefiles readable.

Usage
-----

To skip right to some code, here's an example Cakefile with build tasks for a
client-side javascript library:

``` coffee
{each} = require 'frosting'

task 'compile:dev', 'Compile development distro files', ->
  each './lib/*.coffee', ( f ) -> f.compile -> f.write "./dist/dev/#{f.basename( )}.js"

task 'compile:min', 'Compile minified distro files', ->
  each './lib/*.coffee', ( f ) -> f.compile -> f.minify -> f.write "./dist/min/#{f.basename( )}.js"

task 'compile', 'Compile all distro files', ->
  invoke 'compile:dev'
  invoke 'compile:min'
```

Frosting is definitely an opinionated set of build tools. It assumes that source
files are being written in coffeescript and minification will be done via uglify-js.

Frosting provides a couple of convenience methods that yield a `File` class.
This class has the necessary API for reading, writing, mutating, inspecting,
compiling and minifying source files.

**each**

`each` can be used to iterate over a set of source files. It accepts a callback
which will be passed a `File` instance for each file, and you can build as you wish
from there. It can be given a glob pattern or an explicit array of files.

``` coffee
each './lib/*.coffee', ( f ) -> # `f` is an instance of File

# or

each [
	'./lib/foo.coffee',
	'./lib/bar.coffee',
	'./lib/baz.coffee'
], ( f ) -> # `f` is an instance of File
```

**concat**

`concat` is similar to each, except it simply concatenates all of the source
files into one coffeescript file and yields a `File` instance with the combined
sources already in the buffer. If given an array of filenames, they will be
read and concat'd in order.

``` coffee
concat './lib/*.coffee', ( f ) -> # `f` is an instance of File, will only get called once

# or

concat [
	'./lib/foo.coffee',
	'./lib/bar.coffee',
	'./lib/baz.coffee'
], ( f ) -> # `f` is an instance of File, will only get called once
```

**TODO** describe the `File` API
