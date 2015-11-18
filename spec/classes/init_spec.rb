require 'spec_helper'
describe 'consul_functions' do

  context 'with defaults for all parameters' do
    it { should contain_class('consul_functions') }
  end
end
