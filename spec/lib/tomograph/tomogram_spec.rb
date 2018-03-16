require 'spec_helper'

RSpec.describe Tomograph::Tomogram do
  describe '#json' do
    subject do
      JSON.parse(
        described_class.new(
          drafter_yaml_path: "#{ENV['RBENV_DIR']}/spec/fixtures/#{documentation}",
          prefix: ''
        ).to_json
      )
    end
    let(:parsed) { MultiJson.load(File.read(json_schema)) }
    let(:documentation) { nil }

    context 'if one action' do
      let(:json_schema) { 'spec/fixtures/api2.json' }
      let(:documentation) { 'api2.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'additional desription' do
      let(:json_schema) { 'spec/fixtures/api16.json' }
      let(:documentation) { 'api16.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if two actions' do
      let(:json_schema) { 'spec/fixtures/api3.json' }
      let(:documentation) { 'api3.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if two controllers and three actions' do
      let(:json_schema) { 'spec/fixtures/api4.json' }
      let(:documentation) { 'api4.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end

      context 'and separated data structures' do
        let(:json_schema) { 'spec/fixtures/separated_data_structures.json' }
        let(:documentation) { 'separated_data_structures.yaml' }

        it 'parses documents' do
          expect(subject).to eq(parsed)
        end
      end
    end

    context 'blank request' do
      let(:json_schema) { 'spec/fixtures/api5.json' }
      let(:documentation) { 'api5.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'action with comment' do
      let(:json_schema) { 'spec/fixtures/api6.json' }
      let(:documentation) { 'api6.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'action with his unique path' do
      let(:json_schema) { 'spec/fixtures/api7.json' }
      let(:documentation) { 'api7.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if there is a description of the project' do
      context 'action with his unique path' do
        let(:json_schema) { 'spec/fixtures/api8.json' }
        let(:documentation) { 'api8.yaml' }

        it 'parses documents' do
          expect(subject).to eq(parsed)
        end
      end

      context 'action with his unique path' do
        let(:json_schema) { 'spec/fixtures/api9.json' }
        let(:documentation) { 'api9.yaml' }

        it 'parses documents' do
          expect(subject).to eq(parsed)
        end
      end
    end

    context 'if the structure of the first' do
      let(:json_schema) { 'spec/fixtures/api10.json' }
      let(:documentation) { 'api10.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if the structure of the first' do
      let(:json_schema) { 'spec/fixtures/api11.json' }
      let(:documentation) { 'api11.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if two response with the same code' do
      let(:json_schema) { 'spec/fixtures/api12.json' }
      let(:documentation) { 'api12.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if you forget to specify the type of response' do
      let(:json_schema) { 'spec/fixtures/api13.json' }
      let(:documentation) { 'api13.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if you with to specify the type of request' do
      let(:json_schema) { 'spec/fixtures/api14.json' }
      let(:documentation) { 'api14.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'if you with to specify the type of response' do
      let(:json_schema) { 'spec/fixtures/api15.json' }
      let(:documentation) { 'api15.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'with request body' do
      let(:json_schema) { 'spec/fixtures/api_builtin_scheme.json' }
      let(:documentation) { 'api_builtin_scheme.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'with a broken schema' do
      let(:json_schema) { 'spec/fixtures/api_with_broken_schema.json' }
      let(:documentation) { 'api_with_broken_schema.yaml' }

      before { allow_any_instance_of(Kernel).to receive(:puts) }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end

    context 'content-type' do
      let(:json_schema) { 'spec/fixtures/content_type.json' }
      let(:documentation) { 'content_type.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end
  end

  describe '#find_request_with_content_type' do
    let(:method) { 'POST' }
    let(:tomogram) { [double(path: nil, method: nil)] }
    let(:path) { '/status' }
    let(:content_type) { 'application/json' }

    let(:parsed) { MultiJson.load(File.read(json_schema)) }
    before do
      allow(Tomograph).to receive(:configuration).and_return(
        double(documentation: documentation, prefix: '', drafter_yaml: nil)
      )
      allow(Tomograph::ApiBlueprint::Yaml).to receive(:new).and_return(double(to_tomogram: tomogram))
    end
    let(:json_schema) { 'spec/fixtures/api2.json' }
    let(:documentation) { 'api2.yaml' }

    context 'if not found in the tomogram' do
      it 'returns nil' do
        expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(nil)
      end
    end

    context 'without path' do
      it 'returns nil' do
        expect(subject.find_request_with_content_type(method: method, path: nil, content_type: content_type)).to eq(nil)
      end
    end

    context 'if found in the tomogram' do
      let(:request1) { double(method: 'POST', path: double(match: true, to_s: '/status'), content_type: 'application/json' ) }
      let(:request2) { double(method: 'DELETE', path: double(match: true, to_s: '/status/{id}/test/{tid}.json'), content_type: 'application/json') }
      let(:tomogram) do
        [
          # Should not find these
          double(path: '/status', method: 'GET'),
          double(path: '/status/{id}/test/{tid}.json', method: 'GET'),
          double(path: '/status/{id}/test/{tid}.csv', method: 'DELETE'),
          double(path: '/status/{id}/test/', method: 'DELETE'),
          # Should find these
          request1,
          request2
        ]
      end

      context 'if slash at the end' do
        let(:path) { '/status/' }

        it 'return path withoud slash at the end' do
          expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(request1)
        end
      end

      context 'if request with query parameters' do
        let(:path) { '/status/?a=b&c=d' }

        it 'ignores query parameters' do
          expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(request1)
        end
      end

      context 'without parameters' do
        it 'return path' do
          expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(request1)
        end
      end

      context 'with a parameter' do
        let(:path) { '/status/1/test/2.json' }
        let(:method) { 'DELETE' }

        it 'returns the modified path' do
          expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(request2)
        end
      end
    end

    context 'if inserted' do
      let(:req1) { MultiJson.load(File.read('spec/fixtures/request1.json')) }
      let(:req2) { MultiJson.load(File.read('spec/fixtures/request2.json')) }
      let(:req3) { MultiJson.load(File.read('spec/fixtures/request3.json')) }
      let(:request1) do
        double(
          path: req1['path'],
          method: req1['method'],
          content_type: 'application/json',
          request: req1['request'],
          responses: req1['responses']
        )
      end
      let(:request2) do
        double(
          path: req2['path'],
          method: req2['method'],
          content_type: 'application/json',
          request: req2['request'],
          responses: req2['responses']
        )
      end
      let(:request3) do
        double(
          method: req3['method'],
          content_type: 'application/json',
          request: req3['request'],
          responses: req3['responses'],
          path: double(match: true, to_s: req3['path'])
        )
      end
      let(:tomogram) do
        [
          request1,
          request2,
          request3
        ]
      end
      let(:path) { '/users/37812539-99af-4d7c-b86f-b756e3d1a211/pokemons' }
      let(:method) { 'GET' }

      it 'returns the modified path' do
        expect(subject.find_request_with_content_type(method: method, path: path, content_type: content_type)).to eq(request3)
      end
    end
  end

  describe '#find_request' do
    let(:method) { 'POST' }
    let(:tomogram) { [double(path: nil, method: nil)] }
    let(:path) { '/status' }
    let(:content_type) { 'application/json' }

    let(:parsed) { MultiJson.load(File.read(json_schema)) }
    before do
      allow(Tomograph).to receive(:configuration).and_return(
        double(documentation: documentation, prefix: '', drafter_yaml: nil)
      )
      allow(Tomograph::ApiBlueprint::Yaml).to receive(:new).and_return(double(to_tomogram: tomogram))
    end
    let(:json_schema) { 'spec/fixtures/api2.json' }
    let(:documentation) { 'api2.yaml' }

    context 'if not found in the tomogram' do
      it 'returns nil' do
        expect(subject.find_request(method: method, path: path)).to eq(nil)
      end
    end

    context 'without path' do
      it 'returns nil' do
        expect(subject.find_request(method: method, path: nil)).to eq(nil)
      end
    end

    context 'if found in the tomogram' do
      let(:request1) { double(method: 'POST', path: double(match: true, to_s: '/status'), content_type: 'application/json' ) }
      let(:request2) { double(method: 'DELETE', path: double(match: true, to_s: '/status/{id}/test/{tid}.json'), content_type: 'application/json') }
      let(:tomogram) do
        [
          # Should not find these
          double(path: '/status', method: 'GET'),
          double(path: '/status/{id}/test/{tid}.json', method: 'GET'),
          double(path: '/status/{id}/test/{tid}.csv', method: 'DELETE'),
          double(path: '/status/{id}/test/', method: 'DELETE'),
          # Should find these
          request1,
          request2
        ]
      end

      context 'if slash at the end' do
        let(:path) { '/status/' }

        it 'return path withoud slash at the end' do
          expect(subject.find_request(method: method, path: path)).to eq(request1)
        end
      end

      context 'if request with query parameters' do
        let(:path) { '/status/?a=b&c=d' }

        it 'ignores query parameters' do
          expect(subject.find_request(method: method, path: path)).to eq(request1)
        end
      end

      context 'without parameters' do
        it 'return path' do
          expect(subject.find_request(method: method, path: path)).to eq(request1)
        end
      end

      context 'with a parameter' do
        let(:path) { '/status/1/test/2.json' }
        let(:method) { 'DELETE' }

        it 'returns the modified path' do
          expect(subject.find_request(method: method, path: path)).to eq(request2)
        end
      end
    end

    context 'if inserted' do
      let(:req1) { MultiJson.load(File.read('spec/fixtures/request1.json')) }
      let(:req2) { MultiJson.load(File.read('spec/fixtures/request2.json')) }
      let(:req3) { MultiJson.load(File.read('spec/fixtures/request3.json')) }
      let(:request1) do
        double(
          path: req1['path'],
          method: req1['method'],
          content_type: 'application/json',
          request: req1['request'],
          responses: req1['responses']
        )
      end
      let(:request2) do
        double(
          path: req2['path'],
          method: req2['method'],
          content_type: 'application/json',
          request: req2['request'],
          responses: req2['responses']
        )
      end
      let(:request3) do
        double(
          method: req3['method'],
          content_type: 'application/json',
          request: req3['request'],
          responses: req3['responses'],
          path: double(match: true, to_s: req3['path'])
        )
      end
      let(:tomogram) do
        [
          request1,
          request2,
          request3
        ]
      end
      let(:path) { '/users/37812539-99af-4d7c-b86f-b756e3d1a211/pokemons' }
      let(:method) { 'GET' }

      it 'returns the modified path' do
        expect(subject.find_request(method: method, path: path)).to eq(request3)
      end
    end
  end

  describe '#to_resources' do
    subject do
      described_class.new(
        drafter_yaml_path: "#{ENV['RBENV_DIR']}/spec/fixtures/#{documentation}",
        prefix: ''
      ).to_resources
    end
    let(:parsed) { { '/sessions' => ['POST /sessions'] } }
    let(:documentation) { nil }

    context 'if one action' do
      let(:documentation) { 'api2.yaml' }

      it 'parses documents' do
        expect(subject).to eq(parsed)
      end
    end
  end

  describe '#prefix_match?' do
    subject { described_class.new(prefix: '/api/v2') }
    before { allow(Tomograph::ApiBlueprint::Yaml).to receive(:new) }

    it { expect(subject.prefix_match?('http://local/api/v2/users')).to be_truthy }
    it { expect(subject.prefix_match?('http://local/status')).to be_falsey }
  end
end
