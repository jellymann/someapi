require 'spec_helper'

Some::API.include WebMock::API

describe 'Some::API stubs' do

  let(:moar_headers) { { 'X-Fizz' => 'Buzz' } }
  let(:moar_params) { { 'fizz' => 'buzz' } }
  let(:all_the_headers) { test_headers.merge moar_headers }
  let(:all_the_params) { test_params.merge moar_params }
  let(:test_body) { { 'baz' => 'qux' } }

  let(:even_moar_headers) { { 'X-Baz' => 'Qux' } }
  let(:even_moar_params) { { 'baz' => 'qux' } }

  let(:api) { TestAPI.new query: moar_params,
                          headers: moar_headers }

  it 'stubs endpoints using method_missing' do
    stub = api.stub.get.foo.bar!
    stub2 = api.stub.get.foo.bar.!

    HTTParty.get('http://example.com/foo/bar?fizz=buzz&foo=bar',
                headers: all_the_headers)

    expect(stub).to have_been_requested
    expect(stub2).to have_been_requested
  end

  it 'stubs endpoints using subscript operator' do
    stub = api.stub.get['foo']['bar'].!

    HTTParty.get('http://example.com/foo/bar?fizz=buzz&foo=bar',
                 headers: all_the_headers)

    expect(stub).to have_been_requested
  end

  it 'stubs endpoints with query' do
    stub = api.stub.get.foo.bar! query: even_moar_params

    HTTParty.get('http://example.com/foo/bar?baz=qux&fizz=buzz&foo=bar',
                headers: all_the_headers)

    expect(stub).to have_been_requested
  end

  it 'stubs endpoints with headers' do
    stub = api.stub.get.foo.bar! headers: even_moar_headers

    HTTParty.get('http://example.com/foo/bar?fizz=buzz&foo=bar',
                 headers: all_the_headers.merge(even_moar_headers))

    expect(stub).to have_been_requested
  end

  it 'stubs endpoints with body' do
    stub = api.stub.post.foo.bar! body: test_body

    HTTParty.post('http://example.com/foo/bar?fizz=buzz&foo=bar',
                 headers: all_the_headers,
                 body: test_body)

    expect(stub).to have_been_requested
  end
end
