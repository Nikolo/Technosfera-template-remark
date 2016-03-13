package Local::MusicLibrary::Filter;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = ('filter');

sub parser {									#Parser($string, \@record)
	my ($string, $aref) = @_;
	my @temprec = split m/\.?\/+/, $string;					#band:year - album:track.format
	my $extra = shift @temprec;						#@temprec[0] = ''; shifting it;
	my ($year, $album) = split m/\s*\-\s*/, $temprec[1], 2;
	my ($track, $format) = split m/\./, $temprec[2];
	$$aref[0] = $temprec[0];
	$$aref[1] = $year;
	$$aref[2] = $album;
	$$aref[3] = $track;
	$$aref[4] = $format;
}

sub filter {									#Filter(\@database, \%parameters);
	#my $first = 0; #for skipping ./main.pl
	my $it = 0;
	my $flag = 0;
	my $number;
	my @keyarr = qw(band year album track format);
	my @record;
	my ($dataref, $paramref) = @_;
	while (<>){
		chomp;
		#if (!$first) {$first = 1; next;} #for skipping ./main.pl
		$flag = 0;
		parser($_, \@record);
		if ($#record < 4) {next;}
		for $number (0..$#keyarr) {
			if ($number == 1 && $$paramref{$keyarr[$number]} ne '' && $record[$number] != $$paramref{$keyarr[$number]}) {
				$flag = 1;
				last;
			}
			if ($number != 1 && $$paramref{$keyarr[$number]} ne '' && $record[$number] ne $$paramref{$keyarr[$number]}) {
				$flag = 1;
				last;
			}
		}
		next if $flag;
		push @$dataref, [@record];
		$it++;
	}
}
1;
