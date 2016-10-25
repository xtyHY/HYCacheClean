Pod::Spec.new do |s|

  s.name         = "HYCacheClean"
  s.version      = "1.0"
  s.summary      = "清理缓存功能"

  s.description  = <<-DESC
                    清理缓存功能
                    功能：
                      1. 异步计算 指定文件目录组 下 所有文件 大小
                      2. 异步清理 指定文件目录组 下 所有文件
                      3. 计算和清理完成时支持完成回调
                      4. 默认加入清除SDWebImage DiskCache
                   DESC

  s.homepage     = "https://github.com/xtyHY/HYCacheClean"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "xtyHY" => "devhy@foxmail.com" }
  s.social_media_url   = "http://www.devhy.com"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/xtyHY/HYCacheClean.git", :tag => "#{s.version}" }
  s.source_files  = "HYCacheClean/*.{h,m}"
  s.frameworks = "Foundation"
  s.dependency 'SDWebImage', '~>3.7'
  s.requires_arc = true

end