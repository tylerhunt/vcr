# encoding: UTF-8

require 'yaml'
require 'vcr/structs'
require 'uri'

shared_examples_for "a header normalizer" do
  let(:instance) do
    with_headers('Some_Header' => 'value1', 'aNother' => ['a', 'b'], 'third' => [], 'fourth' => nil)
  end

  it 'ensures header keys are serialized to yaml as raw strings' do
    key = 'my-key'
    key.instance_variable_set(:@foo, 7)
    instance = with_headers(key => ['value1'])
    YAML.dump(instance.headers).should eq(YAML.dump('my-key' => ['value1']))
  end

  it 'ensures header values are serialized to yaml as raw strings' do
    value = 'my-value'
    value.instance_variable_set(:@foo, 7)
    instance = with_headers('my-key' => [value])
    YAML.dump(instance.headers).should eq(YAML.dump('my-key' => ['my-value']))
  end
end

module VCR
  describe Request do
    it_behaves_like 'a header normalizer' do
      def with_headers(headers)
        described_class.new(:get, 'http://example.com/', nil, headers)
      end
    end
  end

  describe Response do
    it_behaves_like 'a header normalizer' do
      def with_headers(headers)
        described_class.new(:status, headers, nil, '1.1')
      end
    end
  end
end

