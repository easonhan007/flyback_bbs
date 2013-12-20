FlybackBbs::App.controllers :articles do
  
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
    halt(404, "Can not find article with id = #{id}") unless /\d+/.match(id)
    begin
      @article = Article.find(id)
      @comments = Comment.where(article_id: @article.id).order('created_at DESC').page(params[:page])
    rescue
      halt(404, "Can not find article with id = #{id}") 
    end 

    render 'articles/show'
  end

end