package WebService::MusicBrainz::Request;

use strict;
use Mojo::Base -base;
use Mojo::UserAgent;
use Mojo::URL;

has url_base => 'http://musicbrainz.org/ws/2';
has ua => sub { Mojo::UserAgent->new() };
has 'format' => 'json';
has 'search_resource';
has 'mbid';
has 'inc' => sub { [] };

our $VERSION = '1.0';

sub make_url {
    my $self = shift;

    my @url_parts;

    push @url_parts, $self->url_base();
    push @url_parts, $self->search_resource();
    push @url_parts, $self->mbid() if $self->mbid;

    my $url_str = join '/', @url_parts;

    $url_str .= '?fmt=' . $self->format;

    if(scalar(@{ $self->inc }) > 0) {
        my $inc_query = join '+', @{ $self->inc }; 

        $url_str .= '&inc=' . $inc_query;
    }

    my $url = Mojo::URL->new($url_str);

    return $url;
}

sub result {
    my $self = shift;

    my $request_url = $self->make_url();

    my $json_result = $self->ua->get($request_url => { 'Accept-Encoding' => 'application/json' })->result->json;

    return $json_result;
}

=head1 NAME

WebService::MusicBrainz::Request

=head1 SYNOPSIS

=head1 ABSTRACT

WebService::MusicBrainz::Request - Handle queries using the MusicBrainz WebService API version 2

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

=over 4

=item Bob Faist <bob.faist@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2006-2017 by Bob Faist

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

http://wiki.musicbrainz.org/XMLWebService

=cut

1;
