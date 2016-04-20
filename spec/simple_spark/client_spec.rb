require 'spec_helper'

describe SimpleSpark::Client do
  describe :initialize do
    it 'will raise when no API key provided' do
      expect { SimpleSpark::Client.new }.to raise_error(SimpleSpark::Exceptions::InvalidConfiguration, 'You must provide a SparkPost API key')
    end

    context 'defaults' do
      let(:client) { SimpleSpark::Client.new(api_key: 'mykey') }
      specify { expect(client.instance_variable_get(:@api_key)).to eq('mykey') }
      specify { expect(client.instance_variable_get(:@api_host)).to eq('https://api.sparkpost.com') }
      specify { expect(client.instance_variable_get(:@base_path)).to eq('/api/v1/') }
      specify { expect(client.instance_variable_get(:@session).class).to eq(Excon::Connection) }
      specify { expect(client.instance_variable_get(:@debug)).to eq(false) }
      specify { expect(client.instance_variable_get(:@subaccount_id)).to eq(nil) }
    end

    it 'will use the API key from the ENV var' do
      with_modified_env SPARKPOST_API_KEY: 'mykey' do
        expect(SimpleSpark::Client.new.instance_variable_get(:@api_key)).to eq('mykey')
      end
    end

    it 'will use the base_path provided' do
      expect(SimpleSpark::Client.new(api_key: 'mykey', base_path: 'base').instance_variable_get(:@base_path)).to eq('base')
    end

    it 'will use the debug option provided' do
      expect(SimpleSpark::Client.new(api_key: 'mykey', debug: true).instance_variable_get(:@debug)).to eq(true)
    end

    context 'using the subaccount id provided' do
      let(:subaccount_id) { 'my_subaccount_id' }
      let(:client) { SimpleSpark::Client.new(api_key: 'mykey', subaccount_id: subaccount_id) }
      specify { expect(client.instance_variable_get(:@subaccount_id)).to eq(subaccount_id) }
      specify { expect(client.headers).to include('X-MSYS-SUBACCOUNT' => subaccount_id) }
    end

    context 'using the headers option provided' do
      let(:headers) { { x: 'y' } }
      let(:client) { SimpleSpark::Client.new(api_key: 'mykey', headers: headers) }
      specify { expect(client.instance_variable_get(:@headers)).to eq(headers) }
      specify { expect(client.headers).to include(headers) }

      it 'specified headers will override default constructed ones' do
        client = SimpleSpark::Client.new(api_key: 'mykey', subaccount_id: 'old', headers: { 'X-MSYS-SUBACCOUNT' => 'new' })
        expect(client.headers['X-MSYS-SUBACCOUNT']).to eq('new')
      end
    end

    it 'will raise when headers is not a Hash' do
      expect { SimpleSpark::Client.new(api_key: 'mykey', headers: 'wrong') }.to raise_error(SimpleSpark::Exceptions::InvalidConfiguration, 'The headers options provided must be a valid Hash')
    end
  end
end
