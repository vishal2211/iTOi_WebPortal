namespace :generate do
  task :company_tokens => :environment do
    Company.where("company_token is null").all.each do |company|
      company.company_token = Digest::SHA1.hexdigest(Time.now.to_s + rand(1..999).to_s)
      company.save
    end
  end
end