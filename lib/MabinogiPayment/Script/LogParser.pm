use 5.014001;
use warnings;
use utf8;
package MabinogiPayment::Script::LogParser {

    use MabinogiPayment;
    use File::Spec;
    use File::Slurp;
    use constant {
        ID    => 0,
        TYPE  => 1,
        POINT => 2,
        MEMO  => 3,
        DATE  => 4,
    };
    use Time::Piece::Plus;
    use Encode ();


    sub run {
        my ($class, ) = @_;
        my $c = MabinogiPayment->context;
        my $file = File::Spec->catfile($c->base_dir, 'payment.txt');
        say "parsing $file";

        my @rows = read_file($file);
        
        my $db = $c->get_db;

        for my $row (@rows) {
            $row = Encode::decode('utf-8', $row);
            my ($id, $type, $point, $memo, $date) = split /\t/, $row;
            $point =~ s/,//g;
            $date =~ s/ ([0-9]):/ 0$1:/;
            my $data = $db->single(payment => {id => $id});
            $data = $db->insert(payment => {id => $id}) unless $data;
            $data->update({type => $type, point => $point, memo => $memo, created_at => localtime->strptime($date, '%Y/%m/%d %H:%M')});
        }

    }
}
1;
