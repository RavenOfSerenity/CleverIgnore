#! /usr/bin/perl
use strict;
use warnings;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '0.1.1';
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
    'help'  => \&handleHelp,
    'set'   => \&handleSet,
    'list'  => \&handleList
);

sub handleCommand {
    my ($data, $server , $witem) = @_;
    my ($cmd, $arg_str) = split('\s', $data, 2);
    if ($cmd && exists $commandMap{$cmd}) { 
        $commandMap{$cmd}->($witem, $arg_str); 
    }
}

my @available_modes = ('string');
my @hostmasks = ();

sub handleSet {
    my $witem = $_[0];
    my $arg_str = $_[1];
    my @args = ();
    if($arg_str) {
        @args = split('\s',$arg_str,3);
    }
    if(@args != 3) { $witem->print('Incorrect usage, see help set'); }
    else {
        my ($hostmask, $mode, $args_cmd) = @args;
        if( $mode ~~ @available_modes) {
            push(@hostmasks,[$hostmask, $mode, $args_cmd]);
            $witem->print($hostmask." has been succesfully added");
        }else{
            $witem->print($mode." is not a valid mode mode, see help mode");
        }
    }
}

sub handleList {
    my $witem = $_[0];
    if( @hostmasks == 0 ) { $witem->print("No hostmasks have been set"); }
    else {
        $witem->print("[hostname] [mode] [arg string]");
        foreach my $item (@hostmasks) {
            $witem->print(join(' ',(@{$item})));
        }
    } 
}

my %helpMap = (
    'set'       => ['set <hostmask> <mode> <args>',
                'If an ignore was already it will be replaced',
                'For more details about the available modes see help mode'
                ],
    'unset'     => ['unset <hostmask>',
                'Removes the specified hostmask from the ignore list'
                ],
    'mode'      => ['The mode determines the way the ignore will be performed',
                'string -> A static string is used as the replacement'
                ],
    'list'      => ['Lists all ignored hostmasks'],
    
);

sub handleHelp {
    my $witem = $_[0];
    my $key = $_[1];
    if($key && exists $helpMap{$key}) { 
        iter(sub{ $witem->print(@_); }, $helpMap{$key}); 
    } else {
        $witem->print("Available help topics:"); 
        $witem->print(join(' ',keys %helpMap));
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
