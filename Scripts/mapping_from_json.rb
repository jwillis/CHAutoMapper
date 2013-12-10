#!/usr/bin/ruby
require 'rubygems'
require 'json'

def nsdictionary_from_json(object, property = nil)
	hash = object.is_a?(Hash) ? object : object[0]
	"[CHObjectMapping mappingForClass:[Target class] "  +
	"forPropertyName:" + (property ? "@\"\" " : 'nil ') +
	"withPropertyMap:[NSDictionary dictionaryWithObjectsAndKeys:" +
		hash.keys.collect {|key| "#{hash[key].is_a?(Array) || hash[key].is_a?(Hash) \
			? nsdictionary_from_json(hash[key], key) : '@""'}, @\"#{key}\"" } \
		.join(', ') + ', nil]]'
end

json = JSON.parse(ARGF.read)
code = nsdictionary_from_json(json) + ';'
puts code
