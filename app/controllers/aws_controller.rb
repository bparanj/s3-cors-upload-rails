class AwsController < ApplicationController

  def generate_signed_s3_url
    # To avoid file collision, we prepend string to the file_name
    file_name = Cognac::CloudFile.generate(params[:filename])
    resource_end_point = Cognac::CloudFile.resource_end_point(ENV["AWS_S3_BUCKET"], file_name)
   
    options = Cognac::Signature.generate_options_for_build_s3_upload_url(ENV["AWS_S3_BUCKET"], file_name, params[:content_type])
    url = Cognac::Signature.build_s3_upload_url(resource_end_point, ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"], options)
    
    render :json => {:put_url => url, :file_url => resource_end_point}
  end
end
