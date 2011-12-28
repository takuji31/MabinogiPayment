package MabinogiPayment::Model::Payment;
use strict;
use warnings;
use utf8;
use 5.010000;

use parent qw/MabinogiPayment::Model/;

sub sum {
    my $class = shift;
    return $class->get_db->search_named(qq{
        SELECT SUM(point) AS point FROM payment
    },{},[])->next->point;
}

sub cnt {
    my $class = shift;
    return $class->get_db->search_named(qq{
        SELECT COUNT(id) AS cnt FROM payment
        WHERE `type` != :type
    },{type => Encode::encode('utf-8', 'MOM（手数料）')},[])->next->cnt;
}

sub list {
    state $validator = Data::Validator->new(
        page  => {isa => 'Int', default => 1},
        rows  => {isa => 'Int', default => 20},
    )->with(qw/Method/);
    my ($class, $args) = $validator->validate(@_);
    return $class->search_with_pager({}, {order_by => {created_at => 'ASC'}, %$args});
}

sub report_by_item {
    state $validator = Data::Validator->new(
        name => {isa => 'Str'},
    )->with(qw/Method/);
    my ($class, $args) = $validator->validate(@_);
    
}

1;

