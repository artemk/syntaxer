Before do
  
end

AfterStep do
  FileUtils.rm_r('tmp/arba/.git') if File.directory?('tmp/arba/.git')
end
