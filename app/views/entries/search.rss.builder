xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title 'Dato RSS entries'
    xml.description "Dato RSS search about '#{params[:q]}' "
    xml.link root_url
    xml.copyright "Copyright #{Time.current.year} DatoRSS"
    xml.lastBuildDate Time.current
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: entries_url(q: params[:q])

    @search_entries.limit(100).each do |entry|
      xml.item do
        xml.title entry.title
        xml.description entry.body
        entry.categories.each do |category|
          xml.category category
        end
        xml.pubDate entry.published_at.to_s(:rfc822)
        xml.guid entry.id
        xml.link entry.url
        xml.author entry.feed.title
      end
    end
  end
end
