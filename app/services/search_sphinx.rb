class Services::SearchSphinx
  ALLOW_SCOPES = {
    "by site" => ThinkingSphinx,
    "by questions" => Question,
    "by answers" => Answer,
    "by comments" => Comment,
    "by users" => User,
  }.freeze

  def self.call(query:, scope: nil)

    scope = ALLOW_SCOPES.include?(scope) ? ALLOW_SCOPES[scope] : ThinkingSphinx

    query_safe = ThinkingSphinx::Query.escape(query)

    scope.search query_safe
  end
end
