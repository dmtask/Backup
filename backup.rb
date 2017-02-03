#!/usr/bin/env ruby

# backup Root Verzeichnis
BASE_PATH = File.expand_path(File.dirname(__FILE__))

# lib Verzeichnis in den Load Path packen
$: <<  "#{BASE_PATH}/lib"

require 'start'

Start.copy_data_to_tmp

# TODO: Andere Methoden...
