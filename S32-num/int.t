use Test;
plan 165;

# L<S32::Numeric/Real/=item truncate>
# truncate and .Int are synonynms.
# Possibly more tests for truncate should be added here, too.

=begin pod

Basic tests for the int() builtin

=end pod

# basic sanity:
is(-0, 0, '-0 is the same as 0 - hey, they are integers ;-)');

isa-ok( EVAL(1.raku), Int, 'EVAL 1.raku is Int' );
is( EVAL(1.raku), 1, 'EVAL 1.raku is 1' );
isa-ok( EVAL((-12).raku), Int, 'EVAL -12.raku is Int' );
is( EVAL((-12).raku), -12, 'EVAL -12.raku is -12' );
isa-ok( EVAL(0.raku), Int, 'EVAL 0.raku is Int' );
is( EVAL(0.raku), 0, 'EVAL 0.raku is 0' );
isa-ok( EVAL((-0).raku), Int, 'EVAL -0.raku is Int' );
is( EVAL((-0).raku), -0, 'EVAL -0.raku is 0' );

is((-1).Int, -1, "(-1).Int is -1");
is(0.Int, 0, "0.Int is 0");
is(1.Int, 1, "1.Int is 1");
is(3.14159265.Int, 3, "3.14159265.Int is 3");
is((-3.14159265).Int, -3, "(-3.14159265).Int is -3");

is(0.999.Int,   0, "0.999.Int is 0");
is(0.51.Int,    0, "0.51.Int is 0");
is(0.5.Int,     0, "0.5.Int is 0");
is(0.49.Int,    0, "0.49.Int is 0");
is(0.1.Int,     0, "0.1.Int is 0");
isa-ok(0.1.Int, Int, '0.1.Int returns an Int');

is((-0.999).Int, 0, "(-0.999).Int is 0");
is((-0.51).Int,  0, "(-0.51).Int is 0");
is((-0.5).Int,   0, "(-0.5).Int is 0");
is((-0.49).Int,  0, "(-0.49).Int is 0");
is((-0.1).Int,   0, "(-0.1).Int is 0");
isa-ok((-0.1).Int, Int, 'int(-0.1) returns an Int');

is(1.999.Int, 1, "int(1.999) is 1");
is(1.51.Int,  1, "int(1.51) is 1");
is(1.5.Int,   1, "int(1.5) is 1");
is(1.49.Int,  1, "int(1.49) is 1");
is(1.1.Int,   1, "int(1.1) is 1");

is((-1.999).Int, -1, "int(-1.999) is -1");
is((-1.51).Int, -1, "int(-1.51) is -1");
is((-1.5).Int, -1, "int(-1.5) is -1");
is((-1.49).Int, -1, "int(-1.49) is -1");
is((-1.1).Int, -1, "int(-1.1) is -1");

is(1.999.Num.Int, 1, "int(1.999.Num) is 1");
is(1.1.Num.Int,   1, "int(1.1.Num) is 1");

is((-1.999).Num.Int, -1, "int(-1.999.Num) is -1");
is((-1.1).Num.Int, -1, "int(-1.1.Num) is -1");

nok ?0, "?0 is false";
isa-ok ?0, Bool, "?0 is Bool";
ok ?1, "?1 is true";
isa-ok ?1, Bool, "?1 is Bool";
ok ?42, "?42 is true";
isa-ok ?42, Bool, "?42 is Bool";

nok 0.Bool, "0.Bool is false";
isa-ok 0.Bool, Bool, "0.Bool is Bool";
ok 1.Bool, "1.Bool is true";
isa-ok 1.Bool, Bool, "1.Bool is Bool";
ok 42.Bool, "42.Bool is true";
isa-ok 42.Bool, Bool, "42.Bool is Bool";

is('-1.999'.Int, -1, "int('-1.999') is -1");
is('0x123'.Int, 0x123, "int('0x123') is 0x123");
is('0d456'.Int, 0d456, "int('0d456') is 0d456");
throws-like q['0o678'.Int], X::Str::Numeric,
    'conversion from string to number fails because of trailing characters (1)';
throws-like q['3e4d5'.Int], X::Str::Numeric,
    'conversion from string to number fails because of trailing characters (2)';

#?DOES 24
{
    sub __int( $s ) {
        my $pos = $s.index('.');
        if defined($pos) { return substr($s, 0, $pos); }
        return $s;
    };

    # Check the defaulting to $_

    for 0, 0.0, 1, 50, 60.0, 99.99, 0.4, 0.6, -1, -50, -60.0, -99.99 {
        my $int = __int($_.Num);
        is(.Int, $int, "integral value for $_ is $int");
        isa-ok(.Int, Int);
    }
}

