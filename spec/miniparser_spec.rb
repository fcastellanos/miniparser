require 'spec_helper'

describe MiniParser do
  describe '.parse' do
    let(:config_file) do
      './files/example.config'
    end

    let(:parsed_example) do
      OpenStruct.new(             host: 'test.com',
                            server_id: 55331,
                    server_load_alarm: 2.5,
                                 user: 'user',
                              verbose: true,
                            test_mode: true,
                           debug_mode: false,
                        log_file_path: '/tmp/logfile.log',
                   send_notifications: true)
    end

    it 'should be able to parse the .config file' do
      output = MiniParser.parse config_file

      output.config_file.should eql config_file
      output.host.should eql parsed_example.host
      output.server_id.should eql parsed_example.server_id
      output.server_load_alarm.should eql parsed_example.server_load_alarm
      output.user.should eql parsed_example.user
      output.verbose.should eql parsed_example.verbose
      output.test_mode.should eql parsed_example.test_mode
      output.debug_mode.should eql parsed_example.debug_mode
      output.log_file_path.should eql parsed_example.log_file_path
      output.send_notifications.should eql parsed_example.send_notifications
    end
  end
end