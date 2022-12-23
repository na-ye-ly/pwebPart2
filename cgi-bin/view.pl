#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
</head>
<body>
HTML
my $q = CGI->new;

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.106";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar");

my $userName = $q->param('userName');
my $title = $q->param('title');
my $texto;

my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
$sth->execute($userName, $title);

$texto = $sth->fetchrow;
my @lineas = split("\n", $texto);
foreach my $n (@lineas) {
    print markdown($n);
} 
$sth->finish;
print <<HTML;
</body>
</html>
HTML
my $contCode = 0;
sub markdown{
  my $n = $_[0];
  my $codigo;
  if( $n =~ /^(#+)(.+)/){
    my $aux = length($1);
    $codigo = "<h$aux>$2</h$aux>";
  }
  elsif($n =~ /^~{2}(.+)~{2}/){
    $codigo = "<p>$1</p>";
  }
  elsif($n =~ /^\*{3}(.+)\*{3}/){
    $codigo = "<p><strong><i>$1</i></strong></p>";
  }
  elsif($n =~ /^\*{2}(.+)\*{2}/){
    my $aux = $1;
    if($aux =~ /(.+)_(.+)_(.+)/){
      $codigo = "<p><strong>$1<em>$2</em>$3</strong></p>";
    }else {
      $codigo = "<p><strong>$aux</strong></p>";
    }
  }
  elsif($n =~ /(.+)\[(.+)\]\((.+)\)/){
    $codigo = "<p>$1<a href=\"$3\">$2</a></p>";
  }
  elsif($n =~ /^\*{1}(.+)\*{1}/){
    $codigo = "<p><i>$1</i></p>";
  }
  elsif($n =~ /^'{3}/){
    if($contCode eq 0){
      $contCode = 1;
      $codigo = "<p><code>";
    }else{
      $contCode = 0;
      $codigo = "</code></p>";
    }
  }
  else{
    if($contCode){
      $codigo = $n."<br>";
    }else{
      $codigo = "<p>$n</p>";
    }
  }
  return $codigo;
}

