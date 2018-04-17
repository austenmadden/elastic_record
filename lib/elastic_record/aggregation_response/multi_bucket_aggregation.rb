module ElasticRecord
  module AggregationResponse
    class MultiBucketAggregation < Aggregation
      def buckets
        @buckets ||= results['buckets'].map { |bucket| ElasticRecord::AggregationResponse::Bucket.new(bucket) }
      end
    end
  end
end
