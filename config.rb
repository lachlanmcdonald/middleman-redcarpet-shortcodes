# Extend Middleman's internal Redcarpet implementation to add
# in custom shortcode handling.
class Shortcodes
	cattr_accessor :middleman_app

	# Each handler is added as a static method to the class.
	# For example [[test ... ]] will result in this method
	# being called.
	def self.test(args)
		return middleman_app.content_tag(:div, "#{args}", :id => "test")
	end

	def self.parse(snippet)
		handle = /(?<=\[\[)\w+(?=\W)/.match(snippet)[0].to_sym
		args = {}

		# Create hash of the the provided arguments
		snippet.slice((2 + handle.size)..-3).scan(/\w+="[^"]+"/).each do |x|
			property, value = x.split(/\=/)
			args[property.to_sym] = value.slice(1..-2)
		end

		# Check if a method exists for the provided handle
		if Shortcodes.methods.include? handle
			Shortcodes.send(handle, args)
		else
			return snippet
		end
	end
end
Shortcodes.middleman_app = self

class Middleman::Renderers::MiddlemanRedcarpetHTML < ::Redcarpet::Render::HTML
	def preprocess(doc)
		doc.gsub(/\[\[\w+.*?\]\]/) { |m| Shortcodes::parse(m) }
	end

	def postprocess(doc)
		# Postprocess with the SmartPants plugin. If not desired
		# the entire postprocess method can be removed.
		doc = Redcarpet::Render::SmartyPants.render(doc)
	end
end

# Markdown configuration
# Note: Do not add :smartypants here, or else the class
# extensions above will not be called.
set :markdown_engine, :redcarpet
set :markdown,
	:space_after_headers => true,
	:no_intra_emphasis => true
