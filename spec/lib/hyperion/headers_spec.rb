require 'rspec'
require 'hyperion'

class Hyperion
  describe Headers do
    include Headers
    describe '#post_headers' do
      it 'specifies content type' do
        headers = post_headers('json')
        expect(headers['Content-Type']).to eql 'application/json'
      end
    end
    describe '#default_headers' do
      it 'specifies accept header' do
        headers = default_headers('ttt', '999', 'fff')
        expect(headers['Accept']).to eql "application/vnd.indigobio-ascent.ttt-v999+fff"
      end
    end
    describe '#content_type' do
      it 'returns the appropriate mime type for json' do
        expect(content_type('json')).to eql 'application/json'
      end
    end
  end
end