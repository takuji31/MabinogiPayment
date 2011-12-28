package MabinogiPayment::DB::Schema;
use Time::Piece::Plus;
use Data::Dumper;

use Teng::Schema::Declare;
table {
    name 'payment';
    pk 'id';
    columns (
        {name => 'created_at', type => 11},
        {name => 'point', type => 4},
        {name => 'memo', type => 12},
        {name => 'type', type => 12},
        {name => 'id', type => 4},
    );
    row_class 'MabinogiPayment::Model::Payment';
    inflate qr{_at$} => sub {
        my $value = shift;
        return unless $value;
        return Time::Piece::Plus->parse_mysql_datetime(str => $value);
    };
    deflate qr{_at$} => sub {
        my $value = shift;
        return unless $value;
        warn Dumper $value;
        return ref $value ? $value->mysql_datetime : $value;
    };

};

table {
    name 'sessions';
    pk 'id';
    columns (
        {name => 'session_data', type => 12},
        {name => 'id', type => 1},
    );
    row_class 'MabinogiPayment::Model::Sessions';

};

1;