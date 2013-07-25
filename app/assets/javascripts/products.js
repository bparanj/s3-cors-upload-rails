window.uploadFile = function(file) {
    return $.getJSON("/generate_signed_s3_url?filename=" + file.name.replace(/ /g,"_") + "&content_type=" + file.type, function(data) {
      uploadToS3(file, data.put_url);
      return $("#product_url").val(data.file_url);
    });
  };

window.setProgress = function(progress, str) {
  $(".progress .bar").css("width", progress + "%");
  $("#product-upload-progress .text").text(str);
  if (progress === 100) {
    return $("#new_product_submit").show();
  }
};

$(function() {
  $("#product-upload-progress").hide();
  $("#new_product_submit").hide();
  $("#new_product_submit").click(function() {
    $("#product_file").remove();
    return true;
  });
  return $("#product_file").change(function(obj) {
    var file;

    file = obj.target.files[0];
    if (file.size > 500 * 1024 * 1024) {
      alert("File cannot be larger than 500MB.");
      return false;
    }
    $("#product-upload-progress").show();
    return uploadFile(file);
  });
});