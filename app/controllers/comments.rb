FlybackBbs::App.controllers :comments do
  
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
  
  post :create do
    @comment = Comment.new(params[:comment])
    flash[:danger] = @comment.errors[:content] unless @comment.valid?
    current_account.comments << @comment
    begin
      article = Article.find(params[:article_id])
      article.add_comments(@comment)
      redirect url_for(:articles, :show, id: article.id)
    rescue
      redirect url_for(:home, :index)
    end 
  end

end
