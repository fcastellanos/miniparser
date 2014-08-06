require 'spec_helper'

describe Miniparser do
  describe '.parse' do
    let(:config_file) do
      './spec/files/example.config'
    end

    context "When we want an OpenStruct object as a return" do
      let(:output) do
        Miniparser.parse config_file
      end

      let(:parsed_example) do
        OpenStruct.new(            host: 'test.com',
                              server_id: 55331,
                      server_load_alarm: 2.5,
                                   user: 'user',
                                verbose: true,
                              test_mode: true,
                             debug_mode: false,
                          log_file_path: '/tmp/logfile.log',
                     send_notifications: true)
      end

      it 'should return the configured file' do
        expect(output.config_file).to eql config_file
      end

      it 'should be able to parse the host' do
        expect(output.host).to eql parsed_example.host
      end

      it 'should be able to parse the server_id as integer' do
        expect(output.server_id).to eql parsed_example.server_id
      end

      it 'should be able to parse the server_load_alarm as float' do
        expect(output.server_load_alarm).to eql parsed_example.server_load_alarm
      end

      it 'should be able to parse the user' do
        expect(output.user).to eql parsed_example.user
      end

      it 'should be able to parse verbose as boolean' do
        expect(output.verbose).to eql parsed_example.verbose
      end

      it 'should be able to parse test_mode = on as boolean' do
        expect(output.test_mode).to eql parsed_example.test_mode
      end

      it 'should be able to parse debug_mode = off as boolean' do
        expect(output.debug_mode).to eql parsed_example.debug_mode
      end

      it 'should be able to parse log_file_path' do
        expect(output.log_file_path).to eql parsed_example.log_file_path
      end

      it 'should be able to parse send_notifications = true as boolean' do
        expect(output.send_notifications).to eql parsed_example.send_notifications
      end
    end

    context "When we don't ask for a specific return object" do
      let(:output) do
        Miniparser.parse config_file
      end

      it 'should return an OpenStruct object' do
        expect(output).to be_a_kind_of(OpenStruct)
      end
    end
  end
end