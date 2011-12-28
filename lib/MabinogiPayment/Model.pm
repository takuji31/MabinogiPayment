use 5.014001;
use warnings;
package MabinogiPayment::Model {
    use parent qw/Teng::Row/;

    use MabinogiPayment::DB;
    use String::CamelCase ();

    sub get_db {
        my $class = shift;
        return MabinogiPayment::DB->get_db;
    }

    sub get_dbi {
        my $class = shift;
        return MabinogiPayment::DB->get_dbi;
    }

    sub table_name {
        my $class = shift;
        $class = ref $class || $class;
        Carp::confess("This class can't use directly") if __PACKAGE__ eq $class;
        $class =~ s{^MabinogiPayment::Model::}{};
        my $table_name = String::CamelCase::decamelize($class);
        my $code = sub {$table_name};
        {
            no strict 'refs';
            no warnings 'redefine';
            *{"$class\::table_name"} = $code; ## no critic
        }
        return $table_name;
    }

    sub search {
        my $class = shift;
        return $class->get_db->search($class->table_name => @_);
    }

    sub search_with_pager {
        my $class = shift;
        return $class->get_db->search_with_pager($class->table_name => @_);
    }

    sub single {
        my $class = shift;
        return $class->get_db->single($class->table_name => @_);
    }

    sub insert {
        my $class = shift;
        return $class->get_db->insert($class->table_name => @_);
    }

    sub fast_insert {
        my $class = shift;
        return $class->get_db->fast_insert($class->table_name => @_);
    }
}
1;
