require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'json'

# Ensure the content directory exists
FileUtils.mkdir_p('content')

# Parse the XML file
xml_file = File.open('manifest.xml')
doc = Nokogiri::XML(xml_file)

# Initialize an array to store the deviations
deviations = []

# Iterate over each <item> in the XML
doc.xpath('//items/item').each do |item|
  title = item.at_xpath('title')&.text || 'Untitled'
  pub_date = item.at_xpath('pubDate')&.text || 'Unknown Date'
  description = item.at_xpath('media_description')&.text || 'No Description'
  media_url = item.at_xpath('media_content')&.[]('url')

  # Skip this item if the media URL is missing
  unless media_url
    puts "Skipping item '#{title}' because media URL is missing."
    next
  end

  # Generate a safe filename from the title
  safe_title = title.gsub(/[^a-zA-Z0-9]/, '_').downcase
  file_path = "content/#{safe_title}.jpeg"

  # Download the media file
  begin
    File.open(file_path, 'wb') do |file|
      file << URI.open(media_url).read
    end
  rescue OpenURI::HTTPError => e
    puts "Failed to download media for '#{title}': #{e.message}"
    next
  end

  # Add the deviation data to the array
  deviations << {
    title: title,
    pubDate: pub_date,
    description: description,
    content: file_path
  }
end

# Write the deviations to a JSON file
File.open('deviations.json', 'w') do |file|
  file.write(JSON.pretty_generate(deviations))
end

puts "Downloaded media files and generated deviations.json successfully!"