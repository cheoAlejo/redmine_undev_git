class RemoteRepo < ActiveRecord::Base
  belongs_to :site, :class_name => 'RemoteRepoSite', :foreign_key => 'remote_repo_site_id'
  has_many :revisions,
           :class_name => 'RemoteRepoRevision',
           :inverse_of => :repo,
           :dependent => :destroy # todo: should delete_all for all tails

  validates :site, :presence => true

  serialize :tail_revisions, Array

  def fetch
    fetch_service = RedmineUndevGit::Services::RemoteRepoFetch.new(self)
    fetch_service.fetch
  end

  def uri
    [site.uri.chomp('/'), path_to_repo].join('/')
  end
end
