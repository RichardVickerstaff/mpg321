RSpec.shared_context 'fake_mpg321' do
  let(:fake_mpg321) { FakeMpg321.new }
  let(:last_command) { fake_mpg321.last_command }
  let(:example_file) { '/somepath/somefile.mp3' }

  before do
    allow(Open3).to receive(:popen2e).and_return(fake_mpg321.open2e_returns)

    allow_any_instance_of(Mpg321::ProcessWrapper).to receive(:async_handle_stdoe) do |instance|
      FakeReadThread.new(instance) { read_stdoe_line }
    end
  end
end
