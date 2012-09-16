use strict;
use HTML::TreeBuilder::XPath;
use Data::Dumper;
require LWP::UserAgent;

my %patterns;

open P,"<pastepattern.txt";

while(<P>) {
	chomp;
	my ($key, $value) = split(/:/,$_);
	$patterns{$value} = $key;
}	
close(P);
my $ua = LWP::UserAgent->new(agent => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)");
#$ua->proxy('http', 'http://195.25.110.87:3128');

my $urlbase = 'http://pastebin.com';
my $archive = $ua->get("http://pastebin.com/archive");

my $tree= HTML::TreeBuilder::XPath->new;
$tree->parse($archive->decoded_content);

#print $archive->decoded_content;
my @p= $tree->findnodes('/html/body/div/div[4]/div/div[2]/div[4]/table//tr/td/a');

#print Dumper(@p);
#print "=====\n";
my $i = 0;
my $last;

open LAST, "<last.paste";
$last = <LAST>;
chomp($last);

foreach my $href (@p) {

	$i = !$i;
	sleep(1);
	if($i) {
		my $url = $urlbase.$href->{href};
		#print " =>> $urlbase$href->{href}\n";
		my $content = $ua->get($url);
		if ($content) {
			my $text = $content->decoded_content;
			
			foreach my $pattern (keys %patterns) {
				if($text =~ /$pattern/i) {

					print "[$patterns{$pattern} - $pattern] =>> $urlbase$href->{href}\n";

				}
			}
		}
	}
}

