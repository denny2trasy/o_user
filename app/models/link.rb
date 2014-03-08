class Link < ActiveRecord::Base
  # globalize :name, :description
  has_many :link_group_links, :dependent => :destroy

  def url
    return path if path =~ /^(http|https):\/\//
    "/" + ("#{app}/#{path}".split("/") - [""]).join("/")
  end
end
