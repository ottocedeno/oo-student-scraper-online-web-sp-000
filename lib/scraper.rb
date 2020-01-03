require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    #Array of all students on the page
    students = doc.css(".student-card")
    students.map do |student|
      hash = {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    profile_hash = {}

    social_container = doc.css(".social-icon-container a")
    social_links = social_container.map {|link| link.attribute("href").value}
    social_links.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      else
        profile_hash[:blog] = link
      end
    end
    profile_hash[:profile_quote] = doc.css("div.profile-quote").text
    profile_hash[:bio] = doc.css(".bio-content .description-holder").text.strip
    # quote = doc.css("div.profile-quote").text
    # bio =
    profile_hash
  end

end

# page = "https://learn-co-curriculum.github.io/student-scraper-test-page/"
# # Scraper.scrape_index_page(page)
# binding.pry
