# == Schema Information
# Schema version: 29
#
# Table name: lastfm_charts
#
#  id          :integer       not null, primary key
#  from        :datetime      
#  overall     :boolean       
#  most_recent :boolean       
#

require "rexml/document"

# TODO: Links, formating, micro formats, etc
# TODO: Add archive charts
# TODO: Download new charts weekly, using cron?
# TODO: Other charts?
# TODO: Other data?

class LastfmChart < ActiveRecord::Base
  DATA_TYPES = {
    :top_artists => {:page => 'topartists.xml', :indexname => 'rank', 
                      :index => :int},
    :weekly_artists => {:page => 'weeklyartistchart.xml', :indexname => 'chartposition', 
                         :index => :int}
  }
  DAY_SECS = 24 * 60 * 60
  WEEK_SECS = DAY_SECS * 7
  USER = ''

  has_many :items, :class_name => 'LastfmItem', :foreign_key => 'lastfm_chart_id', :dependent => :destroy

  @@lastlog = nil
  cattr_accessor :lastlog
  
  # Loads an artist chart, either from the database, or from last.fm
  # A time loads a weekly chart for the week containing that chart
  def self.get_overall()
    chart = LastfmChart.find_by_overall(true)
    unless chart
      chart = LastfmChart.new do |ch|
        ch.overall = true
        ch.most_recent = true
        ch.from = 1.month.ago
      end
    end
    if (Time.now - chart.from) > 2.weeks
      lastlog.info("Reading new overall chart") if lastlog
      if chart.items.count > 0
        chart.items.each { |item| item.destroy }
        chart.reload
      end
      self.load_data(:top_artists) do |pos, name|
        chart.items.build( :position => pos, :name => name)
      end
      chart.from = Time.now
      chart.save!
    end
    return chart
  end
  
  def self.get_recent_weekly()
    chart = LastfmChart.find_by_overall_and_most_recent(false, true)
    @reloaded = false
    unless chart 
      chart = LastfmChart.new do |ch|
        ch.overall = false
        ch.most_recent = true
        ch.from = 1.month.ago
      end
    end
    if (Time.now - chart.from) > 2.weeks
      lastlog.info("Reading new recent weekly chart") if lastlog
      if chart.items.count > 0
        chart.items.each { |item| item.destroy }
        chart.reload
      end
      chart.from = self.load_data(:weekly_artists) do |pos, name|
        chart.items.build(:position => pos, :name => name)
      end
      chart.save!
    end
    return chart
  end
  
  def to_liquid
    self
  end

  protected
  # Read data from last.fm
  # options:
  #   :limit = max. number of items in chart
  #   :time = time in the week that data is for 
  def self.load_data(data_type, options = {})
    options[:limit] ||= 10
    url = "http://ws.audioscrobbler.com/1.0/user/#{USER}/#{DATA_TYPES[data_type][:page]}#{make_time_query(options[:time])}"
    lastlog.info("URL: #{url}")
    res = Net::HTTP.get_response(URI.parse(url))
    lastlog.info(res.to_s) if lastlog
    data = parse_chart(res.body, DATA_TYPES[data_type][:indexname])
    lastlog.info(data.to_s) if lastlog
    data[:chart][1..options[:limit]].each_index { |i| yield i+1, data[:chart][i+1] }
    data[:from]
  end
  
  def self.parse_chart(body, index_name)
    doc = REXML::Document.new(body)
    data = { :chart => [], :from => Time.now }
    doc.root.elements.each do |element|
      i = element.elements[index_name].text.to_i
      while !data[:chart][i].nil?
        i += 1
      end
      data[:chart][i] = element.elements['name'].text
    end
    fr = doc.root.attributes["from"].to_i
    data[:from] = Time.at(fr) if fr
    data 
  end
  
  # Make time query string
  def self.make_time_query(time)
    from = start(time)
    to = from + WEEK_SECS if from
    return (from != nil) ? "?from=#{from.to_i}&to=#{to.to_i}" : ""
  end
  
  # Return midnight on the sunday before this day
  def self.start(time)
    return nil if time.nil?
    st = time - time.wday * DAY_SECS
    return Time.utc(st.year, st.month, st.day, 12, 0, 0)
  end
end
