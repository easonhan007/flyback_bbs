FlybackBbs::Admin.controllers :tests do
  get :index do
    @title = "Tests"
    @tests = Test.all
    render 'tests/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'test')
    @test = Test.new
    render 'tests/new'
  end

  post :create do
    @test = Test.new(params[:test])
    if @test.save
      @title = pat(:create_title, :model => "test #{@test.id}")
      flash[:success] = pat(:create_success, :model => 'Test')
      params[:save_and_continue] ? redirect(url(:tests, :index)) : redirect(url(:tests, :edit, :id => @test.id))
    else
      @title = pat(:create_title, :model => 'test')
      flash.now[:error] = pat(:create_error, :model => 'test')
      render 'tests/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "test #{params[:id]}")
    @test = Test.find(params[:id])
    if @test
      render 'tests/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'test', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "test #{params[:id]}")
    @test = Test.find(params[:id])
    if @test
      if @test.update_attributes(params[:test])
        flash[:success] = pat(:update_success, :model => 'Test', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:tests, :index)) :
          redirect(url(:tests, :edit, :id => @test.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'test')
        render 'tests/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'test', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Tests"
    test = Test.find(params[:id])
    if test
      if test.destroy
        flash[:success] = pat(:delete_success, :model => 'Test', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'test')
      end
      redirect url(:tests, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'test', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Tests"
    unless params[:test_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'test')
      redirect(url(:tests, :index))
    end
    ids = params[:test_ids].split(',').map(&:strip)
    tests = Test.find(ids)
    
    if Test.destroy tests
    
      flash[:success] = pat(:destroy_many_success, :model => 'Tests', :ids => "#{ids.to_sentence}")
    end
    redirect url(:tests, :index)
  end
end
