class DemoController < ApplicationController
  def index
    render ('demo/hello')
  end
  def hello
    render(:text => 'Hello world')
  end
end
