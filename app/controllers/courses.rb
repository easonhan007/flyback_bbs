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
    begin
      @course = Course.find(params[:id])      
    rescue 
      halt(404, 'Invalid id or can not find the course')
    end #begin
    render 'courses/show', layout: :course
  end #show

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
    if params[:answer][:id]
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

end
