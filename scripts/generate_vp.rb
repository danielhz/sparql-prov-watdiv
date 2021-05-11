#!/usr/bin/env ruby

require 'sequel'
require 'pry'

DB_DIR = '/home/ubuntu/images'
DB_NAME = 'watdiv-100M-vp.db'

## This is done once
# system "cp #{DB_DIR}/watdiv-100M-psog.db #{DB_DIR}/#{DB_NAME}"

db = Sequel.connect("sqlite:#{DB_DIR}/#{DB_NAME}")

def url_to_table_name(url)
  prefixes = {
    dc: 'http://purl.org/dc/terms/',
    foaf: 'http://xmlns.com/foaf/',
    gr: 'http://purl.org/goodrelations/',
    gn: 'http://www.geonames.org/ontology#',
    mo: 'http://purl.org/ontology/mo/',
    og: 'http://ogp.me/ns#',
    rev: 'http://purl.org/stuff/rev#',
    rdf: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    rdfs: 'http://www.w3.org/2000/01/rdf-schema#',
    sorg: 'http://schema.org/',
    wsdbm: 'http://db.uwaterloo.ca/~galuc/wsdbm/'
  }

  table_name = nil

  prefixes.each do |name, prefix|
    if url.include? prefix
      table_name = url.sub(prefix, "#{name}__").
                     strip.sub(/^</, '').sub(/>$/, '')
      not_replaced = false
    end
  end

  raise 'unknown prefix' if table_name.nil?
  table_name
end

db.transaction do

  db[:quads].distinct.select(:predicate).each do |row|

    puts row[:predicate]
    table_name =  url_to_table_name(row[:predicate])
    puts table_name

    db.run("CREATE TABLE #{table_name} (subject text, object text, PRIMARY KEY(subject, object))")
    db.run("INSERT INTO #{table_name} (subject, object) SELECT subject, object FROM quads " +
           "WHERE predicate = '#{row[:predicate]}'")
    puts db[:"#{table_name}"].count
    db.run("CREATE INDEX idx_#{table_name}_os ON #{table_name} (object, subject)")
  end

end
