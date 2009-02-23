#! perl

sub c
{
  my @a = split (/\\./, $_[0]);
  my @b = split (/\\./, $_[1]);
  for my $i (0 .. @a-1)
    {
      if ($a[$i] > $b[$i])
	{
	  return 1;
	}
      elsif ($a[$i] < $b[$i])
	{
	  return -1;
	}
    }
  return 0;
}

my $t = $ARGV[0];
my @s = sort { c ($a, $b) } <STDIN>;
my $g = $s[0];
for my $i (0 .. @s-1)
  {
    last if c ($s[$i], $t) > 0;
    $g = $s[$i];
  }
print $g;
0;
