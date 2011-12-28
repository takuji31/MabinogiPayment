package MabinogiPayment::DB::Schema;
use Time::Piece::Plus;

use Teng::Schema::Declare;
table {
    name 'payment';
    pk 'id';
    columns (
        {name => 'point', type => 4},
        {name => 'created_on', type => 9},
        {name => 'memo', type => 12},
        {name => 'type', type => 12},
        {name => 'id', type => 4},
    );
    row_class 'MabinogiPayment::Model::Payment';
    inflate qr{_on$} => sub {
        my $value = shift;
        return unless $value;
        return Time::Piece::Plus->parse_mysql_date(str => $value);
    };
    deflate qr{_on$} => sub {
        my $value = shift;
        return unless $value;
        return ref $value ? $value->mysql_date : $value;
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