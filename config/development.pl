+{
    datasource => [
        "DBI:mysql:mabinogi_payment",
        'root',
        '',
        +{
            RaiseError            => 1,
            mysql_connect_timeout => 10,
            mysql_enable_utf8     => 1,
        }
    ],
};
