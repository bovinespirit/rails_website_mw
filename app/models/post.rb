class Post < ActiveRecord::Base
  has_many :redirections, :as => :targetable, :dependent => :nullify
  has_one :photo_set, :as => :page, :dependent => :nullify

  acts_as_versioned :if_changed => [:body, :title]
  acts_as_taggable

  validates_length_of :title, :in => 5...255

  cattr_reader :per_page
  @@per_page = 7

  def to_param
    "#{id}-#{title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=_+]+/, '-').gsub(/[\-]{2,}/, '-')}"
  end
  
  def to_liquid
    self
  end
  
  class << self
    def find_by_date_and_id(params, show_all = false, oldest_first = true)
      opts = options_for_date_and_id(params, show_all)
      opts.merge!({ :order => (oldest_first) ? 'created_at' : 'created_at DESC' })
      find(:all, opts)
    end
  
    def count_by_date_and_id(params, show_all = false)
      count(options_for_date_and_id(params, show_all))
    end
    
    def paginate_by_date(params, show_all = false, oldest_first = true)
      opts = options_for_date_and_id(params, show_all)
      opts.merge!({ :page => params[:page] })
      opts.merge!({ :order => (oldest_first) ? 'created_at' : 'created_at DESC' })
      paginate(:all, opts)
    end
    
    def find_recent(limit = 5, options = {})
      opts = {:limit => limit, :order => 'updated_at DESC'}
      opts.merge!(:conditions => {:staging => false}.merge(options.delete(:conditions) || {}))
      find(:all, opts.merge(options))
    end
  end
  
  # For Atom
  def guid
    "tag:matthewwest.co.uk,#{created_at.strftime('%Y-%m-%d')}:#{id}"
  end
  
  protected
  def self.options_for_date_and_id(params, show_all)
    time = Time.utc(params[:year] || 1, params[:month] || 1, params[:day] || 1)
    conditions = {}
    opt = {}
    if params[:day]
      conditions.merge!(:created_at => time.beginning_of_day .. (time + 1.day).beginning_of_day)
    elsif params[:month]
      conditions.merge!(:created_at => time.beginning_of_month .. (time + 1.month).beginning_of_month)
    elsif params[:year]
      conditions.merge!(:created_at => time.beginning_of_year .. (time + 1.year).beginning_of_year)
    end
    conditions.merge!(:id => params[:id].to_i) if params[:id]
    conditions.merge!(:staging => false) unless show_all
    opt.merge!(:conditions => conditions) unless conditions.empty?
    opt
  end
end
