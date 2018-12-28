#
# Be sure to run `pod lib lint ChallongeNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChallongeNetworking'
  s.version          = '0.1.0'
  s.summary          = 'Swift library to integrate with the Challonge API.'


  s.description      = 'A library to easily integrate with the Challonge API for easy tournament and bracket management.'

  s.homepage         = 'https://github.com/ashleyng/ChallongeNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ashleyng' => 'ashleyng@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/ashleyng/ChallongeNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = "4.2"

  s.source_files = 'ChallongeNetworking/Classes/**/*'
end
