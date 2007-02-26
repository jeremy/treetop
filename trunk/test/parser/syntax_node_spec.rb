require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of SyntaxNode" do
  setup do
    @failure = mock("parse failure")
    @node = SyntaxNode.new(mock("input"), mock("interval"), @failure)
  end
  
  specify "should be success" do
    @node.should_be_success
  end
  
  specify "should not be failure" do
    @node.should_not_be_failure
  end
  
  specify "can propagate an embedded parse failure" do
    @node.embedded_failure.should == @failure
  end

end