package RunApp::Simple;
use Spiffy -Base;
use RunApp;
use RunApp::Apache;
use File::Spec::Functions qw(catfile catdir);
use Cwd;
use YAML;

our $VERSION = '0.02';

field mode => 'apache_cgi';
field 'apxs';
field 'config_block';
field hostname => 'localhost';
field port => 12345;

field default_config => -init => q{
    {
        cwd => Cwd::cwd(),
	webmaster => 'admin@' . $self->hostname,
        hostname => $self->hostname,
        port => $self->port
    }
};

field default_profile => {
    apache_perl => {
	root => catfile (Cwd::cwd(), 'apache_perl'),
	report => 1,
	CTL => 'RunApp::Control::ApacheCtl',
	apxs => '/usr/sbin/apxs',
	required_modules => ["log_config","perl","alias", "mime","dir"],
	config_block => q{
	    DocumentRoot [% cwd %]/html
	    AddDefaultCharset UTF-8
	    AddHandler perl-script .pl
	}
    },
    apache_cgi => {
	root => catfile (cwd, 'apache_cgi'),
	report => 1,
	CTL => 'RunApp::Control::ApacheCtl',
	apxs => '/usr/sbin/apxs',
	required_modules => ["log_config","perl","alias", "mime","dir"],
	config_block => q{
	    DocumentRoot [% cwd %]/html
	    AddDefaultCharset UTF-8
	    AddHandler cgi-script .cgi
	}
    }
};

sub run {
    my %mode = %{$self->default_profile->{$self->mode}};
    $mode{config_block} = $self->config_block
	if ($self->config_block);
    my $ra = RunApp::Apache->new(%mode);
    RunApp->new($self->mode() => $ra)->development($self->default_config);
}

__END__

=head1 NAME

  RunApp::Simple - RunApp in a simple way;

=head1 SYNOPSIS

  my $param = YAML::LoadFile('config.yaml');
  RunApp::Simple->new(%$param)->run();

=head1 DESCRIPTION

This module provides an simple interface of RunApp::* modules.  It
provides a script "runapp" which reads "config.yaml" from current
working directory and then start-up your application according to what
is configured in "config.yaml".

=head1 Object Interface

C<RunApp::Simple> provide an object-origented interface to initialize
C<RunApp::*> objects. It has following methods:

=head2 new(%param)

The new() method is the constructor of this object. You'll have
to provide sufficient values in the %param parameter hash.
Following keys are required:

=over 4

=item mode

Possible values: apache_perl , apache_cgi.
Default: apache_cgi

=item apxs

Path to your "apxs" executable.
Default: /usr/sbin/apxs.

=item config_block

A block of text to put in your httpd.conf.

=item hostname

Hostname are detected automatically, but you may also specify it here.

=item port

Port number for your applcation. Default: 12345.

=back

=head2 run()

Run your application.

=head1 SEE ALSO

L<RunApp>

=head1 COPYRIGHT

Copyright 2005 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut

