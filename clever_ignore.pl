#! /usr/bin/perl
use strict;
use warnings;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '0.1';
%IRSSI = (
    authors     => 'Radditz',
    name        => 'clever_ignore',
    description => 'Ignore IRC users in a clever way',
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
    if ($cmd && exists $commandMap{$cmd}) { 
        $commandMap{$cmd}->(@args); 
    }
}

my %helpMap = (
    'list'      => ['Lists available commands'],
    'set'       => ['set <hostmask> <mode> <args>',
                'If an ignore was already it will be replaced',
                'For more details about the available modessee help mode'
                ],
    'unset'     => ['unset <hostmask>',
                'Removes the specified hostmask from the ignore list'
                ],
    'mode'      => ['The mode determines the way the ignore will be performed',
                'string -> A static string is used as the replacement'
                ]
    
);

sub handleHelp {
    my $key = $_[0];
    if($key && exists $helpMap{$key}) { 
        iter(\&irssi_print, $helpMap{$key}); 
    } else {
        irssi_print("Available help topics:"); 
        irssi_print(join(' ',keys %helpMap));
    } 
}

sub irssi_print {
    Irssi::print($_[0]);
}

sub iter {
    my $fun = $_[0];
    my @arr = @{$_[1]};
    foreach my $item (@arr) {
        $fun->($item);
    }   

}

Irssi::command_bind($commandName,'handleCommand');
