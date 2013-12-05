require 'mechanize'
require 'rubygems'
require 'nokogiri'

agent = Mechanize.new
page=agent.get("http://www.kudzu.com/profileReviews.do?A=60049309&pageNumber=1")

array = Array.new
h=Hash.new

result = page.search("//table[@class='profileReviewsBody']")[0]

result.search("//div[@class='reviewHeading']").each do |heading|
	h['title']=heading.content.gsub("\n", "")
end

result.search("//div[@style='color:#000000; font-size:12px;']").each do |rev|
	h['content']=rev.content.gsub("\n", " ")
	array.push(h)
end

puts array