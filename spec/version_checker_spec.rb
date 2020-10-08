require_relative '../lib/version_checker'

describe VersionChecker do
  describe '#is_ruby_before_2_7' do
    context 'when ruby verison is 2.7' do

      before do
        stub_const('RUBY_VERSION', VersionChecker::RUBY_2_7)
      end

      it 'should return false ' do
        expect(VersionChecker.is_ruby_before_2_7).to be_falsey
      end
    end

    context 'when ruby version is before 2.7' do
      let(:old_ruby) { '2.0.0' }
      before do
        stub_const('RUBY_VERSION', old_ruby)
      end

      it 'should return false ' do
        expect(VersionChecker.is_ruby_before_2_7).to be_truthy
      end
    end
  end
end