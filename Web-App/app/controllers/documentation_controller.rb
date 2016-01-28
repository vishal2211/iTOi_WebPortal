class DocumentationController < ApplicationController
  layout 'docs'
  http_basic_authenticate_with :name => "seeitoi", :password => "ApZxDKfCvQVX47xJEyHV"
  def index

  end
end