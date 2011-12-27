use strict;
use warnings;
use utf8;
use Test::More;

use_ok $_ for qw(
    MabinogiPayment
    MabinogiPayment::Web
    MabinogiPayment::Web::Dispatcher
);

done_testing;
