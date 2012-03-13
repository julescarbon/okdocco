#!/usr/bin/perl

# This script documents the current source tree recursively using [Docco](http://jashkenas.github.com/docco/),
# a tool for documenting your code inline using comments.
# Conforming to convention, it moves all the generated documentation into the `doc/`
# directory.  It also produces a manifest file linking to all the generated source code.

# Prerequisites
# -------------

# Enter the name of the current project here.
our $PROJECT_NAME = "OKDocco";

# Docco should be installed somewhere sane.
our $DOCCO_PATH = '/usr/local/bin/docco';

# As should mv.
our $MV_PATH = '/bin/mv';

# Usage
# -----
# We presume a Rails environment.
# By default, running `./document.pl` will document the `app` directory, this file, and nothing else.
sub run () {

  if (scalar(@ARGV) == 0) {
    recurse("app");
    push(@files, "document.pl");
  }


  # Optionally specify all the directories you care about as commandline arguments.
  else {
    for $arg (@ARGV) {
      $arg =~ s/\/$//;
      recurse($arg);
    }
  }

  # Once we know what to look for, run Docco against all of these files.
  document();

  # Docco does not output files in the conventional rails place; we handle that later;
  system("rm -rf docs");
}

# Walking the tree
# ----------------

# We store the data files in a global for convenience.
our @files = ();

# Given a directory, look at all the files in it and then look recursively into
# subdirectories.
sub recurse ($) {
  my ($dir) = @_;
  my @dirs = ();

  # Deal with this directory first.
  opendir(DIR, $dir) || die $!;
  while (my $file = readdir DIR) {
    # Ignore . and ..
    next if $file =~ /^\./;
    $path = $dir . "/" . $file;

    # If we see a directory, save it to be looked at later.
    if (-d $path) {
      push(@dirs, $path);
    }

    # Otherwise if this is a file we care about, so make a record of it.
    elsif ($file =~ /\.(rb|js)$/) {
      push(@files, $path);
    }
  }
  closedir DIR;

  # Then take all those subdirectories we found and do the same thing to each.
  for my $dir (@dirs) {
    recurse($dir);
  }
}

# Building a Manifest
# -------------------
# One thing Docco does not give us for free is a manifest file linking to all our documentation.
# For visual consistency, we output a file that resembles what comes out of Docco.
sub header () {
  return <<__HEADER__;
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=utf-8">
  <title>$PROJECT_NAME</title>
  <link rel="stylesheet" href="docco.css">
</head>
<body>
<div id='container'>
  <div id="background"></div>
  <table cellspacing=0 cellpadding=0>
  <thead>
    <tr>
      <th class=docs>
        <h1>$PROJECT_NAME</h1>
        <ul>
__HEADER__
}

# Close the tags and so on.
sub footer () {
  return <<__FOOTER__;
        </ul>
      </th>
    </tr>
  </thead>
  </table>
</div>
</body>
</html>
__FOOTER__
}

# Finally, the function that spits out the documentation.
sub document () {
  # Per Ruby convention, we store documentation in the "doc" directory.
  # We build the manifest simultaneously.
  open DOC, ">doc/index.html";
  print DOC header();
  
  for my $file (sort @files) {
    # We care about two paths -- the file that Docco outputs,
    # and the place we want it to live in the doc directory.
    my $src = $file;
    my $dest = $file;
    
    # Given a filename, Docco outputs to `docs/filename.html`.
    $src =~ s/\.[^\.]+$/.html/g;
    $src =~ /\/?([^\/]+)$/;
    $src = $1;

    # However, we would prefer `doc/path_to_filename.html`.
    $dest =~ s/\//_/g;
    $dest =~ s/\.[^\.]+$/.html/g;

    # Todo: Running Docco during the recurse step would be faster.
    system($DOCCO_PATH, $file);
    system($MV_PATH, "docs/$src", "doc/$dest");

    # Make a notation in the manifest.
    print DOC "<li><a href=\"$dest\">$file</a></li>";
  }

  # Print the footer and be done with it.
  print DOC footer();
  close DOC;
}

# And that's it!
run();

# [OKFocus](http://okfoc.us/) 2012

