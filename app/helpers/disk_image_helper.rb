module DiskImageHelper
  def upload_image(namespace, path, uploaded_io)
    File.open(path.join(uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end

  def delete_image(namespace, path, name)
    File.delete(path.join(name))
  end
end
