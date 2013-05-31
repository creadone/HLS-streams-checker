# encoding: utf-8

require "HLSpider"

beginning = Time.now

CLP = "channels.cfg"

chList = []
badChList = []

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
		puts "\n-------------------------------------------------------------------------"
    puts "Channel id '#{getChannelName(item)}'"
    spider.playlists.each do |playlist|
			puts "Bitrate #{playlist.source.scan(/(\d{3,}\.)/).to_s} is alive? #{playlist.valid?.to_s.capitalize!}!"
    end
		puts "Processing: #{Time.now - beginning1}"
	rescue => err
    badChList.unshift(err.message.to_s)
	end
end

puts "Channels: #{chList.count}\n\n"

if badChList.empty?
  puts "All channels is working."
else
  puts "Wrong streams: #{badChList.count}"
  badChList.map do |ch|
    puts "\t#{ch.split("\n")[0]}"
  end
end

puts "\nTotal time: #{Time.now - beginning}"

