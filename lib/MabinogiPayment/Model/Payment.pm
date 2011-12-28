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
    return $class->search_with_pager({}, {order_by => {created_on => 'ASC'}, %$args});
}

sub report_by_item {
    state $validator = Data::Validator->new(
        name => {isa => 'Str'},
    )->with(qw/Method/);
    my ($class, $args) = $validator->validate(@_);
    my $name = $args->{name};
    my $db = $class->get_db;
    return {
        cnt => $db->search_named(q{SELECT COUNT(id) AS cnt FROM payment WHERE memo=:name}, {name => $name}, [])->next->cnt,
        point => $db->search_named(q{SELECT SUM(point) AS point FROM payment WHERE memo=:name}, {name => $name}, [])->next->point,
    };
}

sub item_list {
    state $validator = Data::Validator->new(
        page  => {isa => 'Int', default => 1},
        rows  => {isa => 'Int', default => 20},
    )->with(qw/Method/);
    my ($class, $args) = $validator->validate(@_);
    return $class->search_with_pager({}, {order_by => {memo => 'ASC'}, columns => [qw/memo/], prefix => 'SELECT DISTINCT ', %$args});

}

sub ranking {
    my $class = shift;
    my $db = $class->get_db;
    my $limit = 10;
    return {
        count => [
            map {$_->get_columns} $db->search_named(
                qq{
                    SELECT memo AS name, COUNT(id) as cnt FROM payment
                    GROUP BY memo
                    ORDER BY COUNT(id) DESC
                    LIMIT $limit
                },
                {},
            )->all
        ],
        point => [
            map {$_->get_columns} $db->search_named(
                qq{
                    SELECT memo AS name, SUM(point) as point FROM payment
                    GROUP BY memo
                    ORDER BY SUM(point) DESC
                    LIMIT $limit
                },
                {},
            )->all
        ],
        monthly_count => [
            map {$_->get_columns} $db->search_named(
                qq{
                    SELECT DATE_FORMAT(created_on, '%m月') AS month, COUNT(id) as cnt FROM payment
                    GROUP BY DATE_FORMAT(created_on, '%m')
                    ORDER BY COUNT(id) DESC
                },
                {},
            )->all
        ],
        monthly_point => [
            map {$_->get_columns} $db->search_named(
                qq{
                    SELECT DATE_FORMAT(created_on, '%m月') AS month, SUM(point) as point FROM payment
                    GROUP BY DATE_FORMAT(created_on, '%m')
                    ORDER BY SUM(point) DESC
                },
                {},
            )->all
        ],
    };
}

1;

