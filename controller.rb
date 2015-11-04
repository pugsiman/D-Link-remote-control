require 'rubygems'
require 'mechanize'

# known macs to be recognized
@users_macs = {
  # example:    '40:b0:ca:ad:f2:b5',
  # example2:   '62:23:c0:08:7d:b1',
  # example3:   '23:fc:ef:e0:79:22'
}

# deafult parameters
USER = 'Admin'
PASS = 'Admin'
URL = 'http://10.0.0.138/'

MAC_REGEX = /[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}/
# uncomment to specify sys admin MAC to hide from block command
# MASTER_USR = '00:00:00:00:00:00'

@agent = Mechanize.new
@agent.user_agent_alias = 'Windows Mozilla'
@agent.add_auth(URL, USER, PASS)

# uncomment for logging
# @agent.log = Logger.new(STDOUT)

def run(choice = nil)
  print 'Commands: (r)eset, (b)lock, (u)nblock, (l)ist users, (h)elp, (e)xit: '
  until %w(r b u l h e).include? choice
    choice = gets.chomp.downcase
    case choice
    when 'r' then reset_router
    when 'b' then block_user
    when 'u' then unblock_user
    when 'l' then [list_users, run]
    when 'h' then [help, run]
    when 'e' then exit
    end
  end
end

def fetch_sessionkey(url)
  page = @agent.get_file(url)
  session_str = page.partition('sessionKey=')[2][0..10]
  return session_str.to_i unless session_str.to_i == 0
  page.partition('sessionKey=')[2][1..11].to_i
end

def fetch_macs
  page = @agent.get_file("#{URL}dhcpinfo.html")
  macs_array = page.scan(MAC_REGEX)
  prep_usr_macs(macs_array)
end

def prep_usr_macs(macs_array)
  user_count = 1
  macs_array.each do |mac|
    name = "user#{user_count}".to_sym
    if mac == MASTER_USR || @users_macs.values.include?(mac)
      next
    else
      @users_macs[name] = mac
      user_count += 1
    end
  end
end

def display_users
  fetch_macs
  @users_macs.sort_by { |user, _v| user.length }.each do |user, v|
    puts "#{user.upcase} (#{v})"
  end
end

def list_users
  @users_connected = {}
  page = @agent.get_file("#{URL}dhcpinfo.html")
  macs_array ||= page.scan(MAC_REGEX)
  user_count = 1
  macs_array.each do |mac|
    name = "user#{user_count}".to_sym
    @users_connected[name] = mac
    user_count += 1
  end
  @users_connected.each { |user, v| puts "#{user.upcase} (#{v})" }
end

def block_user
  puts "\nWhich user to block?\n"
  display_users
  user_url = block_user_url(gets.chomp.downcase.to_sym)
  print "\nSENDING REQUEST TO:\n", user_url
  @agent.get user_url
  sleep(10)
  puts "\nDONE"
end

def block_user_url(user)
  value = @users_macs.fetch(user)
  URL + "wlmacflt.cmd?action=add&wlFltMacAddr=#{value}"\
         "&wlSyncNvram=1&sessionKey=#{fetch_sessionkey(URL + 'wlmacflt.html')}"
end

def unblock_user
  puts 'Which user to unblock?'
  display_users
  user_url = unblock_user_url(gets.chomp.downcase.to_sym)
  print "\nSENDING REQUEST TO:\n", user_url
  @agent.get user_url
  sleep(10)
  puts "\nDONE"
end

def unblock_user_url(user)
  value = @users_macs.values.map { |v| ", #{v.upcase}" }
  value = @users_macs.fetch(user) unless user == :all
  URL + "wlmacflt.cmd?action=remove&rmLst=#{value.join.upcase}"\
         "&sessionKey=#{fetch_sessionkey(URL + 'wlmacflt.cmd?action=view')}"
end

def reset_router
  puts 'are you sure?'
  choice = gets.to_s.chomp.downcase
  exit if choice.start_with? 'n'
  temp_url = "#{URL}updatesettings.html"
  reboot_cgi = "#{URL}rebootinfo.cgi?sessionKey=#{fetch_sessionkey(temp_url)}"
  print "\nSENDING REQUEST TO:\n#{reboot_cgi}"
  @agent.get(reboot_cgi)
  puts "\nDONE"
end

def help
  puts "\n\nReset: soft resets the router. It wont delete/reset any settings.",
       "This is the same as powering the router off and on.\n\n",
       'Block: allows you to block any user you want from the network.',
       'The user will be able to connect again if, and only if,',
       "you\'ll unblock him using the unblock command.\n\n",
       'Unblock: allows you to unblock currently blocked users.',
       "You can type 'all' to unblock all currently blocked users.\n\n",
       "List users: lists every currently logged in user.\n\n\n"
end

run
