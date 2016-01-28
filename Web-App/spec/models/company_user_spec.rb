RSpec.describe CompanyUser, type: :model do
  
  context 'Company user' do
    it 'should be an admin' do
      company_user = FactoryGirl.build(:company_user, permissions: 1)
      expect(company_user.is_admin?).to eq(true)
    end

    it 'should not be an admin' do
      company_user = FactoryGirl.build(:company_user)
      expect(company_user.is_admin?).to eq(false)
    end
  end
end
