Pod::Spec.new do |s|
  s.name             = 'CascadingTableDelegate'
  s.version          = '2.0.4'
  s.summary          = 'A no-nonsense way to write cleaner `UITableViewDelegate` and `UITableViewDataSource`.'

  s.description      = <<-DESC
CascadingTableDelegate allows you to propagate `UITableViewDelegate` and `UITableViewDataSource` method calls to several objects, based by the `IndexPath` of the method's parameter.
                       DESC

  s.homepage         = 'https://github.com/edopelawi/CascadingTableDelegate'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ricardo Pramana Suranta' => 'ricardo.pramana@gmail.com' }
  s.source           = { :git => 'https://github.com/edopelawi/CascadingTableDelegate.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/edopelawi'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CascadingTableDelegate/Classes/**/*'

  s.frameworks = 'UIKit'

end
