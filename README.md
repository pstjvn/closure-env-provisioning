### Closure project environment builder.

Provides the makefile to initialize your workspace / base directory for
building closure based projects.

The script will build closure compiler, closure templates, closure stylesheets
and gjslint from source assuming the build pre-requisites are met (those are
tested so if you lack them the build will fail early).

Once the makefile is run you should have all you need to start a new project or
clone an existing one built with this setup and compile it / build it for
production locally.

All projects are to be found in the ```apps``` directory. You cna put there as
many projecta as you need as those are built indepedently (i.e. you need only
one copy of the build environment).

TODO:
* add gjslint
* automatically build node dependencies for automatic code generation in dependent libs.