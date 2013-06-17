# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl WebService-MusicBrainz.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More;
BEGIN { use_ok('WebService::MusicBrainz::Artist') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $sleep_duration = 2;

my $ws = WebService::MusicBrainz::Artist->new();
ok( $ws, 'create WebService::MusicBrainz::Artist object' );

my $wsde = WebService::MusicBrainz::Artist->new(HOST => 'de.musicbrainz.org');
my $wsde_query = $wsde->query();
ok( $wsde_query->{_baseurl} =~ m/de\.musicbrainz\.org/, 'create WebService::MusicBrainz::Artist object/altername host' );

my $mbid_response = $ws->search({ MBID => '4eca1aa0-c79f-481b-af8a-4a2d6c41aa5c' });
ok( $mbid_response, 'artist by MBID' );

my $mbid_artist = $mbid_response->artist();
ok( $mbid_artist, 'artist obj');
is( $mbid_artist->name(), "Miranda Lambert", 'artist name'); 
is( $mbid_artist->sort_name(), "Lambert, Miranda", 'artist sort_name'); 
is( $mbid_artist->life_span_begin(), "1983-11-10", 'artist life_span_begin'); 
is( $mbid_artist->gender(), "Female", 'artist gender');

my $name_response = $ws->search({ NAME => 'Pantera' });
ok( $name_response, 'artist by NAME' );
my $name_artist_list = $name_response->artist_list();
ok( $name_artist_list, 'artist list obj' );
ok( $name_artist_list->count() >= 3, 'artist list count' );
ok( $name_artist_list->offset() == 0, 'artist list offset' );
my $name_artist = $name_artist_list->artists()->[0];
ok( $name_artist, 'first artist' );
ok( $name_artist->id() eq "541f16f5-ad7a-428e-af89-9fa1b16d3c9c", 'first artist id' );
ok( $name_artist->name() eq "Pantera", 'first artist name' );
ok( $name_artist->sort_name() eq "Pantera", 'first artist sort-name' );
ok( $name_artist->type() eq "Group", 'first artist type' );
ok( $name_artist->score() > 90, 'first artist score' );
ok( $name_artist->life_span_begin() eq "1982", 'first artist life-span-begin' );
ok( $name_artist->life_span_end() eq "2003", 'first artist life-span-end' );
is( $name_artist->gender(), undef, 'first artist gender');

sleep($sleep_duration);

my $name_limit_response = $ws->search({ NAME => 'Elvis', LIMIT => 3 });
ok( $name_limit_response, 'artist by NAME LIMIT' );
my $name_limit_artist_list = $name_limit_response->artist_list();
ok( $name_limit_artist_list, 'artist list by NAME LIMIT');
ok( $name_limit_artist_list->count() > 80, 'artist list count LIMIT');
my $artist_counter = 0;
foreach my $artist_node (@{ $name_limit_artist_list->artists() }) {
    $artist_counter++;
}
ok( $artist_counter == 3, 'artist limit check');

my $name_offset_response = $ws->search({ NAME => 'Elvis', OFFSET => 10 });
ok( $name_offset_response, 'artist by NAME OFFSET' );
my $name_offset_artist_list = $name_offset_response->artist_list();
ok( $name_offset_artist_list, 'artist list OFFSET');
ok( $name_offset_artist_list->count() > 80, 'artist offset COUNT');
ok( $name_offset_artist_list->offset() == 10, 'artist offset OFFSET');

sleep($sleep_duration);

my $name_limit_offset_response = $ws->search({ NAME => 'Elvis', LIMIT => 5, OFFSET => 6 });
ok( $name_limit_offset_response, 'artist by NAME LIMIT OFFSET' );
my $name_limit_offset_artist_list = $name_limit_offset_response->artist_list();
ok( $name_limit_offset_artist_list, 'artist list LIMIT OFFSET' );
ok( $name_limit_offset_artist_list->offset() == 6, 'artist limit offset OFFSET');

my $mbid_aliases_response = $ws->search({ MBID => '070d193a-845c-479f-980e-bef15710653e', INC => 'aliases' });
ok( $mbid_aliases_response, 'artist by MBID ALIASES' );
my $mbid_aliases_artist = $mbid_aliases_response->artist();
ok( $mbid_aliases_artist, 'artist aliases');
ok( $mbid_aliases_artist->type() eq "Person", 'artist aliases TYPE');
ok( $mbid_aliases_artist->name() eq "Prince", 'artist aliases NAME');
ok( $mbid_aliases_artist->sort_name() eq "Prince", 'artist aliases SORT NAME');
ok( $mbid_aliases_artist->life_span_begin() eq "1958-06-07", 'artist aliases LIFE SPAN BEGIN');
my $mbid_aliases_alias_list = $mbid_aliases_artist->alias_list();
ok( $mbid_aliases_alias_list, 'artist aliases ALIAS LIST');
ok( scalar(@{ $mbid_aliases_alias_list->aliases() }) > 2, 'artist aliases ALIAS COUNT');

sleep($sleep_duration);

my $mbid_release_groups_response = $ws->search({ MBID => '4dca4bb2-23ba-4103-97e6-5810311db33a', INC => 'release-groups releases' });
ok( $mbid_release_groups_response, 'artist by MBID RELEASE-GROUPS' );
my $mbid_rg_artist = $mbid_release_groups_response->artist();
ok( $mbid_rg_artist, 'artist release-groups');
my $mbid_rg_release_list = $mbid_rg_artist->release_list();
ok( $mbid_rg_release_list,'artist release-groups RELEASE LIST');
my $mbid_rg_release_group_list = $mbid_rg_artist->release_group_list();
ok( $mbid_rg_release_group_list, 'artist release-groups RELEASE GROUP LIST');
ok( scalar(@{ $mbid_rg_release_group_list->release_groups() }) > 1, 'artist release-groups RELEASE GROUPS');

my $mbid_artist_rels_response = $ws->search({ MBID => 'ae1b47d5-5128-431c-9d30-e08fd90e0767', INC => 'artist-rels' });
ok( $mbid_artist_rels_response, 'artist by MBID ARTIST-RELS' );
my $mbid_artist_rels_artist = $mbid_artist_rels_response->artist();
ok( $mbid_artist_rels_artist, 'artist artist-rels ARTIST');
ok( $mbid_artist_rels_artist->type() eq "Group", 'artist artist-rels GROUP');
ok( $mbid_artist_rels_artist->name() eq "Coheed and Cambria", 'artist artist-rels NAME');
ok( $mbid_artist_rels_artist->sort_name() eq "Coheed and Cambria", 'artist artist-rels SORT NAME');
my $mbid_artist_rels_list = $mbid_artist_rels_artist->relation_list();
ok( $mbid_artist_rels_list, 'artist artist-rels RELATION LIST');
ok( $mbid_artist_rels_list->target_type() eq "artist",'artist artist-rels relation-list TARGET TYPE');
foreach my $relation (@{ $mbid_artist_rels_list->relations() }) {
    if($relation->target() eq "56c0c0ec-5973-4ce8-9fd8-ba7b46ce0a9e") {
        ok( $relation->type() eq "MemberOfBand",  'artist artist-rels relation TYPE');
        ok( $relation->direction() eq "backward",  'artist artist-rels relation DIRECTION');
        ok( $relation->begin() eq "1995",  'artist artist-rels relation BEGIN');
        my $ar = $relation->artist();
        ok( $ar, 'artist artist-rels relation ARTIST');
        ok( $ar->id() eq "56c0c0ec-5973-4ce8-9fd8-ba7b46ce0a9e", 'artist artist-rels relation artist ID');
        ok( $ar->type() eq "Person", 'artist artist-rels relation artist PERSON');
        ok( $ar->name() eq "Claudio Sanchez", 'artist artist-rels relation artist NAME');
        ok( $ar->sort_name() eq "Sanchez, Claudio", 'artist artist-rels relation artist SORT NAME');
        ok( $ar->life_span_begin() eq "1978-03-12", 'artist artist-rels relation artist LIFE SPAN BEGIN');
        last; 
    }
}

sleep($sleep_duration);

my $mbid_label_rels_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'label-rels releases', STATUS => 'official' });
ok( $mbid_label_rels_response, 'artist by MBID LABEL-RELS' );
my $mbid_label_rels_artist = $mbid_label_rels_response->artist();
ok( $mbid_label_rels_artist,'artist label rels ARTIST');
my $mbid_label_rels_release_list = $mbid_label_rels_artist->release_list();
ok( $mbid_label_rels_release_list, 'artist label_rels RELEASE LIST');
foreach my $release (@{ $mbid_label_rels_release_list->releases() }) {
    if($release->id() eq "940d6fba-3603-4ac2-8f5d-ea0a11e51765") {
        ok($release->type() eq "Album Official",'artist label rels release TYPE');
        my $relation_list = $release->relation_list();
        ok($relation_list->target_type() eq "label", 'artist label-rels release relation_list TYPE');
        foreach my $relation (@{ $relation_list->relations() }) {
           if($relation->target() eq "82275f26-c259-4a3e-a476-91277f1d0c3d") {
               ok($relation->type() eq "Publishing", 'artist label-rels relation TYPE');
               ok($relation->label(), 'artist label-res relation LABEL');
               ok($relation->label()->name() eq "Creeping Death Music", 'artist label-rels label NAME');
               ok($relation->label()->sort_name() eq "Creeping Death Music", 'artist label-rels label SORT NAME');
               ok($relation->label()->country() eq "US", 'artist label-rels label COUNTRY');
               last;
           }
        }
        last;
    }
}

