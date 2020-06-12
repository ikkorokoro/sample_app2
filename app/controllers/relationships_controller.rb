class RelationshipsController < ApplicationController
before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|#respond_toブロック内の）コードのうち、いずれかの1行が実行されるという点が重要です（このためrespond_toメソッドは、上から順に実行する逐次処理というより、if文を使った分岐処理に近いイメージです）
    format.html { redirect_to @user }
    format.js#デフォルトの動作、app/view/relationships/create.js.erb
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
    format.html { redirect_to @user }
    format.js#デフォルトの動作、app/view/relationships/destroy.js.erb
    end
  end

end
