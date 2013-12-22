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

  get :new do
    make_breadcrumb(@title = 'Create topic')
    @article = Article.new
    render 'articles/new'
  end #new

  post :create do
    @article = Article.new(params[:article])
    if @article.save
      current_account.articles << @article
      flash[:success] = 'Create Successfully'
      redirect(url_for(:articles, :show, :id => @article.id))
    else
      flash.now[:danger] = 'Failed'
      render 'articles/new'
    end

  end #create

end
