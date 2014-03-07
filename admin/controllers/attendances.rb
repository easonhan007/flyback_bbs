FlybackBbs::Admin.controllers :attendances do
  get :index do

    if params[:course_id] != nil
      cookies[:course_name] = params[:course_name]
      cookies[:course_id] = params[:id]
    end
    
    @title = "Attendances"
    @attendances = Attendance.all
    render 'attendances/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'attendance')
#    @coure = Course.find(params[:id]) rescue halt(404, 'Can not find test with id ' + params[:id].to_s)
    @attendance = Attendance.new
    @courses = Course.order('created_at DESC').all
    @accounts = Account.all

    @result = {}
    Course.all.each do |course|
      @result[course.id] = course.accounts.map{|account| {id: account.id, name: account.name}}
    end
    render 'attendances/new'
  end

  post :create do
    @attendance = Attendance.new(params[:attendance])
    if @attendance.save
      @title = pat(:create_title, :model => "attendance #{@attendance.id}")
      flash[:success] = pat(:create_success, :model => 'Attendance')
      params[:save_and_continue] ? redirect(url(:attendances, :index)) : redirect(url(:attendances, :edit, :id => @attendance.id))
    else
      @title = pat(:create_title, :model => 'attendance')
      flash.now[:error] = pat(:create_error, :model => 'attendance')
      render 'attendances/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "attendance #{params[:id]}")
    @attendance = Attendance.find(params[:id])
    if @attendance
      render 'attendances/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'attendance', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "attendance #{params[:id]}")
    @attendance = Attendance.find(params[:id])
    if @attendance
      if @attendance.update_attributes(params[:attendance])
        flash[:success] = pat(:update_success, :model => 'Attendance', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:attendances, :index)) :
          redirect(url(:attendances, :edit, :id => @attendance.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'attendance')
        render 'attendances/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'attendance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Attendances"
    attendance = Attendance.find(params[:id])
    if attendance
      if attendance.destroy
        flash[:success] = pat(:delete_success, :model => 'Attendance', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'attendance')
      end
      redirect url(:attendances, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'attendance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Attendances"
    unless params[:attendance_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'attendance')
      redirect(url(:attendances, :index))
    end
    ids = params[:attendance_ids].split(',').map(&:strip)
    attendances = Attendance.find(ids)
    
    if Attendance.destroy attendances
    
      flash[:success] = pat(:destroy_many_success, :model => 'Attendances', :ids => "#{ids.to_sentence}")
    end
    redirect url(:attendances, :index)
  end
end
