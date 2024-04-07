require 'rails_helper'

RSpec.describe Manager::OrdersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:orders) { create_list(:order, 3, client: client) }
  let(:order) { create(:order, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @orders' do
      order = FactoryBot.create(:order, client: client)
      get :index
      expect(assigns(:orders)).to eq([order])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns @orders for the given search parameters' do
      double('search_result', result: orders)
      allow(Order)
        .to receive_message_chain(:ransack, :result).and_return(orders)

      get :index

      expect(assigns(:orders)).to match_array(orders)
    end
  end

  describe 'GET #index with search' do
    it 'returns the orders searched correctly' do
      order1 = create(:order, date: '2024-04-07', client: client)
      order2 = create(:order, date: '2024-04-06', client: client)
      get :index,
          params: { q: { date_eq: '2024-04-07' } }

      expect(assigns(:orders)).to include(order1)
      expect(assigns(:orders)).to_not include(order2)
    end
  end
end
