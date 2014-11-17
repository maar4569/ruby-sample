# encoding: UTF-8
require 'mechanize'
auth_url='auth_url'
agent = Mechanize.new
account  = "myaccount"
passcode = "mypass"
actions = ["action_url1","action_url2"]
trans_status = true
def zaim_login agent, auth_url , account , passcode
  callback_url=""
  begin
    agent.get( auth_url ) do | page |
      search_result = page.form_with(:name => nil) do | login_form |
        login_form.field_with(:type => 'text').value = account
        login_form.field_with(:type => 'password').value= passcode
        p "input auth"
        p "target->#{login_form.fields}"
      end.click_button
      p "login succeed"
      callback_url_base= search_result.search('//script[@type=\'text/javascript\']')[0].text
      if callback_url_base =~ /(http:\/\/.+)\"/ then
        callback_url = $1
        p "got callback_url #{callback_url}"
      else
        p "could not get callback url"
      end
    end #agent end
    return callback_url
  rescue
    p "zaim login failure"
    p $!
  end
end

begin
  actions.each { | action_url |
    p "-------------------------------------"
    p "login phase"
    p "-------------------------------------"
    agent = Mechanize.new
    callback_url = zaim_login( agent , auth_url , account , passcode )
    p "--------------------------------------"
    p "transaction phase"
    p "--------------------------------------"
    p "access callback #{callback_url}"
    res = ""
    agent.get( callback_url ) do | page |
      #p "page=>>>>>>#{page}"
      #p "#{page.forms}"
        for form in page.forms
          case action_url
            when form.action
              p "updatedata command is #{form.button_with(:type => 'submit').value}"
	      p "do action!=>#{form.action}"
	      res = form.click_button
              "p "#{res.parser}"
              p "transaction completed!!!!!"
	      break
            else
	  end
        end #end for    
    end #end agent
  }#end action for
rescue
  p "exception happend"
  p $!
  trans_status= false
end

p "--------------------------------------"
p "send mail to notify transaction status"
p "--------------------------------------"
# sucesss
# failure => $!
