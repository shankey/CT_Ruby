class CtControllerController < ApplicationController
  
  skip_before_filter  :verify_authenticity_token
  
  def index
  end

  def place
  end
  
  def share
  end
  
  def titleUploader
    
    puts params
    render :nothing => true
  end
  
  def fileUploader
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
  end
    
    tempfile = params[:file].tempfile.path
    if File::exists?(tempfile)
      File::delete(tempfile)
    end
    
    render :nothing => true
  end

end
