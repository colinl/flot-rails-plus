require 'test_helper'

class PlotValuesControllerTest < ActionController::TestCase
  setup do
    @plot_values = plot_values(:one)
  end
  
  test "index should default to graph page" do
    get :index
    assert_response :success
    # should have the graph div
    assert_select "div#flot_chart_div"
    # and should not show table
    assert_select "table", 0
  end
  
  test "index should contain chart for correct div" do
    get :index
    chart = fetch_flot_chart_by_div "flot_chart_div"
    assert_not_nil chart
  end
  
  test "index chart should contain correct lines" do
    get :index
    chart = fetch_flot_chart_by_div( "flot_chart_div" )
    # should be two lines, systolic and diastolic
    lines = chart["lines"]
    assert_equal 2, lines.size
    assert_equal 1, lines.select { |l| l["tag"] == "v1" }.length
    assert_equal 1, lines.select { |l| l["tag"] == "v2" }.length
  end
  
  test "index chart should contain correct chart data" do
    get :index
    # only one chart_set so we can get it
    chart_set = fetch_flot_chart_sets[0]
    samples = chart_set["samples"]
    assert_operator samples.length, :>, 0
    # check the third sample
    sample = samples[2]
    assert_in_delta sample["v1"], -0.5, 0.001
    assert_in_delta sample["v2"], -0.3, 0.001
    assert_equal "2015-09-17 09:27:53".to_time(:utc), sample["timestamp"]
    # check xaxis range
    assert_equal "2015-09-15 09:27:53".to_time(:utc).to_i*1000, chart_set["xaxis"]["min"]
    assert_equal "2015-09-18 09:27:53".to_time(:utc).to_i*1000, chart_set["xaxis"]["max"]
  end
    
  test "index chart should contain xaxis method" do
    get :index
    assert_equal "timestamp", fetch_flot_chart_sets[0]["xaxis"]["method"]
  end
  
  test "index with no data should not fail" do
    PlotValue.delete_all
    get :index
    assert_response :success
  end
  
  test "page2 should contain chart for correct div" do
    get :page2
    chart = fetch_flot_chart_by_div "flot_chart_div2"
    assert_not_nil chart
  end
  
  test "page2 should contain correct chart data" do
    get :page2
    chart_set = fetch_flot_chart_sets[0]
    samples = chart_set["samples"]
    assert_operator samples.length, :>, 0
    # check the third sample
    sample = samples[2]
    assert_in_delta sample["v1"], -0.5, 0.001
    assert_in_delta sample["v2"], -0.3, 0.001
    assert_equal 2, sample["x"]
    assert_equal 0, chart_set["xaxis"]["min"]
    assert_equal 3, chart_set["xaxis"]["max"]
  end
  
  test "page3 with url includes url in json" do
    get :page3
    url = fetch_flot_callback_url
    assert_equal "/plot_values/page3.json", url
  end
  
  test "page3 with url includes refresh in json" do
    get :page3
    url = fetch_flot_refresh
    assert_equal "15", url
  end
  
  test "page3 has two charts" do
    get :page3
    assert_not_nil fetch_flot_chart_by_div "flot_chart_div3_1"
    assert_not_nil fetch_flot_chart_by_div "flot_chart_div3_2"
  end
  
  test "page3 json returns valid json with plot_data" do
    get :page3, format: 'json'
    data = JSON.parse @response.body
    chart_sets = data["chart_sets"]
    samples = chart_sets[0]["samples"]
    assert_operator samples.length, :>, 0
    # check the third sample
    sample = samples[2]
    assert_in_delta sample["v1"], -0.5, 0.001
    assert_in_delta sample["v2"], -0.3, 0.001
    assert_equal 2, sample["x"]
    assert_equal 0, chart_sets[0]["xaxis"]["min"]
    assert_equal 3, chart_sets[0]["xaxis"]["max"]
  end
  
  test "page3 json returns samples empty if no data" do
    PlotValue.delete_all
    get :page3, format: 'json'
    data = JSON.parse @response.body
    chart_sets = data["chart_sets"]
    samples = chart_sets[0]["samples"]
    assert samples.empty?
  end
  
  test "page4 preset xaxis shows correct range" do
    get :page4
    chart_set = fetch_flot_chart_sets[0]
    assert_equal -10, chart_set["xaxis"]["min"]
    assert_equal 10, chart_set["xaxis"]["max"]
  end
  
  test "page5 preset xaxis shows correct time range" do
    get :page5
    chart_set = fetch_flot_chart_sets[0]
    min = chart_set["xaxis"]["min"]
    max = chart_set["xaxis"]["max"]
    assert_equal "2015-09-15 08:00:00".to_time(:utc).to_i*1000, min,
      "xaxis min is #{Time.at(min/1000)}"
    assert_equal "2015-09-18 10:00:00".to_time(:utc).to_i*1000, max,
      "xaxis max is #{Time.at(max/1000)}"
  end
  
  test "page6 shows two chart sets" do
    get :page6
    chart_sets = fetch_flot_chart_sets
    assert_equal 2,chart_sets.length
    samples_0 = chart_sets[0]["samples"]
    assert_operator samples_0.length, :>, 0
    samples_1 = chart_sets[1]["samples"]
    assert_operator samples_1.length, :>, 0
  end
  
  test "page7 json returns data for two chart_sets" do
    get :page7, format: 'json'
    data = JSON.parse @response.body
    chart_sets = data["chart_sets"]
    assert_equal 2, chart_sets.length
  end
  
  test "exception if no xaxis passed" do
    exception = assert_raises(Exception) {get :index, :option => "no_xaxis"}
    assert_equal "Flot-rails-plus error: xaxis is not a hash", exception.message
  end
  
  test "exception if no xaxis method passed" do
    exception = assert_raises(Exception) {get :index, :option => "no_xaxis_method"}
    assert_equal "Flot-rails-plus error: xaxis[:method] is nil", exception.message
  end
    
end
