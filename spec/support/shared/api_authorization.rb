shared_examples_for 'API Authorizable' do
  context 'unauthorized' do

    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '0952' }, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns empty body' do
      do_request(method, api_path, params: { access_token: '0952' }, headers: headers)
      expect(response.body).to be_empty
    end
  end
end
