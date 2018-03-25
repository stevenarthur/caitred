Before do
  FileUtils.mkdir_p 'tmp/emails'
end

After do
  FileUtils.rm_rf('tmp/emails') if Dir.exist? 'tmp/emails'
end
