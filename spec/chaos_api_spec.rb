require 'spec_helper'

describe Chaos::API do
  it 'has a version number' do
    expect(Chaos::API::VERSION).not_to be nil
  end
end
