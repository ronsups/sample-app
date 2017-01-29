class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  root render html: "Hello World"
end
