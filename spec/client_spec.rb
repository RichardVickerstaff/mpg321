require 'spec_helper'

describe Mpg321::Client do
  include_context 'fake_mpg321'

  describe 'initialize' do
    it 'sets the volume to 50' do
      expect(subject.volume).to eq 50
    end
  end

end
