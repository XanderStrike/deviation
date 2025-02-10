require 'nokogiri'
require 'open-uri'

def fetch_rss(url, items = [])
  # Fetch the RSS feed
  doc = Nokogiri::XML(URI.open(url))

  # Extract all <item> elements and add them to the items array
  doc.xpath('//item').each do |item|
    items << item.to_xml
  end

  # Check for a rel="next" link
  next_link = doc.at_xpath('//atom:link[@rel="next"]', 'atom' => 'http://www.w3.org/2005/Atom')
  if next_link
    next_url = next_link['href']
    fetch_rss(next_url, items) # Recursively fetch the next URL
  else
    items # Return all items when there are no more pages
  end
end

# Start fetching from the initial RSS URL
initial_url = 'https://backend.deviantart.com/rss.xml?type=deviation&q=by%3Axanderstrike+sort%3Atime+meta%3Aall'
all_items = fetch_rss(initial_url)

# Write all items to output.xml
File.open('manifest.xml', 'w') do |file|
  all_items.each { |item| file.puts item }
end

puts 'All items have been written to output.xml'
