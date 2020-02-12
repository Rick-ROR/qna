shared_examples_for 'API return Pub Fields' do

  it 'returns all public fields' do

    klass = resource.class.to_s.downcase!

    fields.each do |field|
      expect(send("#{klass}_response")[field]).to eq resource.send(field).as_json
    end
  end
end