# Special values
is((1.9e3).Int, 1900, "int 1.9e3 is 1900");

# https://github.com/Raku/old-issue-tracker/issues/949
throws-like 'int 3.14', X::Syntax::Confused,
    'dies: int 3.14 (prefix:int is gone)';

is 0.lsb,        Nil, "0.lsb is Nil";
is 1.lsb,        0,   "1.lsb is 0";
is 2.lsb,        1,   "2.lsb is 1";
is 256.lsb,      8,   "256.lsb is 8";
is (-1).lsb,     0,   "(-1).lsb is 0";       # 1111 1111
is (-2).lsb,     1,   "(-2).lsb is 1";       # 1111 1110
is (-126).lsb,   1,   "(-126).lsb is 1";     # 1000 0010
is (-127).lsb,   0,   "(-127).lsb is 0";     # 1000 0001
is (-128).lsb,   7,   "(-128).lsb is 7";     # 1000 0000
is (-32768).lsb, 15,  "(-32768).lsb is 15";

is 0.msb,        Nil, "0.msb is Nil";
is 1.msb,        0,   "1.msb is 0";
is 2.msb,        1,   "2.msb is 1";
is 256.msb,      8,   "256.msb is 8";
is (-1).msb,     0,   "(-1).msb is 0";       # 1111 1111
is (-2).msb,     1,   "(-2).msb is 1";       # 1111 1110
is (-126).msb,   7,   "(-126).msb is 7";     # 1000 0010
is (-127).msb,   7,   "(-127).msb is 7";     # 1000 0001
is (-128).msb,   7,   "(-128).msb is 7";     # 1000 0000
is (-129).msb,   8,   "(-129).msb is 8";
is (-32768).msb, 15,  "(-32768).msb is 15";

# Test issue fixed by https://github.com/rakudo/rakudo/commit/84b7ebdf42
subtest 'smartmatching :U numeric against :D numeric does not throw' => {
    plan 60;
    for -42, 42, τ, .5, <1+3i>,
        <-42>, <42>, <1e0>, <1/3>, <-1-3i > -> $what {
        is (Numeric ~~ $what), False, "Numeric:U ~~ $what ($what.^name())";
        is (Int     ~~ $what), False, "Int:U     ~~ $what ($what.^name())";
        is (UInt    ~~ $what), False, "UInt:U    ~~ $what ($what.^name())";
        is (Num     ~~ $what), False, "Num:U     ~~ $what ($what.^name())";
        is (Rat     ~~ $what), False, "Rat:U     ~~ $what ($what.^name())";
        is (Complex ~~ $what), False, "Complex:U ~~ $what ($what.^name())";
    }
}

{ # coverage; 2016-10-05
    my UInt $u;
    is-deeply $u.defined, Bool::False, 'undefined UInt is undefined';
    cmp-ok $u, '~~', UInt, 'UInt var smartmatches True against UInt';
    # TODO Module name to be changed when changed in the core.
    is $u.HOW.^name, 'Perl6::Metamodel::SubsetHOW', 'UInt is a subset';
    throws-like { UInt.new }, Exception,
        'attempting to instantiate UInt throws';

    is-deeply ($u = 42), 42, 'Can store a positive Int in UInt';
    is-deeply ($u = 0),  0,  'Can store a zero in UInt';
    throws-like ｢my UInt $z = -42｣, X::TypeCheck::Assignment,
        'UInt rejects negative numbers';
    throws-like ｢my UInt $y = "foo"｣, X::TypeCheck::Assignment,
        'UInt rejects other types';

    is-deeply ($u = Nil), UInt,  'Can assign Nil to UInt';
    my $u2 is default(72);
    is-deeply $u2, 72, 'is default() trait works on brand new UInt';
    is-deeply ($u2 = 1337), 1337, 'is default()ed UInt can take values';
    is-deeply ($u2 = Nil),  72,
        'Nil assigned to is default()ed UInt gives default values';
}

subtest 'Int.new' => { # coverage; 2016-10-05
    plan 10;

    subtest 'returns a new object (not a cached constant)' => {
        plan 3;
        {
            my int $orig = 2; my $new := Int.new: $orig;
            $new does my role Meows {};
            is-deeply $orig.^name, 'Int', 'Int.new: int';
        }
        {
            my $orig := 2; my $new := Int.new: $orig;
            $new does my role Meows {};
            is-deeply $orig.^name, 'Int', 'Int.new: Int';
        }
        {
            my $orig := 2; my $new := Int.new: "2";
            $new does my role Meows {};
            is-deeply $orig.^name, 'Int', 'Int.new: Str';
        }
    }

   for '42', 42e0, 420/10, 42, ^42, (|^42,), [|^42] -> $n {
        is-deeply Int.new($n), 42,
           "Can use $n.^name() to construct an Int from";
    }

    is-deeply Int.new, 0, 'no args default to 0';

    # https://github.com/Raku/old-issue-tracker/issues/6539

    subtest '.new of subclass of Int' => {
        plan 3*
        my @tests = no-arg => \(),              Int => \( 42 ),
                    int    => \(my int $ = 42), Str => \('42');

        my class Foo is Int {};
        for @tests -> (:key($what), :value($args)) {
            my Foo $x;
            lives-ok { $x = Foo.new: |$args }, "lives ($what)";
            isa-ok $x, Foo,                    "returns subclass ($what)";
            cmp-ok $x, '==', $args[0]//0,      "right numeric value ($what)";
        }
    }
}

