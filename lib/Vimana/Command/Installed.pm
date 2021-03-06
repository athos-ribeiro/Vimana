package Vimana::Command::Installed;
use warnings;
use strict;
use parent qw(App::CLI::Command);
use YAML;
use Vimana::Logger;
use Vimana::Record;
use File::Find;

=head2 run

find installed packages.

=cut

sub run {
    my ($self,$arg) = @_;

    unless( $arg )  {
        my $record_dir = Vimana::Record->record_dir();
        my @list;
        File::Find::find( sub { 
            return unless -f $_;
            my $pkgname = $_;
            my $data = Vimana::Record->load( $pkgname );
            $data->{installer_type} ||= 'unknown';
            print $data->{package} . ' [' . $data->{installer_type} . "]\n";
        }, $record_dir );
    }
    else {
        my $data = Vimana::Record->load( $arg );
        print "Package: " . $data->{package} . "\n";
        print "Files:\n";
        for my $entry (  @{ $data->{files} } ) {
            print "\t" .  $entry->{file} . "\n";

        }
    }
}



1;
__END__

=head1 NAME

Vimana::Command::Installed - List installed packages and contents

=head1 SYNOPSIS

    $ vimana installed

    $ vimana installed [keyword]

=cut
