Pod::Spec.new do |s|
  s.name             = "GQModularize"
  s.version          = "0.1.2"
  s.summary          = "GQModularize."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       GQModularize Example
                       DESC

  s.homepage         = "https://github.com/gonefish/GQModularize"
  s.license          = 'MIT'
  s.author           = { "Qian GuoQiang" => "gonefish@gmail.com" }
  s.source           = { :git => "https://github.com/gonefish/GQModularize.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