my $mbid_release_rels_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'release-rels' });
ok( $mbid_release_rels_response, 'artist by MBID RELEASE-RELS' );
my $mbid_release_rels_artist = $mbid_release_rels_response->artist();
ok( $mbid_release_rels_artist, 'artist release rels ARTIST');
ok( $mbid_release_rels_artist->name() eq "Metallica", 'artist release rels artist NAME');
ok( $mbid_release_rels_artist->sort_name() eq "Metallica", 'artist release rels artist SORT NAME');
ok( $mbid_release_rels_artist->life_span_begin() eq "1981-10", 'artist release rels artist BEGIN');
my $mbid_release_rels_list = $mbid_release_rels_artist->relation_list();
ok( $mbid_release_rels_list, 'artist release rels RELATION LIST');
ok( $mbid_release_rels_list->target_type() eq "release", 'artist release rels RELATION LIST');
ok( scalar(@{ $mbid_release_rels_list->relations() }) > 0, 'artist release rels RELEASES');
foreach my $relation (@{ $mbid_release_rels_list->relations() }) {
    if($relation->target() eq "552c4163-397e-4ae3-8da5-8f551ebbdbc1") {
        ok( $relation->type() eq "Tribute", 'artist release rels relation TYPE');
        ok( $relation->release()->type() eq "EP Official", 'artist release rels relation release TYPE');
        ok( $relation->release()->title() eq "A Tribute to Metallica", 'artist release rels relation release TITLE');
        ok( $relation->release()->text_rep_language() eq "ENG", 'artist release rels relation release LANG');
        ok( $relation->release()->text_rep_script() eq "Latn", 'artist release rels relation release SCRIPT');
        last;
    }
}

