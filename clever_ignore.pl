#! /usr/bin/perl
use strict;
use warnings;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '0.1';
%IRSSI = (
	authors 	=> 'Radditz',
	name 		=> 'clever_ignore',
	description 	=> 'Ignore IRC users in a clever way',
);

my $commandName = "clever_ignore";

#tremendous technique, he's just a student of the game
#as technically solid as anybody \ knows the ins and outs
#writes perl in his sleep
my %commandMap = (
	'help' => \&handleHelp
);

sub handleCommand {
	my ($data, $server , $witem) = @_;
	my ($cmd, @args) = split('\s', $data);
	my $handlerFun = getValueFromMap(\%commandMap,$cmd);
	if ($handlerFun) { $handlerFun->(@args); }	
	
}

sub getValueFromMap {
	my %map = %{$_[0]}; 
	my $cmd = $_[1];
	if ($cmd) { return $map{$cmd}; }
	else { return undef; }
}

my %helpMap = (
	'list'		=> ['Lists available commands'],
	'set'  		=> ['set <hostmask> <mode> <args>',
				'If an ignore was already it will be replaced',
				'For more details about the available modessee help mode'
				],
	'unset' 	=> ['unset <hostmask>',
				'Removes the specified hostmask from the ignore list'
				],
	'mode' 		=> ['The mode determines the way the ignore will be performed',
				'string -> A static string is used as the replacement'
				]
	
);

sub handleHelp {
	my $key = $_[0];
	#irssi_print('key:'.$key);
	my $vals = getValueFromMap(\%helpMap,$key); 
	#irssi_print('vals:'.$vals->[0]);
	#irssi_print('vals:'.$vals->[1]);
	if(!$vals) { 
		irssi_print("Available help topics:"); 
		$vals = [keys %helpMap]; 
		irssi_print(concat($vals, ' '));
	} else { iter(\&irssi_print, $vals); }
}

sub irssi_print {
	Irssi::print($_[0]);
}

sub concat {
	my @arr = @{$_[0]};
	my $sep = $_[1];
	my $len = @arr;
	my $res = '';
	if($len>0) { $res = $arr[0]; }
	for my $i (1..$len-1){
		$res = $res.$sep.$arr[$i];	
	}
	return $res;
}

sub iter {
	my $fun = $_[0];
	my @arr = @{$_[1]};
	foreach my $item (@arr) {
		$fun->($item);
	}	

}

Irssi::command_bind($commandName,'handleCommand');
