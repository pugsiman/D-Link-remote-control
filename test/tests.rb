require 'rubygems'
require 'mechanize'

url = 'http://10.0.0.138'

# p Mechanize::AGENT_ALIASES
@agent = Mechanize.new
@agent.add_auth(url, 'Admin', 'Admin')
100.times do
  page = @agent.get_file('http://10.0.0.138/wlmacflt.cmd?action=view')
  session_key = page.partition('sessionKey=')[2][0..10].to_i.to_s
  puts "#{session_key} (#{sessionKey.to_s.length})"
end
