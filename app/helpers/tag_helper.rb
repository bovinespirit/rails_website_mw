module TagHelper
  def show_tags(taggable)
    ar = taggable.tag_list.collect { |tag_name| link_to tag_name, tag_page_url(:tag => tag_name), :rel => 'tag' }
    return ar.join(', ')
  end

  def tag_cloud_links
    tags = Tag.counts
    return if tags.nil? or tags.size == 0
    max_count = tags.sort_by(&:count).last.count.to_f
    max = Math.sqrt(max_count)
    str = ""
    tags.each do |tag|
      unless tag.count == 0
        height = ((Math.sqrt(tag.count) / max) * 125).to_i + 25
        str << link_to(tag.name, tag_page_url(:tag => tag.name), :style => "font-size: #{height}%;")
        str << " "
      end
    end
    return str
  end
end
