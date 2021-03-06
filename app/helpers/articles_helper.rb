# Helper methods defined here can be accessed in any controller or view in the application

FlybackBbs::App.helpers do
  # def simple_helper_method
  #  ...
  # end
  def md_extensions
  	{:space_after_headers => true,
     :fenced_code_blocks => true,
  	 :tables => true}
  end 

  def md_render_opts
  	{:filter_html => true,
     :no_styles => true,
  	 :safe_links_only => true,
  	 :hard_wrap => true}
  end

  def to_md(text)
  	markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(md_render_opts), md_extensions)
  	markdown.render(text)
  end

  def admin_or_owner_of?(article_or_comment)
    current_account && 
    current_account.active? && 
    (current_account.owner_of?(article_or_comment) || current_account.admin?)
  end


end
