require 'spec_helper'
describe 'twlight' do

  context 'with defaults for all parameters' do
    it { should contain_class('twlight') }
  end
end
