#!/usr/bin/env ruby

class Reifier
  def parse_triple(string)
    str = string.sub(/.\s+$/, '').strip

    subject_end = str.index(/\s+/)
    subject = str[0, subject_end]
    
    str = str[subject_end, str.size].strip
    
    predicate_end = str.index(/\s+/)
    predicate = str[0, predicate_end]
    
    object = str[predicate_end, str.size].strip

    [subject, predicate, object]
  end
  
  def statement_url(statement_id)
    "<http://example.org/statement/#{statement_id}>"
  end
end

class NamedGraphReifier < Reifier
  def reify(subject, predicate, object, statement_id)
    statement = statement_url(statement_id)
    <<~RDF
      #{subject} #{predicate} #{object} #{statement} .
    RDF
  end
end

class RDFReifier < Reifier
  @@rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
  @@rdf_subject = "<#{@@rdf}subject>"
  @@rdf_predicate = "<#{@@rdf}predicate>"
  @@rdf_object = "<#{@@rdf}object>"
  
  def reify(subject, predicate, object, statement_id)
    statement = statement_url(statement_id)
    <<~RDF
      #{statement} #{@@rdf_subject} #{subject} .
      #{statement} #{@@rdf_predicate} #{predicate} .
      #{statement} #{@@rdf_object} #{object} .
    RDF
  end
end

class WikidataReifier < Reifier
  def predicate_prefix(predicate, prefix)
    predicate.
      sub(/^<http:\/\//, "<#{prefix}").
      sub(/^<https:\/\//, "<#{prefix}")
  end
  
  def reify(subject, predicate, object, statement_id)
    statement = statement_url(statement_id)
    predicate_p = predicate_prefix(predicate, 'http://example.org/p/')
    predicate_ps = predicate_prefix(predicate, 'http://example.org/ps/')
    <<~RDF
      #{subject} #{predicate_p} #{statement} .
      #{statement} #{predicate_ps} #{object} .
    RDF
  end
end

case ARGV[0]
when 'namedgraphs'
  reifier = NamedGraphReifier.new
when 'rdf'
  reifier = RDFReifier.new
when 'wikidata'
  reifier = WikidataReifier.new
else
  raise "Unsuported reification scheme #{ARGV[0]}"
end

statement_id = 0
while str = STDIN.gets
  statement_id += 1
  triple = reifier.parse_triple(str)
  puts reifier.reify(*triple, statement_id)
end
