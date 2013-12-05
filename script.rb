require 'mechanize'
require 'rubygems'
require 'nokogiri'

array = Array.new
headinglist = Array.new
textlist = Array.new
datelist = Array.new

agent = Mechanize.new
page=agent.get("http://www.kudzu.com/profileReviews.do?A=60049309&pageNumber=1")

result = page.search("//table[@class='profileReviewsBody']")[0]

result.search("//div[@class='reviewHeading']").each do |heading|
	headinglist.push(heading.content.gsub("\n", ""))
end

result.search("//div[@style='color:#000000; font-size:12px;']").each do |text|
	textlist.push(text.content.gsub("\n", " "))
end

result.search("//div[@style='color:#656565; font-size:11px; width:115px;']").each do |dt|
	datelist.push(dt.content.gsub("\n", " "))
end

for i in 0..headinglist.length-1
	h=Hash.new
	h['title']=headinglist[i]
	h['text']=textlist[i]
	h['date']=datelist[i]
	array.push(h)
end

puts array