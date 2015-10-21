# Flot::Rails::Plus

A gem to provide an Object Oriented interface to the flot javascript graphics library.  All javascript resides in assets. A feature is available that allows the data values to be requested using ajax, with optional refresh at specified intervals.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flot-rails-plus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flot-rails-plus

## Usage

Note this should be considered work in progress, but does appear to be functional.

### Definitions
  
#### ChartLine

A `ChartLine` is a line which is to appear on a chart (or several charts).  Construct using:
```ruby
chart_line = ChartLine.new( tag, colour, value_method, options={} )
```
Where `tag` is a string used to identify the line, `colour` is the required colour, `value_method` is a symbol representing the method that is to be used to fetch the individual values for the line and 'options' allows any of the line options available in flot to be specified.

Examples
```ruby
chart_line1 = ChartLine.new( "t1", "#ff0000", :temperature_1 )
chart_line2 = ChartLine.new( "pressure", "#00ff00", :pressure, lines: {show: false}, bars: => {show: true}, yaxis: 2 )
```

#### Chart

A `Chart` represents a chart to be drawn in a div in the view.  Construct using:
```ruby
chart = Chart.new( div, lines, options = {} )
```
Where string `div` is the id of the div to contain the chart, `lines` is an array of ChartLines to be shown on the charts and `options` allows for flot options for the chart to be specified.

Examples
```ruby
chart1 = Chart.new( "chart1", [chart_line1], yaxis: {min: 0, max: 10} )
chart2 = Chart.new( "chart2", [chart_line1,chart_line2], yaxis: {min: 0, max: 10}, y2axis: {min: 900, max: 1100} )
```

####ChartSet

A `ChartSet` is a set of charts which appear on the same view, have the same x axis and whose values all come from the same collection.  Often the collection will be the result of an ActiveRecord query. The value_method specified for a line may be a field from the database or may be any method on the ActiveRecord derived class which returns a value to be plotted.

Construct using:
```ruby
chart_set = new ChartSet( charts, collection, xaxis )
```
Where `charts` is an array of charts, `collection` is generally an ActiveRecord query and `xaxis` is a hash defining the method to be used to get the xaxis value, and other flot xaxis options.

Examples
```ruby
chart_set1 = new ChartSet( [chart1, chart2], Values.all, {method: x} )
chart_set2 = new ChartSet( [chart3, chart4], Samples.where(...), {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc) } )
```

If no range is specified for the x axis then the range will be taken from the first and last items in the collection.

### How to use the gem

To app/assets/javascripts/application.js add
```javascript
//= require flot_rails_plus`
```

In application_controller.rb insert at top of class
```ruby
  include FlotViewHelpers
```

In the controller set up the collection(s) of records to be plotted, one for each ChartSet.  
In the view define the divs for the charts.  
In the view header (in fact probably in a view helper) define the `ChartSets` and call:
```ruby
setup_flot_view( chart_sets )
```
Where chart_sets is an array of ChartSets.  Often this will only contain a single ChartSet.

That's it.

### Using AJAX

To use AJAX to fetch the data points, procede as above, but in the construction of the ChartSets 
leave the collection as nil and in the call to `setup_flot_view` pass the url to be used to fetch
the data and optionally a refresh time (seconds) to specify automatic refresh of the data every 
refresh seconds. For example
```ruby
setup_flot_view( chart_sets, url: "/samples/index.json", refresh: 60 )
```

Then in the controller for the json call prepare collection (usually an ActiveRecord query, as above)
and provide a jbuilder file (in this case views/samples/index.json.jbuilder) which prepares the ChartSets 
and calls `setup_flot_view` passing the ChartSets and the json builder.
```ruby
setup_flot_view( chart_sets, json: json )
```
### Examples

The dummy app included with the gem (in test/dummy) includes usage examples. The app may be run by
```
cd test/dummy
rake db:migrate
rake db:seed
rails s
```

### Compatibility

The gem is compatible with rails 3.2 with ruby 1.8.7 and rails 4 with any appropriate ruby version.

If using ruby 1.8.7 then in Gemfile include
```ruby
gem 'gon', '4.1.1'    # held back for ruby 1.8.7 compat.
```
To use ajax with ruby 1.8.7 also include
```ruby
gem 'jbuilder', '1.5.3'   # held back for ruby 1.8.7 compat.
```

The gem is currently not compatible with turbolinks.

As the gem gon is used to pass data to the view, gon cannot be used for other things on the same view.

### Testing

A number of test helpers are available in lib/flot/rails/plus/test_helper.rb  
To use test helpers, in your test_helper.rb add
```ruby
require 'flot/rails/plus/test_helper'
```
Then the methods there may be called to check that you have setup the charts as you intend.  See 
test/controllers/plot_values_controller_test for examples of how methods such as fetch_flot_chart_sets and
fetch_flot_chart_by_div may be used.

These provided tests may be run from the top level of the gem using
```
rake test
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/flot-rails-plus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
