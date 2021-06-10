#!/usr/bin/env ruby

require 'json'
require 'fileutils'

class SQLGenerator
  def initialize(query)
    @query = query
  end

  def triples
    if @triples.nil?
      @triples = @query['where'][0]['triples']
    end
    @triples
  end
  
  def attributes
    if @attributes.nil?
      @attributes = {}
      triples.each_with_index do |triple, index|
        %w{subject predicate object}.each do |attr|
          if triple[attr]['termType'] == 'Variable'
            variable = triple[attr]['value']
            @attributes[variable] = [] if @attributes[variable].nil?
            @attributes[variable] << "t#{index}.#{attr}"
          end
        end
      end
    end
    @attributes
  end

  def variable_identities
    identities = []
    attributes.each_value do |attribute_set|
      identities += attribute_set.combination(2).to_a
    end
    identities
  end

  def constant_identities
    identities = []
    triples.each_with_index do |triple, index|
        %w{subject predicate object}.each do |attr|
          if triple[attr]['termType'] == 'NamedNode'
            identities << ["t#{index}.#{attr}",
                           "'<#{triple[attr]['value']}>'"]
          end
        end
      end
    identities
  end

  def identities_formula
    identities = constant_identities + variable_identities
    identities.map do |pair|
      "#{pair[0]} = #{pair[1]}"
      end.join(" AND\n  ")
  end

  def select_attributes
    @query['variables'].map do |var|
      var_name = var['value']
      attr_name = attributes[var_name].first
      "#{attr_name} AS #{var_name}"
    end
  end

  def from_tables
    (0...triples.size).map do |i|
      "quads as t#{i}"
    end
  end

  def to_s
    <<~SQL
      SELECT
        #{select_attributes.join(",\n  ")}
      FROM
        #{from_tables.join(",\n  ")}
      WHERE
        #{identities_formula}
    SQL
  end
end

Dir['queries/100M/C3/namedgraphs/B/*.sparql'].sort.each do |query|
  puts query
  sql = SQLGenerator.new(JSON.parse(`sparqljs #{query}`)).to_s
  outfile_b = query.sub(/.sparql/, '.sql').sub('/namedgraphs/B/', '/quads/B/')
  outfile_p = query.sub(/.sparql/, '.sql').sub('/namedgraphs/B/', '/quads/P/')
  FileUtils.mkdir_p(File.dirname(outfile_b))
  FileUtils.mkdir_p(File.dirname(outfile_p))
  File.open(outfile_b, 'w') { |file| file.puts "#{sql};" }
  File.open(outfile_p, 'w') { |file| file.puts "PROVENANCE OF (\n#{sql});" }
end
