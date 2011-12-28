package MabinogiPayment::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use MabinogiPayment::Model::Payment;

get '/' => sub {
    my ($c) = @_;
    $c->stash->{cnt} = MabinogiPayment::Model::Payment->cnt;
    $c->stash->{sum} = MabinogiPayment::Model::Payment->sum;
    $c->render('index.tx');
};

get '/list' => sub {
    my ($c) = @_;
    my $page = $c->req->param("page") || 1;
    my ($rows, $pager) = MabinogiPayment::Model::Payment->list(page => $page);
    $c->stash->{rows} = $rows;
    $c->stash->{pager} = $pager;
    $c->render('list.tx');
};

get '/item/' => sub {
    my ($c, $param) = @_;
    my $page = $c->req->param("page") || 1;
    my ($rows, $pager) = MabinogiPayment::Model::Payment->item_list(page => $page);
    $c->stash->{rows} = $rows;
    $c->stash->{pager} = $pager;
    $c->render('item_list.tx');
};

get '/item/:name' => sub {
    my ($c, $param) = @_;
    my $name = $param->{name};
    my $report = MabinogiPayment::Model::Payment->report_by_item(name => $name);
    $c->stash->{report} = $report;
    $c->stash->{name} = $name;
    $c->render('item.tx');
};

get '/ranking' => sub {
    my ($c, $param) = @_;
    my $ranking = MabinogiPayment::Model::Payment->ranking;
    $c->stash->{ranking} = $ranking;
    $c->render('ranking.tx');
};

1;