{ # coverage; 2016-10-05
    my int $i0 = 0;
    my int $i1 = 1;
    my int $i2 = 2;
    my int $i3 = 3;
    my int $i5 = 5;
    my int $i6 = 6;
    my int $i8 = 8;
    my int $iL = 2**62;
    my int $iu;

    is-deeply 42.narrow,  42,  'Int.narrow gives Int';

    is-deeply $i2 ** $i3, $i8, 'int ** int returns int';
    is-deeply $iu ** $i3, $i0, '0 (uninitialized int) ** int returns 0';
    is-deeply $i8 ** $iu, $i1, 'int ** 0 (uninitialized int) returns 1';

    is-deeply $i2 * $i3,  $i6, 'int * int returns int';
    is-deeply $iu * $i3,  $i0, '0 (uninitialized int) * int returns 0';
    is-deeply $i8 * $iu,  $i0, 'int * 0 (uninitialized int) returns 0';

    is-deeply $i5 div $i2, $i2, 'int(5) div int(2) returns int(2)';
    is-deeply $i8 div $i3, $i2, 'int(8) div int(3) returns int(2)';
    is-deeply $i0 div $i2, $i0, '0 div int returns 0';
    is-deeply $iu div $i2, $i0, '0 (uninitialized int) div int returns 0';
    throws-like { $i5 div $i0 }, Exception, 'int div 0 throws';
    throws-like { $i5 div $iu }, Exception, 'int div 0 (uninit. int) throws';

    is-deeply $i5 % $i2, $i1, 'int(5) % int(2) returns int(1)';
    is-deeply $i8 % $i2, $i0, 'int(8) % int(2) returns int(0)';
    is-deeply $i0 % $i2, $i0, '0 % int returns 0';
    is-deeply $iu % $i2, $i0, '0 (uninitialized int) div int returns 0';

    is-deeply $i3 lcm $i2, $i6, 'int(3) lcm int(2) returns int(6)';
    is-deeply $i3 lcm $i2, $i6, 'int(3) lcm int(2) returns int(6)';
    is-deeply $i8 lcm $i8, $i8, 'int(8) lcm int(8) returns int(8)';
    is-deeply $i0 lcm $i8, $i0, 'int(0) lcm int(8) returns int(0)';
    is-deeply $iu lcm $i8, $i0, 'int(uninitialized) lcm int(8) returns int(0)';

    is-deeply $i3 gcd $i2, $i1, 'int(3) gcd int(2) returns int(1)';
    is-deeply $i8 gcd $i2, $i2, 'int(8) gcd int(2) returns int(2)';
    is-deeply $i8 gcd $i0, $i8, 'int(8) gcd int(0) returns int(8)';
    is-deeply $i0 gcd $i8, $i8, 'int(0) gcd int(8) returns int(8)';
    is-deeply $i0 gcd $i0, $i0, 'int(0) gcd int(0) returns int(0)';
    is-deeply $iu gcd $i0, $i0, 'int(uninitialized) gcd int(0) returns int(0)';

    is-deeply $i8 === $i8, Bool::True,  'int === int (True)';
    is-deeply $i8 === $i2, Bool::False, 'int === int (False)';
    is-deeply $iu === $i0, Bool::True, 'int (uninit.) === int(0) (True)';

    is-deeply $iu.chr, "\x[0]", 'int(uninit.) .chr works';
    is-deeply $i0.chr, "\x[0]", 'int(0) .chr works';
    is-deeply $i8.chr, "\x[8]", 'int(8) .chr works';
}

{ # coverage; 2016-10-06
    is-deeply expmod(10, 3, 11), 10, 'expmod with Ints (1)';
    is-deeply expmod(10, 0, 11), 1,  'expmod with Ints (2)';
    is-deeply expmod("10", 0e0, 110/10), 1, 'expmod with other types';

    is-deeply lsb(0b01011), 0, 'lsb (1)';
    is-deeply lsb(0b01000), 3, 'lsb (2)';
    is-deeply msb(0b01011), 3, 'msb (1)';
    is-deeply msb(0b00010), 1, 'msb (2)';

    is-deeply lsb(0), Nil, 'lsb 0';
    is-deeply msb(0), Nil, 'msb 0';
}

