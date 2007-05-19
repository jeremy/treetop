require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
  end
  
  it "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should equal(@grammar)
  end
  
  it "has a string representation" do
    @nonterminal.to_s.should == 'foo'
  end
  
  it "propagates parsing to the parsing expression to which it refers" do
    referrent_expression = mock("Associated parsing expression")
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(referrent_expression)
    parse_result_of_referrent = parse_success
    referrent_expression.stub!(:parse_at).and_return(parse_result_of_referrent)

    result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_success
    result == parse_result_of_referrent
  end
end

describe "The result of parsing a nonterminal symbol that refers to an expression that fails to parse, with a nested failure" do
  before(:each) do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
    
    @referenced_expression = mock('referenced expression')
    @referenced_expression_result = parse_failure_at_with_nested_failure_at(0, 5)
    @referenced_expression.stub!(:parse_at).and_return(@referenced_expression_result)
    
    @grammar.stub!(:get_parsing_expression).and_return(@referenced_expression)
    
    @result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  it "propagates the nested failure on its result" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 1
    nested_failures.first.should == @referenced_expression_result.nested_failures.first
  end
end