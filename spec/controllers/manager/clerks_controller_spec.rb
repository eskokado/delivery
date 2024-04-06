require 'rails_helper'

RSpec.describe Manager::ClerksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:clerks) { create_list(:clerk, 3, client: client) }
  let(:clerk) { create(:clerk, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @clerks' do
      clerk = FactoryBot.create(:clerk, client: client)
      get :index
      expect(assigns(:clerks)).to eq([clerk])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
