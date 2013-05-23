# encoding: utf-8

beginning = Time.now

require "uri/http"
require "HLSpider"

CLP = "channels.cfg"

chList = []

linklist = File.open(CLP,'r') do |file|
  file.each do |line|
    chList.unshift(line)
  end
end

def getChannelName (url)
	uri = URI.parse(url)
	uri_step1 = uri.path.split(":")
	uri_step2 = uri_step1[1].split(".")
	return uri_step2[0]
end

chList.each do |item|
	beginning1 = Time.now
	begin
		spider = HLSpider.new(item)
		puts "-------------------------------------------------------------------------"
    		puts "Channel id '#{getChannelName(item)}'"
    		spider.playlists.each do |playlist|
			puts "Bitrate #{playlist.source.scan(/(\d{3,}\.)/).to_s} is alive? #{playlist.valid?.to_s.capitalize!}!"
		end
		puts "Processing: #{Time.now - beginning1}"
	rescue
		puts "Status: down."
	end
end
puts "Channels: #{chList.count}"
puts "Total time: #{Time.now - beginning}"
