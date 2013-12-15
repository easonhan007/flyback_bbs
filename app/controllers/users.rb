FlybackBbs::App.controllers :users do
  
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
  
  get :new do
    @user = User.new
    render 'users/new'
  end

  post :create do
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'Thank you for your register'
      set_current_account(@user)
      redirect(url(:home, :index)) 
    else
      flash.now[:error] = 'Failed'
      render 'users/new'
    end

  end 

end
