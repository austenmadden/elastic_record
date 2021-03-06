module ElasticRecord
  class Index
    # This module facilitates the removal of multiple mapping types from ElasticSearch.
    # See https://www.elastic.co/guide/en/elasticsearch/reference/6.x/removal-of-types.html
    #
    #   * 6.x - Type defaults to _doc, but any type can be specified
    #   * 7.x - Only _doc will be supported, effectively removing the type concept.
    module MappingType
      attr_accessor :mapping_type

      def mapping_type
        @mapping_type || '_doc'
      end
    end
  end
end
