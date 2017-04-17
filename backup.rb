#!/usr/bin/env ruby

# backup Root Verzeichnis
BASE_PATH = File.expand_path(File.dirname(__FILE__))

# lib Verzeichnis in den Load Path packen
$: <<  "#{BASE_PATH}/lib"

# https://github.com/phortx/ferrets-on-fire
require '_'

# Allgemeine Start Klasse
require 'start'

info "**** Starte Backup #{DateTime.now.strftime('%d.%m.%Y')} ****"

Start.start

info '**** Beende Backup ****'
