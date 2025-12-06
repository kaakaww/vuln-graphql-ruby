module Types
  class QueryMetaType < BaseObject
    graphql_name '_QueryMeta'

    field :count, Integer, null: false

    def count
      object
    end
  end
end
