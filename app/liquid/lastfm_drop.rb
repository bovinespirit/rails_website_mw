# TODO: More information, total tracks etc
Comatose.define_drop "lastfm" do 
  def overall
    LastfmChart.get_overall
  end
  
  def recent_weekly
    LastfmChart.get_recent_weekly
  end
end

module LastfmFilter
  def lastfm_list(input)
    begin
      if input.is_a?(LastfmChart)
        str = ""
        if input.overall
          str << %Q|<dd class="minor">#{input.from.strftime('%d/%m/%Y')}</dd>|
        else
          str << "<dd class=\"minor\">#{input.from.strftime('%a %d')}"
          str << " - #{(input.from + 1.week).strftime('%a %d')}"
          str << "</dd>"
        end
        input.items.each do |item|
          str << "<dd>#{item.position} : #{item.name}</dd>"
        end
      else
        str = "Error, input is not a LastfmChart"
      end
      str
    rescue
      "<pre>#{$!}</pre>"
    end
  end
end

Liquid::Template.register_filter(LastfmFilter)
