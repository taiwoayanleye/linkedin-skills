require 'anemone' # Install the anemone gem before you begin https://github.com/chriskite/anemone
#The below count is manually extracted from https://www.linkedin.com/directory/topics-X where 'X' is the alphabet
word_to_char = {
  a: 98, b: 100, c: 99, d: 99, e: 99, f: 97, g: 96, h: 95, i: 100, j: 88, k: 92, l: 97, m: 100, 
  n: 94, o: 99, p: 99, q: 87, r: 100, s: 100, t: 100, u: 94, v: 96, w: 100, x: 73, y: 53, z: 0
}

all_urls, skipped_urls = [], []
word_to_char.each{ |char, count| 1.upto(count) { |num| all_urls << "https://www.linkedin.com/directory/topics-#{char}-#{num}/" } }

File.open('linkedin_skills.txt', 'w') do |file|
  all_urls.each do |url|
    puts "Processing #{url}"
    begin
      Anemone.crawl(url, depth_limit: 0) do |anemone|
        anemone.on_every_page do |page|
          list = page.doc.at_xpath("//ul[contains(@class,'column')]")
          list.children.each { |li| file.puts(li.text) }
        end
      end
    rescue
      skipped_urls << url
    end
  end
end

puts skipped_urls.to_s