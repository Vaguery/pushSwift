pushSwift
=========
A simple interpreter based somewhat on Lee Spector's [PushGP system for genetic programming](http://faculty.hampshire.edu/lspector/push.html). With some amendments.

## Why

To work on TDD habits in XCode, and explore Apple's new Swift langauge. Which, to be honest, looks an awful lot like Scala....

## Status

Just barely started.

## Goals

- build a parser that converts Push [dialect] scripts into code points
- build an interpreter that executes [most of] the instructions defined in the [Push 3.0 Specification](http://faculty.hampshire.edu/lspector/push3-description.html) and [Clojush](https://github.com/lspector/Clojush)
- add a few simple extensions to the basic type structure from our [GPTP conferences](http://vserver1.cscs.lsa.umich.edu/gptp-workshops/) through the years
- build a simple desktop [?] app that loads training and test data
- let the app solve problems locally using modern [Pareto-GP](http://www.evolved-analytics.com/?q=technology/publications) approaches
- maybe some cloud things; you know, for kids
