shared_examples_for 'API Unprocessable' do

  it 'returns 422 status with errors' do
    expect(response.status).to eq 422
    expect(json.keys).to eq %w[ errors ]
  end
end
