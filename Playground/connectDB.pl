#!/usr/bin/perl

=head1 SYNOPSIS
    SCRIPT:   connectDB.pl
    LOCATION: Fullstack/Playground/
    CLIENT:   MUREX ATA, MUREX EOD
    AUTHOR:   Yoann Racine
    DATE:     02-09-2018
    PLATFORM: TBA
    PURPOSE:  Read a config file that contains all the murex launchers then check if all the launchers are up and running
 		      Read a config file that contains all the running murex processing scripts (feeders, extractions) and check if any process is suspending/hanging
 	          Check the server status (HDD, RAM, etc.) of all the servers
 		      Send summary report via email to users.       
    USAGE:    launchDB.pl 
=cut

use 5.010;
use strict;
use warnings;
use File::Basename;
use DBI;
use POSIX qw(strftime);
use Log::Log4perl qw(get_logger :levels :no_extra_logdie_message);

my $datetime = strftime("%Y%m%d",localtime());
my $dsn      = "dbi:mysql:database=MARKETDATA;host=localhost";
my $row;

use constant user => "$ENV{USER}";
use constant pass => "$ENV{PASS}";

#############################################################################
#                              connect to DB                                #
#############################################################################

my $dbh = DBI -> connect($dsn, user, pass);

my $sth = $dbh -> prepare("SELECT * FROM INSTRUMENT_DBF LIMIT 10");
$sth->execute();

while ($row = $sth->fetchrow_arrayref()) {
    print "@$row[0] @$row[1] @$row[2]\n";
}

$sth->finish();

$dbh -> disconnect();
