Pod::Spec.new do |s|
s.name     = 'ZLNinaPagerView'
s.version  = '1.4.8'
s.license  = 'MIT'
s.platform      = :ios, '7.0'
s.summary  = 'NinaPagerView is a low-coupling segment easy to page your controllers and views.增加了已自动计算宽度的'
s.homepage = 'https://github.com/zhoulincome/ZLNinaPagerView'
s.author   = { 'RamWire' => 'RamWire' }
s.source   = { :git => 'https://github.com/zhoulincome/ZLNinaPagerView.git', :tag => s.version.to_s }
s.source_files = 'NinaPagerView/**/*.{h,m}'
s.framework = 'UIKit'
s.requires_arc  = true
end
