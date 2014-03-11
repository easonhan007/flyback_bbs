#encoding: utf-8
FlybackBbs::App.controllers :courses do
  
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

  before do 
    @title = '课程平台'
  end

  before except: [:index, :show] do
    halt(401, "You should login") unless logged_in?
    halt(403, 'You are disabled') unless current_account.active?
  end
  
  get :index do
    @courses = Course.order('created_at DESC').all
    render 'courses/index', layout: :course
  end #index

  get :show, with: :id do
    @course = Course.find(params[:id]) rescue halt(404, 'Invalid id or can not find the course')
    render 'courses/show', layout: :course
  end #show

  get :show_result, with: :result_id do
    @result = TestResult.find(params[:result_id]) rescue halt(404, 'Invalid id or can not find result')
    halt(503, 'You are not allowed to view the result') unless @result.account_id.eql?(current_account.id)
    @answers = @result.answers
    render 'courses/show_result', layout: :course
  end

  get :mine do
    @courses = current_account.courses
    render 'courses/mine', layout: :course
  end

  get :take_test, with: :test_id do
    @test = Test.find(params[:test_id]) rescue nil
    halt(404, 'Can not find test') if @test.blank?
    @course = @test.course
    halt(503, "You are not a member of course #{@course.name}") unless current_account.course_selected?(@course)
    @questions = @test.questions

    render('courses/take_test', layout: :course)
  end

  post :create_answer do 
    unless params[:answer][:id].blank?
      @answer = Answer.find(params[:answer][:id])
      @answer.content = params[:answer][:content]
    else
      @answer = Answer.new(params[:answer])
    end #if

    if @answer.save
      flash[:success] = '提交成功'
    else 
      flash[:error] = '无法提交'
    end #if
    redirect request.referrer
  end 

  get :attendance_detail, with: :id do
    @course = Course.find(params[:id]) rescue halt(404, 'Invalid id or can not find the course')
    @current_accout_all_attendances = current_account.attendances
    @results = @current_accout_all_attendances.where(course_id: @course.id).order('attendance_time DESC').page(params[:page]).per_page(10)

    @on_time = @results.where(attendance_status: '正常').count
    @arrive_late= @results.where(attendance_status: '迟到').count
    @leave_early = @results.where(attendance_status: '早退').count
    @absence = @results.where(attendance_status: '缺席').count
    render 'courses/attendance_detail', layout: :course
  end 
end
