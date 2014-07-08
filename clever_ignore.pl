#! /usr/bin/per
#Copyright (c) <YEAR>, <OWNER>
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
#2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#use strict;
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
    my $printFun;
    if($witem) { $printFun = sub { $witem->print(@_);}; }
    else { $printFun = sub { Irssi::print(@_[0]); }; }
    my ($cmd, $arg_str) = split('\s', $data, 2);
    if ($cmd && exists $commandMap{$cmd}) { 
        $commandMap{$cmd}->($printFun, $arg_str); 
    }
}

my @available_modes = ('string');
#TODO: switch to map, makes re-setting easier
my @hostmasks = ();

sub handleSet {
    my $printFun = $_[0];
    my $arg_str = $_[1];
    my @args = ();
    if($arg_str) {
        @args = split('\s',$arg_str,3);
    }
    if(@args != 3) { $printFun->('Incorrect usage, see help set'); }
    else {
        my ($hostmask, $mode, $args_cmd) = @args;
        if( $mode ~~ @available_modes) {
            push(@hostmasks,[$hostmask, $mode, $args_cmd]);
            $printFun->($hostmask." has been succesfully added");
        }else{
            $printFun->($mode." is not a valid mode mode, see help mode");
        }
    }
}

sub handleList {
    my $printFun = $_[0];
    if( @hostmasks == 0 ) { $printFun->("No hostmasks have been set"); }
    else {
        $printFun->("[hostname] [mode] [arg string]");
        foreach my $item (@hostmasks) {
            $printFun->(join(' ',(@{$item})));
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
    my $printFun = $_[0];
    my $key = $_[1];
    if($key && exists $helpMap{$key}) { 
        iter(sub{ $printFun->(@_); }, $helpMap{$key}); 
    } else {
        $printFun->("Available help topics:"); 
        $printFun->(join(' ',keys %helpMap));
    } 
}

sub iter {
    my $fun = $_[0];
    my @arr = @{$_[1]};
    foreach my $item (@arr) {
        $fun->($item);
    }   

}

Irssi::command_bind($commandName,'handleCommand');
