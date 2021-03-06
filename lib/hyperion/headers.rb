require 'hyperion/formats'
require 'logatron/logatron'

class Hyperion
  module Headers
    # constructs and destructures HTTP headers

    def route_headers(route)
      headers = Logatron.http_headers
      rd = route.response_descriptor
      pd = route.payload_descriptor
      headers['Expect'] = nil # this overrides default libcurl behavior.
                              # see http://devblog.songkick.com/2012/11/27/a-second-here-a-second-there/
                              # and http://stackoverflow.com/questions/17383089/libcurl-delays-for-1-second-before-uploading-data-command-line-curl-does-not
      if rd
        headers['Accept'] = "application/vnd.#{Hyperion.config.vendor_string}.#{short_mimetype(rd)}"
      end
      if pd
        headers['Content-Type'] = content_type_for(pd.format)
      end
      headers
    end

    def short_mimetype(response_descriptor)
      x = response_descriptor
      "#{x.type}-v#{x.version}+#{x.format}"
    end

    ContentTypes = [[:json, 'application/json'],
                    [:protobuf, 'application/x-protobuf'],
                    [Multipart.format, Multipart.content_type]]

    def content_type_for(format)
      format = Hyperion::Formats.get_from(format)
      ct = ContentTypes.detect{|x| x.first == format}
      ct ? ct.last : 'application/octet-stream'
    end

    def format_for(content_type)
      ct = ContentTypes.detect{|x| x.last == content_type.split(';')[0]}
      fail "Unsupported content type: #{content_type}" unless ct
      ct.first
    end
  end
end
