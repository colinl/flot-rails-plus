require 'test_helper'

class ChartLineTest < ActiveSupport::TestCase

  def test_constructor_should_setup_attributes
    line = ChartLine.new( "tag", "#0000c3", :t_internal, {:yaxis => 2, :zaxis => 7})
    assert_equal "tag", line.tag
    assert_equal "#0000c3", line.color
    assert_equal :t_internal, line.value_method
    assert_equal 2, line.options[:yaxis]
    assert_equal 7, line.options[:zaxis]
  end
  
  def test_options_defaults_to_empty
    line = ChartLine.new( "tag", "#0000c3", :t_internal )
    assert_equal 0, line.options.keys.length
  end
  
  def test_value_methods_returns_array_of_methods
    lines = [ ChartLine.new( "t1", "#000000", :t_internal ),
      ChartLine.new( "t2", "#ffffff", :t_external ),
      ChartLine.new( "t3", "#0f0f0f", :rain_total ) ]
    methods = ChartLine.value_methods( lines )
    assert_equal 3, methods.size
    assert methods.include? :t_internal
    assert methods.include? :t_external
    assert methods.include? :rain_total
  end

  def test_as_hash_returns_tag_colour_and_method_as_hash_if_no_yaxis_supplied
    line = ChartLine.new( "tag", "#0000c3", :t_internal )
    hash = line.as_hash
    assert_equal "tag", hash[:tag]
    assert_equal "#0000c3", hash[:color]
    assert_equal :t_internal, hash[:value_method]
    assert_equal 0, hash[:options].keys.length
    # check four keys
    assert_equal 4, hash.keys.length
  end
  
  def test_as_hash_returns_tag_colour_yaxis_and_method_as_hash_if_yaxis_supplied
    line = ChartLine.new( "tag", "#0000c3", :t_internal, :yaxis => 2 )
    hash = line.as_hash
    assert_equal "tag", hash[:tag]
    assert_equal "#0000c3", hash[:color]
    assert_equal :t_internal, hash[:value_method]
    assert_equal 2, hash[:options][:yaxis]
    # check four keys
    assert_equal 4, hash.keys.length
   end
  
end
