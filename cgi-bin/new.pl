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
my $title = $q->param("title");
my $text = $q->param("text");

my $sth = $dbh->prepare("INSERT INTO Articles(title, owner, text) VALUES (?, ?, ?)");
$sth->execute($title,$userName,$text);
$sth->finish;
$sth = $dbh->prepare("SELECT title, text FROM Articles WHERE owner=? AND title=?");
$sth->execute($userName, $title);
if( my @row = $sth->fetchrow_array ) {
	print "<?xml version='1.0' encoding='UTF-8'?>\n";
	print "<article>\n";
	print "   <title>$row[0]</title>\n";
	print "   <text>$row[1]</text>\n";
	print "</article>\n";
}
$sth->finish;
$dbh->disconnect;

