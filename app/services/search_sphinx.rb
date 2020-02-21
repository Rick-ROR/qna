class Services::SearchSphinx
  ALLOW_SCOPES = {
    "by site" => ThinkingSphinx,
    "by questions" => Question,
    "by answers" => Answer,
    "by comments" => Comment,
    "by users" => User,
  }.freeze

  def call(params)

    scope = ALLOW_SCOPES.include?(params[:scope]) ? ALLOW_SCOPES[params[:scope]] : ThinkingSphinx

    scope.send :search, ThinkingSphinx::Query.escape(params[:query])
  end
end
