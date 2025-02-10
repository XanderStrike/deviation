require 'open-uri'
require 'fileutils'

# Define the paths
input_file = 'deviations.json'
output_file = 'deviations_updated.json'
emojis_folder = 'avatars'

# Create the emojis folder if it doesn't exist
FileUtils.mkdir_p(emojis_folder)

# Read the file as a string
file_content = File.read(input_file)

# Use a regular expression to find all URLs matching the pattern
file_content.gsub!(%r{https://a\.deviantart\.(net|com)/avatars/[a-z]*/[a-z]*/([^/]+)\.png}) do |url|
  # Extract the emoji name from the URL
  emoji_name = File.basename(url, '.png')
  local_path = File.join(emojis_folder, "#{emoji_name}.png")

  # Skip if file already exists
  if File.exist?(local_path)
    puts "Skipping: #{emoji_name}.png (already exists)"
    local_path
  else
    # Download the image
    begin
      URI.open(url) do |image|
        File.open(local_path, 'wb') do |file|
          file.write(image.read)
        end
      end
      puts "Downloaded: #{emoji_name}.png"

      # Replace the URL with the local path
      local_path
    rescue OpenURI::HTTPError => e
      puts "Failed to download #{url}: #{e.message}"
      # If the download fails, keep the original URL
      url
    end
  end
end

# Write the updated content back to the file
File.open(output_file, 'w') do |file|
  file.write(file_content)
end

puts "Updated file saved to #{output_file}"