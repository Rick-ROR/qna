shared_examples_for 'be Modulable' do |module_names|
  module_names.each do |name|
    it "has the module #{name}" do
      expect(described_class.include?(name.constantize)).to eq true
    end
  end
end
