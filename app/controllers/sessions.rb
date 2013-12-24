FlybackBbs::App.controllers :sessions do
  get :new do
    render "/sessions/new"
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url(:home, :index)
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:error] = pat('login.error')
      redirect url(:sessions, :new)
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end
