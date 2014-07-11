require 'singleton'
require 'fileutils'
require 'open-uri'
require 'net/ftp'

class Zoopla

	include Singleton

	def initialize
    @key_data = YAML.load(File.read("#{Rails.root}/lib/rightmove/file_format.yml")).symbolize_keys!
    @zoopla_config = YAML.load(File.read("#{Rails.root}/config/rightmove_file_upload.yml"))[Rails.env].symbolize_keys!
    @path = Rails.root.join('tmp', 'upload')
    FileUtils.mkdir_p(@path) unless File.exists?(@path)
	end

	def upload(properties)
		prepare(properties)

    cmd1 = "cd #{@path}"
    cmd2 = "rm -rf .DS_Store"
    cmd3 = "zip -rmT #{Time.now.strftime('%Y%M%d')}.zip ."
    system "#{cmd1} && #{cmd2} && #{cmd3}"

		Net::FTP.open(@zoopla_config[:host], @zoopla_config[:login], @zoopla_config[:password]) do |ftp|
			ftp.passive = true

			Dir.foreach(@path).each do |filename|
				next if [".", ".."].include?(filename)
				puts filename
				file = File.open("#{@path}/#{filename}", 'r')
			  ftp.putbinaryfile(file)
			end
		end		
	end

	def prepare(properties)
		FileUtils.rm_rf Dir.glob("#{@path}/*")

		f = File.new("#{@path}/#{@zoopla_config[:branch_id]}_#{Time.now.strftime('%Y%M%d')}_00.BLM", 'w')
		f.puts header(properties.count)
		data = data(properties)
		f.puts data[0]
		f.puts data[1]
		f.puts '#END#'
		f.close
	end

	def header(property_count=1, eof=nil, eor=nil)
		header = "#HEADER#\n"
		header += "Version : 3\n"
		header += "EOF : '^'\n"
		header += "EOR : '~'\n"
		header += "Property Count : #{property_count}\n" 
		header += "Generated Date : #{Time.now.strftime("%d-%M-%Y %H:%M")}\n"
		return header
	end

	def data(properties)
		property = properties.first

		definition = "\n#DEFINITION#\n"
		data = "\n#DATA#\n"
		@key_data.each do |key, value|
			definition += "#{key.upcase}^" if property.respond_to?(key)
		end

		properties.each do |p|
			@key_data.each do |key, value|
      	p.branch_id = @zoopla_config[:branch_id]

				if p.respond_to?(key)
					data += "#{p.send(key).to_s}^"; puts "#{key.upcase}: #{p.send(key)}";
				end
			end

			p.media.each_with_index do |m, i|
				definition += "MEDIA_IMAGE_0#{i}^"
				filename = medium_file_name(p, m, i)
				data += "#{filename}^"
				
		  	open("#{@path}/#{filename}", 'wb') do |file|
			  	file << open(m.media_url).read
			  end
			end
			data += "~"
		end

		definition += "~"
		return [definition, data]
	end

  def medium_file_name(p, m, index)
  	"#{p.agent_ref}_#{m.media_upload_type}_0#{index}#{File.extname(m.photo_file_name)}"
  end
end
