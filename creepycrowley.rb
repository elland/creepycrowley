#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'

$agent = Mechanize.new
$username = ''
$password = ''
$arg1 = ''
$country = ''
$run = false

def get_args

	help = "Use one of the following options:\n-u   Username\n-p  Password\n-c  Country(to limit the search to a particular country, use its 2 letter code, as in US or FR for the United States and France, respectively)\n-s  The term to be searched\n-h/--help this help menu"

	if ARGV.length == 0
		print help
	end
	
	ARGV.length.times do |i|
		case ARGV[i]
		when '-u'
			$username = ARGV[i+1]
		when '-p'
			$password = ARGV[i+1]
		when '-c'
			$country = '+country:' + ARGV[i+1]
		when '-s'
			$arg1 = ARGV[i+1]
			$run = true
		when '-h', '--help'
			print help
		end
	end
end

def login
	
	page1 = $agent.get("http://www.shodanhq.com/account/login")
	login_form = page1.form("login_form")
	login_form.username = $username
	login_form.password = $password
	$agent.submit(login_form)
	
end


def get_ips
	
	uri = "http://www.shodanhq.com/?q=#{$arg1}#{$country}&page="

	$ips = []

	(1..5).each do |x|
		page = $agent.get(uri+x.to_s).search(".//div[@class = 'ip']")
		page.children.length.times do |i|
			$ips << page.children[i].inner_text.strip
		end
	end
end

get_args()
	
if ($run)
	login()
	get_ips()

$ips.length.times do |i|
	print $ips[i] +  '\n'
end
end