Closure project environment builder.
====================================

Provides the makefile to initialize your workspace / base directory for
building closure based projects.

The script will build closure compiler, closure templates, closure stylesheets
and gjslint from source assuming the build pre-requisites are met (those are
tested so if you lack them the build will fail early).

Once the makefile is run you should have all you need to start a new project or
clone an existing one built with this setup and compile it / build it for
production locally.

All projects are to be found in the `apps` directory. You can put there as
many projects as you need as those are built indepedently (i.e. you need only
one copy of this build environment).

In `apps` additionally are pre-populated several open source projects that might
or might not be used in your project.

* `pstj` - librari that builds on top of closure library and provides many
utilities to work with components, touch/mouse abstraction, animation tools etc.
* `smjs` - provides transport abstractions and widgets useful for building TV
optimized UI (i.e. navigatable with remote controls)
* `externs` - common externs, some built from third party sources, mainly the
chromecast as well as externs for tools in pstj library

### HOWTO: 

```
make
```
Will do the trick.


### TODO:

* automatically build node js dependencies for automatic code generation in
dependent libs.