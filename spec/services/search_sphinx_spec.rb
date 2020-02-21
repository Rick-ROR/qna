require 'rails_helper'

RSpec.describe Services::SearchSphinx, type: :services do
  allow_scopes = Services::SearchSphinx::ALLOW_SCOPES

  allow_scopes.keys.each do |scope|
    it "calls search for #{allow_scopes[scope]} class" do
      expect(allow_scopes[scope]).to receive(:search).with('ping')
      Services::SearchSphinx.new.call(scope: scope, query: 'ping')
    end
  end

  it "if not allow scope then calls search for ThinkingSphinx" do
    expect(ThinkingSphinx).to receive(:search).with('ping')
    Services::SearchSphinx.new.call(scope: "DUOTONE", query: 'ping')
  end

end