sleep($sleep_duration);

my $mbid_recording_rels_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'recording-rels' });
ok( $mbid_recording_rels_response, 'artist by MBID RECORDING-RELS' );
my $mbid_recording_rels_artist = $mbid_recording_rels_response->artist();
ok( $mbid_recording_rels_artist, 'artist recording rels ARTIST' );
ok( $mbid_recording_rels_artist->name() eq "Metallica", 'artist recording rels artist NAME');
ok( $mbid_recording_rels_artist->sort_name() eq "Metallica", 'artist recording rels artist SORT NAME');
my $mbid_recording_rels_list = $mbid_recording_rels_artist->relation_list();
ok( $mbid_recording_rels_list, 'artist recording rels artist RELATION LIST' );
ok( $mbid_recording_rels_list->target_type() eq "recording", 'artist recording rels artist relation list TYPE');
ok( scalar(@{ $mbid_recording_rels_list->relations() }) > 0, 'artist recording rels artist relation list RELATIONS');
foreach my $recording_rel (@{ $mbid_recording_rels_list->relations() }) {
    if($recording_rel->target() eq "f415a50d-4594-4d39-b84d-57afd433ef6d") {
        ok( $recording_rel->type() eq "performer", 'artist recording rels relation TYPE');
        ok( $recording_rel->recording()->title() eq "Halloween (feat. Metallica)", 'artist recording rels relation recording TITLE');
        ok( $recording_rel->recording()->duration() eq "174200", 'artist recording rels relation recording DURATION');
        last;
    }
}

