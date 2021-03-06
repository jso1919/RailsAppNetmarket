class Api::V1::Admin::RewardsController < ApplicationController
  before_action :admin_user

  # create reward for every active subscription on the system based on the percent posted by the admin
  def create
    subscriptions = Subscription
                    .where(subscription_status_id: 11)
                    .where(plan_id: params[:plan])
                    .select(:id,:plan_id,:user_id,:created_at)
    subscriptions     = subscriptions.map{ |x| 
      current_plan = Plan.where(id:x.plan_id).select(:id,:price,:expiration_days).first
      profit       = ((current_plan.price * params[:daily_value].to_f) / 100).round(2)
      allowed    = true
      allowed    = x.rewards.where(reward_type_id:11).count == 0 ? (false) : (true)
      allowed    = !allowed ? (x.created_at.beginning_of_day + 5.days < Time.zone.now.beginning_of_day) : (true)

      x.rewards.create(value: profit, 
        reward_type_id: 11,
        reward_status_id: 11,
        currency_id: 11,
        user_id:x.user_id) if allowed
    }.reject(&:blank?) if subscriptions.count(:id) > 0
    render json: subscriptions, status:200
  end

  private

end
