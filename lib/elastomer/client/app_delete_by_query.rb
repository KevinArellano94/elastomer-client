# typed: true
# frozen_string_literal: true

module Elastomer
  class Client

    # DEPRECATED: Delete documents from one or more indices and one or more
    # types based on a query.
    #
    # The return value follows the format returned by the Elasticsearch Delete
    # by Query plugin: https://github.com/elastic/elasticsearch/blob/v2.4.6/docs/plugins/delete-by-query.asciidoc
    #
    # Internally, this method uses a combination of scroll and bulk delete
    # instead of the Delete by Query API, which was removed in Elasticsearch
    # 2.0.
    #
    # For native _delete_by_query functionality in Elasticsearch 5+, see the
    # native_delete_by_query method.
    #
    # query  - The query body as a Hash
    # params - Parameters Hash
    #
    # Examples
    #
    #   # request body query
    #   app_delete_by_query({:query => {:match_all => {}}}, :type => 'tweet')
    #
    #   # same thing but using the URI request method
    #   app_delete_by_query(nil, { :q => '*:*', :type => 'tweet' })
    #
    # See https://www.elastic.co/guide/en/elasticsearch/plugins/current/delete-by-query-usage.html
    #
    # Returns a Hash of statistics about the delete operations, for example:
    #
    #   {
    #     "took" : 639,
    #     "_indices" : {
    #       "_all" : {
    #         "found" : 5901,
    #         "deleted" : 5901,
    #         "missing" : 0,
    #         "failed" : 0
    #       },
    #       "twitter" : {
    #         "found" : 5901,
    #         "deleted" : 5901,
    #         "missing" : 0,
    #         "failed" : 0
    #       }
    #     },
    #     "failures" : [ ]
    #   }
    def app_delete_by_query(query, params = {})
      AppDeleteByQuery.new(self, query, params).execute
    end

    class AppDeleteByQuery

      # Create a new DeleteByQuery command for deleting documents matching a
      # query
      #
      # client - Elastomer::Client used for HTTP requests to the server
      # query  - The query used to find documents to delete
      # params - Other URL parameters
      def initialize(client, query, params = {})
        @client = client
        @query = query
        @params = params
        @response_stats = { "took" => 0, "_indices" => { "_all" => {} }, "failures" => [] }
      end

      attr_reader :client, :query, :params, :response_stats

      # Internal: Determine whether or not an HTTP status code is in the range
      # 200 to 299
      #
      # status - HTTP status code
      #
      # Returns a boolean
      def is_ok?(status)
        status.between?(200, 299)
      end

      # Internal: Tally the contributions of an item to the found, deleted,
      # missing, and failed counts for the summary statistics
      #
      # item - An element of the items array from a bulk response
      #
      # Returns a Hash of counts for each category
      def categorize(item)
        {
          "found" => item["found"] || item["status"] == 409 ? 1 : 0,
          "deleted" => is_ok?(item["status"]) ? 1 : 0,
          "missing" => !item["found"]  && !item.key?("error") ? 1 : 0,
          "failed" => item.key?("error") ? 1 : 0,
        }
      end

      # Internal: Combine a response item with the existing statistics
      #
      # item - A bulk response item
      def accumulate(item)
        item = item["delete"]
        (@response_stats["_indices"][item["_index"]] ||= {}).merge!(categorize(item)) { |_, n, m| n + m }
        @response_stats["_indices"]["_all"].merge!(categorize(item)) { |_, n, m| n + m }
        @response_stats["failures"] << item unless is_ok? item["status"]
      end

      # Perform the Delete by Query action
      #
      # Returns a Hash of statistics about the bulk operation
      def execute
        ops = Enumerator.new do |yielder|
          scan = @client.scan(@query, search_params)
          scan.each_document do |hit|
            yielder.yield([:delete, hit.select { |key, _| ["_index", "_type", "_id", "_routing"].include?(key) }])
          end
        end

        stats = @client.bulk_stream_items(ops, bulk_params) { |item| accumulate(item) }
        @response_stats["took"] = stats["took"]
        @response_stats
      end

      # Internal: Remove parameters that are not valid for the _search endpoint
      def search_params
        return @search_params if defined?(@search_params)

        @search_params = @params.merge(_source: false)
        @search_params.delete(:action_count)
        @search_params
      end

      # Internal: Remove parameters that are not valid for the _bulk endpoint
      def bulk_params
        return @bulk_params if defined?(@bulk_params)

        @bulk_params = @params.dup
        return @bulk_params if @bulk_params.nil?

        @bulk_params.delete(:q)
        @bulk_params
      end

    end
  end
end
