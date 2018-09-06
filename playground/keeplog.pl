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
use POSIX qw(strftime);
use Log::Log4perl qw(get_logger);

my $datetime = strftime("%Y%m%d",localtime());


use constant LOGCONF => "$ENV{LOGCONF}";

Log::Log4perl::init(LOGCONF);

my $logger = Log::Log4perl->get_logger();

$logger->info("Script Start");
$logger->info("Parent PID -> ");

