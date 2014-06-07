pushSwift
=========
A simple interpreter based somewhat on the [PushGP system for genetic programming](http://faculty.hampshire.edu/lspector/push.html) (work by Lee Spector, Maarten Keijzer, Jon Klein, Chris Perry and Tom Helmuth, among others).

With some amendments.

## Why

To work on TDD habits in XCode, and explore Apple's new Swift language. Which to be honest is the first compiled thing I've worked in since before you were born....

## Status

Just barely started.

## Goals

- build a parser that converts Push [dialect] scripts into code points
- build an interpreter that executes [most of] the instructions defined in the [Push 3.0 Specification](http://faculty.hampshire.edu/lspector/push3-description.html) and [Clojush](https://github.com/lspector/Clojush)
- add a few simple extensions to the basic type structure from our [GPTP conferences](http://vserver1.cscs.lsa.umich.edu/gptp-workshops/) through the years
  - tag spaces
  - Range types
  - implied block structure
- build a simple desktop [?] app that loads training and test data
- let the app solve problems locally using modern [Pareto-GP](http://www.evolved-analytics.com/?q=technology/publications) approaches
- maybe some cloud things; you know, for kids
