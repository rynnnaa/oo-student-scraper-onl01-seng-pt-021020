require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.roster-cards-container").each do |card| card.css
    card.css(".student-card a").each do |student|
      student_profile = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    attributes = {}
    
    icon_container = doc.css("div.social-icon-container a").collect{|icon| icon.attributes("href").value}
    doc.each do |link|
      if link.include?("twitter")
        attributes[:twitter] = link
      elsif link.include?("linkedin")
        attributes[:linkedin] = link
      elsif link.include?("github")
        attributes[:github] = link
      elsif link.include?(".com")
        attributes[:blog] = link
      end
    end
    attributes[:profile_quote] = doc.css("div.profile-quote").text
    attributes[:bio] = doc.css("div.description-holder p").text.strip
    attributes
  end
end
