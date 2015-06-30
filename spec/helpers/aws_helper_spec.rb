require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AwsHelper. For example:
#
# describe AwsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AwsHelper do
  
  describe ".build_s3_str_to_sign" do

    it "should work without headers" do
      result = AwsHelper.build_s3_str_to_sign(:http_verb => "GET", :date => "Tue, 27 Mar 2007 19:44:46 +0000", 
        :resource => "/johnsmith/?acl")
        
      expected_result = "GET\n\n\nTue, 27 Mar 2007 19:44:46 +0000\n/johnsmith/?acl"
      
      expect(result).to eq(expected_result)
    end

    it "should work with amazon headers" do
      result = AwsHelper.build_s3_str_to_sign(:http_verb => "PUT", :date => "Tue, 27 Mar 2007 21:06:08 +0000", 
        :content_md5 => "4gJE4saaMU4BqNR0kLY+lw==", :content_type => "application/x-download",
        :resource => "/static.johnsmith.net/db-backup.dat.gz", 
        :amz_headers => ["x-amz-acl:public-read", "x-amz-meta-checksumalgorithm:crc32"])
      
        expected_result = "PUT\n4gJE4saaMU4BqNR0kLY+lw==\napplication/x-download\nTue, 27 Mar 2007 21:06:08 +0000\nx-amz-acl:public-read\nx-amz-meta-checksumalgorithm:crc32\n/static.johnsmith.net/db-backup.dat.gz"
      expect(result).to eq(expected_result)
    end

  end

  describe ".build_s3_rest_signature" do

    it "should work" do
      options = {
        :http_verb => "GET", :date => "Tue, 27 Mar 2007 19:36:42 +0000", 
        :resource => "/johnsmith/photos/puppy.jpg"
      }
      key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
      
      expected_result = "bWq2s1WEIj+Ydj0vQ697zp+IXMU="
      
      result = AwsHelper.build_s3_rest_signature(key, options)  
      
      expect(result).to eq(expected_result)
    end

  end

  describe ".build_s3_upload_url" do

    it "should work" do
      options = {
        :http_verb => "GET", 
        :date => "1175139620", 
        :resource => "/johnsmith/photos/puppy.jpg"
      }
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
      access_key = "AKIAIOSFODNN7EXAMPLE"
      url = AwsHelper.build_s3_upload_url("/photos/puppy.jpg", access_key, secret_key, options)
      
      expected_result = "/photos/puppy.jpg?AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Expires=1175139620&Signature=NpgCjnDzrM%2BWFzoENXmpNDUsSn8%3D"
      expect(url).to eq(expected_result)
    end

  end

end
