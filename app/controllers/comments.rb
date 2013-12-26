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

  get :edit, with: :id do |id|
    # begin
      @comment = Comment.find(id)
      @article = @comment.article
      make_breadcrumb(url_for(:categories, :show, id: @article.category.id), @article.category.name)
      make_breadcrumb(@title = 'Edit Comment')
      render('comments/edit')
    # rescue
      # halt(404, 'Can not find comment with id = ' + id)
    # end
  end

  put :update do
    @comment = Comment.find(params[:comment]['id'])
    @article = @comment.article
    if @comment
      if @comment.update_attributes(params[:comment])
        flash[:success] = 'Update Successfully' 
        redirect(url(:articles, :show, :id => @article.id))
        return
      else
        flash[:danger] = 'Update Failed'
        render('comments/edit')
      end #if
    else
      halt 404, 'update failed'
    end
  end

end
