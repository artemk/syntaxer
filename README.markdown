# syntaxer

[![Build Status](http://travis-ci.org/artemk/syntaxer.png)](http://travis-ci.org/artemk/syntaxer)

## Overview

Syntaxer make possible check syntax of scripts. It may be used in standalone mode and with git repository for checking changed and added files only.
It is useful for for rails team, because you need to store only file with rules, and git hook will be generated for you.

## Installation

To install syntaxer run

<pre><code>
  [sudo] gem install syntaxer
</code></pre>  
  
## Usage with rails

1) Add to Gemfile

<pre><code>
    gem "syntaxer"
</code></pre>
    
2)

<pre><code>
    bundle install
</code></pre>

3) 

<pre><code>
  rake syntaxer:install
</code></pre>

or run in working dir

<pre><code>
  syntaxer --install 
</code></pre>

It creates config/syntaxer.rb file with common rails options, you may edit it as you wish, and .git/hooks/pre-commit script, which will run syntax checking before every commit.

## Standalone usage

Example of usage:

Run syntax checking in current directory recursively

<pre><code>
  syntaxer
</code></pre>

Run syntax checking in another directory recursively. Make sure to add '/' at the end.

<pre><code>
  syntaxer -p ./developement/
</code></pre>

Install hook to git repository in current directory

<pre><code>
  syntaxer -g -r git
</code></pre>

If you want to use custom config in pair with git

<pre><code>
  syntaxer -g -r git -c [CONFIG_FILE]
</code></pre>

Run syntaxer with custom config file

<pre><code>
  syntaxer -c config.rb
</code></pre>

Example of syntaxer.rb file:

<pre><code>
  syntaxer do
    languages :ruby, :haml, :sass do         # type of files to be watched
      folders 'app/**/*', 'lib/**/*'               # folders to be checked
    end               
  end
</code></pre>

You can specify multiple rules, for example you want to check only ruby files in app/controllers/* and only haml in app/views/*, you can write the next in your "initializers/syntaxer.rb" file:

<pre><code>
  syntaxer do
    languages :ruby do
      folders 'app/controllers/*'
    end
  
    lang :haml do  # lang is an alias for languages
      f 'app/views/*' #f is an alias for folders    
    end
    
    #all supported types at app/**
    languages :all do
      folders 'app/**'
    end
  
    ignore_folders 'app/models/**' # this folders will be deleted from all languages
  end
</code></pre>

Languages available for now are: ruby, erb, haml, sass. You can extend this by your own, how to do that will be described below.


<pre><code>
Options for usage
  -i, --install         run install wizzard, preferred method of installation
  -c, --config          specify config file
  -p, --path            path for syntax check. If this option is not specify it checks files from current directory
  -r, --repo            indicate type of repository. Available git and svn at this time.
  -g, --generate        generates pre-commit hook and put it in .git/hooks folder. It checks syntax of languages what are indicated in options file before every commit
  -q, --quite           disable information messages. Is needed when you only want to know the result: 1 or 0
  -l, --loud            informate about every checked file
  -W, --warnings        show warning messages
  -h, --help            show help and options describe above.
</code></pre>

## Syntaxer with jslint

You may use syntaxer to check javascript files using jslint (http://github.com/psionides/jslint_on_rails)

It require installed Java and Rhino, you may read about it in jslint gem page.

### For checking js scripts in standalone mode

<pre><code>
  syntaxer --jslint [DIR]
</code></pre>

It will be check all scripts under DIR recursively

You also may indicate custom config file or another options

<pre><code>
  syntaxer -c [CONFIG_FILE] --jslint [DIR]
</code></pre>

If where is `javascript` section in config file it will check it and DIR indicated in command line.    

### To run syntaxer with jslint on your rails project you should run in console and choose javascript checking to:

<pre><code>
  rake syntaxer:install
</code></pre>

It creates config/syntaxer.rb file with common rails options and config/jslint.rb with jslint options, you may edit it as you wish, and .git/hooks/pre-commit script, which will run syntax checking before every commit.

Javascript section have to be in the following form in config file:

<pre><code>
  syntaxer do
    lang :javascript do
      folders "javascripts/*", "javascripts/**/*"
      extensions "js"
      exec_rule Syntaxer::Runner.javascript
    end
  end
</code></pre>

## Contributing to syntaxer
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## TODO

* Have to fix the problem with only created repository and initial commit with GIT repository
* Add SVN support
* Add description on how to add new languages

## Known problems

* Git gem doesn't work properly on the very first commit.

## Author

Artyom Kramarenko (artemk) Svitla Systems Inc (www.svitla.com)

## Contributors

Artem Melnikov (ignar) Svitla Systems Inc (www.svitla.com)

## Copyright

See LICENSE.txt for further details.
