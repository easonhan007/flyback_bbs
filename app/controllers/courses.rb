#encoding: utf-8
FlybackBbs::App.controllers :courses do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end

  before do 
    @title = '课程平台'
  end
  
  get :index do
    @courses = Course.order('created_at DESC').all
    render 'courses/index', layout: :course
  end #index

  get :show, with: :id do
    begin
      @course = Course.find(params[:id])      
    rescue 
      halt(404, 'Invalid id or can not find the course')
    end #begin
    render 'courses/show', layout: :course
  end #show

end
