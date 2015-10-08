require 'spec_helper'

describe 'test_helpers::default' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  
  it 'does something' do
    expect(return_true()).to  eq(true)
  end

  it 'does something else' do
    expect(has_directory('asdf')).to eq("yessir")
  end

  
end