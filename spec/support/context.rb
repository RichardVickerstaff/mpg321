RSpec.shared_context 'fake_mpg321' do
  let (:fake_mpg321) { FakeMpg321.new }
  let (:last_command) { fake_mpg321.last_command }
  let (:example_file) { '/somepath/somefile.mp3' }

  before do
    allow(Open3).to receive(:popen2e).and_return(fake_mpg321.open2e_returns)
  end
end
