FlybackBbs::App.controllers :home do
  
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
  
  get :index, map: '/' do
    # @categories = Category.order('created_at DESC').limit(5)    
    @articles = Article.order('created_at DESC, commented_at DESC').limit(10)
    render 'home/index'
  end

end
