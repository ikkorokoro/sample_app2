class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
  if @micropost.save
    flash[:success] = "Micropost created"
    redirect_to  root_url
  else
    @feed_items = current_user.feed.paginate(page: params[:page])#static_pagesではfeed_itemを定義しているがここでも定義していないとrenndeで
    #"ビューを呼び出した時に_feed.html.erbに＠feed_itemがnilになっているためエラーが起きてしまう
    render 'static_pages/home'
  end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

private
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user#ユーザーが投稿したマイクロポストカどうかの確認
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
  end


end
