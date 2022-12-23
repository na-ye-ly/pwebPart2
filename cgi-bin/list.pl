#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

print $q->header('text/XML');
my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.106";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $userName = $q->param("userName");

my $sth = $dbh->prepare("SELECT owner,title FROM Articles WHERE owner=?");
$sth->execute($userName);
print "<?xml version='1.0' encoding='UTF-8'?>\n";
print "<Articles>\n";
while( my @row = $sth->fetchrow_array ) {
	print" <article>\n";
	print "   <Owner>$row[0]</Owner>\n";
	print "   <title>$row[1]</title>\n";
	print "</article>\n";
}
print"</Articles>\n";
$sth->finish;
$dbh->disconnect;

