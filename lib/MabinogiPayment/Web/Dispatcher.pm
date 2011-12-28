package MabinogiPayment::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use MabinogiPayment::Model::Payment;

any '/' => sub {
    my ($c) = @_;
    $c->stash->{cnt} = MabinogiPayment::Model::Payment->cnt;
    $c->stash->{sum} = MabinogiPayment::Model::Payment->sum;
    $c->render('index.tx');
};

any '/list' => sub {
    my ($c) = @_;
    my $page = $c->req->param("page") || 1;
    my ($rows, $pager) = MabinogiPayment::Model::Payment->list(page => $page);
    $c->stash->{rows} = $rows;
    $c->stash->{pager} = $pager;
    $c->render('list.tx');
};

any '/item/:name' => sub {
    my ($c, $param) = @_;
    my $name = $param->{name};
    my $report = MabinogiPayment::Model::Payment->report_by_item(name => $name);
    $c->stash->{report} = $report;
    $c->stash->{name} = $name;
    $c->render('item.tx');
};

any '/ranking' => sub {
    my ($c, $param) = @_;
    my $ranking = MabinogiPayment::Model::Payment->ranking;
    $c->stash->{ranking} = $ranking;
    $c->render('ranking.tx');
};

1;
