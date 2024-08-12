#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint compdfkit_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'compdfkit_flutter'
  s.version          = '2.1.1'
  s.summary          = 'Flutter PDF Library by ComPDFKit'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.compdf.com'
  s.license          = { type:'Commercial', file: '../LICENSE' }
  s.author           = { 'ComPDFKit' => 'compdfkit@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency("ComPDFKit_Tools")
  s.dependency("ComPDFKit")
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
