class GraphqlController < ApplicationController
  
  protect_from_forgery with: :null_session

  def execute
    result = GraphqlTutorialSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

    # Check for GraphQL errors and return 500 if present
    if result['errors'].present?
      render json: result, status: 500
    else
      render json: result
    end
  rescue StandardError => e
    handle_error_in_development e
  end

  private

  def query
    params[:query]
  end

  def variables
    ensure_hash params[:variables]
  end

  def operation_name
    params[:operationName]
  end

  def context
    {
      session: session,
      current_user: AuthToken.user_from_token(session[:token])
    }
  end

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: {
      error: {
        message: e.message,
        backtrace: e.backtrace,
        error_class: e.class.name,
        rails_root: Rails.root.to_s,
        ruby_version: RUBY_VERSION,
        rails_version: Rails.version
      },
      data: {}
    }, status: 500
  end
end
