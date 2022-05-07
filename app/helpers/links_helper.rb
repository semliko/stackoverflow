module LinksHelper

  def display_link(link)
    if link.gist_url
      javascript_include_tag(link.gist_url)
    else
      link_to link.name, link.url
    end
  end
end
