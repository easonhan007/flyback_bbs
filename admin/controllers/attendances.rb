#encoding: utf-8
FlybackBbs::Admin.controllers :attendances do
  get :index do

    @title = "Attendances"
    @attendances = Attendance.order('created_at DESC').page(params[:page]).per_page(20)
    render 'attendances/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'attendance')
    @course = Course.find(params[:id]) rescue halt(404, 'Can not find test with id ' + params[:id].to_s)
    @attendance = Attendance.new
#    @courses = Course.order('created_at DESC').all
    @accounts = Account.all

    render 'attendances/new'
  end

  post :create do
    #获取到从view传过来的课程id与选中的所有账号id
    #通过遍历获取到的账号id，更新存入数据库中的课程id与账号id
    course_id = params[:course_id]
    selected_account_ids = params[:attendance_account_ids]
    selected_account_ids.each do |selected_account_id|
      @attendance = Attendance.new(params[:attendance])
      @attendance.update_attributes(account_id: selected_account_id.to_i,course_id: course_id.to_i)
    end

      if @attendance.save
        @title = pat(:create_title, :model => "attendance #{@attendance.id}")
        flash[:success] = pat(:create_success, :model => 'Attendance')
        params[:save_and_continue] ? redirect(url(:attendances, :index)) : redirect(url(:attendances, :index))
      else
        @title = pat(:create_title, :model => 'attendance')
        flash.now[:error] = pat(:create_error, :model => 'attendance')
        render 'attendances/new'
      end
  end

  get :statistics, with: :id do
    @course = Course.find(params[:id]) rescue halt(404, 'Can not find course with id' + params[:id].to_s)
    @accounts = Account.joins(:attendances).where("attendances.course_id=?", @course.id).group(:id)
    @results = {}
    @results = @accounts.map{|account|
                              on_time = account.attendances.where(attendance_status: '正常', course_id: @course.id ).count
                              arrive_late= account.attendances.where(attendance_status: '迟到', course_id: @course.id).count
                              leave_early= account.attendances.where(attendance_status:'早退', course_id: @course.id).count
                              absence = account.attendances.where(attendance_status: '缺席', course_id: @course.id).count
                              {
                                account_name: account.name,
                                on_time: on_time,
                                arrive_late: arrive_late,
                                leave_early: leave_early,
                                absence: absence,
                                account_id: account.id
                              }
    }
    render 'attendances/statistics'
  end

  get :show_detail, with: :id do
    @account = Account.find(params[:id])
    @results= @account.attendances.order('course_id').page(params[:page]).per_page(10)
#    @course = Course.find(params[:id])
#    @attendances = Attendance.joins(:account).where("attendances.account_id=?", @account.id)
#
#    @results = {}
#    @results = @attendances.map{|attendance|
#                              {
#                                attendance_time: attendance.attendance_time,
#                                attendance_status: attendance.attendance_status,
#                                attendance_description: attendance.description
#                              }}
    render 'attendances/show_detail'
  end
  post :grade do 
    logger.info params[:show_detail][:id]
    halt(404, 'failed to grade') if params[:show_detail][:id].blank?
    @result = TestResult.find(params[:show_detail][:id])
    ActiveRecord::Base.record_timestamps = false
    begin 
      @result.update_attributes(params[:show_detail])
    ensure
      ActiveRecord::Base.record_timestamps = true
    end 
    redirect request.referrer
  end 


  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "attendance #{params[:id]}")
    @attendance = Attendance.find(params[:id])
    @courses = Course.order('created_at DESC').all
    @accounts = Account.all
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
