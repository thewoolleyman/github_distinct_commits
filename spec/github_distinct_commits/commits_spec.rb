require 'rspec'
require_relative '../../lib/github_distinct_commits/commits'

describe GithubDistinctCommits::Commits do
  before do
    @owner = 'thewoolleyman'
    @repo = 'dummyrepo'
    @commits = GithubDistinctCommits::Commits.new(@owner, @repo)
  end

  describe "#commits" do
    it "shows commits" do
      expect(@commits.commits).to eq({})
    end
  end

  describe "#events" do
    it "shows events" do
      expect(@commits.events).to eq({})
    end
  end
end