my $mbid_url_rels_response = $ws->search({ MBID => 'ae1b47d5-5128-431c-9d30-e08fd90e0767', INC => 'url-rels' });
ok( $mbid_url_rels_response, 'artist by MBID URL-RELS' );
my $mbid_url_rels_artist = $mbid_url_rels_response->artist();
ok( $mbid_url_rels_artist, 'artist url rels ARTIST');
ok( $mbid_url_rels_artist->name() eq "Coheed and Cambria", 'artist url rels artist NAME');
ok( $mbid_url_rels_artist->sort_name() eq "Coheed and Cambria", 'artist url rels artist SORT NAME');
my $mbid_url_rels_list = $mbid_url_rels_artist->relation_list();
ok( $mbid_url_rels_list, 'artist url rels artist RELATION LIST');
ok( $mbid_url_rels_list->target_type() eq "url", 'artist url rels artist relation list TYPE');
foreach my $url_rel (@{ $mbid_url_rels_list->relations() }) {
    if($url_rel->type() eq "Wikipedia") { 
        ok($url_rel->target() eq "http://en.wikipedia.org/wiki/Coheed_and_Cambria", 'artist url rels relation URL TYPE');
        last;
    }
}

sleep($sleep_duration);

my $mbid_tags_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'tags' });
ok( $mbid_tags_response, 'artist by MBID TAGS' );
my $mbid_tags_artist = $mbid_tags_response->artist();
ok( $mbid_tags_artist, 'artist tags ARTIST');
ok( $mbid_tags_artist->name() eq "Metallica", 'artist tags artist NAME');
ok( $mbid_tags_artist->sort_name() eq "Metallica", 'artist tags artist SORT NAME');
my $mbid_tags_tag_list = $mbid_tags_artist->tag_list();
ok( $mbid_tags_tag_list, 'artist tags artist TAGLIST');
foreach my $tag (@{ $mbid_tags_tag_list->tags() }) {
    if($tag->text() eq "heavy metal") {
        ok($tag->count() > 2, 'artist tags tag COUNT2');
    }
}

my $mbid_ratings_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'ratings' });
ok( $mbid_ratings_response, 'artist by MBID RATINGS' );
my $mbid_ratings_artist = $mbid_ratings_response->artist();
ok( $mbid_ratings_artist, 'artist ratings ARTIST');
ok( $mbid_ratings_artist->name() eq "Metallica", 'artist ratings artist NAME');
ok( $mbid_ratings_artist->sort_name() eq "Metallica", 'artist ratings artist SORT NAME');
my $mbid_ratings_rating = $mbid_ratings_artist->rating();
ok( $mbid_ratings_rating, 'artist ratings RATING');
ok( $mbid_ratings_rating->votes_count() > 20, 'artist ratings rating VOTE COUNT');
ok( $mbid_ratings_rating->value() > 3 , 'artist ratings rating VALUE');


# TODO: requires auth/credentials
# my $mbid_user_tags_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'user-tags' });
# ok( $mbid_user_tags_response, 'artist by MBID USERs-TAGS' );
# 
# my $mbid_user_ratings_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'user-ratings' });
# ok( $mbid_user_ratings_response, 'artist by MBID USER-RATINGS' );

sleep($sleep_duration);

my $mbid_releases_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'releases', STATUS => 'official' });
ok( $mbid_releases_response, 'artist by MBID RELEASES' );
my $mbid_releases_artist = $mbid_releases_response->artist();
ok( $mbid_releases_artist, 'artist releases ARTIST');
ok( $mbid_releases_artist->name() eq "Metallica", 'artist releases artist NAME');
ok( $mbid_releases_artist->sort_name() eq "Metallica", 'artist releases artist SORT NAME');
foreach my $release (@{ $mbid_releases_artist->release_list()->releases() }) {
    if($release->id() eq "834a7aa9-c7f5-3571-a812-46c6d134a98d") {
        is( $release->status(), "Official", 'artist releases release STATUS');
        ok( $release->title() eq "Kill 'em All", 'artist releases release TITLE');
        is( $release->text_rep_language(), "eng", 'artist releases release LANG');
        is( $release->text_rep_script(), "Latn", 'artist releases release SCRIPT');
        foreach my $event (@{ $release->release_event_list()->events() }) {
           if($event->barcode() && $event->barcode() eq "075596076623") {
               ok( $event->date() eq "1988-01-15", 'artist releases release events DATE');
               ok( $event->country() eq "US", 'artist releases release events COUNTRY');
               ok( $event->catalog_number() eq "CD 60766", 'artist releases release events CATALOG NUMBER');
               ok( $event->format() eq "CD", 'artist releases release events FORMAT');
               last;
           }
        }
        last;
    }
}

