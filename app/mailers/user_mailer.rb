class UserMailer < ApplicationMailer
    default from: "server@coupletrips.in"
  
  
  def welcome_email(travelstory)
    @ts = travelstory
    subj = "New Story Shared By "+ " " + travelstory.user_id.to_s + "  " + travelstory.id.to_s
    mail(:to => "share@coupletrips.in", :subject => subj) do |format|
      format.html { render 'welcome_email.html.erb' }
      format.text { render text: 'Render text' }
    end
  end
  
end

