class ApplicationController < ActionController::Base
  
  def hello
    render html: "hellp world!"
  end
end
