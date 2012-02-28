APP_DIR = File.expand_path File.dirname(__FILE__)
GEM_DIR = File.join(APP_DIR, 'vendor', 'gems')

Dir.entries(GEM_DIR).each do |dir|
  $LOAD_PATH << File.join(GEM_DIR, dir, 'lib')
end

require 'rack'
require 'sinatra/base'
require 'erb'
require 'pathname'

class Entry 
  attr_accessor :name, :path, :ftype

  def initialize(path)
    p = Pathname.new(path)
    @name = p.basename
    @path = p.to_s
    @ftype = p.ftype
  end
end

class Server < Sinatra::Base

  get '/favicon.ico' do end

  get '/' do
    @cwd = '/'
    @entries = make_entries(@cwd)
    erb :index
  end

  get '/*' do
    @cwd = "/#{params[:splat][0]}"
    @entries = make_entries(@cwd)
    erb :index
  end

  private
  def make_entries(path)
    pathname = Pathname.new(path)

    return [] unless pathname.directory?

    pathname.entries.map do |entry|
      Entry.new(File.join path, entry.to_s)
    end
  end
end

Server.run!
