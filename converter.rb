#!/usr/bin/env ruby
require "Hunspell" # inject Hunspell class to Ruby namespace
require 'csv'

sp = Hunspell.new("Papiamento.aff", "Papiamento.dic")
src_dir = "source.csv"
dst_dir = "out.csv"
puts " Reading data from  : #{src_dir}"
puts " Writing data to    : #{dst_dir}"
#create a new file
csv_out = File.open(dst_dir, 'wb')
#read from existing file
CSV.foreach(src_dir , :headers => true) do |row|
  if sp.spellcheck(row['pap_cw'])
    csv_out << row
  elsif sp.suggest(row['pap_cw']).count > 0
    row[0] = sp.suggest(row['pap_cw']).first
    # This items coming form automated suggestions needs to be checked
    row[1] =  'check this'
    csv_out << row
  else
    row[0] = 'x'
    csv_out << row
  end
end

# close the file
csv_out.close
