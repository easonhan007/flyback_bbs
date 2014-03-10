#encoding: utf-8
FlybackBbs::Admin.controllers :accounts do
  get :index do
    @title = "Accounts"
    @accounts = Account.all
#    @accounts = Account.all.paginate(page: params[:page], per_page: 10).order('create_time DESC')
#    @features = Feature.where(project_id: cookies[:project_id]).paginate(page: params[:page], per_page: 10).order('id ASC')
    render 'accounts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'account')
    @account = Account.new
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      @title = pat(:create_title, :model => "account #{@account.id}")
      flash[:success] = pat(:create_success, :model => 'Account')
      params[:save_and_continue] ? redirect(url(:accounts, :new)) : redirect(url(:accounts, :index))
    else
      @title = pat(:create_title, :model => 'account')
      flash.now[:error] = pat(:create_error, :model => 'account')
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "account #{params[:id]}")
    @account = Account.find(params[:id])
    if @account
      render 'accounts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'account', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "account #{params[:id]}")
    @account = Account.find(params[:id])
    if @account
      # 清空所有选择的课程
      @account.selected_courses.each { |c| c.destroy }
      if params[:account][:all_courses]
        # 保存选择的课程
        params[:account][:all_courses].each do |course_id|
          course = Course.find(course_id)
          course.accounts << @account unless @account.course_selected?(course)
        end #each
      end #if
      if @account.update_attributes(params[:account])
        flash[:success] = pat(:update_success, :model => 'Account', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:accounts, :index)) :
          redirect(url(:accounts, :index))
      else
        flash.now[:error] = pat(:update_error, :model => 'account')
        render 'accounts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Accounts"
    account = Account.find(params[:id])
    if account
      if account != current_account && account.destroy
        flash[:success] = pat(:delete_success, :model => 'Account', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'account')
      end
      redirect url(:accounts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Accounts"
    unless params[:account_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'account')
      redirect(url(:accounts, :index))
    end
    ids = params[:account_ids].split(',').map(&:strip)
    accounts = Account.find(ids)
    
    if accounts.include? current_account
      flash[:error] = pat(:delete_error, :model => 'account')
    elsif Account.destroy accounts
    
      flash[:success] = pat(:destroy_many_success, :model => 'Accounts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:accounts, :index)
  end
end
