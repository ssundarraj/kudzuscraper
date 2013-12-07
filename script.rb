require 'mechanize'
require 'rubygems'
require 'nokogiri'

#Samepl link---: "http://www.kudzu.com/profileReviews.do?A=60049309&pageNumber=1"

def kudzuscraper(uri, paginate=1)
	array = Array.new
	headinglist = Array.new
	textlist = Array.new
	datelist = Array.new
	unamelist = Array.new
	ratinglist = Array.new
	piclist = Array.new
	agent = Mechanize.new
	page=agent.get(uri)
	result = page.search("//table[@class='profileReviewsBody']")[0]
	result.search("//div[@class='reviewHeading']").each do |heading|
		headinglist.push(heading.content.gsub("\n", ""))
	end
	result.search("//div[@style='color:#000000; font-size:12px;']").each do |text|
		textlist.push(text.content.gsub("\n", " ")[1..-2])
	end
	result.search("//div[@style='color:#656565; font-size:11px; width:115px;']").each do |dt|
		datelist.push(dt.content.gsub("\n", " ").split(" ")[-1])
	end
	result.search("//div[@style='font-size:13px']").each do |uname|
		unamelist.push(uname.content.gsub("\n", ""))
	end
	result.search("//div[contains(@class, 'rating-newstar')]").each do |rating|
		ratinglist.push(rating.attr('class')[-2..-1].to_i/10)
	end
	result.search("//img[@width='50']").each do |pic|
		piclist.push(pic.attr('src'))
	end
	for i in 0..headinglist.length-1
		h=Hash.new
		h['title']=headinglist[i]
		h['text']=textlist[i]
		h['date']=datelist[i]
		h['user']=unamelist[i]
		h['rating']=ratinglist[i]
		h['image']=piclist[i]
		array.push(h)
	end
	if paginate==1
		nexturi="http://www.kudzu.com" + page.search("//td[@class='pagingLink']/a")[-1].attr('href')
		if nexturi[-1]>uri[-1]
			array.push(kudzuscraper(nexturi))
		end
	end
	return array
end

if __FILE__ == $0
	uri=ARGV.first
	op=kudzuscraper(uri)
	target=File.open("output.html.erb", 'w')
	target.write(op)
	puts op
end