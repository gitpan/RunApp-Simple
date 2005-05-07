use inc::Module::Install;

name            ('RunApp-Simple');
abstract        ('RunApp in a Simple way');
author          ('Kang-min Liu <gugod@gugod.org>');
license         ('perl');
version_from    ('lib/RunApp/Simple.pm');

requires(qw(
	Spiffy 0
	RunApp 0
	YAML 0
));

build_requires  ('Test::More');
install_script  ('bin/runapp');

&WriteAll;

