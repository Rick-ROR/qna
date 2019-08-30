class Link < ApplicationRecord
  URL_FORMAT = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/ix
  GIST_FORMAT = /^(https|http):\/\/gist\.github\.com\//i

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: URL_FORMAT, message: 'Ooops! URL has an invalid format.' }

  def gist?
    url =~ GIST_FORMAT
  end

  def gist
    Octokit::Client.new.gist(url.split('/').last).files.map { |file| { name: file[0].to_s, content: file[1]['content'] } }
  rescue Faraday::ConnectionFailed, Octokit::TooManyRequests => ex
    [ {name: ex.class, content: ex.message} ]
  end
end

