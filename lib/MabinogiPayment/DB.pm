use 5.014002;
use warnings;
package MabinogiPayment::DB {

    use parent qw/Teng/;

    use Carp ();
    use Data::GUID::URLSafe;
    use Data::Validator;
    use Digest::MurmurHash qw/murmur_hash/;
    use Scope::Container::DBI;
    use Time::Piece::Plus;
    use Class::Method::Modifiers;

    use MabinogiPayment;

    __PACKAGE__->load_plugin('FindOrCreate');

    sub conf {MabinogiPayment->config}

    sub get_db {
        my $class = shift;
        my $dbi = $class->get_dbh;
        return $class->new(dbh => $dbi);
    }

    sub get_dbh {
        my $class = shift;
        return Scope::Container::DBI->connect(@{$class->conf->{datasource}});
    }

    #各メソッドへのtrigger
    #TODO 共通化すべし
    before 'insert', 'fast_insert' => sub {
        my ($self, $table_name, $row_data) = @_;
        my $table = $self->schema->get_table($table_name);
        if ($table) {
            my @columns = @{$table->columns};
            my $now = localtime;

            #GUID
            if(grep /^guid$/, @columns) {
                $row_data->{guid} = Data::GUID->guid_hex;
            }

            #(created|updated)_at
            my @datetime_columns = grep /^(created|updated)_(at|on)$/, @columns;
            for my $column (@datetime_columns) {
                $row_data->{$column} ||= $now;
            }

            #hash値計算
            my @hash_columns = grep /_hash$/, @columns;
            for my $column (@hash_columns) {
                (my $origin = $column) =~ s/_hash$//;
                if($row_data->{$origin}) {
                    $row_data->{$column} = murmur_hash($row_data->{$origin});
                }
            }
        }
    };

    before 'update' => sub {
        my ($self, $table_name, $row_data) = @_;
        my $table = $self->schema->get_table($table_name);
        if ($table) {
            my $columns = $table->columns;
            my $now = localtime;
            my @datetime_columns = grep /^updated_(at|on)$/, @$columns;

            #updated_at
            for my $column (@datetime_columns) {
                $row_data->{$column} ||= $now;
            }

            #hash値計算
            my @hash_columns = grep /_hash$/, @$columns;
            for my $column (@hash_columns) {
                (my $origin = $column) =~ s/_hash$//;
                if($row_data->{$origin}) {
                    $row_data->{$column} = murmur_hash($row_data->{$origin});
                }
            }
        }
    };

}

1;

