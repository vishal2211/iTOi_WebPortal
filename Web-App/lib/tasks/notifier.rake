namespace :notify do
  task :send_emails do
    next unless Rails.env.production?
    User.where(plan_id: 2, plan_expiration: Date.today + 5.days).each do |user|
      ExpirationNoticeMailer.expiration_notice(user).deliver
      puts "Deliver to #{user.email}"
    end
    puts "done"
  end

  task :downgrade_plans do
    User.where(plan_expiration: Date.today).each do |user|
      user.plan_id = 1
      user.save
    end
  end

end
