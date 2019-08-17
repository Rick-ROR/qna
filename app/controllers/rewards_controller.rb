class RewardsController < ApplicationController

  expose :reward, ->{ Reward.find(params[:id]) }
  expose :user
  expose :rewards, -> { user.rewards }

end
