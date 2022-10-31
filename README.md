## HCL::Parser

This is a parser for the HCL language, primarily used for configuration of Terraform.

Currently it just includes a grammar and a little command line tool.

Example usage:

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

`tf-parse` also has a `--dump` option to dump the syntax tree.

## INSTALLATION

1. Install raku (see https://rakubrew.org/) and zef, the package manager.

2. `zef install https://github.com/bduggan/raku-hcl-parser.git`

## TODO

- heredocs
- for expressions
- if/else in templates
- inline comments
- rule for identifiers
- an action class, to make a data structure, and do something interesting after parsing
