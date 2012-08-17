
begin
  require 'rubygems'
  require 'nokogiri'
  require 'erb'
rescue LoadError
  puts $!
  puts "Error: Install nokogiri to run reports\n\n\t\tgem install nokogiri\n\n"
end

class AutomationPlistToHtml

  module Types
   DEBUG = 0
   MESSAGE = 1
   WARNING = 2
   ERROR = 3
   START = 4
   PASS = 5
   ISSUE = 6
   FAIL = 7
   SCREENSHOT = 8
  end

  def initialize(options)
    @dir = options[:dir]

    @devices = devices
    @test_files = files

    generate_report
  end

  def report
    @report
  end

  def write_report(output_file)
    require 'FileUtils'

    # Copy resources
    file_dir = File.dirname __FILE__
    resources_dir = File.join file_dir, 'resources'
    FileUtils.cp_r resources_dir, File.dirname(output_file)

    # Write html
    File.open(output_file, 'w') do |f|
      f.puts @report
    end
  end

private

  def generate_report
    template_file = File.join(File.dirname(__FILE__), 'report.html.erb')
    template = ERB.new File.read(template_file)
    @report = template.result(binding)
  end

  def results_of_test(device, file)
    plist = File.join @dir, device, file, 'Automation Results.plist'
    doc = Nokogiri::XML(File.read plist)
    output = Nokogiri::XML::Document.new()

    def value_from_dict(dict, keypath, type)
      el = dict.xpath("key[text() = '#{keypath}']/following-sibling::#{type}[1]")
      if el.size > 0
        el.first.content
      else
        ""
      end
    end

    content_for_test = lambda { |dict|
      message = value_from_dict dict, 'Message', 'string'
      logtype = value_from_dict dict, 'LogType', 'string'
      display_text = message.clone

      if display_text =~ /^(Assertion|Expected)/
        display_text.gsub! /[<>]/, '"'
        display_text.gsub! 'but', 'and' if display_text =~ /^Assertion passed/
      end

      screen = value_from_dict dict, 'Screenshot', 'string'
      unless screen == ""
        dir = dict.xpath("ancestor::dict[parent::array/preceding-sibling::key]/key[text() = 'Message']/following-sibling::*[text()]")
        puts dir

        screen = "<figure><img src='#{device}/#{file}/#{message.gsub ':', '-'}.png'/></figure>"

        has_screen = true
      end
      

      "<li class='#{logtype.downcase} #{screen == "" ? '' : 'has_screen'}'>#{display_text}#{screen}</li>"
    }

    root = output.add_child '<ul/>'
    current_node = root

    doc.xpath('./plist/dict/array/dict').each do |dict|
      
      type = value_from_dict(dict, 'Type', 'integer').to_i

      if type == Types::START
        current_node.add_child("<li><h1>#{value_from_dict dict, 'Message', 'string'}</h1><ul/></li>")
        current_node = current_node.children.last.children.last
      elsif type == Types::PASS
        inner_failures = current_node.css('li.fail,li.error').size > 0
        current_node.parent.set_attribute 'class', (inner_failures ? 'fail' : 'pass') 

        current_node.add_child '<li class="pass"/>'#content_for_test.call dict
        current_node = current_node.parent.parent
      elsif type == Types::FAIL
        current_node.parent.set_attribute 'class', 'fail'
        current_node.add_child content_for_test.call dict
        current_node = current_node.parent.parent
      else
        current_node.add_child content_for_test.call dict
      end
    end

    root
  end

  def devices
    devices = "iphone ipad".split
  end

  def files
    Dir[File.join @dir, 'iphone', '/*'].map do |d|
      File.basename d
    end
  end

end


if __FILE__ == $0
  dir = ARGV[0]
  raise "Directory required" unless dir and File.directory? dir
  auto = AutomationPlistToHtml.new :dir => dir
  auto.write_report File.join(dir, 'report.html')
end
