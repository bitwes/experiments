#
# Cookbook Name:: library
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

ruby_block 'check_attribute -- 1 --' do
  block do
    puts "\nin ruby block, an_attribute = #{node['an_attribute']}"
  end
end

some_method()
override_an_attribute('something new')

ruby_block 'check_attribute -- 2 --' do
  block do
    puts "\nin ruby block, an_attribute = #{node['an_attribute']}"
  end
end
