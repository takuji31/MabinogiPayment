use 5.014001;
use warnings;
package MabinogiPayment {
    use parent qw/Amon2/;

    # initialize database
    use MabinogiPayment::DB;
    use DBI;
    sub setup_schema {
        my $self = shift;
        my $dbh = MabinogiPayment::DB->get_dbh;
        my $driver_name = $dbh->{Driver}->{Name};
        my $fname = lc("sql/${driver_name}.sql");
        open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
        my $source = do { local $/; <$fh> };
        for my $stmt (split /;/, $source) {
            next unless $stmt =~ /\S/;
            $dbh->do($stmt) or die $dbh->errstr();
        }
    }

    sub get_db {
        my $self = shift;
        if ( !defined $self->{db} ) {
            $self->{db} = MabinogiPayment::DB->get_db;
        }
        return $self->{db};
    }

}
1;