ok Int ~~ UInt, "accept undefined Int";

# https://github.com/rakudo/rakudo/issues/2157
subtest 'no funny business with Ints that are not representable in double' => {
    plan 3*4;
    is-deeply $_+1, 9930972392403502
        for 9930972392403501, 0x23482ab1b9322d, 0o432202526156231055,
            0b100011010010000010101010110001101110010011001000101101;
    is-deeply $_+1, 9930972392403504
        for 9930972392403503, 0x23482ab1b9322f, 0o432202526156231057,
            0b100011010010000010101010110001101110010011001000101111;
    is-deeply $_+1, 9007199254740994
        for 9007199254740993, 0x20000000000001, 0o400000000000000001,
          0b100000000000000000000000000000000000000000000000000001;
}

#?rakudo.jvm skip 'crashes JVM'
{
    my $n = 2; $n *= $n for ^16;
    is-deeply $n.Str,
          ~ '20035299304068464649790723515602557504478254755697514192650169737'
        ~ '10894059556311453089506130880933348101038234342907263181822949382'
        ~ '11881266886950636476154702916504187191635158796634721944293092798'
        ~ '20843091048559905701593189596395248633723672030029169695921561087'
        ~ '64948889254090805911457037675208500206671563702366126359747144807'
        ~ '11177481588091413574272096719015183628256061809145885269982614142'
        ~ '50301233911082736038437678764490432059603791244909057075603140350'
        ~ '76162562476031863793126484703743782954975613770981604614413308692'
        ~ '11810248595915238019533103029216280016056867010565164675056803874'
        ~ '15294638422448452925373614425336143737290883037946012747249584148'
        ~ '64915930647252015155693922628180691650796381064132275307267143998'
        ~ '15850881129262890113423778270556742108007006528396332215507783121'
        ~ '42885516755540733451072131124273995629827197691500548839052238043'
        ~ '57045848197956393157853510018992000024141963706813559840464039472'
        ~ '19401606951769015611972698233789001764151719005113346630689814021'
        ~ '93834814354263873065395529696913880241581618595611006403621197961'
        ~ '01859534802787167200122604642492385111393400464351623867567078745'
        ~ '25946467090388654774348321789701276445552940909202195958575162297'
        ~ '33335761595523948852975799540284719435299135437637059869289137571'
        ~ '53740001986394332464890052543106629669165243419174691389632476560'
        ~ '28941519977547770313806478134230959619096065459130089018888758808'
        ~ '47336259560654448885014473357060588170901621084997145295683440619'
        ~ '79690565469813631162053579369791403236328496233046421066136200220'
        ~ '17578785185740916205048971178182040018728293994344618622432800983'
        ~ '73237649318147898481194527130074402207656809103762039992034920239'
        ~ '06626264491909167985461515778839060397720759279378852241294301017'
        ~ '45808686226336928472585140303961555856433038545068865221311481363'
        ~ '84083847782637904596071868767285097634712719888906804782432303947'
        ~ '18650525660978150729861141430305816927924971409161059417185352275'
        ~ '88750447759221830115878070197553572224140001954810200566177358978'
        ~ '14995323252085897534635470077866904064290167638081617405504051176'
        ~ '70093673202804549339027992491867306539931640720492238474815280619'
        ~ '16690093380573212081635070763435166986962502096902316285935007187'
        ~ '41905791612415368975148082619048479465717366010058924766554458408'
        ~ '38334790544144817684255327207315586349347605137419779525190365032'
        ~ '19802010876473836868253102518337753390886142618480037400808223810'
        ~ '40764688784716475529453269476617004244610633112380211345886945322'
        ~ '00116564076327023074292426051582811070387018345324567635625951430'
        ~ '03203743274078087905628366340696503084422585596703927186946115851'
        ~ '37933864756997485686700798239606043934788508616492603049450617434'
        ~ '12365828352144806726676841807083754862211408236579802961200027441'
        ~ '32443843240233125740354501935242877643088023285085588608996277445'
        ~ '81646808578751158070147437638679769550499916439982843572904153781'
        ~ '43438847303484261903388841494031366139854257635577105335580206622'
        ~ '18557706008255128889333222643628198483861323957067619140963853383'
        ~ '23743437588308592337222846442879962456054769324289984326526773783'
        ~ '73173288063210753211238680604674708428051166488709084770291208161'
        ~ '10491255559832236624486855665140268464120969498259056551921618810'
        ~ '43412268389962830716548685255369148502995396755039549383718534059'
        ~ '00096187489473992880432496373165753803673586710175783994818471798'
        ~ '49824694806053208199606618343401247609663951977802144119975254670'
        ~ '40806084993441782562850927265237098986515394621930046073645079262'
        ~ '12975917698293892367015170992091531567814439791248475706237804600'
        ~ '00991829332130688057004659145838720808801688744583555792625846512'
        ~ '47630871485663135289341661174906175266714926721761283308452739364'
        ~ '69244582892571388877839056300482483799839692029222215486145902373'
        ~ '47822268252163995744080172714414617955922617508388902007416992623'
        ~ '83002822862492841826712434057514241885699942723316069987129868827'
        ~ '71820617214453142574944015066139463169197629181506579745526236191'
        ~ '22484806389003366907436598922634956411466550306296596019972063620'
        ~ '26035219177767406687774635493753188995878662821254697971020657472'
        ~ '32721372918144666659421872003474508942830911535189271114287108376'
        ~ '15922238027660532782335166155514936937577846667014571797190122711'
        ~ '78127804502400263847587883393968179629506907988171216906869295382'
        ~ '48529830023476068454114178139110648560236549754227497231007615131'
        ~ '87002405391051091381784372179142252858743209852495787803468370333'
        ~ '78184214440171386881242499844186181292711985333153825673218704215'
        ~ '30631197748535214670955334626336610864667332292409879849256691109'
        ~ '51614361860154890974024191350962304361219612816595051866602203071'
        ~ '56136847323646608689050142639139065150639081993788523183650598972'
        ~ '99125404479443425166774299659811849233151555272883274028352688442'
        ~ '40875281128328998062591267369954624734154333350014723143061275039'
        ~ '03073971352520693381738433229507010490618675394331307847980156551'
        ~ '30384758155685236218010419650255596181934986315913233036096461905'
        ~ '99023611268119602344184336333459492763194610171665291382371718239'
        ~ '42992162725384617760656945422978770713831988170369645886898118632'
        ~ '10976900355735884624464835706291453052757101278872027965364479724'
        ~ '02540544813274839179412882642383517194919720979714593688753719872'
        ~ '91308317380339110161285474153773777159517280841116275971863849242'
        ~ '22802373441925469991983672192131287035585307966942713416391033882'
        ~ '75431861364349010094319740904733101447629986172542442335561223743'
        ~ '57158259333828049862438924982227807159517627578471094751190334822'
        ~ '41412025182688713728193104253478196128440176479531505057110722974'
        ~ '31456991522345164312184865757578652819756484350895838472292353455'
        ~ '94645212158316577514712987082259092926556388366511206819438369041'
        ~ '16252668710044560243704200663709001941185557160472044643696932850'
        ~ '06004692814050711906926139399390273553454556747031490388602202463'
        ~ '99482605017624319693056406663666260902070488874388989074981528654'
        ~ '44381862917382901051820869936382661868303915273264581286782806601'
        ~ '33750009659336462514609172318031293034787742123467911845479131110'
        ~ '98977946482169225056293999567934838016991574397005375421344858745'
        ~ '86856047286751065423341893839099110586465595113646061055156838541'
        ~ '21745980180713316361257307961116834386376766730735458349478978831'
        ~ '63301292408008363568259391571131309780305164417166825183465736759'
        ~ '34198084958947940983292500086389778563494693212473426103062713745'
        ~ '07728615692259662857385790553324064184901845132828463270926975383'
        ~ '08673084091422476594744399733481308109863994173797896570106870267'
        ~ '34161967196591599588537834822988270125605842365589539690306474965'
        ~ '58414798131099715754204325639577607048510088157829140825077773855'
        ~ '97901291294073094627859445058594122731948127532251523248015034665'
        ~ '19048228961406646890305102510916237770448486230229488966711380555'
        ~ '60795662073244937337402783676730020301161522700892184351565212137'
        ~ '92157482068593569207902145022771330999877294595969528170445821819'
        ~ '56080965811702798062669891205061560742325686842271306295009864421'
        ~ '85347081040712891764690655083612991669477802382250278966784348919'
        ~ '94096573617045867862425540069425166939792926247145249454088584227'
        ~ '26153755260071904336329196375777502176005195800693847635789586878'
        ~ '48953687212289855780682651819270363209948015587445557517531273647'
        ~ '14212955364940843855866152080121150790750685533444892586932838596'
        ~ '53013272046970694571546959353658571788894862333292465202735853188'
        ~ '53337094845540333656535698817258252891805663548836374379334841184'
        ~ '55801683318276768346462919956055134700391478768086403226296166415'
        ~ '60667508153710646723108461964247537490553744805318226002710216400'
        ~ '98058449752602303564003808347205314994117296573678506642140084269'
        ~ '64971032419191821212132069397691439233683747092282677387081322366'
        ~ '80086924703491586840991153098315412063566123187504305467536983230'
        ~ '82796645741762080659317726568584168183796610614496343254411170694'
        ~ '17002226578173583512598210807691019610522292638797450490192543119'
        ~ '00620561906577452416191913187533984049343976823310298465893318373'
        ~ '01580959252282920682086223033258528011926649631444131644277300323'
        ~ '77922747123306964171499455322610354751456312906688543454268697884'
        ~ '47742981777493710117614651624183616680254815296335308490849943006'
        ~ '76365480610294009469375060984558855804397048591444958444507997849'
        ~ '70455835506854087451633164641180831230797043898491905065875864258'
        ~ '10738422420591191941674182490452700288263983057950057341711487031'
        ~ '18714283418449915345670291528010448514517605530697144176136858238'
        ~ '41027876593246626899784183196203122624211773914772080048835783335'
        ~ '69204533935953254564897028558589735505751235129536540502842081022'
        ~ '78524877660357424636667314868027948605244578267362623085297826505'
        ~ '71146248465959142102781227889414481639949738818846227682448516220'
        ~ '51817076722169863265701654316919742651230041757329904473537672536'
        ~ '84579275436541282655358185804684006936771860502007054724754840080'
        ~ '55304249518544952672472613473181747421800785746934654471360369758'
        ~ '84118029408039616746946288540679172138601225419503819704538417268'
        ~ '00639882065632879283958270851091995883944829777564715202613287108'
        ~ '95261634177071516428994879535648545535531487549781340099648544986'
        ~ '35824847690590033116961303766127923464323129706628411307427046202'
        ~ '03201336835038542536031363676357521260470742531120923340283748294'
        ~ '94531047274189692872755720276152722682833767413934256526532830684'
        ~ '69997597097750005560889932685025049212884068274139881631540456490'
        ~ '35077587168007405568572402175868543905322813377070741583075626962'
        ~ '83169556874240605277264858530506113563848519659189686495963355682'
        ~ '16975437621430778665934730450164822432964891270709898076676625671'
        ~ '51726906205881554966638257382927418208227896068448822298339481667'
        ~ '09840390242835143068137672534601260072692629694686727507943461904'
        ~ '39996618979611928750519442356402644303271737341591281496056168353'
        ~ '98818856948404534231142461355992527233006488162746672352375123431'
        ~ '18934421188850850793581638489944875447563316892138696755743027379'
        ~ '53785262542329024881047181939037220666894702204258836895840939998'
        ~ '45356094886994683385257967516188215941098162491874181336472696512'
        ~ '39806775619479125579574464714278686240537505761042042671493660849'
        ~ '80238274680575982591331006919941904651906531171908926077949119217'
        ~ '94640735512963386452303567334558803331319708036545718479155043265'
        ~ '48995597058628882868666066180218822486021449999731221641381706534'
        ~ '80175510438406624412822803616648904257377640956326482825258407669'
        ~ '04560843949032529052633753231650908768133661424239830953080654966'
        ~ '18793819491200339194894940651323988166420800883955549422370967348'
        ~ '40072642705701165089075196155370186264797456381187856175457113400'
        ~ '47381076276301495330973517418065547911266093803431137853253288353'
        ~ '33520249343659791293412848549709468263290758301930726653377825593'
        ~ '14331110963848053940859283988907796210479847919686876539987477095'
        ~ '91278872747587443980677982496827827220092644994455938041460877064'
        ~ '19418104407582698056880389496546165879839046605876453418102899071'
        ~ '94293021774519976104495043196841503455514044820928933378657363052'
        ~ '83061999007774872692299860827905317169187657886090894181705799340'
        ~ '48902184415597910926768627965975839524839267348836347456516870161'
        ~ '66240642424241228961118010615682342539392180052483454723779219911'
        ~ '22859591419187749179382334001007812832650671028178139602912091472'
        ~ '01009478787525512633728842223538694900679276645116347581011938753'
        ~ '19657242121476038284774774571704578610417385747911301908583877890'
        ~ '15233434301300528279703858035981518292960030568261209195094373732'
        ~ '54541710563838870475289505639610298436413609356416325894081379815'
        ~ '11693338619797339821670761004607980096016024823096943043806956620'
        ~ '12321365014054958625061528258803302290838581247846931572032323360'
        ~ '18994694376477267218793768264318283826035645206994686302160488745'
        ~ '28424363593558622333506235945002890558581611275341783750455936126'
        ~ '13085264082805121387317749020024955273873458595640516083058305377'
        ~ '07325339715526204447054295735383611136775231699727402929416742044'
        ~ '23248113875075631319078272188864053374694213842169928862940479635'
        ~ '30515056078812636620649723125757901959887304119562622734372890051'
        ~ '65611110941117452779654827904712505819990774980638215593768855464'
        ~ '98822938985408291325129076478386322494781016753491693489288104203'
        ~ '01561028338614382737816094634133538357834076531432141715065587754'
        ~ '78202524547806573013422774706167442419689526131642741046954746214'
        ~ '83756288299771804186785084546965619150908695874251184435837306590'
        ~ '95146098045124740941137389992782249298336779601101538709612974970'
        ~ '55663016373072027507347599229437923938244274211861582361613178863'
        ~ '92553095117188421298508307238259729144142251579403883011359083331'
        ~ '65185823496722125962181250705811375949552502274727467436988713192'
        ~ '66707692991990844671612287388584575846227265733307537355728239516'
        ~ '16964175198675012681745429323738294143824814377139861906716657572'
        ~ '94580780482055951188168718807521297183263644215533678775127476694'
        ~ '07901170575098195750845635652173895441798750745238544552001335720'
        ~ '33332379895074393905312918212255259833790909463630202185353848854'
        ~ '82506289771561696386071238277172562131346054940177041358173193176'
        ~ '33701363322528191275471914434509207118488383668181742633429496118'
        ~ '70091503049165339464763717766439120798347494627397822171502090670'
        ~ '19030246976215127852195614207080646163137323651785397629209202550'
        ~ '02889620129701413796400380557349492690735351459612086747965477336'
        ~ '92958773628635660143767964038430796864138563447801328261284589184'
        ~ '89852804804884418082163942397401436290348166545811445436646003249'
        ~ '06187630395023564020445307482102413668951966442213392007574791286'
        ~ '83805175150634662569391937740283512075666260829890491877287833852'
        ~ '17852279204577184696585527879044756219266399200840930207567392536'
        ~ '37356283908298175779021532021064096173732835984940666521411981838'
        ~ '10884515459772895164572131897797907491941013148368544639616904607'
        ~ '03010759681893374121757598816512700076126278916951040631585763753'
        ~ '47874200702220510708912576123616580268068158584998526314658780866'
        ~ '16800733264676830206391697203064894405628195406190685242003053463'
        ~ '15662189132730906968735318164109451428803660599522024824888671155'
        ~ '44291047219291342483464387053685086487490991788126705656653871910'
        ~ '49721820042371492740164460943459845392536706132210616533085662021'
        ~ '18896823400575267548610147699368873820958455221157192347968688816'
        ~ '08536316158628801503959494185294892270744108282071693033878180849'
        ~ '36204018255222271010985653444817207470756019245915599431072949578'
        ~ '19787859057894005254012286751714251118435643718405356302418122547'
        ~ '32660933027103979680910649392727226830354104676325913552796838377'
        ~ '05019855234621222858410557119921731717969804339317707750755627056'
        ~ '04783177984444763756025463703336924711422081551997369137197516324'
        ~ '13027487121998634045482485245701185533426752647159783107312456634'
        ~ '29805221455494156252724028915333354349341217862037007260315279870'
        ~ '77187249123449447714790952073476138542548531155277330103034247683'
        ~ '58654960937223240071545181297326920810584240905577256458036814622'
        ~ '34493189708138897143299831347617799679712453782310703739151473878'
        ~ '69211918756670031932128189680332269659445928621060743882741691946'
        ~ '51622676325406650708810710303941788605648937698167341590259251946'
        ~ '11823642945652669372203155504700213598846292758012527715422016629'
        ~ '95486313032491231102962792372389976641680349714122652793190763632'
        ~ '61368141455163766565598397884893817330826687799019628869322965973'
        ~ '79951931621187215455287394170243669885593888793316744533363119541'
        ~ '51840408828381519342123412282003095031334105070476015998798547252'
        ~ '91906652224793197154403317948368373732208218857733416238564413807'
        ~ '00541913530245943913502554531886454796252260251762928374330465102'
        ~ '36105758351455073944333961021622967546141578112719700173861149427'
        ~ '95014112532806212547758105129720884652631580948066336876701473107'
        ~ '33540717710876615935856814098212967730759197382973441445256688770'
        ~ '85532457088895832099382343210271822411476373279135756861542125284'
        ~ '96579033350931527769255058456440105521926445053120737562877449981'
        ~ '63646332835816140330175813967359427327690448920361880386754955751'
        ~ '80689005853292720149392350052584514670698262854825788326739873522'
        ~ '04572282392902071448222198855871028969919358730742778151597576207'
        ~ '64023951243860202032596596250212578349957710085626386118233813318'
        ~ '50901468657706401067627861758377277289589274603940393033727187385'
        ~ '05369129571267150668966884938808851429436099620129667590792250822'
        ~ '75313812849851526902931700263136328942095797577959327635531162066'
        ~ '75348865131732387243874806351331451264488996758982881292548007642'
        ~ '51865864902411111273013571971813816025831785069322440079986566353'
        ~ '71544088454866393181708395735780799059730839094881804060935959190'
        ~ '90747396090441015051632174968141210076571917748376735575100073361'
        ~ '69223865374290794578032000423374528075661530429290144957806296341'
        ~ '38383551783599764708851349004856973697965238695845994595592090709'
        ~ '05895689145114141268450546211794502661175016692826025095077077821'
        ~ '19504326173832235624376017767993627960993689751913949650333585071'
        ~ '55418436456852616674243688920371037495328425927131610537834980740'
        ~ '73915863381796765842525803673720646935124865223848134166380806150'
        ~ '57048290598906964519364400185971204257230073164100099169875242603'
        ~ '77362177763430621616744884930810929901009517974541564251204822086'
        ~ '71458684925513244426677712786372821133153622430109182439124338021'
        ~ '40462422233491535595168908162884879899882736304453724321742802157'
        ~ '55777967021666317047969728172483392841015642274507271779269399929'
        ~ '74030807277039501358154514249404902653610582540937311465310494338'
        ~ '24843797186069372144446008267980024712294894057618538922034256083'
        ~ '02697052876621377373594394224114707074072902725461307358541745691'
        ~ '41944648762435768239706570318416846754073346634629367398362000404'
        ~ '14007140542776324801327422026853936988697876070095900486846506267'
        ~ '71363070979821006557285101306601010780633743344773073478653881742'
        ~ '68123074376606664331277535646657860371519292276844045827328324380'
        ~ '82128412187761320424604649008010547314267492608269221556374054862'
        ~ '41717031027919996942645620955619816454547662045022411449404749349'
        ~ '83220680719135276798674781345820385957041346617793722853494003163'
        ~ '15995440936840895725334387029867178297703733328068017646395020900'
        ~ '23941931499115009105276821119510999063166150311585582835582607179'
        ~ '41005252858361136996130344279017381178741206128818206202326384986'
        ~ '15156564512300477929675636183457681050433417695430675380411139285'
        ~ '53792529241347339481050532025708728186307291158911335942014761872'
        ~ '66429156403637192760230628384065042544174233546454998705531872688'
        ~ '79264241021473636986254637471597443549434438997300517425251108773'
        ~ '57886390946812096673428152585919924857640488055071329814299359911'
        ~ '46323991911395992675257635900744657281019180584180734222773472139'
        ~ '77232182317717169164001088261125490933611867805757223910181861685'
        ~ '49108500885272274374212086524852372456248697662245384819298671129'
        ~ '45294551549703058591930719849710541418163696897613112674402700964'
        ~ '86675459345670599369954645005589216280479763656861333165639073957'
        ~ '03272034389175415267500915011198856872708848195531676931681272892'
        ~ '14303137681801644547736751835349785792427646335416243360112596025'
        ~ '21095016122641103460834656482355979342740568688492244587454937767'
        ~ '52120324703803035491157544831295275891939893680876327685438769557'
        ~ '69488142284431199859570072752139317683783177033913042306095899913'
        ~ '73146845690104220951619670705064202567338734461156552761759927271'
        ~ '51877660010238944760539789516945708802728736225121076224091810066'
        ~ '70088347473760515628553394356584375627124124445765166306408593950'
        ~ '79475509204639322452025354636344447917556617259621871992791865754'
        ~ '90857852950012840229035061514937310107009446151011613712423761426'
        ~ '72254173205595920278212932572594714641722497732131638184532655527'
        ~ '96042705418714962365852524586489332541450626423378856514646706042'
        ~ '98564781968461593663288954299780722542264790400616019751975007460'
        ~ '54515006029180663827149701611098795133663377137843441619405312144'
        ~ '52918551801365755586676150193730296919320761200092550650815832755'
        ~ '08499340768797252369987023567931026804136745718956641431852679054'
        ~ '71716996299036301554564509004480278905570196832831363071899769915'
        ~ '31666792089587685722906009154729196363816735966739599757103260155'
        ~ '71920237348580521128117458610065152598883843114511894880552129145'
        ~ '77569914657753004138471712457796504817585639507289533753975582208'
        ~ '7777506072339445587895905719156736', 'huge Ints stringify correctly';
}

# https://github.com/rakudo/rakudo/issues/3419
{
    dies-ok { Int.new(Int) }, 'does Int.new(Int) die?';
}

# vim: expandtab shiftwidth=4
