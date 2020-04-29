module ActionNetworkRest
  class Taggings < Base
    attr_accessor :tag_id

    def base_path
      "tags/#{url_escape(tag_id)}/taggings/"
    end
  end
end
