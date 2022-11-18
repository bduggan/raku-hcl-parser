## HCL::Parser

This is a parser for the HCL language, primarily used for configuration of Terraform.

Currently it just includes a grammar and a little command line tool.

Example usage of the command line tool, `tf-parse`:

    # config.tf
    terraform {
       required_providers {
         linode = {
           source = "linode/linode"
           version = "1.16.0"
         }
       }
    }

    $ tf-parse config.tf
    config.tf: syntax ok

example 2

    $ tf-parse config.tf --json
    [
      {
        "terraform": {
          "required_providers": {
            "linode": {
              "source": "linode/linode",
              "version": "1.16.0"
            }
          }
        }
      }
    ]

`tf-parse` has these options:

* a `--dump` option to dump the parse tree.

* a `--json` option to dump the generated syntax tree as json.

## INSTALLATION

1. Install raku (see https://rakubrew.org/) and zef, the package manager.

2. `zef install https://github.com/bduggan/raku-hcl-parser.git`

## TODO

A lot!

- heredocs
- for expressions
- if/else in templates
- inline comments
- rule for identifiers
- an action class, to do something interesting after parsing, like generate a syntax tree
