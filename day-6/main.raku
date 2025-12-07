sub part1($f = 'input.txt') {
    my @l = $f.IO.lines.grep(*.chars);
    my ($ops, $w, $s, $t) = (@l.pop, @l.map(*.chars).max, 0, 0);
    
    for 0..$w -> $c {
        my $sep = @l.all.map({$c >= .chars || .substr($c,1) eq ' '}).all;
        if $sep || $c == $w {
            if $s < $c {
                my (@n, $op);
                for $s..^$c { $op = $ops.substr($_,1) if $_ < $ops.chars && $ops.substr($_,1) ~~ /<[+*]>/ }
                for @l {
                    my $seg = $s < .chars ?? .substr($s, min($c-$s, .chars-$s)) !! '';
                    @n.push($seg.trim.Int) if $seg.trim ~~ /\d/;
                }
                if $op && @n {
                    my $r = @n[0];
                    $r = $op eq '+' ?? $r + @n[$_] !! $r * @n[$_] for 1..^@n;
                    $t += $r;
                }
            }
            $s = $c + 1;
        }
    }
    return $t;
}

sub part2($f = 'input.txt') {
    my @l = $f.IO.lines.grep(*.chars);
    my ($ops, $w, $s, $t) = (@l.pop, @l.map(*.chars).max, 0, 0);
    
    for 0..$w -> $c {
        my $sep = @l.all.map({$c >= .chars || .substr($c,1) eq ' '}).all;
        if $sep || $c == $w {
            if $s < $c {
                my (@n, $op);
                for $s..^$c { $op = $ops.substr($_,1) if $_ < $ops.chars && $ops.substr($_,1) ~~ /<[+*]>/ }
                
                # Read columns right-to-left, digits top-to-bottom
                for ($s..^$c).reverse -> $col {
                    my $num-str = '';
                    for @l -> $line {
                        if $col < $line.chars {
                            my $char = $line.substr($col, 1);
                            $num-str ~= $char if $char ~~ /\d/;
                        }
                    }
                    @n.push($num-str.Int) if $num-str;
                }
                
                if $op && @n {
                    my $r = @n[0];
                    $r = $op eq '+' ?? $r + @n[$_] !! $r * @n[$_] for 1..^@n;
                    $t += $r;
                }
            }
            $s = $c + 1;
        }
    }
    return $t;
}

sub MAIN($f = 'input.txt') {
    say "Part 1: { part1($f) }";
    say "Part 2: { part2($f) }";
}