sleep($sleep_duration);

my $mbid_media_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'releases media', STATUS => 'official' });
ok( $mbid_media_response, 'artist by MBID MEDIA' );
my $mbid_media_artist = $mbid_media_response->artist();
ok( $mbid_media_artist, 'artist media ARTIST');
ok( $mbid_media_artist->name() eq "Metallica", 'artist media artist NAME');
ok( $mbid_media_artist->sort_name() eq "Metallica", 'artist media artist SORT NAME');
foreach my $release (@{ $mbid_media_artist->release_list()->releases() }) {
    if($release->id() eq "51eb10e0-2b9e-3906-a8f1-db74b346cba5") {
        is( $release->status(), "Official", 'artist media release TYPE');
        ok( $release->title() eq "Ride the Lightning", 'artist media release TITLE');
        ok( $release->text_rep_language() eq "eng", 'artist media release LANG');
        ok( $release->text_rep_script() eq "Latn", 'artist media release SCRIPT');
        ok( $release->asin() eq "B000002H2H", 'artist media release ASIN');
        foreach my $disc (@{ $release->medium_list()->media() }) {
            # FIXME: add media tests here.
           # if($disc->id() eq "UhuTnSAqRRgWbuC0zf1rvAzFX9M-") {
           #     ok( $disc->sectors() eq "213595", 'artist media disc-list disc SECTORS');
           #     last;
           # }
        }
        last;
    }
}

my $mbid_labels_response = $ws->search({ MBID => '65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab', INC => 'releases', STATUS => 'official' });
ok( $mbid_labels_response, 'artist by MBID LABELS' );
my $mbid_labels_artist = $mbid_labels_response->artist();
ok( $mbid_labels_artist, 'artist labels ARTIST');
ok( $mbid_labels_artist->name() eq "Metallica", 'artist labels artist NAME');
ok( $mbid_labels_artist->sort_name() eq "Metallica", 'artist labels artist SORT NAME');
foreach my $release (@{ $mbid_labels_artist->release_list()->releases() }) {
    if($release->id() eq "456efd39-f0dc-4b4d-87c7-82bbc562d8f3") {
        is( $release->type(), "Official", 'artist labels release TYPE');
        ok( $release->title() eq "Ride the Lightning", 'artist labels release TITLE');
        is( $release->text_rep_language(), "eng", 'artist labels release LANG');
        ok( $release->text_rep_script() eq "Latn", 'artist labels release SCRIPT');
        ok( $release->asin() eq "B000002H2H", 'artist labels release ASIN');
        foreach my $event (@{ $release->release_event_list()->events() }) {
           if($event->barcode() eq "075596039628") {
               ok( $event->date() eq "1987", 'artist labels release event DATE');
               ok( $event->country() eq "US", 'artist labels release event COUNTRY');
               ok( $event->format() eq "CD", 'artist labels release event FORMAT');
               ok( $event->catalog_number() eq "9 60396-2", 'artist labels release event CATALOG');
               ok( $event->label()->id() eq "873f9f75-af68-4872-98e2-431058e4c9a9", 'artist labels release event label ID');
               ok( $event->label()->name() eq "Elektra", 'artist labels release event label NAME');
               last;
           }
        }
        last;
    }
}

sleep($sleep_duration);

my $q1_response = $ws->search({ QUERY => 'begin:1990 AND type:group'});
ok($q1_response, 'artist query begin type');
foreach my $artist (@{ $q1_response->artist_list()->artists() }) {
    if($artist->id() eq "e9571c17-817f-4d34-ae3f-0c7a96f822c1") {
        ok($artist->type() eq "Group", 'artist query begin type TYPE');
        ok($artist->name() eq "Temple of the Dog", 'artist query begin type NAME');
        ok($artist->sort_name() eq "Temple of the Dog", 'artist query begin type SORT NAME');
        ok($artist->life_span_begin() eq "1990", 'artist query begin type LIFE SPAN BEGIN');
        ok($artist->life_span_end() eq "1991", 'artist query begin type LIFE SPAN END');
        last;
    }
}

my $search_name_utf8 = $ws->search({ NAME => 'ザ・リリーズ' });
ok( $search_name_utf8, 'get NAME search response object when NAME is UTF-8 encoded' );

done_testing();
