class PdfUploader < CarrierWave::Uploader::Base

  storage :aws

  def store_dir
    "uploads/invoice/#{model.id}"
  end

  def extension_allowlist
    %w(pdf)
  end

end
