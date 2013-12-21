FlybackBbs::App.controllers :categories do
  
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
  
  get :show, with: :id do |id|
    halt(404, 'Id should be an integer') unless /\d+/.match(id) 
    begin 
      @category = Category.find(id.to_i) 
      @articles = Article.where(category_id: @category.id).order('commented_at DESC').page(params[:page]).per_page(2)
    rescue 
      halt(404, "Can not find category which id = #{id}") 
    end #begin
    render 'categories/show'
  end #show

  get :index do

  end

end
