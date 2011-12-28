#!/usr/bin/env perl
use 5.14.0;
use warnings;

use lib './lib';

use Class::Load ();
use MabinogiPayment;
use Scope::Container;

my $guard = start_scope_container();

my $module = shift @ARGV;

die "Module name is empty" unless $module;

$module = "MabinogiPayment::Script::$module";

my $c = MabinogiPayment->bootstrap;
Class::Load::load_class($module);

$module->run($c, @ARGV);
