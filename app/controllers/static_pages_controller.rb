class StaticPagesController < ApplicationController
  def home
   if logged_in?#current_userがnilの場合にメソッドmicropostsを渡してもエラーになるためif logged_in?を確認する    @micropost = current_user.microposts.build
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
   end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
