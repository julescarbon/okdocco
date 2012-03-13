
# OKDocco

Recursive documentation generator for your Rails app.

It's built using the Node JS documentation generator "Docco":http://jashkenas.github.com/docco/ -- and adds two key conveniences.  First, it moves all the documentation in to the `doc` directory, and renames the files so they offer a better representation of the directory structure in `app`.  Second, it builds a manifest file of all the documentation it generated.

See the output of Docco on the script itself here: "http://julescarbon.github.com/okdocco/":http://julescarbon.github.com/okdocco/


## Usage

By default it generates documentation for `app` and the script, `document.pl`.

Optionally call it with several files on the commandline to document those instead.

`./document.pl app config test`

Note that the default Docco installation does not support Perl's comment character, so add it to `/usr/local/bin/docco` around line 121.


## Copyright

[OKFOCUS](http://okfoc.us/) &copy; 19112

!http://i.asdf.us/im/e1/678_D_036_1331588699_ryz.gif! !http://i.asdf.us/im/98/houseplant3_1331588703_ryz.gif!

