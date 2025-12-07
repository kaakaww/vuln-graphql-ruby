module Types
  class QueryType < BaseObject
    add_field GraphQL::Types::Relay::NodeField
    add_field GraphQL::Types::Relay::NodesField

    field :all_links, resolver: Resolvers::LinksSearch
    field :_all_links_meta, QueryMetaType, null: false

    field :all_votes, [VoteType], null: false

    def _all_links_meta
      Link.count
    end

    def all_votes
      Vote.all
    end
  end
end
