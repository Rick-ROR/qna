# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities unless user
    user.admin? ? admin_abilities : user_abilities
  end


  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id
    can :destroy, Subscription, user_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :vote, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end
    can :best, [Answer], question: { author_id: user.id }
    can :read, Reward
  end
end
