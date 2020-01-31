class RewardsController < ApplicationController

  expose :reward, ->{ Reward.find(params[:id]) }
  expose :user
  expose :rewards, -> { user.rewards }

  authorize_resource

end
