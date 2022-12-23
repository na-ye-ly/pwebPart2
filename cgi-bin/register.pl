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
my $clave = $q->param("password");
my $firstName = $q->param("firstName");
my $lastName = $q->param("lastName");
#if ($userName =~ /(.+)/ and $clave =~ /(.+)/ and $firstName =~ /(.+)/ and $lastName /(.+)/ ){ 
my $sth = $dbh->prepare("INSERT INTO Users (userName,password,lastName,firstName) VALUES (?,?,?,?)");
$sth->execute($userName,$clave,$lastName,$firstName);
$sth->finish;
#}
$sth = $dbh->prepare("SELECT userName, firstName, lastName FROM Users WHERE userName=? AND password=?");
$sth->execute($userName, $clave);
if( my @row = $sth->fetchrow_array ) {
	print "<?xml version='1.0' encoding='UTF-8'?>\n";
	print" <user>\n";
	print "   <owner>$row[0]</owner>\n";
	print "   <firstName>$row[1]</firstName>\n";
	print "   <lastName>$row[2]</lastName>\n";
	print "</user>\n";
}
$sth->finish;
$dbh->disconnect;
