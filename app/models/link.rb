class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def is_gist_url?
    url.to_s =~ %r{https://gist.github.com}
  end

  def js_url?
    url.to_s =~ /\.js$/
  end

  def gist_url
    url if is_gist_url? && js_url?
  end
end
