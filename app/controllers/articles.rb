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

  before except: :show do
    @categories = Category.all
    halt(401, "You should login") unless logged_in?
    halt(403, 'You are disabled') unless current_account.active?
  end
  
  get :show, with: :id do |id|
    halt(404, "Can not find article with id = #{id}") unless /\d+/.match(id)
    begin
      @article = Article.find(id)
      @category = @article.category
      @comments = Comment.where(article_id: @article.id).order('created_at ASC').page(params[:page])
      make_breadcrumb(url_for(:categories, :show, id: @article.category.id), @article.category.name)
      make_breadcrumb(@title = @article.title)
    rescue
      halt(404, "Can not find article with id = #{id}") 
    end 

    render 'articles/show'
  end

  get :edit, with: :id do |id|
    make_breadcrumb(@title = 'Edit topic')
    # begin
      @article = Article.find(id)
      halt(401, 'You have no permission to edit this article') unless (current_account.owner_of?(@article) || current_account.admin?)
      render('articles/edit')
    # rescue Exception => e
    #   halt(404, "Can not find article with id = #{id}") 
    # end
  end

  get :new do
    make_breadcrumb(@title = 'Create topic')
    @article = Article.new
    render 'articles/new'
  end #new

  post :create do
    @article = Article.new(params[:article])
    @article.set_last_commentor_and_last_commented_at(current_account)
    if @article.save
      current_account.articles << @article
      flash[:success] = 'Create Successfully'
      redirect(url_for(:articles, :show, :id => @article.id))
    else
      flash.now[:danger] = 'Failed'
      render 'articles/new'
    end
  end #create

  put :update do
    @article = Article.find(params[:article]['id'])
    if @article
      if @article.update_attributes(params[:article])
        flash[:success] = 'Update Successfully' 
        redirect(url(:articles, :show, :id => @article.id))
      else
        flash.now[:danger] = 'Update Failed'
        render 'articles/edit'
      end #if
    else
      halt 404, 'update failed'
    end
  end #update

end
